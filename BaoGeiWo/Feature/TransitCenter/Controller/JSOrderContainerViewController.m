//
//  JSOrderContainerViewController.m
//  BaoGeiWo
//
//  Created by wb on 2018/5/25.
//  Copyright © 2018年 qyqs. All rights reserved.
//

#import "JSOrderContainerViewController.h"
#import "JSOrderListViewController.h"


@interface JSOrderContainerViewController ()

@property (nonatomic, strong) NSArray *segments;
@property (nonatomic, strong) UIView *segmentView;
@property (nonatomic, strong) NSArray<UIButton *> *segmentTabs;
@property (nonatomic, strong) UIButton *selectedTab;


@end

@implementation JSOrderContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationBar.titleLabel.text = @"查看订单";

    [self setupUI];
}


- (void)setupUI {
    self.segments = @[@"寄存件", @"已完成"];
    
    [self.view addSubview:self.segmentView];
    [self.segmentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigationBar.mas_bottom);
        make.left.right.equalTo(@0);
        make.height.equalTo(@36);
    }];
    for (NSInteger i = 0; i < self.segments.count; i++) {
        [self.viewControllers addObject:[[JSOrderListViewController alloc] initWithType:i+1]];
    }
    
    [self.pageViewController.view mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.segmentView.mas_bottom);
        make.left.right.equalTo(@0);
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(@0).with.insets(self.view.safeAreaInsets);
        } else {
            make.bottom.equalTo(@0);
        }
    }];
    
    [self.pageViewController setViewControllers:@[[self.viewControllers firstObject]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    self.selectedTab = [self.segmentTabs firstObject];
}



- (void)selectVC:(UIButton *)sender {
    self.nextIndex = [self.segmentTabs indexOfObject:sender];
    UIPageViewControllerNavigationDirection direction = self.nextIndex > self.currentIndex ? UIPageViewControllerNavigationDirectionForward : UIPageViewControllerNavigationDirectionReverse;
    [self.pageViewController setViewControllers:@[self.viewControllers[self.nextIndex]] direction:direction animated:YES completion:nil];
    self.currentIndex = self.nextIndex;
    self.selectedTab = sender;
    
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed {
    
    if(completed) {
        NSInteger index = self.currentIndex = [self.viewControllers indexOfObject:[pageViewController.viewControllers objectAtIndex:0]];
        self.selectedTab = self.segmentTabs[index];
    }
    
    self.nextIndex = self.currentIndex;
}


- (UIButton *)initialTabWithText:(NSString *)text {
    
    UIButton *tab = [[UIButton alloc] init];
    [tab setTitle:text forState:UIControlStateNormal & UIControlStateSelected];
    [tab setTitleColor:kMBlackColor forState:UIControlStateNormal];
    [tab setTitleColor:kMThemeColor forState:UIControlStateSelected];
    tab.titleLabel.font = BGWFont(14);
    [tab addTarget:self action:@selector(selectVC:) forControlEvents:UIControlEventTouchUpInside];
    
    return tab;
    
}


#pragma mark- Properties
- (void)setSelectedTab:(UIButton *)selectedTab {
    if (_selectedTab == selectedTab) {
        return;
    }
    _selectedTab.userInteractionEnabled = YES;
    _selectedTab.selected = NO;
    selectedTab.selected = YES;
    _selectedTab = selectedTab;
    _selectedTab.userInteractionEnabled = NO;
}

- (UIView *)segmentView {
    if (!_segmentView) {
        UIView *segment = [[UIView alloc] init];
        segment.backgroundColor = kWhiteColor;
        
        NSMutableArray *tempArr = [NSMutableArray arrayWithCapacity:0];
        CGFloat tabW = DEVICE_WIDTH/self.segments.count;
        for (NSInteger i = 0; i < self.segments.count; i++) {
            
            UIButton *tab1 = [self initialTabWithText:self.segments[i]];
            [segment addSubview:tab1];
            [tab1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.equalTo(@0);
                make.left.equalTo(@(tabW*i));
                make.width.equalTo(@(tabW));
            }];
            [tempArr addObject:tab1];
            
            UIView *sepLine = [[UIView alloc] init];
            sepLine.backgroundColor = kMSeparateColor;
            [segment addSubview:sepLine];
            [sepLine mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.equalTo(@0);
                make.left.equalTo(tab1.mas_right);
                make.width.equalTo(@.5);
            }];
            
        }
        self.segmentTabs = tempArr;
        _segmentView = segment;
        
    }
    return _segmentView;
}




@end
