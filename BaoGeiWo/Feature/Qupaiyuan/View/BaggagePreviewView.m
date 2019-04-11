//
//  BaggagePreviewView.m
//  BaoGeiWo
//
//  Created by wb on 2018/6/27.
//  Copyright © 2018年 qyqs. All rights reserved.
//

#import "BaggagePreviewView.h"

@interface BaggagePreviewView()
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIImageView *imgView;

@property (nonatomic, assign) CGRect rect;
@end


@implementation BaggagePreviewView

- (void)dealloc {
    NSLog(@"BaggagePreviewView dealloc");
}

- (instancetype)initWithCover:(UIImage *)cover curRect:(CGRect)curRect {
    self = [super initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT)];
    if (self) {
        self.rect = curRect;
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT)];
        bgView.backgroundColor = [UIColor blackColor];
        bgView.hidden = YES;
        [self addSubview:bgView];
        self.bgView = bgView;
        
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectZero];
        imgView.contentMode = UIViewContentModeScaleAspectFit;
        imgView.image = cover;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(done:)];
        [imgView addGestureRecognizer:tap];
        imgView.userInteractionEnabled = YES;
        [self addSubview:imgView];
        self.imgView  = imgView;
    }
    return self;
}

- (void)show {
    self.imgView.frame = self.rect;
    self.bgView.hidden = NO;
    
    [UIView animateWithDuration:0.2 animations:^{
        self.imgView.frame = CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT);
    } completion:^(BOOL finished) {
        //
    }];
}

- (void)done:(UITapGestureRecognizer *)sedner {

    [UIView animateWithDuration:0.2 animations:^{
        self.imgView.frame = self.rect;
        self.bgView.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
