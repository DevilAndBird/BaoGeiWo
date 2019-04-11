//
//  QPYTaskListGroupCell.m
//  BaoGeiWo
//
//  Created by wb on 2018/6/22.
//  Copyright © 2018年 qyqs. All rights reserved.
//

#import "QPYTaskListTakeGroupCell.h"
#import "QPYTaskListAddressInfoView.h"
#import "QPYOrderTaskListModel.h"

@interface QPYTaskListTakeGroupCell()

@property (nonatomic, strong) UIView *containerView;

@property (nonatomic, strong) UIImageView *taskTypeImageView;
@property (nonatomic, strong) UILabel *promptLabel;

@property (nonatomic, strong) UILabel *destAddressLabel;
@property (nonatomic, strong) UILabel *destAddressDescLabel;
@property (nonatomic, strong) UILabel *sendTimeLabel;

@property (nonatomic, strong) QPYOrderTaskListModel *taskModel;


@end


@implementation QPYTaskListTakeGroupCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = self.contentView.backgroundColor = kMBgColor;
        [self setupTaskListGroupUI];
    }
    return self;
}

- (void)setTaskTakeGroup:(QPYOrderTaskGroupModel *)groupModel {
    QPYOrderTaskListModel *taskModel = [groupModel.taskGroup firstObject];
    self.taskModel = taskModel;
    BGWRoleActionType roleType = [taskModel.roleType roleActionType];
    [self setTaskTypeImage:roleType];
    self.promptLabel.text = [NSString stringWithFormat:@"查看更多(%zd条) >", groupModel.taskGroup.count];
    
    if ([taskModel.destAddress isEqualToString:@""] || !taskModel.destAddress) {
        self.destAddressLabel.text = @"酒店/住宅";
    } else {
        self.destAddressLabel.text = taskModel.destAddress;
    }
    
    self.destAddressDescLabel.text = taskModel.destAddressDesc;
    self.sendTimeLabel.text = [taskModel.arrivedTime interactiveTime];
    
    self.containerView.backgroundColor = kWhiteColor;
    for (QPYOrderTaskListModel *task in groupModel.taskGroup) {
        if ([task.isTake isEqualToString:@"N"]) {
            self.containerView.backgroundColor = kMSeparateColor;
            break;
        }
    }

}

- (void)setupTaskListGroupUI {
    
    UIView *containerView = [[UIView alloc] init];
    containerView.backgroundColor = kWhiteColor;
    [self.contentView addSubview:containerView];
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(@10);
        make.bottom.right.mas_offset(-10);
    }];
    self.containerView = containerView;
    
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
        make.left.bottom.right.equalTo(@0);
    }];
    self.destAddressLabel = [addressView viewWithTag:1];
    self.destAddressDescLabel = [addressView viewWithTag:2];
    self.sendTimeLabel = [addressView viewWithTag:3];
    
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
