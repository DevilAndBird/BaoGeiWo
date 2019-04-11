//
//  OrderTaskFirstDetailCellTableViewCell.m
//  BaoGeiWo
//
//  Created by wb on 2018/5/24.
//  Copyright © 2018年 qyqs. All rights reserved.
//

#import "OrderTaskFirstDetailCell.h"

@implementation OrderTaskFirstDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupTaskFirstDetailUI];
    }
    return self;
}

- (void)setupTaskFirstDetailUI {
    
    UIView *containerView = [[UIView alloc] init];
    containerView.backgroundColor = kWhiteColor;
    [self.contentView addSubview:containerView];
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(@10);
        make.bottom.right.mas_offset(-10);
    }];
    
    UILabel *textLabel = [[UILabel alloc] initWithTextColor:kMPromptColor font:BGWFont(14)];
    textLabel.text = @"订单编号:";
    [containerView addSubview:textLabel];
    [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@7);
        make.left.equalTo(@15);
    }];
    
    UILabel *orderNumber = [[UILabel alloc] initWithTextColor:kMPromptColor font:BGWFont(14)];
    [containerView addSubview:orderNumber];
    [orderNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(textLabel.mas_right).with.offset(10);
        make.centerY.equalTo(textLabel);
    }];
    self.orderNumberLabel = orderNumber;
    
    UIView *separateLine = [[UIView alloc] init];
    separateLine.backgroundColor = kMSeparateColor;
    [containerView addSubview:separateLine];
    [separateLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(textLabel.mas_bottom).with.offset(10);
        make.left.equalTo(@15);
        make.right.mas_offset(-15);
        make.height.equalTo(@.5);
    }];
    
    
    UIView *lastView = separateLine;
    NSArray *texts = @[@"客户姓名", @"客户电话", @"证件号码", @"寄件时间", @"寄件地标", @"寄件地址", @"寄件类型", @"航班号",  @"代收人姓名", @"代收人电话", @"收件时间", @"收件地标", @"收件地址", @"收件类型", @"行李数量", @"总计价格", @"备注"];
    NSArray *images = @[@"task_detail_user", @"task_detail_phone", @"task_detail_idcard", @"task_detail_time", @"task_detail_address_mark", @"task_detail_address", @"task_detail_mailing_way", @"task_detail_flight",  @"task_detail_user", @"task_detail_phone", @"task_detail_time", @"task_detail_address_mark", @"task_detail_address", @"task_detail_mailing_way", @"task_detail_baggage_number", @"task_detail_total_price", @"task_detail_notes"];
    
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
    for (NSInteger i = 0; i < texts.count; i++) {
        UIView *view;
        if (i == texts.count-2) {
            view = [self customViewWithImage:images[i] text:texts[i] textColor:kMWarningColor];
        } else {
            view = [self customViewWithImage:images[i] text:texts[i]];
        }
        [containerView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lastView.mas_bottom);
            make.left.right.equalTo(@0);
        }];
        [array addObject:[view viewWithTag:1]];
        
        if (i == 0) {
            [view mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(lastView.mas_bottom).with.offset(5);
            }];
        } else if (i == texts.count-1) {
            [view mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(lastView.mas_bottom).with.offset(5);
                make.bottom.mas_offset(-5);
            }];
        }
        lastView = view;
        
        if (i == texts.count-2) { //倒数第二个，添加分割线
            UIView *separateLine = [[UIView alloc] init];
            separateLine.backgroundColor = kMSeparateColor;
            [containerView addSubview:separateLine];
            [separateLine mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(lastView.mas_bottom).with.offset(5);
                make.left.equalTo(@15);
                make.right.mas_offset(-15);
                make.height.equalTo(@.5);
            }];
            lastView = separateLine;
        }
        
    }
    [self initialLabels:array];
    
    

    
    
}


@end
