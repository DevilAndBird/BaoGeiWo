//
//  QPYDeliverContainerViewController.m
//  BaoGeiWo
//
//  Created by wb on 2018/5/7.
//  Copyright © 2018年 qyqs. All rights reserved.
//

#import "QPYOrderListContainerViewController.h"
#import "QPYOrderListViewController.h"

#import "CommonRequest.h"

#import "BGWTransitCenter.h"

@interface QPYOrderListContainerViewController ()

@property (nonatomic, assign) BGWCityNodeType type;

@property (nonatomic, strong) NSArray *segments;
@property (nonatomic, strong) UIView *segmentView;
@property (nonatomic, strong) NSArray<UIButton *> *segmentTabs;
@property (nonatomic, strong) UIButton *selectedTab;

@end

@implementation QPYOrderListContainerViewController

- (instancetype)initWithCityNodeType:(BGWCityNodeType)type {
    self = [super init];
    if (self) {
        self.type = type;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBar.titleLabel.text = @"交接订单";
    self.pageViewController.view.userInteractionEnabled = NO;
    
    [SVProgressHUD show];
    [CommonRequest getCityNodeWithType:self.type success:^(id responseObject) {
        [SVProgressHUD dismiss];

        self.segments = responseObject;
        [self setupUI];

    } failure:^(id error) {
        [SVProgressHUD dismiss];
    }];
}


- (void)setupUI {
    self.pageViewController.view.userInteractionEnabled = YES;

    [self.view addSubview:self.segmentView];
    [self.segmentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigationBar.mas_bottom);
        make.left.right.equalTo(@0);
        make.height.equalTo(@36);
    }];
    
    [self.pageViewController.view mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.segmentView.mas_bottom);
        make.left.right.equalTo(@0);
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(@0).with.insets(self.view.safeAreaInsets);
        } else {
            make.bottom.equalTo(@0);
        }
    }];
    
    for (NSInteger i = 0; i < self.segments.count; i++) {
        [self.viewControllers addObject:[[QPYOrderListViewController alloc] initWithTransitCenter:self.segments[i] cityNodeType:self.type]];
    }
    
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
            UIButton *tab1;
            
            id model = self.segments[i];
            if ([model isKindOfClass:[BGWTransitCenter class]]) {
                tab1 = [self initialTabWithText:((BGWTransitCenter *)model).transitCenterName];
            } else {
                tab1 = [UIButton new];
            }
            
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
        
//        UIButton *tab1 = [self initialTabWithText:@"集散中心1"];
//        [segment addSubview:tab1];
//        [tab1 mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.bottom.equalTo(@0);
//            make.left.equalTo(@0);
//        }];
//
//        UIButton *tab2 = [self initialTabWithText:@"集散中心2"];
//        [segment addSubview:tab2];
//        [tab2 mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.bottom.equalTo(@0);
//            make.left.equalTo(tab1.mas_right);
//            make.width.equalTo(tab1.mas_width);
//        }];
//
//        UIButton *tab3 = [self initialTabWithText:@"集散中心3"];
//        [segment addSubview:tab3];
//        [tab3 mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.bottom.equalTo(@0);
//            make.left.equalTo(tab2.mas_right);
//            make.width.equalTo(tab2.mas_width);
//        }];
//
//        UIButton *tab4 = [self initialTabWithText:@"集散中心4"];
//        [segment addSubview:tab4];
//        [tab4 mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.bottom.equalTo(@0);
//            make.left.equalTo(tab3.mas_right);
//            make.right.equalTo(@0);
//            make.width.equalTo(tab3.mas_width);
//        }];
//
        

    }
    return _segmentView;
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
