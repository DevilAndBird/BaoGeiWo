//
//  GTOrderListWaitPayCell.m
//  BaoGeiWo
//
//  Created by wb on 2018/11/2.
//  Copyright © 2018 qyqs. All rights reserved.
//

#import "GTOrderListWaitPayCell.h"

@implementation GTOrderListWaitPayCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupGTOrderWaitPayUI];
    }
    return self;
}


- (void)setupGTOrderWaitPayUI {
    
    [self.containerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(@10);
        make.right.equalTo(@0).with.offset(-10);
    }];
    
    UIView *btnView = [[UIView alloc] init];
    btnView.backgroundColor = kWhiteColor;
    [self.contentView addSubview:btnView];
    [btnView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.containerView.mas_bottom);
        make.left.right.equalTo(self.containerView);
        make.bottom.mas_equalTo(0);
    }];
    
    UIButton *cancelButton = [[UIButton alloc] init];
    NSAttributedString *cancelAttr = [[NSAttributedString alloc] initWithString:@"取消订单" attributes:@{NSFontAttributeName:BGWFont(12), NSForegroundColorAttributeName:kMPromptColor}];
    [cancelButton setAttributedTitle:cancelAttr forState:UIControlStateNormal];
    cancelButton.layer.borderWidth = 0.5;
    cancelButton.layer.borderColor = kMPromptColor.CGColor;
    [cancelButton addTarget:self action:@selector(cancelOrder:) forControlEvents:UIControlEventTouchUpInside];
    [btnView addSubview:cancelButton];
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.left.equalTo(@10);
        make.height.equalTo(@25);
        make.bottom.mas_equalTo(-10);
    }];
    
    UIButton *payButton = [[UIButton alloc] init];
    NSAttributedString *payAttr = [[NSAttributedString alloc] initWithString:@"已支付" attributes:@{NSFontAttributeName:BGWFont(12), NSForegroundColorAttributeName:kMThemeColor}];
    [payButton setAttributedTitle:payAttr forState:UIControlStateNormal];
    payButton.layer.borderWidth = 0.5;
    payButton.layer.borderColor = kMThemeColor.CGColor;
    [payButton addTarget:self action:@selector(paidOrder:) forControlEvents:UIControlEventTouchUpInside];
    [btnView addSubview:payButton];
    [payButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.width.equalTo(cancelButton);
        make.left.equalTo(cancelButton.mas_right).offset(20);
        make.right.mas_equalTo(-10);
    }];

}


@end
