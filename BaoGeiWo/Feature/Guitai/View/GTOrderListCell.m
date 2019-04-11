//
//  GTOrderListCell.m
//  BaoGeiWo
//
//  Created by wb on 2018/6/20.
//  Copyright © 2018年 qyqs. All rights reserved.
//

#import "GTOrderListCell.h"
#import "GTOrderListModel.h"

@interface GTOrderListCell()

@property (nonatomic, strong) UILabel *orderNumberLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *phoneLabel;
@property (nonatomic, strong) UILabel *baggageNumberLabel;
@property (nonatomic, strong) UILabel *qrLabel;

@property (nonatomic, strong) UIImageView *zhuanche;

@property (nonatomic, strong) GTOrderListModel *orderModel;

@end

@implementation GTOrderListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = kMBgColor;
        [self setupGTOrderUI];
    }
    return self;
}

- (void)cancelOrder:(UIButton *)sender {
    if (self.cancelOrder) {
        self.cancelOrder(self.orderModel.orderId);
    }
}

- (void)paidOrder:(UIButton *)sender {
    if (self.paidOrder) {
        self.paidOrder(self.orderModel.orderNo);
    }
}

- (void)setOrderContent:(GTOrderListModel *)order {

    self.orderModel = order;
    self.orderNumberLabel.text = [NSString stringWithFormat:@"订单编号: %@", order.orderNo];
    self.timeLabel.text = order.takeTime?[order.takeTime interactiveTime]:order.sendTime?[order.sendTime interactiveTime]:order.modifyTime?[order.modifyTime interactiveTime]:@"";
    
    self.nameLabel.text = order.personName;
    self.phoneLabel.text = order.mobile;
    
    self.baggageNumberLabel.text = [NSString stringWithFormat:@"行李数: %@", order.baggageNumber];

    NSInteger qrCount = order.baggageList.count;
    if (qrCount) {
        NSMutableString *qrString = [NSMutableString string];
        for (NSInteger i = 0; i < qrCount; i++) {
            GTOrderBaggageModel *baggage = order.baggageList[i];
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
    } else {
        NSMutableAttributedString *qrAttr = [[NSMutableAttributedString alloc] initWithString:@"占位" attributes:@{NSForegroundColorAttributeName:kWhiteColor, NSFontAttributeName:BGWFont(16)}];
        [self.qrLabel setAttributedText:qrAttr];
    }
    
    
    if ([order.channel isEqualToString:@"weixin_sc"]) {
        self.zhuanche.hidden = NO;
    } else if ([order.channel isEqualToString:@"weixin_gs"]) {
        self.zhuanche.hidden = YES;
    } else {
        self.zhuanche.hidden = YES;
    }
}


- (void)setupGTOrderUI {
    
    UIView *containerView = [[UIView alloc] init];
    containerView.backgroundColor = kWhiteColor;
    [self.contentView addSubview:containerView];
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(@10);
        make.bottom.equalTo(@0);
        make.right.equalTo(@0).with.offset(-10);
    }];
    self.containerView = containerView;
    
    UILabel *orderNumberLabel = [[UILabel alloc] initWithTextColor:kMPromptColor font:BGWFont(12)];
    orderNumberLabel.text = @"订单编号：1111111111111111";
    [containerView addSubview:orderNumberLabel];
    [orderNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.equalTo(@10);
    }];
    self.orderNumberLabel = orderNumberLabel;
    
    UILabel *timeLabel = [[UILabel alloc] initWithTextColor:kMPromptColor font:BGWFont(12)];
    timeLabel.text = @"16:00";
    [containerView addSubview:timeLabel];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.centerY.equalTo(orderNumberLabel);
    }];
    self.timeLabel = timeLabel;
    
    
    UIImageView *userIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"order_list_person"]];
    [containerView addSubview:userIcon];
    [userIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(orderNumberLabel.mas_bottom).with.offset(10);
        make.left.mas_equalTo(orderNumberLabel);
    }];
    
    UILabel *userNameLabel = [[UILabel alloc] initWithTextColor:kMBlackColor font:BGWFont(16)];
    userNameLabel.text = @"joey wong";
    [containerView addSubview:userNameLabel];
    [userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(userIcon.mas_right).with.offset(10);
        make.centerY.equalTo(userIcon);
    }];
    self.nameLabel = userNameLabel;
    
    
    UIImageView *phoneIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"order_list_phone"]];
    [containerView addSubview:phoneIcon];
    [phoneIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(userIcon.mas_bottom).with.offset(15);
        make.left.mas_equalTo(orderNumberLabel);
    }];
    
    UILabel *phoneLabel = [[UILabel alloc] initWithTextColor:kMBlackColor font:BGWFont(16)];
    phoneLabel.text = @"15766668888";
    [containerView addSubview:phoneLabel];
    [phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(phoneIcon.mas_right).with.offset(10);
        make.centerY.equalTo(phoneIcon);
    }];
    self.phoneLabel = phoneLabel;

    
    UIView *segmentLine = [[UIView alloc] init];
    segmentLine.backgroundColor = kMSeparateColor;
    [containerView addSubview:segmentLine];
    [segmentLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(phoneLabel.mas_bottom).with.offset(10);
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
    baggageLabel.text = @"行李数:";
    [containerView addSubview:baggageLabel];
    [baggageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(baggageImage);
        //        make.top.equalTo(segmentLine.mas_bottom).with.offset(10);
        make.left.equalTo(baggageImage.mas_right).with.offset(10);
    }];
    self.baggageNumberLabel = baggageLabel;
    
//            NSString *qrString = @"行李qr码1:12345678\n行李qr码2:12345678\n行李qr码3:12345678\n行李qr码4:12345678";
//            UILabel *qrLabel = [[UILabel alloc] initWithTextColor:kMGrayColor font:BGWFont(16)];
//            qrLabel.text = qrString;
    UILabel *qrLabel = [[UILabel alloc] init];
    qrLabel.numberOfLines = 0;
    [containerView addSubview:qrLabel];
    [qrLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(containerView.mas_centerX).with.offset(-20);
        make.top.equalTo(baggageLabel);
        make.bottom.equalTo(@0).with.offset(-10);
    }];
    self.qrLabel = qrLabel;
    
    UIImageView *zhuanche = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"task_list_zhuanche"]];
    [containerView addSubview:zhuanche];
    [zhuanche mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@0);
        make.top.equalTo(@20);
    }];
    self.zhuanche = zhuanche;
}

@end
