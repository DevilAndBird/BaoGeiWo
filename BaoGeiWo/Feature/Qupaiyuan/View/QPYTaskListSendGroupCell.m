//
//  QPYTaskListSendGroupCell.m
//  BaoGeiWo
//
//  Created by wb on 2018/6/22.
//  Copyright © 2018年 qyqs. All rights reserved.
//

#import "QPYTaskListSendGroupCell.h"
#import "QPYTaskListAddressInfoView.h"
#import "QPYOrderTaskListModel.h"

@interface QPYTaskListSendGroupCell()

@property (nonatomic, strong) UIImageView *taskTypeImageView;
@property (nonatomic, strong) UILabel *promptLabel;

@property (nonatomic, strong) UILabel *destAddressLabel;
@property (nonatomic, strong) UILabel *destAddressDescLabel;
@property (nonatomic, strong) UILabel *sendTimeLabel;

@property (nonatomic, strong) UIButton *rightButton;

@property (nonatomic, strong) QPYOrderTaskListModel *taskModel;

@end


@implementation QPYTaskListSendGroupCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = self.contentView.backgroundColor = kMBgColor;
        [self setupTaskListSendGroupUI];
    }
    return self;
}

- (void)setTaskSendGroup:(QPYOrderTaskGroupModel *)groupModel {
    QPYOrderTaskListModel *taskModel = [groupModel.taskGroup firstObject];
    self.taskModel = taskModel;
    BGWRoleActionType roleType = [taskModel.roleType roleActionType];
    [self setTaskTypeImage:roleType];
    self.promptLabel.text = [NSString stringWithFormat:@"查看更多(%zd条) >", groupModel.taskGroup.count];

    if (taskModel.nextBindAction) {
        if ([taskModel.nextBindAction.destAddress isEqualToString:@""] || !taskModel.nextBindAction.destAddress) {
            self.destAddressLabel.text = @"酒店/住宅";
        } else {
            self.destAddressLabel.text = taskModel.nextBindAction.destAddress;
        }
    } else {
        if ([taskModel.destAddress isEqualToString:@""] || !taskModel.destAddress) {
            self.destAddressLabel.text = @"酒店/住宅";
        } else {
            self.destAddressLabel.text = taskModel.destAddress;
        }
    }
    
    self.destAddressDescLabel.text = taskModel.destAddressDesc;
    self.sendTimeLabel.text = [taskModel.arrivedTime interactiveTime];
    
    
    switch (taskModel.taskType) {
        case BGWOrderTaskTypePrepareReceive:
        case BGWOrderTaskTypePrepareSend:
            [self.rightButton setTitle:@"确认发车" forState:UIControlStateNormal];
            self.rightButton.tag = 100;
            break;
            
        case BGWOrderTaskTypeOnGoing:
            if (roleType == BGWRoleActionTypeHotelTask || roleType == BGWRoleActionTypeHotelSend) {
                [self.rightButton setTitle:@"通知" forState:UIControlStateNormal];
                self.rightButton.tag = 103;
            } else {
                //即将到达
                if ([taskModel.travelStatus isEqualToString:@""] || taskModel.travelStatus==nil) {
                    [self.rightButton setTitle:@"即将到达" forState:UIControlStateNormal];
                    self.rightButton.tag = 101;
                } else {
                    [self.rightButton setTitle:@"确认到达" forState:UIControlStateNormal];
                    self.rightButton.tag = 102;
                }
                
            }
            
            break;
        case BGWOrderTaskTypeFinished:
        default:
            break;
    }
    
}

- (void)rightClick:(UIButton *)sender {
    if (sender.tag == 100) {
        [self driverStart:sender];
    } else if (sender.tag == 101 || sender.tag == 102) {
        [self driverStatusChange:sender];
    } else if (sender.tag == 103) {
        [self notifyUser:sender];
    }
}

- (void)driverStart:(UIButton *)sender {
    if (self.confirmDriverStartBlock) {
        self.confirmDriverStartBlock();
    }
}

- (void)notifyUser:(UIButton *)sender {
    //
    POPUPINFO(@"notify");
}

- (void)driverStatusChange:(UIButton *)sender {
    
    if ([sender.currentTitle isEqualToString:@"即将到达"]) {
        if (self.driverStatusBlock) {
            self.driverStatusBlock(BGWOrderDriverStatusArriving, ^{
                [sender setTitle:@"确认到达" forState:UIControlStateNormal];
            });
            
        }
    } else if ([sender.currentTitle isEqualToString:@"确认到达"]) {
        if (self.driverStatusBlock) {
            self.driverStatusBlock(BGWOrderDriverStatusArrived, nil);
        }
    }
    
}


#pragma mark- setupUI
- (void)setupTaskListSendGroupUI {
    
    UIView *containerView = [[UIView alloc] init];
    containerView.backgroundColor = kWhiteColor;
    [self.contentView addSubview:containerView];
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(@10);
        make.bottom.right.mas_offset(-10);
    }];
    
    UIImageView *taskStatusImage = [[UIImageView alloc] init];
    [containerView addSubview:taskStatusImage];
    [taskStatusImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@5);
        make.left.mas_offset(-5);
    }];
    self.taskTypeImageView = taskStatusImage;
    
    UILabel *promptLabel = [[UILabel alloc] initWithTextColor:kMGrayColor font:BGWFont(14)];
    promptLabel.text = @"查看更多 >";
    [containerView addSubview:promptLabel];
    [promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@7);
        make.right.mas_equalTo(-10);
    }];
    self.promptLabel = promptLabel;
    
    UIView *separateLine1 = [[UIView alloc] init];
    separateLine1.backgroundColor = kMSeparateColor;
    [containerView addSubview:separateLine1];
    [separateLine1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(promptLabel.mas_bottom).with.offset(7);
        make.left.equalTo(@10);
        make.right.mas_offset(-10);
        make.height.equalTo(@.5);
    }];
    
    QPYTaskListAddressInfoView *addressView = [[QPYTaskListAddressInfoView alloc] init];
    [containerView addSubview:addressView];
    [addressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(separateLine1.mas_bottom);
        make.left.right.equalTo(@0);
    }];
    self.destAddressLabel = [addressView viewWithTag:1];
    self.destAddressDescLabel = [addressView viewWithTag:2];
    self.sendTimeLabel = [addressView viewWithTag:3];
    
    
    UIView *separateLine2 = [[UIView alloc] init];
    separateLine2.backgroundColor = kMSeparateColor;
    [containerView addSubview:separateLine2];
    [separateLine2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(addressView.mas_bottom).with.offset(5);
        make.left.equalTo(@10);
        make.right.mas_offset(-10);
        make.height.equalTo(@.5);
    }];
    
    UIView *bottomButtonView = [[UIView alloc] init];
    [containerView addSubview:bottomButtonView];
    [bottomButtonView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(separateLine2.mas_bottom);
        make.left.right.equalTo(@0);
        make.height.equalTo(@50);
        make.bottom.equalTo(@0);
    }];

    UIButton *rightButton = [[UIButton alloc] init];
    [rightButton setTitle:@"确认发车" forState:UIControlStateNormal];
    rightButton.titleLabel.font = BGWFont(14);
    [rightButton setTitleColor:kMThemeColor forState:UIControlStateNormal];
    [rightButton setCornerRadius:12.f boderWidth:.5f borderColor:kMThemeColor];
    [rightButton addTarget:self action:@selector(rightClick:) forControlEvents:UIControlEventTouchUpInside];
    [bottomButtonView addSubview:rightButton];
    [rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(10);
        make.left.equalTo(bottomButtonView.mas_centerX).with.offset(20);
        make.right.mas_offset(-20);
        make.centerY.equalTo(@0);
    }];
    self.rightButton = rightButton;
}


- (void)setTaskTypeImage:(BGWRoleActionType)roleType {
    NSString *img;
    switch (roleType) {
        case BGWRoleActionTypeHotelTask:
            img = @"task_hotel_take";
            break;
        case BGWRoleActionTypeHotelSend:
            img = @"task_hotel_send";
            break;
        case BGWRoleActionTypeTransitTask:
            img = @"task_transit_take";
            break;
        case BGWRoleActionTypeTransitSend:
            img = @"task_transit_send";
            break;
        case BGWRoleActionTypeAirportTask:
            img = @"task_airport_take";
            break;
        case BGWRoleActionTypeAirportSend:
            img = @"task_airport_send";
            break;
        default:
            break;
    }
    self.taskTypeImageView.image = [UIImage imageNamed:img];
}

@end
