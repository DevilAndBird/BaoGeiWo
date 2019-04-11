//
//  QPYTaskListViewController.h
//  BaoGeiWo
//
//  Created by wb on 2018/5/7.
//  Copyright © 2018年 qyqs. All rights reserved.
//

#import "BaseViewController.h"

@class QPYOrderTaskListModel;
@interface QPYTaskListViewController : BaseViewController

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *taskList;
@property (nonatomic, assign) BOOL isGroupList;

@property (nonatomic, copy) void(^reloadSegmentNumber)(void);

- (instancetype)initWithTaskType:(BGWOrderTaskType)type;
- (instancetype)initWithTaskType:(BGWOrderTaskType)type container:(BaseViewController *)container;

- (void)notifyAppCus:(QPYOrderTaskListModel *)taskModel;
- (void)mapClick:(QPYOrderTaskListModel *)taskModel;
- (void)alertCall:(QPYOrderTaskListModel *)taskModel;


@end
