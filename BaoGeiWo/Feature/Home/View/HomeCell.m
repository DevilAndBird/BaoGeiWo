//
//  HomeCell.m
//  BaoGeiWo
//
//  Created by wb on 2018/5/3.
//  Copyright © 2018年 qyqs. All rights reserved.
//

#import "HomeCell.h"


@interface HomeCell ()

@property (nonatomic, strong) UIImageView *image;
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UIImageView *arrow;

@end



@implementation HomeCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = kMBgColor;
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    UIView *containerView = [[UIView alloc] init];
    containerView.backgroundColor = kWhiteColor;
    containerView.layer.cornerRadius = 4.f;
    containerView.layer.shadowOffset = CGSizeMake(0, 3);
    containerView.layer.shadowOpacity = .1f;
    [self.contentView addSubview:containerView];
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.left.equalTo(@15);
        make.right.mas_equalTo(-15);
        make.bottom.mas_equalTo(-8);
    }];
    
    self.image = [[UIImageView alloc] init];
    [containerView addSubview:self.image];
    [self.image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.centerY.equalTo(@0);
        make.top.equalTo(@10);
    }];
    
    self.title = [[UILabel alloc] initWithTextColor:kMBlackColor font:BGWFont(18)];
    [containerView addSubview:self.title];
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.image.mas_right).with.offset(20);
        make.centerY.equalTo(@0);
    }];
    
    self.arrow = [[UIImageView alloc] init];
    self.arrow.image = [UIImage imageNamed:@"home_detail_arrow"];
    [containerView addSubview:self.arrow];
    [self.arrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@0).with.offset(-20);
        make.centerY.equalTo(@0);
    }];
    
//    UIView *separateLine = [[UIView alloc] init];
//    separateLine.backgroundColor = kMSeparateColor;
//    [self.contentView addSubview:separateLine];
//    [separateLine mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.bottom.right.equalTo(@0);
//        make.height.equalTo(@.5);
//    }];
    
}


- (void)setImage:(NSString *)image title:(NSString *)title {
    self.image.image = [UIImage imageNamed:image];
    self.title.text = title;
}



@end
