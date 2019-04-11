//
//  UILabel+BGWExtension.m
//  BaoGeiWo
//
//  Created by wb on 2018/5/3.
//  Copyright © 2018年 qyqs. All rights reserved.
//

#import "UILabel+BGWExtension.h"

@implementation UILabel (BGWExtension)

- (instancetype)initWithTextColor:(UIColor *)textColor {
    return [self initWithTextColor:textColor font:nil];
}

- (instancetype)initWithFont:(UIFont *)font {
    return [self initWithTextColor:nil font:font];
}

- (instancetype)initWithTextAlignment:(NSTextAlignment)textAlignment {
    return [self initWithTextColor:nil font:nil textAlignment:textAlignment];
}

- (instancetype)initWithTextColor:(UIColor *)textColor font:(UIFont *)font {
    return [self initWithTextColor:textColor font:font textAlignment:NSTextAlignmentNatural];
}

- (instancetype)initWithTextColor:(UIColor *)textColor font:(UIFont *)font textAlignment:(NSTextAlignment)textAlignment {
    self = [super init];
    if (self) {
        self.textColor = textColor;
        self.font = font;
        self.textAlignment = textAlignment;
    }
    return self;
}

@end
