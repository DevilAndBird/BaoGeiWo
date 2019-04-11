//
//  QPYTaskListViewController.m
//  BaoGeiWo
//
//  Created by wb on 2018/5/7.
//  Copyright © 2018年 qyqs. All rights reserved.
//

#import "QPYTaskListViewController.h"
#import "QPYTaskListContainerViewController.h"

#import "QPYTaskListSingleAddressCell.h"
#import "QPYTaskListDiadAddressCell.h"
#import "QPYTaskListFinishedCell.h"
#import "QPYTaskListTakeGroupCell.h"
#import "QPYTaskListSendGroupCell.h"

#import "OrderTaskDetailViewController.h"
#import "QPYTaskMapViewController.h"
#import "QPYTaskGroupListViewController.h"

#import "OrderRequest.h"

#import "QPYOrderTaskListModel.h"
#import "BGWLocationManager.h"

@interface QPYTaskListViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) QPYTaskListContainerViewController *taskListContainer;

@property (nonatomic, assign) BGWOrderTaskType taskType;

@property (nonatomic, strong) NSMutableArray *timerArray;

@property (nonatomic, strong) NSMutableDictionary *countDownTimeDic;

@property (nonatomic, assign) BOOL firstLoad;

@end

@implementation QPYTaskListViewController


- (instancetype)initWithTaskType:(BGWOrderTaskType)type {
    self = [super init];
    if (self) {
        self.taskType = type;
        
        self.firstLoad = YES;
    }
    return self;
}

- (instancetype)initWithTaskType:(BGWOrderTaskType)type container:(BaseViewController *)container {
    self = [super init];
    if (self) {
        self.taskType = type;
        self.taskListContainer = (QPYTaskListContainerViewController *)container;
        
        self.firstLoad = YES;
    }
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationBarHidder = YES;
    
    self.view.backgroundColor = kRandomColor;
    self.taskList = [NSMutableArray arrayWithCapacity:0];
    self.timerArray = [NSMutableArray arrayWithCapacity:0];
    self.countDownTimeDic = [NSMutableDictionary dictionaryWithCapacity:0];

    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(@0);
    }];
    
    if (!self.isGroupList) {
        self.tableView.mj_header = [BGWRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(getTaskList)];
        [self.tableView.mj_header beginRefreshing];
    }

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (!self.isGroupList) {
        if (self.firstLoad) {
            self.firstLoad = NO;
        } else {
            [self getTaskList];
        }
    }

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [self invalidateTimer];
}

- (void)invalidateTimer {
    for (__strong NSTimer *timer in self.timerArray) {
        if (timer) {
            [timer invalidate];
            timer = nil;
        }
    }
    
    [self.timerArray removeAllObjects];
}

- (void)getTaskList {

    [OrderRequest getOrderTaskList:[self getRequestParam] success:^(id responseObject) {
        
        [self.taskList removeAllObjects];
        [self invalidateTimer];
        
        [self.tableView.mj_header endRefreshing];
        
        [self.taskList addObjectsFromArray:responseObject];
        [self.tableView reloadData];
        [self enumerateDataSourceCountDown];
        
    } failure:^(id error) {
        [self.tableView.mj_header endRefreshing];
    }];
    
}


// 订单倒计时 
- (void)enumerateDataSourceCountDown {
    //刷新顶部数量
    [self.taskListContainer reloadSegmentNumber];
    
    for (NSInteger i = 0; i < self.taskList.count; i++) {
        id obj = self.taskList[i];
        QPYOrderTaskListModel *taskModel;
        BOOL addTimer = NO;
        
        if ([obj isKindOfClass:[QPYOrderTaskGroupModel class]]) {
            taskModel = [((QPYOrderTaskGroupModel *)obj).taskGroup firstObject];
            if (((QPYOrderTaskGroupModel *)obj).taskGroup.count == 1) {
                addTimer = YES;
            }
        } else if ([obj isKindOfClass:[QPYOrderTaskListModel class]]) {
            taskModel = (QPYOrderTaskListModel *)obj;
            
            addTimer  = YES;
        }

        if (addTimer) {

            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:0];
            NSString *indexKey =@(i).stringValue;
            [dic setObject:indexKey forKey:@"indexPath"];
            [dic setObject:taskModel forKey:indexKey];
            
            if (!self.countDownTimeDic[indexKey] || 1) { //timer全部移除重新添加
                NSTimer *timer = [NSTimer timerWithTimeInterval:1.f target:self selector:@selector(countDown:) userInfo:dic repeats:YES];
                [self.timerArray addObject:timer];
                [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
            }
            
            [self.countDownTimeDic addEntriesFromDictionary:dic];
            
        } else  {
//            taskModel = [((QPYOrderTaskGroupModel *)obj).taskGroup firstObject];
        }
        
    }
    
}

- (void)countDown:(NSTimer *)timer {
    
    NSString *indexKey = timer.userInfo[@"indexPath"];
    QPYOrderTaskListModel *model = timer.userInfo[indexKey];
    model.currentTime = @(model.currentTime.doubleValue+1).stringValue;
    
    //替换数据源
    id obj = self.taskList[indexKey.integerValue];
    if ([obj isKindOfClass:[QPYOrderTaskListModel class]]) {
        [self.taskList replaceObjectAtIndex:indexKey.integerValue withObject:model];
    } else if ([obj isKindOfClass:[QPYOrderTaskGroupModel class]]) {
        QPYOrderTaskGroupModel *group = self.taskList[indexKey.integerValue];
        NSMutableArray *mArr = [NSMutableArray arrayWithArray:group.taskGroup];
        [mArr replaceObjectAtIndex:0 withObject:model];
        group.taskGroup = mArr;
        
        [self.taskList replaceObjectAtIndex:indexKey.integerValue withObject:group];
    }
   
    for (QPYTaskListCell *cell in [self.tableView visibleCells]) {
        NSIndexPath *indexp = [self.tableView indexPathForCell:cell];
        if (indexp.row == indexKey.integerValue) {
            [cell setTakeTimeWithTaskModel:model];
            break;
        }
    }
}

#pragma mark- Event Response
- (void)driverStatusChange:(BGWOrderDriverStatus)status taskModel:(QPYOrderTaskGroupModel *)task success:(void (^)(void))success {
    [SVProgressHUD show];

    QPYOrderTaskListModel *taskModel = [task.taskGroup firstObject];
    [OrderRequest confirmDriverStatus:status taskListModel:taskModel success:^(id responseObject) {
        [SVProgressHUD dismiss];

        if (status == BGWOrderDriverStatusArriving) {
            POPUPINFO(@"即将到达成功");
            for (QPYOrderTaskListModel *model in task.taskGroup) {
                model.travelStatus = @"arriving";
            }
        } else if (status == BGWOrderDriverStatusArrived) {
            POPUPINFO(@"确认到达成功");
        }
        if (success) {
            success();
        }
    } failure:^(id error) {
        [SVProgressHUD dismiss];
    }];
}


- (void)confirmDriverStart:(QPYOrderTaskGroupModel *)task {
    QPYOrderTaskListModel *taskModel = [task.taskGroup firstObject];
    if ([taskModel.isTake isEqualToString:@"N"]) {
        POPUPINFO(@"机场未收件");
        return;
    }
    
    void(^driverStartRequest)(void) = ^{
        [SVProgressHUD show];
        [OrderRequest confirmDriverStartedWithTaskGroup:task success:^(id responseObject) {
            [SVProgressHUD dismiss];
            
            NSInteger index = [self.taskList indexOfObject:task];
            if (self.taskType == BGWOrderTaskTypeAll) { //废弃
                POPUPINFO(@"确认发车成功");
                
                for (QPYOrderTaskListModel *model in task.taskGroup) {
                    model.taskType = BGWOrderTaskTypeOnGoing;
                    model.isFinish = [NSString roleActionStatus:BGWRoleActionStatusOnGoing];
                }
                [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
                
            } else {
                POPUPINFO(@"确认发车成功，请到进行中列表查看");
                
                //移除taskmodel 废弃所有定时器重新创建
                [self.taskList removeObjectAtIndex:index];
                [self invalidateTimer];
                [self enumerateDataSourceCountDown];
                
                [self.tableView beginUpdates];
                [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationRight];
                [self.tableView endUpdates];
            }
            
        } failure:^(id error) {
        }];
    };
    
    if ([taskModel.isToday isEqualToString:@"N"]) {
        [self alertWithTitle:nil message:@"此件为隔夜件，是否确认发车？" cancel:nil confirm:^{
            driverStartRequest();
        }];
    } else {
        driverStartRequest();
    }
    
}

- (void)notifyAppCus:(QPYOrderTaskListModel *)taskModel {
    
    [OrderRequest notifyAppCusWithOrderId:taskModel.orderId roleType:taskModel.roleType success:^(id responseObject) {
        POPUPINFO(responseObject[@"notifymsg"]?:@"用户通知成功");
    } failure:^(id error) {
        //
    }];
}

- (void)alertCall:(QPYOrderTaskListModel *)taskModel {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"拨打电话" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"联系寄件人" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [UIWebView webViewCallWithPhoneNumber:taskModel.srcPhone];
    }]];
    if (taskModel.destPhone) {
        [alert addAction:[UIAlertAction actionWithTitle:@"联系收件人" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [UIWebView webViewCallWithPhoneNumber:taskModel.destPhone];
        }]];
    }
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }]];

    [self presentViewController:alert animated:YES completion:nil];
}

- (void)mapClick:(QPYOrderTaskListModel *)taskModel {
    
    //弹出当前已有地图
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"选择地图" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
    
    //baidu
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:[@"baidumap://" stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]]]) {
        [arr addObject:@"百度地图"];
    };
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:[@"iosamap://" stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]]]) {
        [arr addObject:@"高德地图"];
    };
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:[@"http://maps.apple.com/" stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]]]) {
        [arr addObject:@"苹果地图"];
    };
    
    if (arr.count == 0) {
        POPUPINFO(@"未安装地图应用");
        return;
    }
    
    for (NSString *str in arr) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:str style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            CLLocationCoordinate2D daddr = CLLocationCoordinate2DMake(taskModel.addressCoordinate.latitudeStr.doubleValue, taskModel.addressCoordinate.longitudeStr.doubleValue);
            [[BGWLocationManager shareLocationManager] openMap:action.title destination:daddr destinationName:taskModel.destAddressDesc];
        }];
        [alert addAction:action];
    }
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {}];
    [alert addAction:action];

    [self presentViewController:alert animated:YES completion:nil];

    //apple
//    MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
//    MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate: addressDictionary:nil]];
//    [MKMapItem openMapsWithItems:@[currentLocation, toLocation]
//                   launchOptions:@{MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving,
//                                   MKLaunchOptionsShowsTrafficKey: [NSNumber numberWithBool:YES]}];
    
//    QPYTaskMapViewController *vc = [[QPYTaskMapViewController alloc] initWithCoordinate:coordinate];
//    [self.navigationController pushViewController:vc animated:YES];
}



#pragma mark- TableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.taskList.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    switch (self.taskType) {
        case BGWOrderTaskTypeFinished:
        {
            QPYOrderTaskGroupModel *group = self.taskList[indexPath.row];
            if (group.taskGroup.count == 1) {
                cell = [tableView dequeueReusableCellWithIdentifier:@"QPYTaskListFinishedCell" forIndexPath:indexPath];
            } else if (group.taskGroup.count > 1) { //任务组
                cell = [tableView dequeueReusableCellWithIdentifier:@"QPYTaskListTakeGroupCell" forIndexPath:indexPath];
            }
        }
            break;

        default:
        {
            QPYOrderTaskGroupModel *group = self.taskList[indexPath.row];
            QPYOrderTaskListModel *model = [group.taskGroup firstObject];

            if (group.taskGroup.count == 1) {
                if (model.nextBindAction) {
                    cell = [tableView dequeueReusableCellWithIdentifier:@"QPYTaskListDiadAddressCell" forIndexPath:indexPath];
                } else {
                    cell = [tableView dequeueReusableCellWithIdentifier:@"QPYTaskListSingleAddressCell" forIndexPath:indexPath];
                }
            } else if (group.taskGroup.count > 1) { //任务组
                if (model.nextBindAction && self.taskType == BGWOrderTaskTypePrepareReceive) { //fix: taskType
                    cell = [tableView dequeueReusableCellWithIdentifier:@"QPYTaskListTakeGroupCell" forIndexPath:indexPath];
                } else {
                    cell = [tableView dequeueReusableCellWithIdentifier:@"QPYTaskListSendGroupCell" forIndexPath:indexPath];
                }
            }
            
        }
            break;
    }
    return cell;

}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    QPYOrderTaskGroupModel *group = self.taskList[indexPath.row];
    QPYOrderTaskListModel *taskListModel = [group.taskGroup firstObject];
    __weak typeof(self) weakSelf = self;
    
    if (group.taskGroup.count == 1) {
        QPYTaskListCell *taskCell = (QPYTaskListCell *)cell;
        [taskCell setOrderTaskListModel:taskListModel taskType:self.taskType]; //self.taskType暂时没用
        taskCell.callBlock = ^{
            [weakSelf alertCall:taskListModel];
        };
        taskCell.mapBlock = ^{
            [weakSelf mapClick:taskListModel];
        };
        taskCell.notifyAppCusBlock = ^{
            [weakSelf notifyAppCus:taskListModel];
        };
        taskCell.confirmDriverStartBlock = ^{
            [weakSelf confirmDriverStart:group];
        };
        taskCell.driverStatusBlock = ^(BGWOrderDriverStatus status, void (^success)(void)) {
            [weakSelf driverStatusChange:status taskModel:group success:success];
        };
    } else if (group.taskGroup.count > 1) {
        
        if ((taskListModel.nextBindAction && self.taskType == BGWOrderTaskTypePrepareReceive) || self.taskType == BGWOrderTaskTypeFinished) {
            QPYTaskListTakeGroupCell *groupCell = (QPYTaskListTakeGroupCell *)cell;
            [groupCell setTaskTakeGroup:group];
        } else {
            QPYTaskListSendGroupCell *groupCell = (QPYTaskListSendGroupCell *)cell;
            [groupCell setTaskSendGroup:group];
            groupCell.confirmDriverStartBlock = ^{
                [weakSelf confirmDriverStart:group];
            };
            groupCell.driverStatusBlock = ^(BGWOrderDriverStatus status, void (^success)(void)) {
                [weakSelf driverStatusChange:status taskModel:group success:success];
            };
        }
    }

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    QPYOrderTaskGroupModel *group = self.taskList[indexPath.row];
    
    if (group.taskGroup.count == 1) {
        QPYOrderTaskListModel *model = [group.taskGroup firstObject];
        OrderTaskDetailViewController *vc = [[OrderTaskDetailViewController alloc] initWithOrderId:model.orderId taskType:model.taskType roleType:[model.roleType roleActionType]];
        vc.isArrived = [model.isArrived isEqualToString:@"Y"]?1:0;
        vc.confirmBlock = ^{
            [self.taskList removeObjectAtIndex:indexPath.row];
            [self invalidateTimer];
            [self enumerateDataSourceCountDown];
            dispatch_async(dispatch_get_main_queue(), ^{
                [tableView beginUpdates];
                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                [tableView endUpdates];
            });
        };
        [self.navigationController pushViewController:vc animated:YES];
        
    } else if (group.taskGroup.count > 1) {
        QPYTaskGroupListViewController *vc = [[QPYTaskGroupListViewController alloc] initWithTaskType:self.taskType TaskGroup:group];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.taskList.count == 0) {
        return DEVICE_HEIGHT-KNavBarHeight-40;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.taskList.count == 0) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT-KNavBarHeight-40)];
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"list_empty_placrholder"]];
        imageView.frame = CGRectMake(DEVICE_WIDTH/2-60, (DEVICE_HEIGHT)/2-60-KNavBarHeight-40-50, 120, 120);
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
        tableView.estimatedRowHeight = 150;
        tableView.rowHeight = UITableViewAutomaticDimension;
        [tableView registerClass:[QPYTaskListSingleAddressCell class] forCellReuseIdentifier:@"QPYTaskListSingleAddressCell"];
        [tableView registerClass:[QPYTaskListDiadAddressCell class] forCellReuseIdentifier:@"QPYTaskListDiadAddressCell"];
        [tableView registerClass:[QPYTaskListFinishedCell class] forCellReuseIdentifier:@"QPYTaskListFinishedCell"];
        [tableView registerClass:[QPYTaskListTakeGroupCell class] forCellReuseIdentifier:@"QPYTaskListTakeGroupCell"];
        [tableView registerClass:[QPYTaskListSendGroupCell class] forCellReuseIdentifier:@"QPYTaskListSendGroupCell"];

        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _tableView = tableView;
    }
    return _tableView;
}


- (NSDictionary *)getRequestParam {
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:0];
    [dict setObject:[BGWUser getCurrentUserId] forKey:@"roleid"];
    
    
    switch (self.taskType) {
        case BGWOrderTaskTypePrepareReceive:
            [dict setObject:@[@"ROLE_HOTEL_TASK", @"ROLE_AIRPORT_TASK", @"ROLE_TRANSIT_TASK"] forKey:@"orderroleList"];
            [dict setObject:@"UNFINISHED" forKey:@"isfinish"];
            break;
        case BGWOrderTaskTypePrepareSend:
            [dict setObject:@[@"ROLE_HOTEL_SEND", @"ROLE_AIRPORT_SEND", @"ROLE_TRANSIT_SEND"] forKey:@"orderroleList"];
            [dict setObject:@"UNFINISHED" forKey:@"isfinish"];
            break;
        case BGWOrderTaskTypeOnGoing:
            [dict setObject:@"ONGOING" forKey:@"isfinish"];
            break;
        case BGWOrderTaskTypeFinished:
            [dict setObject:@"FINISHED" forKey:@"isfinish"];
            break;
        case BGWOrderTaskTypeAll:
            [dict setObject:@[@"ROLE_HOTEL_TASK", @"ROLE_AIRPORT_TASK", @"ROLE_TRANSIT_TASK", @"ROLE_HOTEL_SEND", @"ROLE_AIRPORT_SEND", @"ROLE_TRANSIT_SEND"] forKey:@"orderroleList"];
            [dict setObject:@[@"UNFINISHED", @"ONGOING"] forKey:@"isfinishList"];
            break;
        default:
            break;
    }
    return dict;
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
