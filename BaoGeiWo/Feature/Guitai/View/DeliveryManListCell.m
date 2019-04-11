//
//  DeliveryManListCell.m
//  BaoGeiWo
//
//  Created by wb on 2018/5/17.
//  Copyright © 2018年 qyqs. All rights reserved.
//

#import "DeliveryManListCell.h"
#import "DeliveryManModel.h"

@interface DeliveryManListCell()

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *numberLabel;
@property (nonatomic, strong) UILabel *travelLabel;

@end

@implementation DeliveryManListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = self.contentView.backgroundColor = kMBgColor;
        [self setupDeliveryManListUI];
    }
    return self;
}

- (void)setDeliveryManModel:(DeliveryManModel *)model {
    self.nameLabel.text = model.dmName;
    self.numberLabel.text = model.dmPlateNumber;
    if (![model.dmTravelStatus isEqualToString:@""] && model.dmTravelStatus) {
        self.travelLabel.text = [model.dmTravelStatus orderDriverStatusCN];
    }
}



- (void)setupDeliveryManListUI {
    
    UIView *containerView = [[UIView alloc] init];
    containerView.backgroundColor = kWhiteColor;
    [self.contentView addSubview:containerView];
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@4);
        make.left.equalTo(@15);
        make.right.mas_offset(-15);
        make.bottom.mas_offset(-4);
    }];
    
    
    UIImageView *avatar = [[UIImageView alloc] init];
    avatar.image = [UIImage imageNamed:@"qupaiyuan_default"];
    [containerView addSubview:avatar];
    [avatar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.centerY.equalTo(@0);
        make.width.height.equalTo(@40);
    }];
    
    UILabel *nameLabel = [[UILabel alloc] initWithTextColor:kMBlackColor font:BGWFont(16)];
    [containerView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@10);
        make.left.equalTo(avatar.mas_right).with.offset(10);
    }];
    self.nameLabel = nameLabel;
    
    UILabel *numberLabel = [[UILabel alloc] initWithTextColor:kMGrayColor font:BGWFont(14)];
    [containerView addSubview:numberLabel];
    [numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameLabel.mas_bottom).with.offset(7);
        make.left.equalTo(nameLabel);
        make.bottom.mas_offset(-10);
    }];
    self.numberLabel = numberLabel;
    
    UILabel *travelLabel = [[UILabel alloc] initWithTextColor:kRedColor font:BGWFont(16)];
    [containerView addSubview:travelLabel];
    [travelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_offset(-20);
        make.centerY.equalTo(@0);
    }];
    self.travelLabel = travelLabel;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
