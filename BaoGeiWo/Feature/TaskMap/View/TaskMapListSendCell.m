//
//  TaskMapListSendCell.m
//  BaoGeiWo
//
//  Created by wb on 2018/7/13.
//  Copyright © 2018年 qyqs. All rights reserved.
//

#import "TaskMapListSendCell.h"
#import "QPYOrderTaskListModel.h"

@interface TaskMapListSendCell ()

@property (nonatomic, strong) UILabel *sendAddress;
@property (nonatomic, strong) UILabel *sendAddressDetail;
@property (nonatomic, strong) UILabel *sendTimeLabel;
@property (nonatomic, strong) UIImageView *sendAddressImage;

@end


@implementation TaskMapListSendCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupTaskMapListSendUI]; //top height: 35pt
    }
    return self;
}

- (void)setupTaskMapListSendUI {
    
    UIView *sendAddressView = [self initialAddresInfoView];
    sendAddressView.bgw_y = 35;
    [self.containerView addSubview:sendAddressView];
    self.sendAddress = [sendAddressView viewWithTag:1];
    self.sendAddressDetail = [sendAddressView viewWithTag:2];
    self.sendTimeLabel = [sendAddressView viewWithTag:3];
    self.sendAddressImage = [sendAddressView viewWithTag:4];
    
    [self setContainerViewHeight:sendAddressView.bgw_y+sendAddressView.bgw_h];
    
//    [self setContainerViewHeight:70];
    
}

- (void)setContent:(QPYOrderTaskListModel *)taskModel {
    [super setContent:taskModel];
    
    self.sendAddress.text = taskModel.destAddress;
    self.sendAddressDetail.text = taskModel.destAddressDesc;
    self.sendTimeLabel.text = [taskModel.arrivedTime interactiveTime];
    
    BGWDestinationType destType = [taskModel.destAddressType destType];
    if (destType == BGWDestinationTypeServiceCenter) {
        self.sendAddressImage.image = [UIImage imageNamed:@"task_map_airport_icon"];
    } else {
        self.sendAddressImage.image = [UIImage imageNamed:@"task_map_send_icon"];
    }
}

@end
