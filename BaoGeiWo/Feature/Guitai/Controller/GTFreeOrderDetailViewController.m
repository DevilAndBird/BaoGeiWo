//
//  GTFreeOrderDetailViewController.m
//  BaoGeiWo
//
//  Created by wb on 2018/5/31.
//  Copyright © 2018年 qyqs. All rights reserved.
//

#import "GTFreeOrderDetailViewController.h"
#import "GTFreeSuccessViewController.h"
#import "ScanViewController.h"

#import "OrderTaskDetailCell.h"
#import "OrderTaskFirstDetailCell.h"
#import "OrderTaskAnotherDetailCell.h"
#import "GTFreeOrderDetailBaggageCell.h"

#import "OrderDetailModel.h"
#import "OrderBaggageModel.h"

#import "OrderRequest.h"

#import "OrderImagePreviewViewController.h"
#import "FeedbackViewController.h"


@interface GTFreeOrderDetailViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) OrderDetailModel *orderDetail;


@property (nonatomic, copy) NSString *orderNo;
@property (nonatomic, copy) NSString *fetchNo;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) NSInteger currentRow;

@property (nonatomic, assign) NSInteger scanCount;
@property (nonatomic, strong) NSMutableArray *isScans;


@end

@implementation GTFreeOrderDetailViewController

- (instancetype)initWithOrderNo:(NSString *)orderNo {
    self = [super init];
    if (self) {
        self.orderNo = orderNo;
        self.scanCount = 0;
        self.isScans = [NSMutableArray arrayWithCapacity:0];
    }
    return self;
}

- (instancetype)initWithFetchNo:(NSString *)fetchNo {
    self = [super init];
    if (self) {
        self.fetchNo = fetchNo;
        self.scanCount = 0;
        self.isScans = [NSMutableArray arrayWithCapacity:0];
    }
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBar.titleLabel.text = @"订单详情";
    [self.navigationBar.rightButton setTitle:@"反馈" forState:UIControlStateNormal];
    [self.navigationBar.rightButton addTarget:self action:@selector(feedbackPressed) forControlEvents:UIControlEventTouchUpInside];
    self.navigationBar.rightButtonWidth = 60;
    
    [SVProgressHUD show];
    if (self.orderNo) {
        [OrderRequest getOrderTaskDetailWithOrderNo:self.orderNo detailsType:@[@"ORDERCUS", @"ORDERADDRESS", @"ORDERBAGGAGE", @"ORDER_PRICE_DETAIL"] success:^(id responseObject) {
            [SVProgressHUD dismiss];
            self.orderDetail = responseObject;
            for (NSInteger i = 0; i<self.orderDetail.orderBaggages.count; i++) {
                [self.isScans addObject:@"0"];
            }
            [self setupTaskDetailUI];
        } failure:^(id error) {
            [SVProgressHUD dismiss];
        }];
    } else {
        [OrderRequest getOrderTaskDetailWithFetchNo:self.fetchNo detailsType:@[@"ORDERCUS", @"ORDERADDRESS", @"ORDERBAGGAGE", @"ORDER_PRICE_DETAIL"] success:^(id responseObject) {
            [SVProgressHUD dismiss];
            self.orderDetail = responseObject;
            for (NSInteger i = 0; i<self.orderDetail.orderBaggages.count; i++) {
                [self.isScans addObject:@"0"];
            }
            [self setupTaskDetailUI];
        } failure:^(id error) {
            [SVProgressHUD dismiss];
        }];
    }


}

- (void)setupTaskDetailUI {
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigationBar.mas_bottom);
        make.left.right.equalTo(@0);
    }];
    
    UIButton *operateButton = [[UIButton alloc] init];
    operateButton.backgroundColor = kMThemeColor;
    operateButton.titleLabel.font = BGWFont(16);
    [operateButton setCornerRadius:4.f boderWidth:.5f borderColor:kMThemeColor];
    [operateButton setTitle:@"释放行李" forState:UIControlStateNormal];
    [operateButton addTarget:self action:@selector(baggageFree) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:operateButton];
    [operateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@100);
        make.centerX.equalTo(@0);
        make.height.equalTo(@40);
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(@0).with.insets(self.view.safeAreaInsets).with.offset(-20);
        } else {
            make.bottom.mas_offset(-20);
        }
    }];
    
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(operateButton.mas_top).with.offset(-20);
    }];
    
}

- (void)back {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)feedbackPressed {
    FeedbackViewController *vc = [[FeedbackViewController alloc] initWithOrderId:self.orderDetail.orderId];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)priceDetail {
    
    OrderPriceDetailViewController *priceDetailVC = [[OrderPriceDetailViewController alloc] initWithPriceModel:self.orderDetail.priceDetail];
    priceDetailVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [self presentViewController:priceDetailVC animated:NO completion:nil];
}

- (void)takePreview {
    OrderBaggageModel *baggage = self.orderDetail.orderBaggages[self.currentRow-1];
    if (!baggage.baggageQRCode) {
        POPUPINFO(@"请先扫描行李qr码");
        return;
    }
    OrderImagePreviewViewController *vc = [[OrderImagePreviewViewController alloc] initWithImageUrls:baggage.baggageImage.takeImageUrls baggageId:baggage.baggageQRCode orderId:self.orderDetail.orderId];
    vc.take = YES;
    vc.preview = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)sendPreview {
    if (![self.isScans[self.currentRow-1] boolValue]) {
        POPUPINFO(@"请先扫描行李");
        return;
    }
    
    OrderBaggageModel *baggage = self.orderDetail.orderBaggages[self.currentRow-1];
    OrderImagePreviewViewController *vc = [[OrderImagePreviewViewController alloc] initWithImageUrls:baggage.baggageImage.sendImageUrls baggageId:baggage.baggageQRCode orderId:self.orderDetail.orderId];
    vc.send = YES;
    vc.preview = NO;
    vc.uploadSuccess = ^(NSArray *imageUrls) {
        baggage.baggageImage.sendImageUrls = imageUrls;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.currentRow inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
        });
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)scan {
    ScanViewController *vc = [[ScanViewController alloc] initWithScanType:2];
    __weak typeof(vc) weakVC = vc;
    vc.scanSuccessBlock = ^(id result) {
        NSLog(@"%@", result);
        [self judgeBaggageQRCode:result];
        [weakVC.navigationController popViewControllerAnimated:YES];

    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)judgeBaggageQRCode:(NSString *)result {
    OrderBaggageModel *baggage = self.orderDetail.orderBaggages[self.currentRow-1];
    if ([baggage.baggageQRCode isEqualToString:result]) {
        POPUPINFO(@"扫描成功");
        self.scanCount++;
        self.isScans[self.currentRow-1] = @"1";
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.currentRow inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    } else {
        POPUPINFO(@"QR码不符");
    }
}


- (void)baggageFree {
    if (self.scanCount < self.orderDetail.orderBaggages.count) {
        POPUPINFO(@"请先扫描行李");
        return;
    }
    for (OrderBaggageModel *baggage in self.orderDetail.orderBaggages) {
        if (baggage.baggageImage.sendImageUrls.count == 0) {
            POPUPINFO(@"请先给行李拍照");
            return;
        }
    }
    
    [SVProgressHUD show];
    [OrderRequest updateOrderStatue:BGWOrderStatusReleaseOver orderId:self.orderDetail.orderId success:^(id responseObject) {
        [SVProgressHUD dismiss];
        GTFreeSuccessViewController *vc = [[GTFreeSuccessViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } failure:^(id error) {
        [SVProgressHUD dismiss];
    }];
}



#pragma mark- TableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.orderDetail.baggageNumber.integerValue+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        OrderTaskDetailCell *cell;
        BGWOrderMailingWay mailingWay = [self.orderDetail.destMailingWay orderMailingWay];
        if (mailingWay == BGWOrderMailingWayFrontDesk || mailingWay == BGWOrderMailingWayAirportCounter) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"OrderTaskAnotherDetailCell" forIndexPath:indexPath];
        } else {
            cell = [tableView dequeueReusableCellWithIdentifier:@"OrderTaskFirstDetailCell" forIndexPath:indexPath];
        }
        [cell setOrderDetailModel:self.orderDetail];
        
        //        [(OrderTaskDetailCell *)cell setTaskModel:self.taskModel srcName:self.srcName destName:self.destName];
        return cell;
        
    } else {
        GTFreeOrderDetailBaggageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GTFreeOrderDetailBaggageCell" forIndexPath:indexPath];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        OrderTaskDetailCell *tempCell = (OrderTaskDetailCell *)cell;
        tempCell.callBlock = ^(NSInteger tag) {
            if (tag == 111) {
                [UIWebView webViewCallWithPhoneNumber:self.orderDetail.srcPhone];
            } else if (tag == 222) {
                [UIWebView webViewCallWithPhoneNumber:self.orderDetail.destPhone];
            };
        };
        tempCell.priceTapBlock = ^{
            [self priceDetail];
        };
    } else {
        GTFreeOrderDetailBaggageCell *tempCell = (GTFreeOrderDetailBaggageCell *)cell;
        [tempCell setBaggageInfo:self.orderDetail.orderBaggages[indexPath.row-1] isScan:[self.isScans[indexPath.row-1] boolValue]];
        tempCell.takePhotoBlock = ^{
            self.currentRow = indexPath.row;
            [self takePreview];
        };
        tempCell.sendPreviewBlock = ^{
            self.currentRow = indexPath.row;
            [self sendPreview];
        };
        tempCell.scanBlock = ^{
            self.currentRow = indexPath.row;
            [self scan];
        };
    }
}


#pragma mark- Properties
- (UITableView *)tableView {
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        tableView.backgroundColor = kMBgColor;
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.estimatedRowHeight = 150;
        tableView.rowHeight = UITableViewAutomaticDimension;
        [tableView registerClass:[OrderTaskFirstDetailCell class] forCellReuseIdentifier:@"OrderTaskFirstDetailCell"];
        [tableView registerClass:[OrderTaskAnotherDetailCell class] forCellReuseIdentifier:@"OrderTaskAnotherDetailCell"];
        [tableView registerClass:[GTFreeOrderDetailBaggageCell class] forCellReuseIdentifier:@"GTFreeOrderDetailBaggageCell"];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

        _tableView = tableView;
    }
    return _tableView;
}



@end
