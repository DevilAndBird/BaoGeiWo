//
//  QPYTaskListSendGroupCell.h
//  BaoGeiWo
//
//  Created by wb on 2018/6/22.
//  Copyright © 2018年 qyqs. All rights reserved.
//

#import "QPYTaskListTakeGroupCell.h"

@class QPYOrderTaskGroupModel;

typedef void(^ConfirmDriverStartBlock)(void);
typedef void(^DriverStatusBlock)(BGWOrderDriverStatus status, void(^success)(void));


@interface QPYTaskListSendGroupCell : UITableViewCell

@property (nonatomic, copy) ConfirmDriverStartBlock confirmDriverStartBlock;
@property (nonatomic, copy) DriverStatusBlock driverStatusBlock;

- (void)setTaskSendGroup:(QPYOrderTaskGroupModel *)groupModel;

@end
