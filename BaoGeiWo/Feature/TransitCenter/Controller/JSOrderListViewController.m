//
//  JSOrderListViewController.m
//  BaoGeiWo
//
//  Created by wb on 2018/5/25.
//  Copyright © 2018年 qyqs. All rights reserved.
//

#import "JSOrderListViewController.h"
#import "OrderTaskDetailViewController.h"

#import "JSOrderListCell.h"
#import "JSOrderListModel.h"

#import "OrderRequest.h"

@interface JSOrderListViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, assign) NSInteger type;  //1:寄存  2:已完成
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *orderList;

@end

@implementation JSOrderListViewController

- (instancetype)initWithType:(NSInteger)type {
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
    
    [OrderRequest getJSOrderListWithType:self.type success:^(id responseObject) {
        [self.orderList removeAllObjects];

        [self.tableView.mj_header endRefreshing];
        [self.orderList addObjectsFromArray:responseObject];
        [self.tableView reloadData];
    } failure:^(id error) {
        [self.tableView.mj_header endRefreshing];
    }];
    
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.orderList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JSOrderListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JSOrderListCell" forIndexPath:indexPath];
    [cell setOrderContent:self.orderList[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    JSOrderListModel *order = self.orderList[indexPath.row];
    OrderTaskDetailViewController *vc = [[OrderTaskDetailViewController alloc] initWithOrderNo:order.orderNumber taskType:BGWOrderTaskTypeFinished roleType:BGWRoleActionTypeTransitSend];
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
        [tableView registerClass:[JSOrderListCell class] forCellReuseIdentifier:@"JSOrderListCell"];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _tableView = tableView;
    }
    return _tableView;
}




@end
