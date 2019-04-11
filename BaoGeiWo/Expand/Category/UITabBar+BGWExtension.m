//
//  UITabBar+BGWExtension.m
//  BaoGeiWo
//
//  Created by wb on 2018/5/3.
//  Copyright © 2018年 qyqs. All rights reserved.
//

#import "UITabBar+BGWExtension.h"


#define TabbarItemNums  5.0

@implementation UITabBar (BGWExtension)


//显示小红点
- (void)showBadgeOnItemIndex:(NSInteger)index{
    //移除之前的小红点
    [self removeBadgeOnItemIndex:index];
    
    //新建小红点
    UIView *badgeView = [[UIView alloc]init];
    badgeView.tag = 888 + index;
    badgeView.layer.cornerRadius = 5.0;//圆形
    badgeView.backgroundColor = [UIColor redColor];//颜色：红色
    CGRect tabFrame = self.frame;
    
    //确定小红点的位置
    CGFloat percentX = (index + 0.6) / TabbarItemNums;
    CGFloat x = ceilf(percentX * tabFrame.size.width);
    CGFloat y = ceilf(0.1 * tabFrame.size.height);
    badgeView.frame = CGRectMake(x, y, 10.0, 10.0);//圆形大小为10
    badgeView.clipsToBounds = YES;
    [self addSubview:badgeView];
}

//隐藏小红点
- (void)hideBadgeOnItemIndex:(NSInteger)index{
    //移除小红点
    [self removeBadgeOnItemIndex:index];
}

//移除小红点
- (void)removeBadgeOnItemIndex:(NSInteger)index{
    //按照tag值进行移除
    for (UIView *subView in self.subviews) {
        if (subView.tag == 888+index) {
            [subView removeFromSuperview];
        }
    }
}

- (void)setBGView {
    UIImageView *bg = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.bgw_h-79, DEVICE_WIDTH, 79)];
    bg.contentMode = UIViewContentModeCenter;
    bg.image = [UIImage imageNamed:@"tabbar_bg"];
    [bg.image stretchableImageWithLeftCapWidth:10 topCapHeight:10];
    [self addSubview:bg];
    
}


@end
