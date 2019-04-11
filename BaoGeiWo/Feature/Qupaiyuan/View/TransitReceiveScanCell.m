//
//  TransitReceiveScanCell.m
//  BaoGeiWo
//
//  Created by wb on 2018/5/9.
//  Copyright © 2018年 qyqs. All rights reserved.
//

#import "TransitReceiveScanCell.h"

@interface TransitReceiveScanCell()

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *numberLabel;

@end

@implementation TransitReceiveScanCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = kClearColor;
        self.contentView.backgroundColor = kClearColor;
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = RGBA(255, 255, 255, 0.8);
    [self.contentView addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.left.equalTo(@10);
        make.bottom.right.mas_offset(-10);
    }];
    
    UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"order_list_person"]];
    [bgView addSubview:icon];
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@10);
        make.centerY.equalTo(@0);
        make.left.equalTo(@10);
    }];
    
    UILabel *nameLabel = [[UILabel alloc] initWithTextColor:kMGrayColor font:BGWFont(14)];
    nameLabel.text = @"joey wong";
    [bgView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(icon.mas_right).with.offset(10);
        make.centerY.equalTo(icon);
    }];
    self.nameLabel = nameLabel;
    
    UILabel *numberLabel = [[UILabel alloc] initWithTextColor:kMThemeColor font:BGWFont(14) textAlignment:NSTextAlignmentRight];
    numberLabel.text = @"行李qr码：123456";
    [bgView addSubview:numberLabel];
    [numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_offset(-30);
        make.centerY.equalTo(icon);
    }];
    self.numberLabel = numberLabel;
    
}

- (void)setPersonName:(NSString *)name qrNumber:(NSString *)qrNumber {
    self.nameLabel.text = name;
    self.numberLabel.text = [NSString stringWithFormat:@"行李qr码：%@", qrNumber];;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
