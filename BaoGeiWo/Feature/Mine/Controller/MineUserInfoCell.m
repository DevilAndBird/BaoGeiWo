//
//  MineUserInfoCell.m
//  BaoGeiWo
//
//  Created by wb on 2018/6/11.
//  Copyright © 2018年 qyqs. All rights reserved.
//

#import "MineUserInfoCell.h"

@interface MineUserInfoCell()

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *phoneLabel;

@end

@implementation MineUserInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle =UITableViewCellSelectionStyleNone;
        [self setupUserInfoCell];
    }
    return self;
}

- (void)setupUserInfoCell {
    UIView *containerView = [[UIView alloc] init];
    containerView.backgroundColor = kMThemeColor;
    [self.contentView addSubview:containerView];
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(@0);
    }];
    
    UIImageView *avatar = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_logo"]];
    [containerView addSubview:avatar];
    [avatar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@20);
        make.left.equalTo(@25);
        make.bottom.mas_offset(-40);
    }];
    
    UILabel *nameLabel = [[UILabel alloc] initWithTextColor:kWhiteColor font:BGWFont(18)];
    [containerView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(avatar.mas_right).with.offset(20);
        make.bottom.equalTo(avatar.mas_centerY).with.offset(-5);
    }];
    self.nameLabel = nameLabel;
    
    UILabel *phoneLabel = [[UILabel alloc] initWithTextColor:kWhiteColor font:BGWFont(18)];
    [containerView addSubview:phoneLabel];
    [phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameLabel);
        make.top.equalTo(avatar.mas_centerY).with.offset(5);
    }];
    self.phoneLabel = phoneLabel;
    
}


- (void)setUserInfo {
    
    self.nameLabel.text = [BGWUser getCurremtUserName];
    self.phoneLabel.text = [[BGWUser currentUser] mobile];
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
