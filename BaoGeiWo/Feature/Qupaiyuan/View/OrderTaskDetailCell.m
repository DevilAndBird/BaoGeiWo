//
//  OrderTaskDetailCell.m
//  BaoGeiWo
//
//  Created by wb on 2018/5/14.
//  Copyright © 2018年 qyqs. All rights reserved.
//

#import "OrderTaskDetailCell.h"
#import "QPYOrderTaskListModel.h"
#import "OrderDetailModel.h"

@interface OrderTaskDetailCell()


@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *phoneLabel;
@property (nonatomic, strong) UILabel *idNumberLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *addressMarkLabel;
@property (nonatomic, strong) UILabel *addressLabel;
@property (nonatomic, strong) UILabel *mailingTypeLabel;
@property (nonatomic, strong) UILabel *flightLabel;
@property (nonatomic, strong) UILabel *destNameLabel;
@property (nonatomic, strong) UILabel *destPhoneLabel;
@property (nonatomic, strong) UILabel *destTimeLabel;
@property (nonatomic, strong) UILabel *destAddressMarkLabel;
@property (nonatomic, strong) UILabel *destAddressLabel;
@property (nonatomic, strong) UILabel *destTypeLabel;
@property (nonatomic, strong) UILabel *numberLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *noteLabel;

@end

@implementation OrderTaskDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = self.contentView.backgroundColor = kMBgColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setOrderDetailModel:(OrderDetailModel *)orderDetail {
    
//    self.orderNumberLabel.text = orderDetail.orderNumber?:@"无";
    
    [self setLabel:self.orderNumberLabel withText:orderDetail.orderNumber];
    [self setLabel:self.nameLabel withText:orderDetail.srcName];
    [self setLabel:self.phoneLabel withText:orderDetail.srcPhone];
    [self setLabel:self.idNumberLabel withText:orderDetail.cusInfo.IDNumber];
    [self setLabel:self.timeLabel withText:orderDetail.takeTime];
    [self setLabel:self.addressMarkLabel withText:orderDetail.orderAddress.srcAddressMark];
    [self setLabel:self.addressLabel withText:orderDetail.orderAddress.srcAddress];
    [self setLabel:self.mailingTypeLabel withText:[orderDetail.srcMailingWay orderMailingWayCN]];
    [self setLabel:self.flightLabel withText:orderDetail.flightNo];
    
    [self setLabel:self.destNameLabel withText:orderDetail.destName];
    [self setLabel:self.destPhoneLabel withText:orderDetail.destPhone];
    [self setLabel:self.destTimeLabel withText:orderDetail.sendTime];
    [self setLabel:self.destAddressMarkLabel withText:orderDetail.orderAddress.destAddressMark];
    [self setLabel:self.destAddressLabel withText:orderDetail.orderAddress.destAddress];
    [self setLabel:self.destTypeLabel withText:[orderDetail.destMailingWay orderMailingWayCN]];
    
    [self setLabel:self.numberLabel withText:orderDetail.baggageNumber];
    OrderDetailNotesModel *orderNote = [orderDetail.orderNotes firstObject];
    [self setLabel:self.priceLabel withText:[@"¥" stringByAppendingString:orderDetail.priceDetail? (orderDetail.priceDetail.totalPrice?:@""):@""]];
    [self setLabel:self.noteLabel withText:orderNote.notes];

}

- (void)setLabel:(UILabel *)label withText:(NSString *)text {
    if ([text isEqualToString:@""] || !text) {
        label.text = @"无";
    } else {
        label.text = text;
    }
}


- (void)callClick:(UIButton *)sender {
    if (self.callBlock) {
        self.callBlock(sender.tag);
    }
}

- (void)priceTap:(UITapGestureRecognizer *)sender {
    if (self.priceTapBlock) {
        self.priceTapBlock();
    }
}

//initialization
- (void)initialLabels:(NSArray *)array {
    
    NSUInteger i = 0;
    self.nameLabel = array[i++];
    self.phoneLabel = array[i++];
    self.idNumberLabel = array[i++];
    self.timeLabel = array[i++];
    self.addressMarkLabel = array[i++];
    self.addressLabel = array[i++];
    self.mailingTypeLabel = array[i++];
    self.flightLabel = array[i++];
    self.destNameLabel = array[i++];
    self.destPhoneLabel = array[i++];
    self.destTimeLabel = array[i++];
    self.destAddressMarkLabel = array[i++];
    self.destAddressLabel = array[i++];
    self.destTypeLabel = array[i++];
    self.numberLabel = array[i++];
    self.priceLabel = array[i++];
    self.noteLabel = array[i++];
}



- (UIView *)customViewWithImage:(NSString *)image text:(NSString *)text {
    
    return [self customViewWithImage:image text:text textColor:kMGrayColor];
}

- (UIView *)customViewWithImage:(NSString *)image text:(NSString *)text textColor:(UIColor *)textColor{
    UIView *view = [[UIView alloc] init];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:image]];
    [view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
    }];
    [imageView setContentHuggingPriority:UILayoutPriorityDefaultLow+1 forAxis:UILayoutConstraintAxisHorizontal];
    //    [imageView setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh+1 forAxis:UILayoutConstraintAxisHorizontal];
    
    UILabel *textLabel = [[UILabel alloc] initWithTextColor:kMGrayColor font:BGWFont(14)];
    textLabel.text = [text stringByAppendingString:@": "];
    [view addSubview:textLabel];
    [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@4);
        make.left.equalTo(imageView.mas_right).with.offset(5);
    }];
    [textLabel setContentHuggingPriority:UILayoutPriorityDefaultLow+1 forAxis:UILayoutConstraintAxisHorizontal];
    //    [textLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh+1 forAxis:UILayoutConstraintAxisHorizontal];
    
    [imageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(textLabel);
    }];
    
    UILabel *detailLabel = [[UILabel alloc] initWithTextColor:textColor font:BGWFont(14)];
    detailLabel.numberOfLines = 0;
    detailLabel.tag = 1;
    detailLabel.text = @"  ";
    [view addSubview:detailLabel];
    [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(textLabel);
        make.left.equalTo(textLabel.mas_right).with.offset(5);
        make.bottom.mas_offset(-4);
    }];
    if ([text isEqualToString:@"总计价格"]) {
        detailLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(priceTap:)];
        [detailLabel addGestureRecognizer:tap];
    }
    [detailLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh-1 forAxis:UILayoutConstraintAxisHorizontal];
    
    if ([text containsString:@"电话"]) {
        
        UIButton *call = [[UIButton alloc] init];
        [call setImage:[UIImage imageNamed:@"task_detail_call"] forState:UIControlStateNormal];
        call.contentMode = UIViewContentModeScaleAspectFit;
        [call addTarget:self action:@selector(callClick:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:call];
        [call mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(detailLabel.mas_right).with.offset(10);
            make.top.bottom.equalTo(@0);
            make.width.equalTo(@40);
        }];
        if ([text isEqualToString:@"客户电话"]) {
            call.tag = 111;
        } else {
            call.tag = 222;
        }
    } else {
        [detailLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.mas_offset(-15);
        }];
    }
    
    return view;
    
}

@end
