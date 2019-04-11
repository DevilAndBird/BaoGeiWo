//
//  MineViewController.m
//  BaoGeiWo
//
//  Created by wb on 2018/5/4.
//  Copyright © 2018年 qyqs. All rights reserved.
//

#import "MineViewController.h"
#import "LoginViewController.h"
#import "QPYUserSignViewController.h"
#import "MineUserInfoCell.h"
#import "OrderTaskDetailViewController.h"
#import "FeedbackViewController.h"

@interface MineViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *texts;
@property (nonatomic, strong) NSArray *images;

@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navBackButtonHidder = YES;
    self.navigationBar.titleLabel.text = @"我的";
    
//    self.texts = @[@[@"当前用户:"],
//                   @[@"员工手册", @"关于"],
//                   @[@"退出登录"]];
//    self.images = @[@[],
//                    @[@"mine_manual", @"mine_about"],
//                    @[@"mine_logout"]];
#if BGW_ENVIRONMENT
    self.texts = @[@[@"当前用户:"],
                   @[@"退出登录"]];
    self.images = @[@[],
                    @[@"mine_logout"]];
#else
    self.texts = @[@[@"当前用户:"],
                   @[@"退出登录"],
                   @[@"反馈测试"]];
    self.images = @[@[],
                    @[@"mine_logout"],
                    @[@"mine_logout"]];
#endif
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    tableView.dataSource = self;
    tableView.delegate = self;
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [tableView registerClass:[MineUserInfoCell class] forCellReuseIdentifier:@"MineUserInfoCell"];
    tableView.estimatedRowHeight = 100;
    tableView.rowHeight = UITableViewAutomaticDimension;
    [self.view addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigationBar.mas_bottom);
        make.left.bottom.right.equalTo(@0);
    }];
    self.tableView = tableView;
    

#if BGW_ENVIRONMENT
#else
    NSString *version = [NSString stringWithFormat:@"%@\n%@", [[[NSBundle mainBundle]infoDictionary] objectForKey:@"CFBundleShortVersionString"], [[[NSBundle mainBundle]infoDictionary] objectForKey:@"CFBundleVersion"]];
    UILabel *versionLabel = [[UILabel alloc] initWithTextColor:kMBlackColor font:BGWFont(18) textAlignment:NSTextAlignmentCenter];
    versionLabel.text = version;
    versionLabel.numberOfLines = 0;
    [self.view addSubview:versionLabel];
    [versionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.bottom.mas_equalTo(-80);
    }];
#endif
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccess) name:kBGWLoginSuccessNotification object:nil];
    
}

- (void)loginSuccess {
    [self.tableView reloadData];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.texts.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.texts[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell;
    if (indexPath.section == 0) {
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        cell =  [tableView dequeueReusableCellWithIdentifier:@"MineUserInfoCell" forIndexPath:indexPath];
        [(MineUserInfoCell *)cell setUserInfo];
//        cell.textLabel.text = [[self.texts[indexPath.section][indexPath.row] stringByAppendingString:[BGWUser getCurremtUserName]] stringByAppendingString:[BGWUser currentUser].mobile];
    } else {
        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        cell.textLabel.textColor = kMGrayColor;
        cell.textLabel.text = self.texts[indexPath.section][indexPath.row];
        cell.imageView.image = [UIImage imageNamed:self.images[indexPath.section][indexPath.row]];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1) {
        [self logout];
    } else if (indexPath.section == 2) {
        FeedbackViewController *vc = [[FeedbackViewController alloc] initWithOrderId:nil];
        [self.navigationController pushViewController:vc animated:YES];
//        OrderTaskDetailViewController *vc = [[OrderTaskDetailViewController alloc] initWithOrderNo:@"402159" taskType:BGWOrderTaskTypeOther roleType:BGWRoleActionTypeHotelTask];
//        [self.navigationController pushViewController:vc animated:YES];
//        QPYUserSignViewController *vc = [[QPYUserSignViewController alloc] init];
//        [self.navigationController pushViewController:vc animated:YES];
        
    }
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}
- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) return 0.00001;
    return 10;
}


- (void)logout {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确定退出？" message:@"" preferredStyle:UIAlertControllerStyleAlert];

    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[AppDelegate sharedAppDelegate] loginBGWUI];
        });
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}







@end
