//
//  TaskMapListTakeCell.m
//  BaoGeiWo
//
//  Created by wb on 2018/7/13.
//  Copyright © 2018年 qyqs. All rights reserved.
//

#import "TaskMapListTakeCell.h"
#import "QPYOrderTaskListModel.h"

@interface TaskMapListTakeCell ()

@property (nonatomic, strong) UILabel *takeAddress;
@property (nonatomic, strong) UILabel *takeAddressDetail;
@property (nonatomic, strong) UILabel *takeTimeLabel;
@property (nonatomic, strong) UIImageView *takeAddressImage;

@property (nonatomic, strong) UILabel *sendAddress;
@property (nonatomic, strong) UILabel *sendAddressDetail;
@property (nonatomic, strong) UILabel *sendTimeLabel;
@property (nonatomic, strong) UIImageView *sendAddressImage;

@end

@implementation TaskMapListTakeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupTaskMapListTakeUI];
    }
    return self;
}

- (void)setupTaskMapListTakeUI {
    
    UIView *takeAddressView = [self initialAddresInfoView];
    takeAddressView.bgw_y = 35;
    [self.containerView addSubview:takeAddressView];
    self.takeAddress = [takeAddressView viewWithTag:1];
    self.takeAddressDetail = [takeAddressView viewWithTag:2];
    self.takeTimeLabel = [takeAddressView viewWithTag:3];
    self.takeAddressImage = [takeAddressView viewWithTag:4];
    
    UIView *sendAddressView = [self initialAddresInfoView];
    sendAddressView.bgw_y = takeAddressView.bgw_y+takeAddressView.bgw_h-5;
    [self.containerView addSubview:sendAddressView];
    self.sendAddress = [sendAddressView viewWithTag:1];
    self.sendAddressDetail = [sendAddressView viewWithTag:2];
    self.sendTimeLabel = [sendAddressView viewWithTag:3];
    self.sendAddressImage = [sendAddressView viewWithTag:4];
    
    [self setContainerViewHeight:sendAddressView.bgw_y+sendAddressView.bgw_h];

}

- (void)setContent:(QPYOrderTaskListModel *)taskModel {
    [super setContent:taskModel];
    
    self.takeAddress.text = taskModel.destAddress;
    self.takeAddressDetail.text = taskModel.destAddressDesc;
    self.takeTimeLabel.text = [taskModel.arrivedTime interactiveTime];
    BGWDestinationType takeDestType = [taskModel.destAddressType destType];
    if (takeDestType == BGWDestinationTypeServiceCenter) {
        self.takeAddressImage.image = [UIImage imageNamed:@"task_map_airport_icon"];
    } else {
        self.takeAddressImage.image = [UIImage imageNamed:@"task_map_take_icon"];
    }
    
    self.sendAddress.text = taskModel.nextBindAction.destAddress;
    self.sendAddressDetail.text = taskModel.nextBindAction.destAddressDesc;
    self.sendTimeLabel.text = [taskModel.nextBindAction.arrivedTime interactiveTime];
    BGWDestinationType sendDestType = [taskModel.nextBindAction.destAddressType destType];
    if (sendDestType == BGWDestinationTypeServiceCenter) {
        self.sendAddressImage.image = [UIImage imageNamed:@"task_map_airport_icon"];
    } else {
        self.sendAddressImage.image = [UIImage imageNamed:@"task_map_send_icon"];
    }
}



@end
