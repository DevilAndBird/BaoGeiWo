//
//  OrderTaskDetailCell.h
//  BaoGeiWo
//
//  Created by wb on 2018/5/14.
//  Copyright © 2018年 qyqs. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OrderDetailModel;
@class QPYOrderTaskListModel;

typedef void(^CallBlock)(NSInteger tag);

@interface OrderTaskDetailCell : UITableViewCell

@property (nonatomic, strong) UILabel *orderNumberLabel;

@property (nonatomic, copy) CallBlock callBlock;
@property (nonatomic, copy) void(^priceTapBlock)(void);

- (void)setOrderDetailModel:(OrderDetailModel *)orderDetail;

- (void)initialLabels:(NSArray *)array;
- (UIView *)customViewWithImage:(NSString *)image text:(NSString *)text;
- (UIView *)customViewWithImage:(NSString *)image text:(NSString *)text textColor:(UIColor *)textColor;

@end
