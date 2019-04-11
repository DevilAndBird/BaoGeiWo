//
//  TaskMapListCell.h
//  BaoGeiWo
//
//  Created by wb on 2018/7/13.
//  Copyright © 2018年 qyqs. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QPYOrderTaskListModel;
@interface TaskMapListCell : UITableViewCell

@property (nonatomic, strong) UIView *containerView;

- (void)setContent:(QPYOrderTaskListModel *)taskModel;
- (UIView *)initialAddresInfoView;

- (void)setContainerViewHeight:(CGFloat)height;

@end
