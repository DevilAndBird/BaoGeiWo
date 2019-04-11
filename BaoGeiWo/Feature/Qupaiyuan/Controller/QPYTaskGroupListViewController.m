//
//  QPYTaskGroupListViewController.m
//  BaoGeiWo
//
//  Created by wb on 2018/6/22.
//  Copyright © 2018年 qyqs. All rights reserved.
//

#import "QPYTaskGroupListViewController.h"

#import "QPYTaskListCell.h"

#import "QPYOrderTaskListModel.h"

#import "OrderTaskDetailViewController.h"

#import "OrderRequest.h"

@interface QPYTaskGroupListViewController ()

@property (nonatomic, strong) QPYOrderTaskGroupModel *taskGroupModel;

@end

@implementation QPYTaskGroupListViewController

- (instancetype)initWithTaskType:(BGWOrderTaskType)type TaskGroup:(QPYOrderTaskGroupModel *)taskGroup {
    self = [super initWithTaskType:type];
    if (self) {
        self.taskGroupModel = taskGroup;
        self.isGroupList = YES;
    }
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBarHidder = NO;
    self.navigationBar.titleLabel.text = @"分组详情";

    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigationBar.mas_bottom);
        make.left.bottom.right.equalTo(@0);
    }];
    
//    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.navigationBar.mas_bottom);
//    }];
    self.tableView.mj_header = nil;
    
    [self.taskList removeAllObjects];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    objc_msgSend(self, @selector(invalidateTimer));
    [self.taskList addObjectsFromArray:self.taskGroupModel.taskGroup];
    objc_msgSend(self, @selector(enumerateDataSourceCountDown));
#pragma clang diagnostic pop

//    [self.tableView removeFromSuperview];

}


- (void)confirmDriverStart:(QPYOrderTaskListModel *)taskModel {
    if ([taskModel.isTake isEqualToString:@"N"]) {
        POPUPINFO(@"机场未收件");
        return;
    }
    
    [SVProgressHUD show];
    [OrderRequest confirmDriverStartedWithTaskListModel:taskModel success:^(id responseObject) {
        [SVProgressHUD dismiss];
        POPUPINFO(@"确认发车成功");

        NSInteger index = [self.taskList indexOfObject:taskModel];
        
        //移除taskmodel 废弃所有定时器重新创建
        [self.taskList removeObjectAtIndex:index];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
        objc_msgSend(self, @selector(invalidateTimer));
        objc_msgSend(self, @selector(enumerateDataSourceCountDown));
#pragma clang diagnostic pop

        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView beginUpdates];
            [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationRight];
            [self.tableView endUpdates];
        });
        
    } failure:^(id error) {
        [SVProgressHUD dismiss];
    }];
}

- (void)driverStatusChange:(BGWOrderDriverStatus)status taskModel:(QPYOrderTaskListModel *)taskModel success:(void (^)(void))success {
    [SVProgressHUD show];
    [OrderRequest confirmDriverStatus:status taskListModel:taskModel success:^(id responseObject) {
        [SVProgressHUD dismiss];
        
        if (status == BGWOrderDriverStatusArriving) {
            POPUPINFO(@"即将到达成功");
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


#pragma mark- TableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.taskList.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    switch (BGWOrderTaskTypeOther) {
        case BGWOrderTaskTypeFinished:
            cell = [tableView dequeueReusableCellWithIdentifier:@"QPYTaskListFinishedCell" forIndexPath:indexPath];
            break;
            
        default:
        {
            QPYOrderTaskListModel *model = self.taskList[indexPath.row];
            if (model.nextBindAction) {
                cell = [tableView dequeueReusableCellWithIdentifier:@"QPYTaskListDiadAddressCell" forIndexPath:indexPath];
            } else {
                cell = [tableView dequeueReusableCellWithIdentifier:@"QPYTaskListSingleAddressCell" forIndexPath:indexPath];
            }
            
        }
            break;
    }
    return cell;
    
}


#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    QPYOrderTaskListModel *taskListModel = self.taskList[indexPath.row];
    
    QPYTaskListCell *taskCell = (QPYTaskListCell *)cell;
    __weak typeof(self) weakSelf = self;
    [taskCell setOrderTaskListModel:taskListModel taskType:BGWOrderTaskTypeOther]; //self.taskType暂时没用
    taskCell.callBlock = ^{
        [weakSelf alertCall:taskListModel];
//        objc_msgSend(weakSelf, @selector(alertCall:), taskListModel);
    };
    taskCell.mapBlock = ^{
        [weakSelf mapClick:taskListModel];
//        objc_msgSend(weakSelf, @selector(mapClick:), taskListModel);
    };
    taskCell.notifyAppCusBlock = ^{
        [weakSelf notifyAppCus:taskListModel];
//        objc_msgSend(weakSelf, @selector(notifyAppCus:), taskListModel);
    };
    taskCell.confirmDriverStartBlock = ^{
        [weakSelf confirmDriverStart:taskListModel];
//        objc_msgSend(weakSelf, @selector(confirmDriverStart:), taskListModel);
    };
    taskCell.driverStatusBlock = ^(BGWOrderDriverStatus status, void (^success)(void)) {
        [weakSelf driverStatusChange:status taskModel:taskListModel success:success];
//        objc_msgSend(weakSelf, @selector(driverStatusChange:taskModel:success:), status, taskListModel, success);
    };
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    QPYOrderTaskListModel *model = self.taskList[indexPath.row];

    OrderTaskDetailViewController *vc = [[OrderTaskDetailViewController alloc] initWithOrderId:model.orderId taskType:model.taskType roleType:[model.roleType roleActionType]];
    vc.isArrived = [model.isArrived isEqualToString:@"Y"]?1:0;
    vc.confirmBlock = ^{
        [self.taskList removeObjectAtIndex:indexPath.row];
        objc_msgSend(self, @selector(invalidateTimer));
        objc_msgSend(self, @selector(enumerateDataSourceCountDown));
        dispatch_async(dispatch_get_main_queue(), ^{
            [tableView beginUpdates];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            [tableView endUpdates];
        });
    };
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma clang diagnostic pop


@end
