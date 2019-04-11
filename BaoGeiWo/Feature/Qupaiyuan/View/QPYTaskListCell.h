//
//  QPYTaskListCell.h
//  BaoGeiWo
//
//  Created by wb on 2018/5/11.
//  Copyright © 2018年 qyqs. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QPYOrderTaskListModel;

typedef void(^CallBlock)(void);
typedef void(^MapBlock)(void);
typedef void(^NotifyAppCusBlock)(void);

typedef void(^ConfirmDriverStartBlock)(void);
typedef void(^ConfirmDriverArrivingBlock)(void);
typedef void(^ConfirmDriverArrivedBlock)(void);
typedef void(^DriverStatusBlock)(BGWOrderDriverStatus status, void(^success)(void));

@interface QPYTaskListCell : UITableViewCell

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) QPYOrderTaskListModel *taskModel;


@property (nonatomic, strong) UIView *addressView;
@property (nonatomic, strong) UIView *bottomButtonView;

@property (nonatomic, copy) CallBlock callBlock;
@property (nonatomic, copy) MapBlock mapBlock;
@property (nonatomic, copy) NotifyAppCusBlock notifyAppCusBlock;

@property (nonatomic, copy) ConfirmDriverStartBlock confirmDriverStartBlock;
@property (nonatomic, copy) ConfirmDriverArrivingBlock confirmDriverArrivingBlock;
@property (nonatomic, copy) ConfirmDriverArrivedBlock confirmDriverArrivedBlock;
@property (nonatomic, copy) DriverStatusBlock driverStatusBlock;

- (void)setOrderTaskListModel:(QPYOrderTaskListModel *)taskModel taskType:(BGWOrderTaskType)taskType;
- (void)setTakeTimeWithTaskModel:(QPYOrderTaskListModel *)taskModel;

@end
