//
//  MessageViewController.m
//  BaoGeiWo
//
//  Created by wb on 2018/5/22.
//  Copyright © 2018年 qyqs. All rights reserved.
//

#import "MessageViewController.h"
#import "OrderMessageCell.h"

#import "SystemMessageViewController.h"

#import "MessageRequest.h"
#import "MessageModel.h"

@interface MessageViewController ()<UITableViewDataSource, UITableViewDelegate>


@end

@implementation MessageViewController

- (instancetype)initWithMsgType:(BGWMessageType)msgType {
    self = [super init];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationBar.rightButton setTitle:@"忽略未读" forState:UIControlStateNormal];
    [self.navigationBar.rightButton addTarget:self action:@selector(overlookClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationBar.rightButtonWidth = 60;
    self.msgList = [NSMutableArray arrayWithCapacity:0];

    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigationBar.mas_bottom).with.offset(0);
        make.left.right.equalTo(@0);
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(@0).with.insets(self.view.safeAreaInsets);
        } else {
            make.bottom.equalTo(@0);
        }
    }];
    

    self.tableView.mj_header = [BGWRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(getMsgList)];
}




- (void)getMsgList {
    [MessageRequest getMessageListWithType:self.msgType success:^(id responseObject) {
        [self.tableView.mj_header endRefreshing];
        
        [self.msgList removeAllObjects];
        [self.msgList addObjectsFromArray:responseObject];
        [self.tableView reloadData];
        
    } failure:^(id error) {
        [self.tableView.mj_header endRefreshing];
    }];
}

#pragma mark- Event

- (void)overlookClick {
    BaseTabBarController *tabBarController = [AppDelegate sharedAppDelegate].tabBarController;
    if (!(tabBarController.unreadSystemMsgCount+tabBarController.unreadOrderMsgCount)) {
        return;
    }
    
    BGWMessageType tempType = self.msgType ;
    if (tempType == BGWMessageTypeOrder) {
        tempType = BGWMessageTypeAll;
    }
    
    [SVProgressHUD show];
    [MessageRequest updateMsgIsReadWithMsgId:nil msgType:tempType success:^(id responseObject) {
        [SVProgressHUD dismiss];
        POPUPINFO(@"已全部忽略");

        for (MessageModel *msg in self.msgList) {
            msg.isRead = @"1";
        }
        [self.tableView reloadData];
        
        if (self.msgType == BGWMessageTypeOrder) {
            [AppDelegate sharedAppDelegate].tabBarController.unreadOrderMsgCount = [AppDelegate sharedAppDelegate].tabBarController.unreadSystemMsgCount = 0;
        } else if (self.msgType == BGWMessageTypeSystem) {
            [AppDelegate sharedAppDelegate].tabBarController.unreadSystemMsgCount = 0;
        }
        
    } failure:^(id error) {
        [SVProgressHUD dismiss];
    }];
    
}





#pragma mark- TableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.msgList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OrderMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderMessageCell" forIndexPath:indexPath];
    [cell setContentWithIcon:@"message_system_small" titleStr:@"企业消息" msgModel:self.msgList[indexPath.row]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //消除未读
    __block MessageModel *msg = self.msgList[indexPath.row];
    if (msg.isRead.integerValue) {
        return;
    }
    
    [MessageRequest updateMsgIsReadWithMsgId:msg.msgId msgType:self.msgType success:^(id responseObject) {
        msg.isRead = @"1";
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        if (self.msgType == BGWMessageTypeOrder) {
            [AppDelegate sharedAppDelegate].tabBarController.unreadOrderMsgCount--;
        } else if (self.msgType == BGWMessageTypeSystem) {
            [AppDelegate sharedAppDelegate].tabBarController.unreadSystemMsgCount--;
        }
        
    } failure:^(id error) {
        //
    }];
}

#pragma mark- ui



- (UITableView *)tableView {
    
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        tableView.backgroundColor = kMBgColor;
        tableView.dataSource = self;
        tableView.delegate = self;
        [tableView registerClass:[OrderMessageCell class] forCellReuseIdentifier:@"OrderMessageCell"];
        tableView.estimatedRowHeight = 50;
        tableView.rowHeight = UITableViewAutomaticDimension;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView = tableView;
    }
    return _tableView;
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
