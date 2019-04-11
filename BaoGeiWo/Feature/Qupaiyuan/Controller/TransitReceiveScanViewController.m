//
//  TransitReceiveScanViewController.m
//  BaoGeiWo
//
//  Created by wb on 2018/5/9.
//  Copyright © 2018年 qyqs. All rights reserved.
//

#import "TransitReceiveScanViewController.h"
#import "TransitReceiveScanCell.h"

#import "DeliverySuccessViewController.h"

#import "BGWTransitCenter.h"
#import "QPYOrderListModel.h"
#import "QPYOrderScanListModel.h"
#import "DeliveryManModel.h"

#import "OrderRequest.h"

@interface TransitReceiveScanViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *deliverButton;

@property (nonatomic, strong) DeliveryManModel *deliveryMan;
@property (nonatomic, strong) BGWTransitCenter *center;
@property (nonatomic, strong) NSMutableArray *orderScanArray;
@property (nonatomic, strong) NSArray *orderArray;

@end

@implementation TransitReceiveScanViewController

- (instancetype)initWithTransitId:(BGWTransitCenter *)center orderArray:(NSArray *)orderArray {
    self = [super initWithScanType:2];
    if (self) {
        self.center = center;
        self.orderArray = orderArray;
        self.orderScanArray = [NSMutableArray arrayWithCapacity:0];
        [self configScanList];
    }
    return self;
}

- (instancetype)initWithDeliveryMan:(DeliveryManModel *)deliveryMan orderArray:(NSArray *)orderArray {
    self = [super initWithScanType:2];
    if (self) {
        self.deliveryMan = deliveryMan;
        self.orderArray = orderArray;
        self.orderScanArray = [NSMutableArray arrayWithCapacity:0];
        [self configScanList];
    }
    return self;
}

- (void)configScanList {
    for (NSInteger i = 0; i < self.orderArray.count; i++) {
        QPYOrderListModel *order = self.orderArray[i];
        for (QPYQRNumerModel *qrNumberModel in order.QRNumbers) {
            QPYOrderScanListModel *model = [QPYOrderScanListModel new];
            model.personName = order.personName;
            model.qrNumber = qrNumberModel.QRNumber;
            model.orderId = order.orderId;
            [self.orderScanArray addObject:model];
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scanView.mas_bottom).with.offset(60);
        make.left.right.equalTo(@0);
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(@0).with.insets(self.view.safeAreaInsets);
        } else {
            make.bottom.equalTo(@0);
        }
    }];
    
    UIButton *deliverButton = [[UIButton alloc] init];
    [deliverButton setTitle:@"确认交接" forState:UIControlStateNormal];
    deliverButton.backgroundColor = kMThemeColor;
    deliverButton.titleLabel.font = BGWFont(14);
    [deliverButton addTarget:self action:@selector(comfirmDeliver) forControlEvents:UIControlEventTouchUpInside];
    deliverButton.hidden = YES;
    [self.view addSubview:deliverButton];
    [deliverButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.bottom.mas_equalTo(-100);
        make.width.equalTo(@150);
        make.height.equalTo(@40);
    }];
    self.deliverButton = deliverButton;
}


- (void)scanResult:(NSString *)result {
    
    BOOL hasPackage = NO;
    NSInteger currentRow = 0;
    QPYOrderScanListModel *scanModel;
    for (NSInteger i = 0; i < self.orderScanArray.count; i++) {
        QPYOrderScanListModel *order = self.orderScanArray[i];
        if ([order.qrNumber isEqualToString:result]) {
            hasPackage = YES;
            currentRow = i;
            scanModel = order;
            break;
        }
    }

    if (hasPackage) {
        [SVProgressHUD show];
        
        if (self.center) {
            [OrderRequest deliveryScanWithQRNumber:result success:^(id responseObject) {
                [self baggageIsScanWithOrderId:[[responseObject firstObject] mj_JSONObject][@"id"]  qrNumber:result currentRow:currentRow];
            } failure:^(id error) {
                [SVProgressHUD dismiss];
                [self startScan];
            }];
        } else {
            [self baggageIsScanWithOrderId:scanModel.orderId qrNumber:result currentRow:currentRow];
        }


    } else {
        POPUPINFO(@"QR码不符");
        [self startScan];
    }
    
}

- (void)baggageIsScanWithOrderId:(NSString *)orderId qrNumber:(NSString *)qrNumber currentRow:(NSInteger)currentRow{
    [OrderRequest baggageIsScanWithOrderId:orderId qrNumber:qrNumber success:^(id responseObject) {
        //扫描成功
        [SVProgressHUD dismiss];
        POPUPINFO(@"扫描成功");
        
        [self.orderScanArray removeObjectAtIndex:currentRow];
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:currentRow inSection:0]] withRowAnimation:UITableViewRowAnimationRight];
        [self.tableView endUpdates];
        
        if (self.orderScanArray.count == 0) {
            self.deliverButton.hidden = NO;
        } else {
            [self startScan];
        }
        
    } failure:^(id error) {
        [SVProgressHUD dismiss];
        [self startScan];
    }];
}





- (void)comfirmDeliver {
    NSMutableArray *idArr = [NSMutableArray arrayWithCapacity:0];
    for (QPYOrderListModel *order in self.orderArray) {
        [idArr addObject:order.orderId];
    };
    
    if (self.center) {
        [SVProgressHUD show];
        [OrderRequest transitCenterLoadDoneWithIdArray:idArr destId:self.center.transitCenterId success:^(id responseObject) {
            [SVProgressHUD dismiss];
            POPUPINFO(@"取派员端 取派员装车交接完成");
            DeliverySuccessViewController *vc = [[DeliverySuccessViewController alloc] initWithType:2];
            [self.navigationController pushViewController:vc animated:YES];
        } failure:^(id error) {
            [SVProgressHUD dismiss];
//            [self startScan];
        }];
    } else {
        [SVProgressHUD show];
        [OrderRequest transitCenterUnloadDoneWithIdArray:idArr deliveryId:self.deliveryMan.dmId success:^(id responseObject) {
            [SVProgressHUD dismiss];
            
            POPUPINFO(@"集散中心端 取派员卸车交接完成");
            DeliverySuccessViewController *vc = [[DeliverySuccessViewController alloc] initWithType:2];
            [self.navigationController pushViewController:vc animated:YES];
        } failure:^(id error) {
            [SVProgressHUD dismiss];
//            [self startScan];
        }];
    
    }
    
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.orderScanArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TransitReceiveScanCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TransitReceiveScanCell" forIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    QPYOrderScanListModel *order = self.orderScanArray[indexPath.row];
    [(TransitReceiveScanCell *)cell setPersonName:order.personName qrNumber:order.qrNumber];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.orderScanArray removeObjectAtIndex:indexPath.row];
//    [tableView reloadData];
    [tableView beginUpdates];
    [tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]] withRowAnimation:UITableViewRowAnimationRight];
    [tableView endUpdates];

    self.deliverButton.hidden = self.orderScanArray.count;
}


- (UITableView *)tableView {
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        tableView.backgroundColor = kClearColor;
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [tableView registerClass:[TransitReceiveScanCell class] forCellReuseIdentifier:@"TransitReceiveScanCell"];
        tableView.estimatedRowHeight = 30;
        tableView.rowHeight = UITableViewAutomaticDimension;
        
        _tableView = tableView;
    }
    return _tableView;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
