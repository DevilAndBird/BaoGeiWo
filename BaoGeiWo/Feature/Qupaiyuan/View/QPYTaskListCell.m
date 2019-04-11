//
//  QPYTaskListCell.m
//  BaoGeiWo
//
//  Created by wb on 2018/5/11.
//  Copyright © 2018年 qyqs. All rights reserved.
//

#import "QPYTaskListCell.h"
#import "QPYOrderTaskListModel.h"


@interface QPYTaskListCell()

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIImageView *taskMark;

@property (nonatomic, strong) UIView *separateLine;

@property (nonatomic, strong) UIImageView *taskTypeImageView;
@property (nonatomic, strong) UILabel *orderNumberLabel;
@property (nonatomic, strong) UILabel *typeLabel;
@property (nonatomic, strong) UILabel *baggageNumberLabel;

@property (nonatomic, strong) UIView *QRView;
@property (nonatomic, strong) UILabel *QRNumberLabel;


@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, strong) UIButton *rightButton;



@end



@implementation QPYTaskListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = self.contentView.backgroundColor = kMBgColor;
        [self setupUI];        
    }
    return self;
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
    
    if (self.notifyAppCusBlock) {
        self.notifyAppCusBlock();
    }
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

- (void)callClick {
    if (self.callBlock) {
        self.callBlock();
    }
}

- (void)mapClick {
    if (self.mapBlock) {
        self.mapBlock();
    }
}

- (void)setTakeTimeWithTaskModel:(QPYOrderTaskListModel *)taskModel {
    
}


- (void)setOrderTaskListModel:(QPYOrderTaskListModel *)taskModel taskType:(BGWOrderTaskType)taskType {
    //
    self.taskModel = taskModel;
    
    if ([taskModel.isTake isEqualToString:@"Y"]) {
        self.containerView.backgroundColor = kWhiteColor;
    } else if ([taskModel.isTake isEqualToString:@"N"]) {
        self.containerView.backgroundColor = kMSeparateColor;
    }
    BGWRoleActionType roleType = [taskModel.roleType roleActionType];
    [self setTaskTypeImage:roleType];
    if ([taskModel.channel isEqualToString:@"weixin_sc"]) {
        self.taskMark.image = [UIImage imageNamed:@"task_list_zhuanche"];
    } else {
        if ([taskModel.isToday isEqualToString:@"N"]) {
            self.taskMark.image = [UIImage imageNamed:@"task_list_geye"];
        } else {
            self.taskMark.image = nil;
        }
    }
    

    self.orderNumberLabel.text = [@"#" stringByAppendingString:[taskModel.orderNumber substringFromIndex:taskModel.orderNumber.length-4]?:@""];
    self.typeLabel.text = [NSString stringWithFormat:@"%@-%@", [taskModel.srcMailingWay orderMailingWayCN], [taskModel.destMailingWay orderMailingWayCN]];
    self.baggageNumberLabel.text = [NSString stringWithFormat:@"行李数量：%@", taskModel.baggageNumber];
    if (taskModel.orderBaggageArray.count) {
        self.QRView.hidden = NO;
        OrderTaskBaggageModel *baggage = [taskModel.orderBaggageArray firstObject];
        self.QRNumberLabel.text = [NSString stringWithFormat:@"行李qr码：%@", baggage.baggageQRNumber];
    } else {
        self.QRView.hidden = YES;
    }
    
    
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



- (void)setupUI {
    
    UIView *containerView = [[UIView alloc] init];
    containerView.backgroundColor = kWhiteColor;
    [self.contentView addSubview:containerView];
    self.containerView = containerView;
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
    
    UILabel *orderNumber = [[UILabel alloc] initWithTextColor:kMGrayColor font:BGWFont(14)];
    orderNumber.text = @"#0000";
    [containerView addSubview:orderNumber];
    [orderNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@7);
        make.left.equalTo(taskStatusImage.mas_right).with.offset(10);
    }];
    self.orderNumberLabel = orderNumber;
    
    UIView *typeView = [self customView:@"酒店前台-酒店前台" image:@"task_list_type"];
    [containerView addSubview:typeView];
    [typeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(orderNumber);
        make.right.equalTo(@0);
    }];
    self.typeLabel = [typeView viewWithTag:1];
    
    UIView *separateLine1 = [[UIView alloc] init];
    separateLine1.backgroundColor = kMSeparateColor;
    [containerView addSubview:separateLine1];
    [separateLine1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(orderNumber.mas_bottom).with.offset(7);
        make.left.equalTo(@10);
        make.right.mas_offset(-10);
        make.height.equalTo(@.5);
    }];
    
    
    
    UIView *addressView = [[UIView alloc] init];
    [containerView addSubview:addressView];
    [addressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(separateLine1.mas_bottom);
        make.left.right.equalTo(@0);
    }];
    self.addressView = addressView;
    

    UIView *separateLine2 = [[UIView alloc] init];
    separateLine2.backgroundColor = kMSeparateColor;
    [containerView addSubview:separateLine2];
    [separateLine2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(addressView.mas_bottom).with.offset(5);
        make.left.equalTo(@10);
        make.right.mas_offset(-10);
        make.height.equalTo(@.5);
    }];
    self.separateLine = separateLine2;
    
    
    UIView *baggageNumberView = [self customView:@"行李数量：1" image:@"task_list_baggage"];
    [containerView addSubview:baggageNumberView];
    [baggageNumberView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(separateLine2.mas_bottom);
        make.left.equalTo(@20);
    }];
    self.baggageNumberLabel = [baggageNumberView viewWithTag:1];
    
    
    UIView *qrView = [self customView:@"行李qr码：" image:@"task_list_qr"];
    [containerView addSubview:qrView];
    [qrView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(baggageNumberView);
        make.left.equalTo(baggageNumberView.mas_right).with.offset(10);
    }];
    self.QRView = qrView;
    self.QRNumberLabel = [qrView viewWithTag:1];

    
    UIView *bottomButtonView = [[UIView alloc] init];
    [containerView addSubview:bottomButtonView];
    [bottomButtonView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(baggageNumberView.mas_bottom);
        make.left.right.equalTo(@0);
        make.height.equalTo(@50);
        make.bottom.equalTo(@0);
    }];
    self.bottomButtonView = bottomButtonView;
    
    UIButton *leftButton = [[UIButton alloc] init];
    [leftButton setTitle:@"联系" forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(callClick) forControlEvents:UIControlEventTouchUpInside];
    [leftButton setTitleColor:kMThemeColor forState:UIControlStateNormal];
    leftButton.titleLabel.font = BGWFont(14);
    [leftButton setCornerRadius:12.f boderWidth:.5f borderColor:kMThemeColor];
    [bottomButtonView addSubview:leftButton];
    [leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(10);
        make.left.equalTo(@20);
        make.centerY.equalTo(@0);
//        make.height.equalTo(@30);
//        make.bottom.mas_offset(-10);
    }];
    
    UIButton *rightButton = [[UIButton alloc] init];
//    [rightButton setTitle:@"确认发车" forState:UIControlStateNormal];
    rightButton.titleLabel.font = BGWFont(14);
    [rightButton setTitleColor:kMThemeColor forState:UIControlStateNormal];
    [rightButton setCornerRadius:12.f boderWidth:.5f borderColor:kMThemeColor];
    [rightButton addTarget:self action:@selector(rightClick:) forControlEvents:UIControlEventTouchUpInside];
    [bottomButtonView addSubview:rightButton];
    [rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(leftButton);
        make.left.equalTo(leftButton.mas_right).with.offset(20);
        make.right.mas_offset(-20);
        make.width.height.equalTo(leftButton);
    }];
    self.rightButton = rightButton;
    
    UIImageView *taskMark = [[UIImageView alloc] init];
    [containerView addSubview:taskMark];
    [taskMark mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(@0);
    }];
    self.taskMark = taskMark;
}


- (UIView *)customView:(NSString *)text image:(NSString *)image {
    
    UIView *view = [[UIView alloc] init];
    
    UIImageView *typeImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:image]];
    [view addSubview:typeImage];
    [typeImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(@0);
        make.left.equalTo(@5);
    }];
    
    UILabel *typeLabel = [[UILabel alloc] initWithTextColor:kMGrayColor font:BGWFont(14)];
    typeLabel.text = text;
    typeLabel.tag = 1;
    [view addSubview:typeLabel];
    [typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@7);
        make.left.equalTo(typeImage.mas_right).with.offset(5);
        make.right.mas_offset(-10);
        make.bottom.mas_offset(-7);
    }];

    return view;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
