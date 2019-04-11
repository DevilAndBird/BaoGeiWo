//
//  OrderTaskDetailBaggageCell.h
//  BaoGeiWo
//
//  Created by wb on 2018/5/14.
//  Copyright © 2018年 qyqs. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OrderTaskBaggageModel;
@class OrderBaggageModel;
typedef void(^PreviewImageBlock)(UIImageView *imgView);
typedef void(^TakePhotoBlock)(void);

typedef void(^TakePreviewBlock)(void);
typedef void(^SendPreviewBlock)(void);
typedef void(^ScanBlock)(void);

@interface OrderTaskDetailBaggageCell : UITableViewCell

@property (nonatomic, strong) UIButton *takePhotoButton;
@property (nonatomic, strong) UIButton *scanButton;

@property (nonatomic, copy) PreviewImageBlock previewImageBlock;
@property (nonatomic, copy) TakePhotoBlock takePhotoBlock;

@property (nonatomic, copy) TakePreviewBlock takePreviewBlock;
@property (nonatomic, copy) SendPreviewBlock sendPreviewBlock;
@property (nonatomic, copy) ScanBlock scanBlock;

- (void)setBaggageInfo:(OrderBaggageModel *)baggage roleType:(NSInteger)roleType;
//- (void)setBaggageInfo:(OrderBaggageModel *)baggage roleType:(BGWRoleActionType)roleType;

@end
