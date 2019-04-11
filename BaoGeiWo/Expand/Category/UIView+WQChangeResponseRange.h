//
//  UIView+WQChangeResponseRange.h
//  WQProject
//
//  Created by wb on 2018/8/9.
//  Copyright © 2018年 qyqs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (WQChangeResponseRange)

- (void)setupLeastRecommendRange:(BOOL)yesOrNo;
- (void)changeResponseRange:(UIEdgeInsets)changeInsets;

@end
