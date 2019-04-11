//
//  OrderMessageCell.h
//  BaoGeiWo
//
//  Created by wb on 2018/5/22.
//  Copyright © 2018年 qyqs. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MessageModel;
@interface OrderMessageCell : UITableViewCell

- (void)setContentWithIcon:(NSString *)icon title:(NSString *)title time:(NSString *)time detail:(NSString *)detail;
- (void)setContentWithIcon:(NSString *)icon titleStr:(NSString *)title msgModel:(MessageModel *)msgModel;

@end
