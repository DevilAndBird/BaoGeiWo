//
//  WQPhotoCell.m
//  BaoGeiWo
//
//  Created by wb on 2018/8/29.
//  Copyright © 2018年 qyqs. All rights reserved.
//

#import "WQPhotoCell.h"

@interface WQPhotoCell()

@end

@implementation WQPhotoCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, self.bgw_w-20, self.bgw_h)];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.clipsToBounds = YES;
        [self.contentView addSubview:imageView];
        self.imageView = imageView;
    }
    return self;
}

@end
