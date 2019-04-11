//
//  WQPhotoBrowser.h
//  BaoGeiWo
//
//  Created by wb on 2018/8/29.
//  Copyright © 2018年 qyqs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WQPhotoBrowser : UIViewController

@property (nonatomic, assign) BOOL deleteButtonShow;
@property (nonatomic, copy) void(^deleteImageBlock)(NSString *image);

- (instancetype)initWithPhotos:(NSArray *)photos atIndex:(NSUInteger)index;

@end
