//
//  OrderTaskDetailBaggageCell.m
//  BaoGeiWo
//
//  Created by wb on 2018/5/14.
//  Copyright © 2018年 qyqs. All rights reserved.
//

#import "OrderTaskDetailBaggageCell.h"
#import "QPYOrderTaskListModel.h"
#import "OrderBaggageModel.h"

@interface OrderTaskDetailBaggageCell()

@property (nonatomic, strong) UIImageView *baggageImageView;
@property (nonatomic, strong) UILabel *qrNumberLabel;

@property (nonatomic, strong) UIButton *takePreviewButton;
@property (nonatomic, strong) UIButton *sendPreviewButton;

@end

@implementation OrderTaskDetailBaggageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = self.contentView.backgroundColor = kMBgColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupTaskDetailBaggageUI];
    }
    return self;
}

- (void)setBaggageInfo:(OrderBaggageModel *)baggage roleType:(NSInteger)roleType {
    
    self.takePhotoButton.hidden = self.scanButton.hidden = (roleType != BGWRoleActionTypeHotelTask);
    self.qrNumberLabel.text = [NSString stringWithFormat:@"QR码：%@", baggage.baggageQRCode?:@""];
    if (baggage.baggageQRCode && ![baggage.baggageQRCode isEqualToString:@""]) {
        self.scanButton.enabled = NO;
    } else {
        self.scanButton.enabled = YES;
    }
    
    [self.takePreviewButton sd_setImageWithURL:[NSURL URLWithString:[baggage.baggageImage.takeImageUrls firstObject]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"task_detail_baggage_take_placeholder"]];
    [self.sendPreviewButton sd_setImageWithURL:[NSURL URLWithString:[baggage.baggageImage.sendImageUrls firstObject]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"task_detail_baggage_send_placeholder"]];

//    if (baggage.image || (baggage.baggageImageUrl && ![baggage.baggageImageUrl isEqualToString:@""])) {
//        self.takePhotoButton.enabled = NO;
//    } else {
//        self.takePhotoButton.enabled = YES;
//    }
//    
//    if (baggage.image) {
//        self.baggageImageView.image = baggage.image;
//    } else {
//        [self.baggageImageView sd_setImageWithURL:[NSURL URLWithString:baggage.baggageImageUrl] placeholderImage:[UIImage imageNamed:@"task_detail_baggage_placeholder"]];
//    }

}

//- (void)previewImage:(UITapGestureRecognizer *)sender {
//    UIImageView *imgView = (UIImageView *)sender.view;
//
//    if (self.previewImageBlock) {
//        self.previewImageBlock(imgView);
//    }
//}
//
//- (void)takePhotoClick {
//    if (self.takePhotoBlock) {
//        self.takePhotoBlock();
//    }
//}

- (void)takePreview:(UIButton *)sender {
    if (self.takePreviewBlock) {
        self.takePreviewBlock();
    }
}

- (void)sendPreview:(UIButton *)sender {
    if (self.sendPreviewBlock) {
        self.sendPreviewBlock();
    }
}

- (void)scanClick {
    if (self.scanBlock) {
        self.scanBlock();
    }
}

- (void)setupTaskDetailBaggageUI {
    
    UIView *containerView = [[UIView alloc] init];
    containerView.backgroundColor = kWhiteColor;
    [self.contentView addSubview:containerView];
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.left.equalTo(@10);
        make.bottom.right.mas_offset(-10);
    }];
    
    UILabel *bagTextLabel = [[UILabel alloc] initWithTextColor:kMThemeColor font:BGWFont(16)];
    bagTextLabel.text = @"行李";
    [containerView addSubview:bagTextLabel];
    [bagTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@5);
        make.left.equalTo(@15);
    }];
    
    UIView *separateLine = [[UIView alloc] init];
    separateLine.backgroundColor = kMSeparateColor;
    [containerView addSubview:separateLine];
    [separateLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bagTextLabel.mas_bottom).with.offset(5);
        make.left.equalTo(@15);
        make.right.mas_offset(-15);
        make.height.equalTo(@.5);
    }];
    
//    UIImageView *baggageImage = [[UIImageView alloc] init];
//    baggageImage.userInteractionEnabled = YES;
//    [containerView addSubview:baggageImage];
//    [baggageImage mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(separateLine.mas_bottom).with.offset(10);
//        make.left.equalTo(@15);
//        make.width.height.equalTo(@100);
//        make.bottom.mas_offset(-10);
//    }];
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(previewImage:)];
//    [baggageImage addGestureRecognizer:tap];
//    self.baggageImageView = baggageImage;
    
    UILabel *qrNumberLabel = [[UILabel alloc] initWithTextColor:kMGrayColor font:BGWFont(14)];
    qrNumberLabel.text = @"QR码:";
    [containerView addSubview:qrNumberLabel];
    [qrNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(separateLine.mas_bottom).with.offset(15);
        make.left.mas_offset(20);
    }];
    self.qrNumberLabel = qrNumberLabel;
    

    UIButton *scan = [[UIButton alloc] init];
    [scan addTarget:self action:@selector(scanClick) forControlEvents:UIControlEventTouchUpInside];
    [scan setTitle:@"扫描" forState:UIControlStateNormal];
    [scan setTitleColor:kMThemeColor forState:UIControlStateNormal];
    [scan setBackgroundImage:[UIImage imageNamed:@"task_detail_baggage_button"] forState:UIControlStateNormal];
    [scan setBackgroundImage:[UIImage imageNamed:@"task_detail_baggage_button_complete"] forState:UIControlStateDisabled];
    scan.titleLabel.font = BGWFont(14);
    [containerView addSubview:scan];
    [scan mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(qrNumberLabel);
        make.right.mas_offset(-20);
        make.width.equalTo(@60);
        make.height.equalTo(@27);
    }];
    self.scanButton = scan;
    
    UILabel *photoLabel = [[UILabel alloc] initWithTextColor:kMGrayColor font:BGWFont(12)];
    photoLabel.text = @"照片";
    [containerView addSubview:photoLabel];
    [photoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(qrNumberLabel.mas_bottom).with.offset(10);
        make.left.equalTo(qrNumberLabel);
    }];
    
    UIButton *takePreButton = [[UIButton alloc] init];
    [takePreButton addTarget:self action:@selector(takePreview:) forControlEvents:UIControlEventTouchUpInside];
    [containerView addSubview:takePreButton];
    [takePreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(photoLabel.mas_bottom).with.offset(10);
        make.left.equalTo(qrNumberLabel);
        make.width.height.equalTo(@90);
        make.bottom.mas_offset(-10);
    }];
    self.takePreviewButton = takePreButton;
    
    UIButton *sendPreButton = [[UIButton alloc] init];
    [sendPreButton addTarget:self action:@selector(sendPreview:) forControlEvents:UIControlEventTouchUpInside];
    [containerView addSubview:sendPreButton];
    [sendPreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(takePreButton);
        make.left.equalTo(takePreButton.mas_right).with.offset(10);
        make.width.height.equalTo(takePreButton);
    }];
    self.sendPreviewButton = sendPreButton;
//    UIButton *takePhoto = [[UIButton alloc] init];
//    [takePhoto addTarget:self action:@selector(takePhotoClick) forControlEvents:UIControlEventTouchUpInside];
//    [takePhoto setTitle:@"拍照" forState:UIControlStateNormal];
//    [takePhoto setTitleColor:kMThemeColor forState:UIControlStateNormal];
//    [takePhoto setBackgroundImage:[UIImage imageNamed:@"task_detail_baggage_button"] forState:UIControlStateNormal];
//    [takePhoto setBackgroundImage:[UIImage imageNamed:@"task_detail_baggage_button_complete"] forState:UIControlStateDisabled];
////    [takePhoto setTitleColor:kMGrayColor forState:UIControlStateDisabled];
//    takePhoto.titleLabel.font = BGWFont(14);
////    [takePhoto setCornerRadius:2.f boderWidth:.5f borderColor:kMThemeColor];
//    [containerView addSubview:takePhoto];
//    [takePhoto mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(scan.mas_right).with.offset(10);
//        make.bottom.equalTo(baggageImage);
//        make.width.equalTo(@60);
//        make.height.equalTo(@30);
//    }];
//    self.takePhotoButton = takePhoto;
}



@end
