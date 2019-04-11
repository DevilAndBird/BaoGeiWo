//
//  BGWPageContainerViewController.m
//  BaoGeiWo
//
//  Created by wb on 2018/5/7.
//  Copyright © 2018年 qyqs. All rights reserved.
//

#import "BGWPageContainerViewController.h"

@interface BGWPageContainerViewController ()<UIPageViewControllerDataSource, UIPageViewControllerDelegate, UIScrollViewDelegate>



@end

@implementation BGWPageContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.viewControllers = [NSMutableArray arrayWithCapacity:0];

    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    [self.pageViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigationBar.mas_bottom);
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

}


- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    if ([self.viewControllers indexOfObject:viewController] > 0) {
        return self.viewControllers[[self.viewControllers indexOfObject:viewController]-1];
    }
    return nil;
    
}
- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    if ([self.viewControllers indexOfObject:viewController] < self.viewControllers.count-1) {
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
//        NSInteger index = self.currentIndex = [self.viewControllers indexOfObject:[pageViewController.viewControllers objectAtIndex:0]];
//        self.selectedTab = self.segmentTabs[index];
        
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
