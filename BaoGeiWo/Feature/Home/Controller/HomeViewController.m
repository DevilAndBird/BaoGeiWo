//
//  HomeViewController.m
//  BaoGeiWo
//
//  Created by wb on 2018/5/3.
//  Copyright © 2018年 qyqs. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeCell.h"

#import "GTTakeViewController.h"
#import "GTFreeViewController.h"
#import "GTFreeSuccessViewController.h"
#import "GTOrderContainerViewController.h"
#import "GTPlaceOrderContainerViewController.h"

#import "DeliveryManListViewController.h"

#import "JSOrderContainerViewController.h"

#import "QPYTaskListContainerViewController.h"
#import "QPYOrderListContainerViewController.h"

#import "OrderTaskDetailViewController.h"

@interface HomeViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *imageArrays;
@property (nonatomic, strong) NSArray *titleArrays;

@end

@implementation HomeViewController

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kMBgColor;
    self.navBackButtonHidder = YES;
    self.navigationBar.titleLabel.text = @"首页";
    
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigationBar.mas_bottom);
        make.left.bottom.right.equalTo(@0);
    }];
    
    self.cycleScrollView = [[SDCycleScrollView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 200)];
    self.tableView.tableHeaderView = self.cycleScrollView;
    
    self.cycleScrollView.localizationImageNamesGroup = @[@"home_banner_1", @"home_banner_2", @"home_banner_3"];;
    self.cycleScrollView.pageDotColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    self.cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleToFill;
    self.cycleScrollView.autoScrollTimeInterval = 3.5f;
    
    [self reloadTable];
//    [self.cycleScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(@20);
//    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTable) name:kBGWLoginSuccessNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}

- (void)reloadTable {
    
    BGWUser *user = [BGWUser currentUser];
    switch (user.userType) {
        case AppUserTypeServiceCenter:
//            self.navigationBar.titleLabel.text = @"机场服务中心";
            self.titleArrays = @[@"收取旅客行李", @"释放旅客行李", @"与取派员交接订单", @"柜台下单", @"查看订单"];
            self.imageArrays = @[@"home_shouqu", @"home_shifang", @"home_jiaojie", @"home_xiadan", @"home_chakan"];
            break;
            
        case AppUserTypeTransitCenter:
//            self.navigationBar.titleLabel.text = @"集散中心";
            self.titleArrays = @[@"交接订单", @"查看订单"];
            self.imageArrays = @[@"home_jiaojie", @"home_chakan"];
            break;
            
        case AppUserTypeDeliveryMan:
//            self.navigationBar.titleLabel.text = @"取派员";
            self.titleArrays = @[@"任务列表", @"集散中心交接订单", @"机场交接订单"];
            self.imageArrays = @[@"home_task", @"home_qpy_transit", @"home_qpy_airport"];
            break;
            
        case AppUserTypeRegularDriver:
        case AppUserTypeAirportPicker:
        default:
            break;
    }
    
    [self.tableView reloadData];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titleArrays.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeCell" forIndexPath:indexPath];
    [cell setImage:self.imageArrays[indexPath.row] title:self.titleArrays[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 20)];
    view.backgroundColor = kMBgColor;
    return view;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BGWUser *user = [BGWUser currentUser];
    switch (user.userType) {
        case AppUserTypeServiceCenter:
            if (indexPath.row == 0) {
//                OrderTaskDetailViewController *vc = [[OrderTaskDetailViewController alloc] initWithOrderNo:@"830238" taskType:BGWOrderTaskTypeOther roleType:BGWRoleActionTypeHotelTask];
//                [self.navigationController pushViewController:vc animated:YES];
                GTTakeViewController *vc = [[GTTakeViewController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            } else if (indexPath.row == 1) {
                GTFreeViewController *vc = [[GTFreeViewController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            } else if (indexPath.row == 2) {
                DeliveryManListViewController *vc = [[DeliveryManListViewController alloc] initWithDestType:BGWDestinationTypeServiceCenter];
                [self.navigationController pushViewController:vc animated:YES];
            } else if (indexPath.row == 3) {
                GTPlaceOrderContainerViewController *vc = [[GTPlaceOrderContainerViewController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            } else if (indexPath.row == 4) {
                GTOrderContainerViewController *vc = [[GTOrderContainerViewController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            }
            break;
            
        case AppUserTypeTransitCenter:
            if (indexPath.row == 0) {
                DeliveryManListViewController *vc = [[DeliveryManListViewController alloc] initWithDestType:BGWDestinationTypeTransitCenter];
                [self.navigationController pushViewController:vc animated:YES];
            } else if (indexPath.row == 1) {
                //查看订单
                JSOrderContainerViewController *vc = [[JSOrderContainerViewController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            }
            break;
            
        case AppUserTypeDeliveryMan:
            if (indexPath.row == 0) {
                QPYTaskListContainerViewController *vc = [[QPYTaskListContainerViewController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            } else if (indexPath.row == 1) {
                QPYOrderListContainerViewController *vc = [[QPYOrderListContainerViewController alloc] initWithCityNodeType:BGWCityNodeTypeTransitCenter];
                [self.navigationController pushViewController:vc animated:YES];
            } else if (indexPath.row == 2) {
                QPYOrderListContainerViewController *vc = [[QPYOrderListContainerViewController alloc] initWithCityNodeType:BGWCityNodeTypeCounterCenter];
//                BaseViewController *vc = [[objc_getClass("QPYTaskMapViewController") alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            }
            break;
            
        case AppUserTypeRegularDriver:
        case AppUserTypeAirportPicker:
        default:
            break;
    }
    
    
}




- (UITableView *)tableView {
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        tableView.dataSource = self;
        tableView.delegate = self;
        [tableView registerClass:[HomeCell class] forCellReuseIdentifier:@"HomeCell"];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.backgroundColor = kMBgColor;
        tableView.estimatedRowHeight = 80;
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
