//
//  GTFreeOrderDetailBaggageCell.m
//  BaoGeiWo
//
//  Created by wb on 2018/5/31.
//  Copyright © 2018年 qyqs. All rights reserved.
//

#import "GTFreeOrderDetailBaggageCell.h"

#import "OrderBaggageModel.h"

@implementation GTFreeOrderDetailBaggageCell


- (void)setBaggageInfo:(OrderBaggageModel *)baggage isScan:(BOOL)isScan {
    [super setBaggageInfo:baggage roleType:BGWRoleActionTypeOther];
    self.scanButton.hidden = NO;
    
    self.scanButton.enabled = !isScan;

}


@end
