//
//  QPYTaskListAddressInfoView.m
//  BaoGeiWo
//
//  Created by wb on 2018/6/22.
//  Copyright © 2018年 qyqs. All rights reserved.
//

#import "QPYTaskListAddressInfoView.h"

@implementation QPYTaskListAddressInfoView

- (instancetype)init {
    
    self = [super init];
    if (self) {
        
        UIImageView *addressMark = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"task_list_address"]];
        [self addSubview:addressMark];
        [addressMark mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@20);
            make.centerY.equalTo(@0);
        }];
        [addressMark setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh+1 forAxis:UILayoutConstraintAxisHorizontal];
        
        
        UILabel *address = [[UILabel alloc] initWithTextColor:kMBlackColor font:BGWFont(16)];
        address.text = @"出发地／目的地";
        address.tag = 1;
        [self addSubview:address];
        [address mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@10);
            make.left.equalTo(addressMark.mas_right).with.offset(10);
        }];
        [address setContentHuggingPriority:UILayoutPriorityDefaultLow-1 forAxis:UILayoutConstraintAxisHorizontal];
        [address setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh-1 forAxis:UILayoutConstraintAxisHorizontal];

        UILabel *descAddress = [[UILabel alloc] initWithTextColor:kMGrayColor font:BGWFont(14)];
        descAddress.text = @"出发地／目的地详情";
        descAddress.tag = 2;
        [self addSubview:descAddress];
        [descAddress mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(address.mas_bottom).with.offset(5);
            make.left.equalTo(address.mas_left);
            make.bottom.mas_offset(-10);
            make.right.mas_equalTo(-10);
        }];
        [descAddress setContentHuggingPriority:UILayoutPriorityDefaultLow-1 forAxis:UILayoutConstraintAxisHorizontal];
        
        UILabel *time = [[UILabel alloc] initWithTextColor:kMBlackColor font:BGWFont(16) textAlignment:NSTextAlignmentRight];
        time.text = @"00:00";
        time.tag = 3;
        [self addSubview:time];
        [time mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(address);
            make.right.mas_offset(-10).priorityHigh();
            make.left.equalTo(address.mas_right).with.offset(10);
        }];
        
    }
   
    return self;
}
@end
