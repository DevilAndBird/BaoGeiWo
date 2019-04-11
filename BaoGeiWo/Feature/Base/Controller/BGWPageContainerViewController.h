//
//  BGWPageContainerViewController.h
//  BaoGeiWo
//
//  Created by wb on 2018/5/7.
//  Copyright © 2018年 qyqs. All rights reserved.
//

#import "BaseViewController.h"

@interface BGWPageContainerViewController : BaseViewController


@property (nonatomic, strong) UIPageViewController *pageViewController;
@property (nonatomic, strong) NSMutableArray<UIViewController *> *viewControllers;

//控制pageView滑动
@property (nonatomic, assign) BOOL shouldBounce;
@property (nonatomic, assign) CGFloat lastPosition;
@property (nonatomic, assign) NSUInteger currentIndex;
@property (nonatomic, assign) NSUInteger nextIndex;






@end
