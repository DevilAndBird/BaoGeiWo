//
//  OrderMessageViewController.m
//  BaoGeiWo
//
//  Created by wb on 2018/5/25.
//  Copyright © 2018年 qyqs. All rights reserved.
//

#import "OrderMessageViewController.h"
#import "OrderMessageCell.h"
#import "MessageRequest.h"
#import "MessageModel.h"

#import "SystemMessageViewController.h"

@interface OrderMessageViewController ()

@property (nonatomic, assign) BOOL isRefresh;
@property (nonatomic, assign) BOOL isVisible;

@end

@implementation OrderMessageViewController

- (instancetype)init {
    self = [super initWithMsgType:BGWMessageTypeOrder];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.navigationBar.titleLabel.text = @"消息";
    self.navBackButtonHidder = YES;
    self.msgType = BGWMessageTypeOrder;

    
    UIView *systemMsgView = [self systemContainerView];
    [self.view addSubview:systemMsgView];
    [systemMsgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigationBar.mas_bottom).with.offset(8);
        make.left.right.equalTo(@0);
    }];
    
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(systemMsgView.mas_bottom).with.offset(8);
        make.left.bottom.right.equalTo(@0);
    }];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccess) name:kBGWLoginSuccessNotification object:nil];

    __weak typeof(self) ws = self;
    self.KVOController = [FBKVOController controllerWithObserver:self];
    
    //unreadSystemMsgCount
    [self.KVOController observe:[AppDelegate sharedAppDelegate].tabBarController keyPath:@"unreadSystemMsgCount" options:NSKeyValueObservingOptionNew block:^(id observer, id object, NSDictionary *change) {
        [ws onUnreadSystemMsg];
    }];
    [self.KVOController observe:[AppDelegate sharedAppDelegate].tabBarController keyPath:@"unreadOrderMsgCount" options:NSKeyValueObservingOptionNew block:^(id observer, id object, NSDictionary *change) {
        [ws onUnreadOrderMsg];
    }];
    [self onUnreadOrderMsg];
    [self onUnreadSystemMsg];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.isVisible = YES;
//    if (self.isRefresh) {
//        [self.tableView.mj_header beginRefreshing];
//        self.isRefresh = NO;
//    }
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.isVisible = NO;
}

- (void)loginSuccess {
    self.isRefresh = YES;
}

- (void)onUnreadOrderMsg {
    if (!self.isVisible) {
        [self.tableView.mj_header beginRefreshing];
    }
}

- (void)onUnreadSystemMsg {
    NSInteger unRead = [AppDelegate sharedAppDelegate].tabBarController.unreadSystemMsgCount;
    if (unRead < 0) {
        unRead = 0;
    }
    
    NSString *badge = @"";
    if (unRead > 0 && unRead <= 99) {
        badge = [NSString stringWithFormat:@"%d", (int)unRead];
    } else if (unRead > 99) {
        badge = @"99+";
    }
    self.unreadCountLabel.text = badge;
    self.unreadCountLabel.hidden = !unRead;
}

- (void)systemMsgClick {
    SystemMessageViewController *vc = [[SystemMessageViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark- TableView

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    OrderMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderMessageCell" forIndexPath:indexPath];
    [cell setContentWithIcon:@"message_order" titleStr:@"订单消息" msgModel:self.msgList[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.msgList.count == 0) {
        return DEVICE_HEIGHT-KNavBarHeight-100-64;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.msgList.count == 0) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT-KNavBarHeight-100-64)];
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"list_empty_placrholder"]];
        imageView.frame = CGRectMake(DEVICE_WIDTH/2-60, (DEVICE_HEIGHT)/2-KNavBarHeight-100-60, 120, 120);
        [view addSubview:imageView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, imageView.bgw_y+imageView.bgw_h+30, DEVICE_WIDTH, 15)];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"啊喔，什么也木有～";
        label.textColor = kMPromptColor;
        label.font = BGWFont(14);
        [view addSubview:label];
        
        return view;
        
    }else {
        return nil;
    }
}


- (UIView *)systemContainerView {
    
    UIView *containerView = [[UIView alloc] init];
    containerView.backgroundColor = kWhiteColor;;
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"message_system"]];
    [containerView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@20);
        make.centerY.equalTo(@0);
        make.left.equalTo(@15);
    }];
    
    UILabel *label = [[UILabel alloc] initWithTextColor:kMBlackColor font:BGWFont(16)];
    label.text = @"企业消息";
    [containerView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageView.mas_right).with.offset(10);
        make.centerY.equalTo(imageView);
    }];
    
    UILabel *unreadCountLabel = [[UILabel alloc] initWithTextColor:kWhiteColor font:BGWFont(10) textAlignment:NSTextAlignmentCenter];
    unreadCountLabel.backgroundColor = RGB(231, 77, 61);
    unreadCountLabel.layer.cornerRadius = 10.f;
    unreadCountLabel.clipsToBounds = YES;
    [containerView addSubview:unreadCountLabel];
    [unreadCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_offset(-30);
        make.width.height.equalTo(@20);
        make.centerY.equalTo(label);
    }];
    self.unreadCountLabel = unreadCountLabel;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(systemMsgClick)];
    [containerView addGestureRecognizer:tap];
    
    return containerView;
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
