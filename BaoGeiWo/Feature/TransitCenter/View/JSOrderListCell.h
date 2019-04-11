//
//  JSOrderListCell.h
//  BaoGeiWo
//
//  Created by wb on 2018/5/25.
//  Copyright © 2018年 qyqs. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JSOrderListModel;
@interface JSOrderListCell : UITableViewCell

- (void)setOrderContent:(JSOrderListModel *)order;

@end
