//
//  GTOrderListViewController.m
//  BaoGeiWo
//
//  Created by wb on 2018/6/20.
//  Copyright © 2018年 qyqs. All rights reserved.
//

#import "GTOrderListViewController.h"
#import "OrderTaskDetailViewController.h"

#import "GTOrderListCell.h"
#import "GTOrderListWaitPayCell.h"
#import "GTOrderListModel.h"

#import "OrderRequest.h"

@interface GTOrderListViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, assign) BGWGTOrderType type;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *orderList;

@end

@implementation GTOrderListViewController

- (instancetype)initWithType:(BGWGTOrderType)type {
    self = [super init];
    if (self) {
        self.type = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBarHidder = YES;
    
    self.orderList = [NSMutableArray arrayWithCapacity:0];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(@0);
    }];
    
    self.tableView.mj_header = [BGWRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(getOrderList)];
    [self.tableView.mj_header beginRefreshing];
}

- (void)getOrderList {
    
    [OrderRequest getGTOrderListWithType:self.type success:^(id responseObject) {
        [self.orderList removeAllObjects];
        
        [self.tableView.mj_header endRefreshing];
        [self.orderList addObjectsFromArray:responseObject];
        [self.tableView reloadData];
    } failure:^(id error) {
        [self.tableView.mj_header endRefreshing];
    }];
    
}

- (void)deleteOrderByOrderId:(NSString *)orderId index:(NSInteger)index {
    [SVProgressHUD show];
    [OrderRequest deleteUnpaidOrderByOrderId:orderId success:^(id responseObject) {
        [SVProgressHUD dismiss];
        
        POPUPINFO(@"订单已取消");
        [self.orderList removeObjectAtIndex:index];
        [self.tableView reloadData];
        
    } failure:^(id error) {
        [SVProgressHUD dismiss];
    }];
}

- (void)paidOrderByOrderNo:(NSString *)orderNo index:(NSInteger)index {
    [SVProgressHUD show];
    [OrderRequest updatePaidOrderByOrderNo:orderNo success:^(id responseObject) {
        [SVProgressHUD dismiss];
        
        POPUPINFO(@"订单已付款");
        [self.orderList removeObjectAtIndex:index];
        [self.tableView reloadData];
        
    } failure:^(id error) {
        [SVProgressHUD dismiss];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.orderList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GTOrderListCell *cell;
    if (self.type == BGWGTOrderTypeWaitPay) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"GTOrderListWaitPayCell" forIndexPath:indexPath];
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"GTOrderListCell" forIndexPath:indexPath];
    }
    [cell setOrderContent:self.orderList[indexPath.row]];
    __weak typeof(self) weakSelf = self;
    cell.cancelOrder = ^(NSString *orderId) {
        [weakSelf deleteOrderByOrderId:orderId index:indexPath.row];
    };
    cell.paidOrder = ^(NSString *orderNo) {
        [weakSelf paidOrderByOrderNo:orderNo index:indexPath.row];
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    GTOrderListModel *order = self.orderList[indexPath.row];
    OrderTaskDetailViewController *vc = [[OrderTaskDetailViewController alloc] initWithOrderNo:order.orderNo taskType:BGWOrderTaskTypeFinished roleType:BGWRoleActionTypeOther];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.orderList.count == 0) {
        return DEVICE_HEIGHT-KNavBarHeight-40;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.orderList.count == 0) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT-KNavBarHeight-40)];
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"list_empty_placrholder"]];
        imageView.frame = CGRectMake(DEVICE_WIDTH/2-60, (DEVICE_HEIGHT)/2-KNavBarHeight-40-60-50, 120, 120);
        [view addSubview:imageView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, imageView.bgw_y+imageView.bgw_h+30, DEVICE_WIDTH, 15)];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"啊喔，什么也木有～";
        label.textColor = kMPromptColor;
        label.font = BGWFont(14);
        [view addSubview:label];
        
        return view;
        
    }else {
        return nil;
    }
}


- (UITableView *)tableView {
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        tableView.backgroundColor = kMBgColor;
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.estimatedRowHeight = 100;
        tableView.rowHeight = UITableViewAutomaticDimension;
        [tableView registerClass:[GTOrderListCell class] forCellReuseIdentifier:@"GTOrderListCell"];
        [tableView registerClass:[GTOrderListWaitPayCell class] forCellReuseIdentifier:@"GTOrderListWaitPayCell"];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _tableView = tableView;
    }
    return _tableView;
}

@end
