//
//  QPYDeliverViewController.m
//  BaoGeiWo
//
//  Created by wb on 2018/5/7.
//  Copyright © 2018年 qyqs. All rights reserved.
//

#import "QPYOrderListViewController.h"
#import "QPYOrderListCell.h"

#import "DeliverySuccessViewController.h"
#import "TransitReceiveScanViewController.h"
#import "AirportReceiveScanViewController.h"

#import "OrderRequest.h"

#import "QPYOrderListModel.h"

@interface QPYOrderListViewController ()<UITableViewDataSource, UITableViewDelegate>


@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray<QPYOrderListModel *> *orderArray;

@property (nonatomic, strong) BGWTransitCenter *currentTransitCenter;
@property (nonatomic, assign) BGWDestinationType destinationType;
@property (nonatomic, assign) BGWRoleActionType roleActionType;
@property (nonatomic, assign) BGWOrderStatus orderStatus;

@property (nonatomic, strong) UILabel *baggageNumberLabel;
@property (nonatomic, strong) UIButton *deliveButton;


@end

@implementation QPYOrderListViewController

- (instancetype)initWithTransitCenter:(BGWTransitCenter *)transitCenter cityNodeType:(BGWCityNodeType)cityNodeType {
    
    self = [super init];
    if (self) {
        self.currentTransitCenter = transitCenter;
        self.orderStatus = BGWOrderStatusWaitingUnload;
        
        if (cityNodeType == BGWCityNodeTypeTransitCenter) {
            self.destinationType = BGWDestinationTypeTransitCenter;
            self.roleActionType = BGWRoleActionTypeTransitSend;

        } else if (cityNodeType == BGWCityNodeTypeCounterCenter) {
            self.destinationType = BGWDestinationTypeServiceCenter;
            self.roleActionType = BGWRoleActionTypeAirportSend;

        }
    }
    return self;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBarHidder = YES;
    
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
        make.top.equalTo(@20);
        make.left.equalTo(@10);
        make.centerX.equalTo(@0);
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
        make.centerX.equalTo(@0);
        make.height.equalTo(@.5);
    }];
    
    
    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = kMBgColor;
    [self.view addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@80);
        if (@available(iOS 11.0, *)) {
            make.left.bottom.right.equalTo(@0).with.insets(self.view.safeAreaInsets);
        } else {
            make.left.bottom.right.equalTo(@0);
        }
    }];
    
    UIButton *deliver = [[UIButton alloc] init];
    deliver.backgroundColor = kMThemeColor;
    [deliver setTitle:@"申请交接" forState:UIControlStateNormal];
    [deliver setCornerRadius:4.f boderWidth:0 borderColor:kMThemeColor];
    [deliver addTarget:self action:@selector(deliverClick) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:deliver];
    [deliver mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@20);
        make.left.equalTo(@80);
//        make.width.equalTo(@200);
        make.centerX.centerY.equalTo(@0);
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
    
    [OrderRequest getOrderListWithRoleActionType:self.roleActionType actionStatus:BGWRoleActionStatusOnGoing destType:self.destinationType destId:self.currentTransitCenter.transitCenterId orderStatus:self.orderStatus success:^(id responseObject) {

        self.orderArray = responseObject;
        
        __block NSInteger baggageNumber = 0;
        dispatch_sync(dispatch_get_global_queue(0, 0), ^{
            for (QPYOrderListModel *model in self.orderArray) {
                baggageNumber += model.baggageNumber.integerValue;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                self.baggageNumberLabel.text = [NSString stringWithFormat:@"行李数量: %ld", baggageNumber];
            });
        });


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
        [self.deliveButton setTitle:@"申请卸车交接" forState:UIControlStateNormal];
        
    } else if (sender.selectedSegmentIndex == 1) {
        if (self.destinationType == BGWDestinationTypeTransitCenter) {
            self.roleActionType = BGWRoleActionTypeTransitTask;
        } else if (self.destinationType == BGWDestinationTypeServiceCenter) {
            self.roleActionType = BGWRoleActionTypeAirportTask;
        }
        self.orderStatus = BGWOrderStatusWaitTruceLoading;
        [self.deliveButton setTitle:@"装车交接扫描" forState:UIControlStateNormal];
    }
    [self getOrderListData];
}

- (void)deliverClick {
    
    if (self.roleActionType == BGWRoleActionTypeTransitSend || self.roleActionType == BGWRoleActionTypeAirportSend) {
        //取派员申请卸车
        if (self.orderArray.count) {
            NSMutableArray *orderIdArray = [NSMutableArray arrayWithCapacity:0];
            for (QPYOrderListModel *order in self.orderArray) {
                [orderIdArray addObject:order.orderId];
            }
            
            
            [SVProgressHUD show];
            [OrderRequest updateOrderStatue:BGWOrderStatusWaitingUnload orderId:orderIdArray success:^(id responseObject) {
                //
                [SVProgressHUD dismiss];

                DeliverySuccessViewController *vc = [[DeliverySuccessViewController alloc] initWithType:1];
                [self.navigationController pushViewController:vc animated:YES];
            } failure:^(id error) {
                //
                [SVProgressHUD dismiss];

            }];
        }

    } else {
        [SVProgressHUD show];
        //取派员装车扫描
        [OrderRequest getDeliveryScanListWithUserId:[BGWUser getCurrentUserId] destId:self.currentTransitCenter.transitCenterId success:^(id responseObject) {
            [SVProgressHUD dismiss];
            
            if (self.destinationType == BGWDestinationTypeTransitCenter) { //集散中心装车
                TransitReceiveScanViewController *vc = [[TransitReceiveScanViewController alloc] initWithTransitId:self.currentTransitCenter orderArray:self.orderArray];
                [self.navigationController pushViewController:vc animated:YES];
                
            } else if (self.destinationType == BGWDestinationTypeServiceCenter) { //柜台装车
                AirportReceiveScanViewController *vc = [[AirportReceiveScanViewController alloc] initWithAirportId:self.currentTransitCenter orderArray:self.orderArray];
                [self.navigationController pushViewController:vc animated:YES];
                
            }
        } failure:^(id error) {
            [SVProgressHUD dismiss];
        }];

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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
