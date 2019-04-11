//
//  TaskMapListCell.m
//  BaoGeiWo
//
//  Created by wb on 2018/7/13.
//  Copyright © 2018年 qyqs. All rights reserved.
//

#import "TaskMapListCell.h"
#import "QPYOrderTaskListModel.h"

@interface TaskMapListCell ()

@property (nonatomic, strong) UIImageView *typeImageView;
@property (nonatomic, strong) UILabel *numLabel;

@end

@implementation TaskMapListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = self.contentView.backgroundColor = kClearColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupTaskMapListUI];
    }
    return self;
}

- (void)setupTaskMapListUI {
    
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, DEVICE_WIDTH-20, 0)];
    containerView.backgroundColor = kWhiteColor;
    [self.contentView addSubview:containerView];
    self.containerView = containerView;
    
    UIImageView *typeImage = [[UIImageView alloc] init];
    typeImage.frame = CGRectMake(5, 5, 63, 22);
    [self.contentView addSubview:typeImage];
    self.typeImageView = typeImage;
    
    UILabel *numLabel = [[UILabel alloc] initWithTextColor:kMGrayColor font:BGWFont(14)];
    numLabel.frame = CGRectMake(73, 8, 100, 15);
    numLabel.text = @"#1234";
    [containerView addSubview:numLabel];
    self.numLabel = numLabel;
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(10, numLabel.bgw_y+numLabel.bgw_h+15, containerView.bgw_w-20, .5)];
    line.backgroundColor = kMBgColor;
    [containerView addSubview:line];
    
}

- (void)setContent:(QPYOrderTaskListModel *)taskModel {
    
    self.typeImageView.image = [self getTaskTypeImage:[taskModel.roleType roleActionType]];
    self.numLabel.text = [NSString stringWithFormat:@"#%@", [taskModel.orderNumber substringFromIndex:taskModel.orderNumber.length-4]];
    
}

- (void)setContainerViewHeight:(CGFloat)height {
    self.containerView.bgw_h = height;
}

- (UIImage *)getTaskTypeImage:(BGWRoleActionType)roleType {
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
    return [UIImage imageNamed:img];
}



- (UIView *)initialAddresInfoView {
    UIView *addressInfo = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH-20, 60)];
    
    UIImageView *markImage = [[UIImageView alloc] initWithFrame:CGRectMake(15, 0, 20, 20)];
    markImage.bgw_centerY = 30;
    markImage.backgroundColor = kWhiteColor;
    markImage.tag = 4;
    [addressInfo addSubview:markImage];
    [markImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.centerY.equalTo(@0);
        make.width.equalTo(@13);
        make.height.equalTo(@17);
    }];
    
    UILabel *time = [[UILabel alloc] initWithTextColor:kMBlackColor font:BGWFont(16) textAlignment:NSTextAlignmentRight];
    time.text = @"00:00";
    time.tag = 3;
    [addressInfo addSubview:time];
    [time mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@10);
        make.right.mas_equalTo(-20);
    }];
    
    UILabel *address = [[UILabel alloc] initWithTextColor:kMBlackColor font:BGWFont(16)];
//    address.frame = CGRectMake(markImage.bgw_x+markImage.bgw_w+10, 10, DEVICE_WIDTH-20, 20);
    address.text = @"汉庭酒店";
    address.tag = 1;
    [addressInfo addSubview:address];
    [address mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@10);
        make.left.equalTo(markImage.mas_right).with.offset(10);
        make.right.equalTo(time.mas_left).with.offset(-20);
        make.height.equalTo(@20);
    }];
    
    UILabel *detail = [[UILabel alloc] initWithTextColor:kMGrayColor font:BGWFont(14)];
//    detail.frame = CGRectMake(markImage.bgw_x+markImage.bgw_w+10, address.bgw_y+address.bgw_h+5, DEVICE_WIDTH-20, 15);
    detail.text = @"普陀区长寿路658号";
    detail.tag = 2;
    [addressInfo addSubview:detail];
    [detail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(address);
        make.bottom.mas_equalTo(-10);
        make.right.mas_equalTo(-20);
    }];
    
    return addressInfo;
}








@end
