//
//  QPYOrderListCell.m
//  BaoGeiWo
//
//  Created by wb on 2018/5/7.
//  Copyright © 2018年 qyqs. All rights reserved.
//

#import "QPYOrderListCell.h"

@interface QPYOrderListCell()

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIView *lastView;

@property (nonatomic, strong) UILabel *orderNumberLabel;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *baggageNumberLabel;
@property (nonatomic, strong) UILabel *qrLabel;

@end

@implementation QPYOrderListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = kMBgColor;
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    UIView *containerView = [[UIView alloc] init];
    containerView.backgroundColor = kWhiteColor;
    [self.contentView addSubview:containerView];
    self.containerView = containerView;
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(@10);
        make.bottom.equalTo(@0);
        make.right.equalTo(@0).with.offset(-10);
    }];
    
    UILabel *orderNumber = [[UILabel alloc] initWithTextColor:kMPromptColor font:BGWFont(12)];
    orderNumber.text = @"订单编号:";
    [containerView addSubview:orderNumber];
    [orderNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(@10);
    }];
    self.orderNumberLabel = orderNumber;
    
    UIImageView *nameImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"order_list_person"]];
    [containerView addSubview:nameImage];
    [nameImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(orderNumber.mas_bottom).with.offset(10);
        make.left.equalTo(orderNumber);
    }];
    
    UILabel *nameLabel = [[UILabel alloc] initWithTextColor:kMBlackColor font:BGWFont(16)];
    nameLabel.text = @"joey wong";
    [containerView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(nameImage);
//        make.top.equalTo(orderNumber.mas_bottom).with.offset(10);
        make.left.equalTo(nameImage.mas_right).with.offset(10);
    }];
    self.nameLabel = nameLabel;
    
//    UIImageView *addressImage = [[UIImageView alloc] init];
//    addressImage.backgroundColor = kRedColor;
//    [containerView addSubview:addressImage];
//    [addressImage mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(orderNumber.mas_bottom).with.offset(10);
//        make.left.equalTo(containerView.mas_centerX).with.offset(10);
//        make.width.height.equalTo(@20);
//    }];
//    UILabel *addressLabel = [[UILabel alloc] initWithTextColor:kGrayColor font:BGWFont(16)];
//    addressLabel.text = @"虹桥机场";
//    [containerView addSubview:addressLabel];
//    [addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(orderNumber.mas_bottom).with.offset(10);
//        make.left.equalTo(addressImage.mas_right).with.offset(10);
//    }];
    
    UIView *segmentLine = [[UIView alloc] init];
    segmentLine.backgroundColor = kMSeparateColor;
    [containerView addSubview:segmentLine];
    [segmentLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameLabel.mas_bottom).with.offset(10);
        make.left.equalTo(@10);
        make.right.equalTo(@0).with.offset(-10);
        make.height.equalTo(@.5);
    }];
    
    UIImageView *baggageImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"order_list_baggage"]];
    [containerView addSubview:baggageImage];
    [baggageImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(segmentLine.mas_bottom).with.offset(10);
        make.left.equalTo(orderNumber);
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
    
//    NSString *qrString = @"行李qr码1:12345678\n行李qr码2:12345678\n行李qr码3:12345678\n行李qr码4:12345678";
//    UILabel *qrLabel = [[UILabel alloc] initWithTextColor:kMGrayColor font:BGWFont(16)];
    UILabel *qrLabel = [[UILabel alloc] init];
    qrLabel.numberOfLines = 0;
    [containerView addSubview:qrLabel];
    [qrLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(containerView.mas_centerX).with.offset(-40);
        make.top.equalTo(baggageLabel);
        make.bottom.equalTo(@0).with.offset(-10);
    }];
    self.qrLabel = qrLabel;
    
}


- (void)setOrderContent:(QPYOrderListModel *)order {
    
    self.orderNumberLabel.text = [NSString stringWithFormat:@"订单编号: %@", order.orderNumber];
    self.nameLabel.text = order.personName;
    self.baggageNumberLabel.text = [NSString stringWithFormat:@"行李数: %@", order.baggageNumber];
    
    NSInteger qrCount = order.QRNumbers.count;
    NSMutableString *qrString = [NSMutableString string];
    for (NSInteger i = 0; i < qrCount; i++) {
        QPYQRNumerModel *qrNumber = order.QRNumbers[i];
        if (i == qrCount-1) {
            [qrString appendFormat:@"%@", [NSString stringWithFormat:@"行李QR码%zd : %@", i+1, qrNumber.QRNumber]];
        } else {
            [qrString appendFormat:@"%@", [NSString stringWithFormat:@"行李QR码%zd : %@\n", i+1, qrNumber.QRNumber]];
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

    
    
    
    return;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunreachable-code"
    
    if (qrCount < 2) {
        [self.lastView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(@0).with.offset(-10);
        }];
        return;
    }
    for (NSInteger i = 1; i < qrCount; i++) {
        UILabel *qrLabe = [[UILabel alloc] initWithTextColor:kMGrayColor font:BGWFont(16)];
        qrLabe.text = @"行李qr码:12345678";
        [self.containerView addSubview:qrLabe];
        [qrLabe mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.lastView);
            make.top.equalTo(self.lastView.mas_bottom).with.offset(5);
        }];
        
        if (i == qrCount) {
            [qrLabe mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(@0).with.offset(-10);
            }];
        }
        
        self.lastView = qrLabe;
    }
#pragma clang diagnostic pop

}





- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
