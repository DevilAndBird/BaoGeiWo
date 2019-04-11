//
//  QPYTaskGroupListViewController.h
//  BaoGeiWo
//
//  Created by wb on 2018/6/22.
//  Copyright © 2018年 qyqs. All rights reserved.
//

#import "QPYTaskListViewController.h"

@class QPYOrderTaskGroupModel;
@interface QPYTaskGroupListViewController : QPYTaskListViewController

@property (nonatomic, copy) void(^OperateTaskNumber)(NSInteger number);

- (instancetype)initWithTaskType:(BGWOrderTaskType)type TaskGroup:(QPYOrderTaskGroupModel *)taskGroup;

@end
