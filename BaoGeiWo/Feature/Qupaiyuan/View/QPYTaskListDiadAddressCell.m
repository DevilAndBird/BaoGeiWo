//
//  QPYTaskListDiadAddressCell.m
//  BaoGeiWo
//
//  Created by wb on 2018/5/11.
//  Copyright © 2018年 qyqs. All rights reserved.
//

#import "QPYTaskListDiadAddressCell.h"
#import "QPYOrderTaskListModel.h"
#import "QPYTaskListAddressInfoView.h"


@interface QPYTaskListDiadAddressCell()

@property (nonatomic, strong) UILabel *srcAddressLabel;
@property (nonatomic, strong) UILabel *srcAddressDescLabel;
@property (nonatomic, strong) UILabel *takeTimeLabel;

@property (nonatomic, strong) UILabel *destAddressLabel;
@property (nonatomic, strong) UILabel *destAddressDescLabel;
@property (nonatomic, strong) UILabel *sendTimeLabel;

@end


@implementation QPYTaskListDiadAddressCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupDiadAddressUI];
    }
    return self;
}


- (void)setTakeTimeWithTaskModel:(QPYOrderTaskListModel *)taskModel {
    BGWRoleActionType roleType = [taskModel.roleType roleActionType];
    if (roleType == BGWRoleActionTypeHotelTask || roleType == BGWRoleActionTypeAirportTask) {
        //酒店、机场取不显示倒计时
        self.takeTimeLabel.textColor = kMBlackColor;
        self.takeTimeLabel.text = [taskModel.arrivedTime interactiveTime];
    } else {
        
        if (taskModel.currentTime.doubleValue > taskModel.arrivedTime.doubleValue) {
            //已超时
            self.takeTimeLabel.textColor = kRedColor;
            self.takeTimeLabel.text = [NSString stringWithFormat:@"超时%@", [taskModel.arrivedTime timeintervalWithOtherTimeStamp:taskModel.currentTime]];
            
        } else {
            self.takeTimeLabel.textColor = kMBlackColor;
            if ([taskModel.currentTime timeintervalSmallThanHourWithTimeStamp:taskModel.arrivedTime]) {
                //小于一小时，显示倒计时
                self.takeTimeLabel.text = [NSString stringWithFormat:@"剩余%@", [taskModel.currentTime timeintervalWithOtherTimeStamp:taskModel.arrivedTime]];
            } else {
                self.takeTimeLabel.text = [taskModel.arrivedTime interactiveTime];
            }
        }
    }
    
}


- (void)setOrderTaskListModel:(QPYOrderTaskListModel *)taskModel taskType:(BGWOrderTaskType)taskType {
    
    [super setOrderTaskListModel:taskModel taskType:taskType];
    
    if ([taskModel.destAddress isEqualToString:@""] || !taskModel.destAddress) {
        self.srcAddressLabel.text = @"酒店/住宅";
    } else {
        self.srcAddressLabel.text = taskModel.destAddress;
    }
    if ([taskModel.destAddressDesc isEqualToString:@""] || !taskModel.destAddressDesc) {
        self.srcAddressDescLabel.text = self.srcAddressLabel.text;
    } else {
        self.srcAddressDescLabel.text = taskModel.destAddressDesc;
    }
    [self setTakeTimeWithTaskModel:taskModel];
   
    
    if ([taskModel.nextBindAction.destAddress isEqualToString:@""] || !taskModel.nextBindAction.destAddress) {
        self.destAddressLabel.text = @"酒店/住宅";
    } else {
        self.destAddressLabel.text = taskModel.nextBindAction.destAddress;
    }
    if ([taskModel.nextBindAction.destAddressDesc isEqualToString:@""] || !taskModel.nextBindAction.destAddressDesc) {
        self.destAddressDescLabel.text = self.destAddressLabel.text;
    } else {
        self.destAddressDescLabel.text = taskModel.nextBindAction.destAddressDesc;
    }
    
    self.sendTimeLabel.text = [taskModel.nextBindAction.arrivedTime interactiveTime];
//    self.sendTimeLabel.text = taskModel.nextBindAction.arrivedTime;
    
    
}


- (void)setupDiadAddressUI {
    
    UIButton *addressButton = [[UIButton alloc] init];
    [addressButton setImage:[UIImage imageNamed:@"task_list_map"] forState:UIControlStateNormal];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    [addressButton addTarget:self action:@selector(mapClick) forControlEvents:UIControlEventTouchUpInside];
#pragma clang diagnostic pop
    [self.addressView addSubview:addressButton];
    [addressButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_offset(-20);
        make.centerY.equalTo(@0);
    }];
    [addressButton setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh+1 forAxis:UILayoutConstraintAxisHorizontal];

    
    QPYTaskListAddressInfoView *srcView = [[QPYTaskListAddressInfoView alloc] init];
    [self.addressView addSubview:srcView];
    [srcView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(@0);
        make.right.equalTo(addressButton.mas_left);
    }];
    self.srcAddressLabel = [srcView viewWithTag:1];
    self.srcAddressDescLabel = [srcView viewWithTag:2];
    self.takeTimeLabel = [srcView viewWithTag:3];

    QPYTaskListAddressInfoView *destView = [[QPYTaskListAddressInfoView alloc] init];
    [self.addressView addSubview:destView];
    [destView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(srcView.mas_bottom);
        make.left.equalTo(@0);
        make.right.equalTo(addressButton.mas_left);
        make.bottom.equalTo(@0);
    }];
    self.destAddressLabel = [destView viewWithTag:1];
    self.destAddressDescLabel = [destView viewWithTag:2];
    self.sendTimeLabel = [destView viewWithTag:3];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
