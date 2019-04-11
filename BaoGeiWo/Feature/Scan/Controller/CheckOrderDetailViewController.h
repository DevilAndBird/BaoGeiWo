//
//  CheckOrderDetailViewController.h
//  BaoGeiWo
//
//  Created by wb on 2018/5/29.
//  Copyright © 2018年 qyqs. All rights reserved.
//

#import "OrderTaskDetailViewController.h"

typedef void(^BackBlock)(void);

@interface CheckOrderDetailViewController : OrderTaskDetailViewController

@property (nonatomic, copy) BackBlock backBlock;

@end
