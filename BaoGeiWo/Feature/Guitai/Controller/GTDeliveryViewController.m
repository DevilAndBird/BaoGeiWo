//
//  GTDeliveryViewController.m
//  BaoGeiWo
//
//  Created by wb on 2018/5/17.
//  Copyright © 2018年 qyqs. All rights reserved.
//

#import "GTDeliveryViewController.h"
#import "DeliverySuccessViewController.h"
#import "TransitReceiveScanViewController.h"
#import "AirportReceiveScanViewController.h"

#import "QPYOrderListCell.h"

#import "QPYOrderListModel.h"
#import "DeliveryManModel.h"
#import "BGWTransitCenter.h"

#import "OrderRequest.h"


@interface GTDeliveryViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray<QPYOrderListModel *> *orderArray;

@property (nonatomic, strong) DeliveryManModel *deliveryMan; //当前取派员
@property (nonatomic, assign) BGWDestinationType destinationType; //目的地类型
@property (nonatomic, assign) BGWRoleActionType roleActionType; //角色动作
@property (nonatomic, assign) BGWOrderStatus orderStatus; //待装／待卸

@property (nonatomic, strong) UILabel *baggageNumberLabel;
@property (nonatomic, strong) UIButton *deliveButton;

@end

@implementation GTDeliveryViewController

- (instancetype)initWithDeliveryManModel:(DeliveryManModel *)deliveryMan {
    self = [super init];
    if (self) {
        self.deliveryMan = deliveryMan;
        self.destinationType = BGWDestinationTypeServiceCenter;
        self.roleActionType = BGWRoleActionTypeAirportSend;
        self.orderStatus = BGWOrderStatusWaitingUnload; //默认待卸
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBarHidder = NO;
    self.navigationBar.titleLabel.text = @"柜台-司机交接";

    [self setupUI];
    [self getOrderListData];
}

- (void)setupUI {
    
    UISegmentedControl *segment = [[UISegmentedControl alloc] initWithItems:@[@"卸车", @"装车"]];
    segment.tintColor = kMThemeColor;
    [segment setTitleTextAttributes:@{NSFontAttributeName:BGWFont(16)} forState:UIControlStateNormal & UIControlStateSelected];
    segment.selectedSegmentIndex = 0;
    [segment addTarget:self action:@selector(selectActionType:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segment];
    [segment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigationBar.mas_bottom).with.offset(20);
        make.left.equalTo(@10);
        make.right.equalTo(@0).with.offset(-10);
        make.height.equalTo(@32);
    }];
    segment.layer.cornerRadius = 16.f;
    segment.layer.masksToBounds = YES;
    segment.layer.borderColor = kMThemeColor.CGColor;
    segment.layer.borderWidth = 1.f;
    
    UILabel *numberLabel = [[UILabel alloc] initWithTextColor:kMBlackColor font:BGWFont(16)];
    numberLabel.text = @"行李数量:";
    [self.view addSubview:numberLabel];
    [numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@20);
        make.top.equalTo(segment.mas_bottom).with.offset(20);
    }];
    self.baggageNumberLabel = numberLabel;
    
    UIView *separateLine = [[UIView alloc] init];
    separateLine.backgroundColor = kMSeparateColor;
    [self.view addSubview:separateLine];
    [separateLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(numberLabel.mas_bottom).with.offset(10);
        make.left.equalTo(@10);
        make.right.equalTo(@0).with.offset(-10);
        make.height.equalTo(@.5);
    }];
    
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 80)];
    bottomView.backgroundColor = kMBgColor;
    
    UIButton *deliver = [[UIButton alloc] init];
    deliver.backgroundColor = kMThemeColor;
    [deliver setTitle:@"卸车扫描" forState:UIControlStateNormal];
    [deliver addTarget:self action:@selector(deliverClick) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:deliver];
    [deliver mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@20);
        make.left.equalTo(@80);
        make.bottom.equalTo(@0).with.offset(-20);
        make.right.equalTo(@0).with.offset(-80);
    }];
    [self.view addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.height.equalTo(@80);
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(@0).with.insets(self.view.safeAreaInsets);
        } else {
            make.bottom.equalTo(@0);
        }
    }];
    self.deliveButton = deliver;
    
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(separateLine.mas_bottom).with.offset(0);
        make.left.right.equalTo(@0);
        make.bottom.equalTo(bottomView.mas_top);
    }];
}

- (void)getOrderListData {
    
    [OrderRequest getOrderListWithDeliveryManId:self.deliveryMan.dmId roleActionType:self.roleActionType actionStatus:BGWRoleActionStatusOnGoing destType:self.destinationType destId:[BGWUser currentUser].userRole.userRoleId orderStatus:self.orderStatus success:^(id responseObject) {
        //
        self.orderArray = responseObject;
        NSInteger baggageNumber = 0;
        for (QPYOrderListModel *model in self.orderArray) {
            baggageNumber += model.baggageNumber.integerValue;
        }
        self.baggageNumberLabel.text = [NSString stringWithFormat:@"行李数量: %ld", baggageNumber];
        
        [self.tableView reloadData];
        
        self.deliveButton.hidden = !self.orderArray.count;
    } failure:^(id error) {
        //
    }];
}



- (void)selectActionType:(UISegmentedControl *)sender {
    
    if (sender.selectedSegmentIndex == 0) {
        if (self.destinationType == BGWDestinationTypeTransitCenter) {
            self.roleActionType = BGWRoleActionTypeTransitSend;
        } else if (self.destinationType == BGWDestinationTypeServiceCenter) {
            self.roleActionType = BGWRoleActionTypeAirportSend;
        }
        self.orderStatus = BGWOrderStatusWaitingUnload;
        [self.deliveButton setTitle:@"卸车扫描" forState:UIControlStateNormal];
        
    } else if (sender.selectedSegmentIndex == 1) {
        if (self.destinationType == BGWDestinationTypeTransitCenter) {
            self.roleActionType = BGWRoleActionTypeTransitTask;
        } else if (self.destinationType == BGWDestinationTypeServiceCenter) {
            self.roleActionType = BGWRoleActionTypeAirportTask;
        }
        self.orderStatus = BGWOrderStatusWaitTruceLoading;
        [self.deliveButton setTitle:@"申请装车" forState:UIControlStateNormal];
    }
    [self getOrderListData];
}

- (void)deliverClick {
    
    if (self.roleActionType == BGWRoleActionTypeTransitSend || self.roleActionType == BGWRoleActionTypeAirportSend) {
        //卸车扫描,跳转扫描页
        
        if (self.destinationType == BGWDestinationTypeTransitCenter) { //集散中心卸车扫描
            TransitReceiveScanViewController *vc = [[TransitReceiveScanViewController alloc] initWithDeliveryMan:self.deliveryMan orderArray:self.orderArray];
            [self.navigationController pushViewController:vc animated:YES];

        } else if (self.destinationType == BGWDestinationTypeServiceCenter) { //柜台卸车扫描
            BGWTransitCenter *center = [BGWTransitCenter new];
            center.transitCenterId = [BGWUser currentUser].userRole.userRoleId;
            center.transitCenterName = [BGWUser currentUser].userRole.userRoleName;
            AirportReceiveScanViewController *vc = [[AirportReceiveScanViewController alloc] initWithDeliveryMan:self.deliveryMan orderArray:self.orderArray];
            [self.navigationController pushViewController:vc animated:YES];

        }
        
    } else {
        //申请装车 申请交接
        if (self.orderArray.count) {
            NSMutableArray *orderIdArray = [NSMutableArray arrayWithCapacity:0];
            for (QPYOrderListModel *order in self.orderArray) {
                [orderIdArray addObject:order.orderId];
            }
            
            [SVProgressHUD show];
            [OrderRequest updateOrderStatue:BGWOrderStatusWaitTruceLoading orderId:orderIdArray success:^(id responseObject) {
                [SVProgressHUD dismiss];
                
//                POPUPINFO(@"申请成功");
                DeliverySuccessViewController *vc = [[DeliverySuccessViewController alloc] initWithType:1];
                [self.navigationController pushViewController:vc animated:YES];
            } failure:^(id error) {
                //
                [SVProgressHUD dismiss];
                
            }];
        }

    }
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.orderArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QPYOrderListCell" forIndexPath:indexPath];
    [(QPYOrderListCell *)cell setOrderContent:self.orderArray[indexPath.row]];
    return cell;
}


- (UITableView *)tableView {
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        tableView.backgroundColor = kMBgColor;
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.estimatedRowHeight = 100;
        tableView.rowHeight = UITableViewAutomaticDimension;
        [tableView registerClass:[QPYOrderListCell class] forCellReuseIdentifier:@"QPYOrderListCell"];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
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
