//
//  OrderMessageCell.m
//  BaoGeiWo
//
//  Created by wb on 2018/5/22.
//  Copyright © 2018年 qyqs. All rights reserved.
//

#import "OrderMessageCell.h"
#import "MessageModel.h"

@interface OrderMessageCell()

@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIImageView *unreadImage;
@property (nonatomic, strong) UILabel *detailLabel;

@end


@implementation OrderMessageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = self.contentView.backgroundColor = kMBgColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupOrderMessageUI];
    }
    return self;
}

- (void)setContentWithIcon:(NSString *)icon title:(NSString *)title time:(NSString *)time detail:(NSString *)detail {
    self.icon.image = [UIImage imageNamed:icon];
    self.titleLabel.text = title;
    
}

- (void)setContentWithIcon:(NSString *)icon titleStr:(NSString *)title msgModel:(MessageModel *)msgModel {
    self.icon.image = [UIImage imageNamed:icon];
    self.titleLabel.text = msgModel.msgTheme?:@"订单消息";
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 5.f;
    NSAttributedString *msgAttr = [[NSAttributedString alloc] initWithString:msgModel.msgContent attributes:@{NSForegroundColorAttributeName:kMGrayColor, NSFontAttributeName:BGWFont(14), NSParagraphStyleAttributeName:paragraphStyle}];
    self.detailLabel.attributedText = msgAttr;
    
    self.timeLabel.text = msgModel.msgTime;
    self.unreadImage.hidden = msgModel.isRead.integerValue;
}


- (void)setupOrderMessageUI {
    
    UIView *containerView = [[UIView alloc] init];
    containerView.backgroundColor = kWhiteColor;
    [self.contentView addSubview:containerView];
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(@0);
    }];
    
    UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
    [containerView addSubview:icon];
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
    }];
    self.icon = icon;
    
    UILabel *title = [[UILabel alloc] initWithTextColor:kMBlackColor font:BGWFont(14)];
    title.text = @"订单信息";
    [containerView addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@8);
        make.left.equalTo(icon.mas_right).with.offset(10);
    }];
    self.titleLabel = title;
    [icon mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(title);
    }];
    
    UILabel *timeLabel = [[UILabel alloc] initWithTextColor:kMPromptColor font:BGWFont(14)];
    timeLabel.text = @"13:23";
    [containerView addSubview:timeLabel];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_offset(-20);
        make.centerY.equalTo(title);
    }];
    self.timeLabel = timeLabel;
    
    UIImageView *unreadImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"msg_unread"]];
    [containerView addSubview:unreadImage];
    [unreadImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(timeLabel.mas_left).with.offset(-7);
        make.centerY.equalTo(timeLabel);
    }];
    self.unreadImage = unreadImage;
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = kMSeparateColor;
    [containerView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(title.mas_bottom).with.offset(8);
        make.left.equalTo(@15);
        make.right.mas_offset(-15);
        make.height.equalTo(@.5);
    }];
    
    UILabel *detailLabel = [[UILabel alloc] initWithTextColor:kMGrayColor font:BGWFont(14)];
    detailLabel.numberOfLines = 0;
    [containerView addSubview:detailLabel];
    [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom).with.offset(8);
        make.left.equalTo(@15);
        make.right.mas_offset(-15);
        make.bottom.mas_offset(-10);
    }];
    self.detailLabel = detailLabel;
    
    UIView *line2 = [[UIView alloc] init];
    line2.backgroundColor = kMSeparateColor;
    [containerView addSubview:line2];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.bottom.mas_offset(-.5);
        make.height.equalTo(@.5);
    }];
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
