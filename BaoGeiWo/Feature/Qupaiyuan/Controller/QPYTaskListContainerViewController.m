//
//  QPYTaskListContainerViewController.m
//  BaoGeiWo
//
//  Created by wb on 2018/5/7.
//  Copyright © 2018年 qyqs. All rights reserved.
//

#import "QPYTaskListContainerViewController.h"
#import "QPYTaskListViewController.h"
#import "OrderRequest.h"

#import "PopoverView.h"
#import "QPYTaskMapViewController.h"

@interface QPYTaskListContainerViewController ()<UIPageViewControllerDataSource, UIPageViewControllerDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) UIPageViewController *pageViewController;
@property (nonatomic, strong) NSMutableArray<UIViewController *> *viewControllers;

//控制pageView滑动
@property (nonatomic, assign) BOOL shouldBounce;
@property (nonatomic, assign) CGFloat lastPosition;
@property (nonatomic, assign) NSUInteger currentIndex;
@property (nonatomic, assign) NSUInteger nextIndex;



@property (nonatomic, strong) UIView *segmentView;
@property (nonatomic, strong) NSArray<UIButton *> *segmentTabs;
@property (nonatomic, strong) UIButton *selectedTab;

@end

@implementation QPYTaskListContainerViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBar.titleLabel.text = @"任务列表";
    [self.navigationBar.rightButton setImage:[UIImage imageNamed:@"task_more"] forState:UIControlStateNormal];
    self.navigationBar.rightButtonWidth = 44;
    [self.navigationBar.rightButton addTarget:self action:@selector(moreClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.segmentView];
    [self.segmentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigationBar.mas_bottom);
        make.left.right.equalTo(@0);
        make.height.equalTo(@40);
    }];
    
    self.viewControllers = [NSMutableArray arrayWithCapacity:0];
//    [self.viewControllers addObject:[[QPYTaskListViewController alloc] initWithTaskType:BGWOrderTaskTypeAll]];
    [self.viewControllers addObject:[[QPYTaskListViewController alloc] initWithTaskType:BGWOrderTaskTypePrepareReceive container:self]];
    [self.viewControllers addObject:[[QPYTaskListViewController alloc] initWithTaskType:BGWOrderTaskTypePrepareSend container:self]];
    [self.viewControllers addObject:[[QPYTaskListViewController alloc] initWithTaskType:BGWOrderTaskTypeOnGoing container:self]];
    [self.viewControllers addObject:[[QPYTaskListViewController alloc] initWithTaskType:BGWOrderTaskTypeFinished container:self]];

    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    [self.pageViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.segmentView.mas_bottom);
        make.left.right.equalTo(@0);
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(@0).with.insets(self.view.safeAreaInsets);
        } else {
            make.bottom.equalTo(@0);
        }
    }];
    for (UIView *view in self.pageViewController.view.subviews) {
        if ([view isKindOfClass:[UIScrollView class]])
            ((UIScrollView *)view).delegate = self;
    }
    
    [self.pageViewController setViewControllers:@[[self.viewControllers firstObject]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    self.selectedTab = [self.segmentTabs firstObject];
    
    [self getTaskNumber];
}

- (void)reloadSegmentNumber {
    [self getTaskNumber];
}

- (void)getTaskNumber {
    [OrderRequest getOrderTaskNumber:^(id responseObject) {
        [self reloadSegmentTabs:responseObject];
    } failure:^(id error) {
        //
    }];
}

- (void)reloadSegmentTabs:(NSDictionary *)dic {
    NSArray *keys = @[@"taskNum", @"sendNum", @"goingNum", @"finishNum"];
    NSArray *titles = @[@"待取", @"待派", @"进行中", @"已完成"];
    for (NSInteger i = 0; i<self.segmentTabs.count; i++) {
        NSString *text = [NSString stringWithFormat:@"%@(%@)", titles[i], dic[keys[i]]?:@"0"];
        [self.segmentTabs[i] setTitle:text forState:UIControlStateNormal & UIControlStateSelected];
    }
    
}

- (void)selectVC:(UIButton *)sender {
    self.nextIndex = [self.segmentTabs indexOfObject:sender];
//    NSLog(@"current:%ld,  next:%ld", self.currentIndex, self.nextIndex);
    UIPageViewControllerNavigationDirection direction = self.nextIndex > self.currentIndex ? UIPageViewControllerNavigationDirectionForward : UIPageViewControllerNavigationDirectionReverse;
    [self.pageViewController setViewControllers:@[self.viewControllers[self.nextIndex]] direction:direction animated:YES completion:nil];
    self.currentIndex = self.nextIndex;
    self.selectedTab = sender;
    
}


#pragma mark - popover
- (void)moreClick:(UIButton *)sender {
    
    __weak typeof(self) weakSelf = self;
    PopoverAction *action1 = [PopoverAction actionWithImage:[UIImage imageNamed:@"task_popover_map"] title:@"地图模式" handler:^(PopoverAction *action) {
        [weakSelf taskMapMode];
    }];
    PopoverAction *action2 = [PopoverAction actionWithImage:[UIImage imageNamed:@"task_popover_phone"] title:@"联系调度" handler:^(PopoverAction *action) {
        [weakSelf contactAttemper];
    }];
    
    PopoverView *popoverView = [PopoverView popoverView];
    popoverView.style = PopoverViewStyleDark;
    //    popoverView.hideAfterTouchOutside = NO; // 点击外部时不允许隐藏
    [popoverView showToView:sender withActions:@[action1, action2]];
    
}

- (void)taskMapMode {
    QPYTaskMapViewController *vc = [[QPYTaskMapViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)contactAttemper {
    [UIWebView webViewCallWithPhoneNumber:@"18221763073"];
}


#pragma mark - page
- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {

    if ([self.viewControllers indexOfObject:viewController] > 0) {
        return self.viewControllers[[self.viewControllers indexOfObject:viewController]-1];
    }
    return nil;
    
}
- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    if ([self.viewControllers indexOfObject:viewController] < self.segmentTabs.count-1) {
        return self.viewControllers[[self.viewControllers indexOfObject:viewController]+1];
    }
    return nil;
}

#pragma mark- PageViewControllerDelegate
- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers {
    
    
    id controller = [pendingViewControllers firstObject];
    self.nextIndex = [self.viewControllers indexOfObject:controller];
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController{
    
    return (NSInteger)self.currentIndex;
}


- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed{
    
    if(completed) {
        NSInteger index = self.currentIndex = [self.viewControllers indexOfObject:[pageViewController.viewControllers objectAtIndex:0]];
        self.selectedTab = self.segmentTabs[index];
        
    }
    
    self.nextIndex = self.currentIndex;
    
    
}

#pragma mark- UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.nextIndex > self.currentIndex) {
        if (scrollView.contentOffset.x < (self.lastPosition - (.9 * scrollView.bounds.size.width))) {
            self.currentIndex = self.nextIndex;
        }
    } else {
        if (scrollView.contentOffset.x > (self.lastPosition + (.9 * scrollView.bounds.size.width))) {
            self.currentIndex = self.nextIndex;
        }
    }
    
    CGFloat minXOffset = scrollView.bounds.size.width - (self.currentIndex * scrollView.bounds.size.width);
    CGFloat maxXOffset = (([self.viewControllers count] - self.currentIndex) * scrollView.bounds.size.width);
    
    if (!self.shouldBounce) {
        CGRect scrollBounds = scrollView.bounds;
        if (scrollView.contentOffset.x <= minXOffset) {
            scrollView.contentOffset = CGPointMake(minXOffset, 0);
            // scrollBounds.origin = CGPointMake(minXOffset, 0);
        } else if (scrollView.contentOffset.x >= maxXOffset) {
            scrollView.contentOffset = CGPointMake(maxXOffset, 0);
            // scrollBounds.origin = CGPointMake(maxXOffset, 0);
        }
        [scrollView setBounds:scrollBounds];
    }
    self.lastPosition = scrollView.contentOffset.x;
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    /* Need to calculate max/min offset for *every* page, not just the first and last. */
    CGFloat minXOffset = scrollView.bounds.size.width - (self.currentIndex * scrollView.bounds.size.width);
    CGFloat maxXOffset = (([self.viewControllers count] - self.currentIndex) * scrollView.bounds.size.width);
    
    if (!self.shouldBounce) {
        if (scrollView.contentOffset.x <= minXOffset) {
            *targetContentOffset = CGPointMake(minXOffset, 0);
        } else if (scrollView.contentOffset.x >= maxXOffset) {
            *targetContentOffset = CGPointMake(maxXOffset, 0);
        }
    }
}


- (UIButton *)initialTabWithText:(NSString *)text {
    
    UIButton *tab = [[UIButton alloc] init];
    [tab setTitle:text forState:UIControlStateNormal & UIControlStateSelected];
    [tab setTitleColor:kGrayColor forState:UIControlStateNormal];
    [tab setTitleColor:kMThemeColor forState:UIControlStateSelected];
    tab.titleLabel.font = BGWFont(14);
    [tab addTarget:self action:@selector(selectVC:) forControlEvents:UIControlEventTouchUpInside];
    
    return tab;
}

- (UIView *)separateHorView {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = kMSeparateColor;
    return view;
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
        
        CGFloat separateW = .5;
        CGFloat separateT = 10;
        
//        CGFloat tabW = DEVICE_WIDTH/4;
//        UIButton *tab0 = [self initialTabWithText:@"今日"];
//        [segment addSubview:tab0];
//        [tab0 mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.bottom.equalTo(@0);
//            make.left.equalTo(@0);
//
//        }];
        
//        UIButton *tab1 = [self initialTabWithText:@"待取"];
//        [segment addSubview:tab1];
//        [tab1 mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.bottom.equalTo(@0);
//            make.left.equalTo(tab0.mas_right);
//            make.width.equalTo(tab0.mas_width);
//        }];
        UIButton *tab1 = [self initialTabWithText:@"待取(0)"];
        [segment addSubview:tab1];
        [tab1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(@0);
            make.left.equalTo(@0);
//            make.width.equalTo(@(tabW));
        }];
        UIView *separate1 = [self separateHorView];
        [segment addSubview:separate1];
        [separate1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(tab1.mas_right);
            make.top.equalTo(@(separateT));
            make.centerY.equalTo(segment);
            make.width.equalTo(@(separateW));
        }];
        
        UIButton *tab2 = [self initialTabWithText:@"待派(0)"];
        [segment addSubview:tab2];
        [tab2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(@0);
            make.left.equalTo(tab1.mas_right);
            make.width.equalTo(tab1.mas_width);
        }];
        UIView *separate2 = [self separateHorView];
        [segment addSubview:separate2];
        [separate2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(tab2.mas_right);
            make.top.equalTo(@(separateT));
            make.centerY.equalTo(segment);
            make.width.equalTo(@(separateW));
        }];

        UIButton *tab3 = [self initialTabWithText:@"进行中(0)"];
        [segment addSubview:tab3];
        [tab3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(@0);
            make.left.equalTo(tab2.mas_right);
            make.width.equalTo(tab2.mas_width);
        }];
        UIView *separate3 = [self separateHorView];
        [segment addSubview:separate3];
        [separate3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(tab3.mas_right);
            make.top.equalTo(@(separateT));
            make.centerY.equalTo(segment);
            make.width.equalTo(@(separateW));
        }];
        
        UIButton *tab4 = [self initialTabWithText:@"已完成(0)"];
        [segment addSubview:tab4];
        [tab4 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(@0);
            make.left.equalTo(tab3.mas_right);
            make.right.equalTo(@0);
            make.width.equalTo(tab3.mas_width);
        }];


        self.segmentTabs = @[tab1, tab2, tab3, tab4];
        _segmentView = segment;
    }
    return _segmentView;
}

- (UIPageViewController *)pageViewController {
    if (!_pageViewController) {
        _pageViewController = [[UIPageViewController alloc]initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
        _pageViewController.view.backgroundColor = RGBOF(0xf3f3f3);
        _pageViewController.delegate = self;
        _pageViewController.dataSource = self;
    }
    return _pageViewController;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
