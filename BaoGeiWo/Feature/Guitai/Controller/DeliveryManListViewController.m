//
//  DeliveryManListViewController.m
//  BaoGeiWo
//
//  Created by wb on 2018/5/17.
//  Copyright © 2018年 qyqs. All rights reserved.
//

#import "DeliveryManListViewController.h"
#import "DeliveryManListCell.h"
#import "GTDeliveryViewController.h"
#import "JSDeliveryViewController.h"
#import "CommonRequest.h"

@interface DeliveryManListViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, assign) BGWDestinationType destType;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *deliveryManList;

@end

@implementation DeliveryManListViewController

- (instancetype)initWithDestType:(BGWDestinationType)destType {
    self = [super init];
    if (self) {
        self.destType = destType;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBar.titleLabel.text = @"选取取派员";
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigationBar.mas_bottom);
        make.left.right.equalTo(@0);
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(@0).with.insets(self.view.safeAreaInsets);
        } else {
            make.bottom.equalTo(@0);
        }
    }];
    
     BGWRefreshHeader *header = [BGWRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(getDeliveryManList)];
    self.tableView.mj_header = header;
    [self.tableView.mj_header beginRefreshing];
    
}

-(void)getDeliveryManList {
    
    [CommonRequest getDeliveryManList:self.destType success:^(id responseObject) {
        [self.tableView.mj_header endRefreshing];
        self.deliveryManList = responseObject;
        [self.tableView reloadData];
    } failure:^(id error) {
        [self.tableView.mj_header endRefreshing];
    }];

}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.deliveryManList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DeliveryManListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DeliveryManListCell" forIndexPath:indexPath];
    [cell setDeliveryManModel:self.deliveryManList[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.destType == BGWDestinationTypeServiceCenter) {
        GTDeliveryViewController *vc = [[GTDeliveryViewController alloc] initWithDeliveryManModel:self.deliveryManList[indexPath.row]];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (self.destType == BGWDestinationTypeTransitCenter) {
        JSDeliveryViewController *vc = [[JSDeliveryViewController alloc] initWithDeliveryManModel:self.deliveryManList[indexPath.row]];
        [self.navigationController pushViewController:vc animated:YES];
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
        [tableView registerClass:[DeliveryManListCell class] forCellReuseIdentifier:@"DeliveryManListCell"];
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
