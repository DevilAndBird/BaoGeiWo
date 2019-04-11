//
//  MessageViewController.h
//  BaoGeiWo
//
//  Created by wb on 2018/5/22.
//  Copyright © 2018年 qyqs. All rights reserved.
//

#import "BaseViewController.h"

@interface MessageViewController : BaseViewController

@property (nonatomic, strong) UILabel *unreadCountLabel;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *msgList;
@property (nonatomic, assign) BGWMessageType msgType;

- (instancetype)initWithMsgType:(BGWMessageType)msgType;

@end
