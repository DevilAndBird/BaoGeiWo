//
//  JSOrderListCell.m
//  BaoGeiWo
//
//  Created by wb on 2018/5/25.
//  Copyright © 2018年 qyqs. All rights reserved.
//

#import "JSOrderListCell.h"
#import "JSOrderListModel.h"

@interface JSOrderListCell()

@property (nonatomic, strong) UIImageView *markImageView;
@property (nonatomic, strong) UILabel *orderNumberLabel;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *baggageNumberLabel;
@property (nonatomic, strong) UILabel *qrLabel;

@end

@implementation JSOrderListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = kMBgColor;
        [self setupJSOrderUI];
    }
    return self;
}

- (void)setOrderContent:(JSOrderListModel *)order {
    
    [self setTaskTypeImage:[order.roleType roleActionType]];
    //[NSString stringWithFormat:@"订单编号: %@", order.orderNumber]
    self.orderNumberLabel.text = [@"#" stringByAppendingString:[order.orderNumber substringFromIndex:order.orderNumber.length-4]];
    if (order.arrivedTime) {
        self.nameLabel.text = [order.arrivedTime mm_ddString];
    } else {
        self.nameLabel.text = order.personName;
    }
    self.baggageNumberLabel.text = [NSString stringWithFormat:@"行李数: %@", order.baggageNumber];
    
    NSInteger qrCount = order.baggageList.count;
    NSMutableString *qrString = [NSMutableString string];
    for (NSInteger i = 0; i < qrCount; i++) {
        JSOrderBaggageModel *baggage = order.baggageList[i];
        if (i == qrCount-1) {
            [qrString appendFormat:@"%@", [NSString stringWithFormat:@"行李QR码%zd : %@", i+1, baggage.baggageCode]];
        } else {
            [qrString appendFormat:@"%@", [NSString stringWithFormat:@"行李QR码%zd : %@\n", i+1, baggage.baggageCode]];
        }
    };
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    [paragraphStyle setLineSpacing:4.f];
    NSMutableAttributedString *qrAttr = [[NSMutableAttributedString alloc] initWithString:qrString attributes:@{NSForegroundColorAttributeName:kMGrayColor, NSFontAttributeName:BGWFont(16), NSParagraphStyleAttributeName:paragraphStyle}];
    for (NSInteger i = 0; i < qrCount; i++) {
        NSRange range = [qrString rangeOfString:[NSString stringWithFormat:@"行李QR码%zd", i+1]];
        [qrAttr addAttribute:NSForegroundColorAttributeName value:kMThemeColor range:range];
    }
    [self.qrLabel setAttributedText:qrAttr];
 
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
    self.markImageView.image = [UIImage imageNamed:img];
}

- (void)setupJSOrderUI {
    
    UIView *containerView = [[UIView alloc] init];
    containerView.backgroundColor = kWhiteColor;
    [self.contentView addSubview:containerView];
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(@10);
        make.bottom.equalTo(@0);
        make.right.equalTo(@0).with.offset(-10);
    }];
    
    UIImageView *markImageView = [[UIImageView alloc] init];
//    markImageView.backgroundColor = kMThemeColor;
    [containerView addSubview:markImageView];
    [markImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(-5);
//        make.width.equalTo(@30);
//        make.height.equalTo(@20);
    }];
    self.markImageView = markImageView;
    
    UILabel *orderNumberLabel = [[UILabel alloc] initWithTextColor:kMGrayColor font:BGWFont(14)];
    orderNumberLabel.text = @"#1111";
    [containerView addSubview:orderNumberLabel];
    [orderNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(markImageView.mas_right).with.offset(10);
        make.top.equalTo(@10);
    }];
    self.orderNumberLabel = orderNumberLabel;
    
    [markImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(orderNumberLabel);
    }];
    
    

    UILabel *deliveryManLabel = [[UILabel alloc] initWithTextColor:kMGrayColor font:BGWFont(14) textAlignment:NSTextAlignmentRight];
    deliveryManLabel.text = @"joey wong";
    [containerView addSubview:deliveryManLabel];
    [deliveryManLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(orderNumberLabel);
        make.right.mas_offset(-20);
    }];
    self.nameLabel = deliveryManLabel;
    
    UIView *segmentLine = [[UIView alloc] init];
    segmentLine.backgroundColor = kMSeparateColor;
    [containerView addSubview:segmentLine];
    [segmentLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(orderNumberLabel.mas_bottom).with.offset(10);
        make.left.equalTo(@10);
        make.right.equalTo(@0).with.offset(-10);
        make.height.equalTo(@.5);
    }];
    
    UIImageView *baggageImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"order_list_baggage"]];
    [containerView addSubview:baggageImage];
    [baggageImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(segmentLine.mas_bottom).with.offset(10);
        make.left.equalTo(@10);
    }];
    UILabel *baggageLabel = [[UILabel alloc] initWithTextColor:kMGrayColor font:BGWFont(14)];
    baggageLabel.text = @"行李数:2";
    [containerView addSubview:baggageLabel];
    [baggageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(baggageImage);
        //        make.top.equalTo(segmentLine.mas_bottom).with.offset(10);
        make.left.equalTo(baggageImage.mas_right).with.offset(10);
    }];
    self.baggageNumberLabel = baggageLabel;
    
//        NSString *qrString = @"行李qr码1:12345678\n行李qr码2:12345678\n行李qr码3:12345678\n行李qr码4:12345678";
//        UILabel *qrLabel = [[UILabel alloc] initWithTextColor:kMGrayColor font:BGWFont(16)];
//        qrLabel.text = qrString;
    UILabel *qrLabel = [[UILabel alloc] init];
    qrLabel.numberOfLines = 0;
    [containerView addSubview:qrLabel];
    [qrLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(containerView.mas_centerX).with.offset(-20);
        make.top.equalTo(baggageLabel);
        make.bottom.equalTo(@0).with.offset(-10);
    }];
    self.qrLabel = qrLabel;
    
}

@end
