//
//  QPYTaskListSingleAddressCell.m
//  BaoGeiWo
//
//  Created by wb on 2018/5/11.
//  Copyright © 2018年 qyqs. All rights reserved.
//

#import "QPYTaskListSingleAddressCell.h"
#import "QPYOrderTaskListModel.h"
#import "QPYTaskListAddressInfoView.h"

@interface QPYTaskListSingleAddressCell()

@property (nonatomic, strong) UILabel *destAddressLabel;
@property (nonatomic, strong) UILabel *destAddressDescLabel;
@property (nonatomic, strong) UILabel *sendTimeLabel;

@end

@implementation QPYTaskListSingleAddressCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupSingleAddressUI];
    };
    return self;
}

- (void)setTakeTimeWithTaskModel:(QPYOrderTaskListModel *)taskModel {
    if (taskModel.taskType == BGWOrderTaskTypeFinished) {
        self.sendTimeLabel.textColor = kMBlackColor;
        self.sendTimeLabel.text = [taskModel.arrivedTime interactiveTime];
        
    } else {
        if (taskModel.currentTime.doubleValue > taskModel.arrivedTime.doubleValue) {
            //已超时
            self.sendTimeLabel.textColor = kRedColor;
            self.sendTimeLabel.text = [NSString stringWithFormat:@"超时%@", [taskModel.arrivedTime timeintervalWithOtherTimeStamp:taskModel.currentTime]];
            
        } else {
            self.sendTimeLabel.textColor = kMBlackColor;
            if ([taskModel.currentTime timeintervalSmallThanHourWithTimeStamp:taskModel.arrivedTime]) {
                //小于一小时，显示倒计时
                self.sendTimeLabel.text = [NSString stringWithFormat:@"剩余%@", [taskModel.currentTime timeintervalWithOtherTimeStamp:taskModel.arrivedTime]];
            } else {
                self.sendTimeLabel.text = [taskModel.arrivedTime interactiveTime];
            }
        }
    }
    
}


- (void)setOrderTaskListModel:(QPYOrderTaskListModel *)taskModel taskType:(BGWOrderTaskType)taskType {
    
    [super setOrderTaskListModel:taskModel taskType:taskType];
    
    if (taskModel.nextBindAction) { //single 应该不会有nextBindAction
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
        
        if ([taskModel.destAddressDesc isEqualToString:@""] || !taskModel.destAddressDesc) {
            self.destAddressDescLabel.text = self.destAddressLabel.text;;
        } else {
            self.destAddressDescLabel.text = taskModel.destAddressDesc;
        }
    }

    [self setTakeTimeWithTaskModel:taskModel];
}

- (void)setupSingleAddressUI {
    
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
//        make.width.height.equalTo(@30);
    }];
    //    self.addresImage = addressImage;
    [addressButton setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh+1 forAxis:UILayoutConstraintAxisHorizontal];
    
    
    QPYTaskListAddressInfoView *destView = [[QPYTaskListAddressInfoView alloc] init];
    [self.addressView addSubview:destView];
    [destView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(@0);
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
