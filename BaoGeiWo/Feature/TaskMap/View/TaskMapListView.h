//
//  TaskMapListView.h
//  BaoGeiWo
//
//  Created by wb on 2018/7/13.
//  Copyright © 2018年 qyqs. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QPYOrderTaskListModel;
@interface TaskMapListView : UIView

@property (nonatomic, copy) void(^deselectAnnotation)(void);
@property (nonatomic, copy) void(^selectTaskDetaik)(QPYOrderTaskListModel *task);

- (void)setTaskList:(NSArray *)list height:(CGFloat)height;
- (void)setListViewHeight:(CGFloat)height;

@end
