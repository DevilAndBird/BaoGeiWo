//
//  ScanViewController.h
//  BaoGeiWo
//
//  Created by wb on 2018/5/9.
//  Copyright © 2018年 qyqs. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^ScanSuccessBlock)(id result);

@interface ScanViewController : BaseViewController

@property (nonatomic, strong) UIView *scanView;
//@property (nonatomic, copy) ScanSuccessBlock scanSuccessBlock;
@property (nonatomic, copy) void(^scanSuccessBlock)(id result);

- (instancetype)initWithScanType:(NSInteger)type;

- (void)startScan;
- (void)scanResult:(NSString *)result;

//- (void)scanSuccess:(void(^)(id))block;

@end
