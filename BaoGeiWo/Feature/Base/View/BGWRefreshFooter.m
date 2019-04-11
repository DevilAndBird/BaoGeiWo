//
//  BGWRefreshFooter.m
//  BaoGeiWo
//
//  Created by wb on 2018/5/16.
//  Copyright © 2018年 qyqs. All rights reserved.
//

#import "BGWRefreshFooter.h"

@interface BGWRefreshFooter()
@property (weak, nonatomic) UILabel *label;
@property (weak, nonatomic) UIActivityIndicatorView *loading;
@end

@implementation BGWRefreshFooter

#pragma mark - 重写方法
#pragma mark 在这里做一些初始化配置（比如添加子控件）
- (void)prepare
{
    [super prepare];
    
    // 设置控件的高度
    self.mj_h = 44;
    
    // 添加label
    UILabel *label = [[UILabel alloc] init];
    label.textColor = kMBlackColor;
    label.font = BGWFont(14);
    label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:label];
    self.label = label;
    
    // loading
    UIActivityIndicatorView *loading = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self addSubview:loading];
    self.loading = loading;
}

#pragma mark 在这里设置子控件的位置和尺寸
- (void)placeSubviews
{
    [super placeSubviews];
    
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(@0);
    }];
    
    [self.loading mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(@0);
        
    }];
}

#pragma mark 监听scrollView的contentOffset改变
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{
    [super scrollViewContentOffsetDidChange:change];
    
}

#pragma mark 监听scrollView的contentSize改变
- (void)scrollViewContentSizeDidChange:(NSDictionary *)change
{
    [super scrollViewContentSizeDidChange:change];
    
}

#pragma mark 监听scrollView的拖拽状态改变
- (void)scrollViewPanStateDidChange:(NSDictionary *)change
{
    [super scrollViewPanStateDidChange:change];
    
}

#pragma mark 监听控件的刷新状态
- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState;
    
    switch (state) {
        case MJRefreshStateIdle:
            self.label.hidden = NO;
            [self.loading stopAnimating];
            self.label.text = @"上拉加载";
            break;
        case MJRefreshStatePulling:
            [self.loading stopAnimating];
            self.label.hidden = NO;
            self.label.text = @"松开加载";
            break;
        case MJRefreshStateRefreshing:
            self.label.text = @"正在加载";
            self.label.hidden = YES;
            [self.loading startAnimating];
            break;
        case MJRefreshStateNoMoreData:
            self.label.text = @"已经到底了";
            self.label.hidden = NO;
            [self.loading stopAnimating];
            break;
        default:
            break;
    }
}

#pragma mark 监听拖拽比例（控件被拖出来的比例）
- (void)setPullingPercent:(CGFloat)pullingPercent
{
    [super setPullingPercent:pullingPercent];
    
}


@end
