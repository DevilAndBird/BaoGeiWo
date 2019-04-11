//
//  GTOrderListCell.h
//  BaoGeiWo
//
//  Created by wb on 2018/6/20.
//  Copyright © 2018年 qyqs. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GTOrderListModel;
@interface GTOrderListCell : UITableViewCell

@property (nonatomic, strong) UIView *containerView;

@property (nonatomic, copy) void(^cancelOrder)(NSString *orderId);
@property (nonatomic, copy) void(^paidOrder)(NSString *orderNo);

- (void)setOrderContent:(GTOrderListModel *)order;

@end
