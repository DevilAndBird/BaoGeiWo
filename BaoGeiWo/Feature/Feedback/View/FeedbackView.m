//
//  FeedbackView.m
//  BaoGeiWo
//
//  Created by wb on 2018/12/10.
//  Copyright © 2018 qyqs. All rights reserved.
//

#import "FeedbackView.h"

@interface FeedbackView ()<UITextViewDelegate>

@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UILabel *placeholder;
@property (nonatomic, strong) UIButton *submitBtn;

@property (nonatomic, copy) void(^textViewEndEditing)(UITextView *textView);
@property (nonatomic, copy) void(^submitPressed)(void);

@end

@implementation FeedbackView


- (instancetype)initWithTextViewEndEditing:(void (^)(UITextView * _Nonnull))endEditing submitPressed:(void (^)(void))submitPressed {
    
    self = [super init];
    if (self) {
        self.backgroundColor = kWhiteColor;
        self.textViewEndEditing = endEditing;
        self.submitPressed = submitPressed;
        [self setupUI];
    }
    return self;
    
}

- (void)setupUI {
    
    UITextView *textView = [[UITextView alloc] init];
    textView.tintColor = kMThemeColor;
    textView.font = BGWFont(16);
    textView.textColor = kMBlackColor;
    textView.delegate = self;
    [self addSubview:textView];
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@8);
        make.left.equalTo(@10);
        make.right.equalTo(@(-10));
        make.height.equalTo(@160);
    }];
    self.textView = textView;
    
    UILabel *placeholder = [[UILabel alloc] initWithTextColor:kMPromptColor font:BGWFont(16)];
    placeholder.text = @"请填写反馈内容...";
    [self addSubview:placeholder];
    [placeholder mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(textView).offset(8);
//        make.left.equalTo(textView).offset(8);
    }];
    self.placeholder = placeholder;
    
    
    UIButton *submitBtn = [[UIButton alloc] init];
    submitBtn.backgroundColor = kMThemeColor;
    submitBtn.layer.masksToBounds = YES;
    submitBtn.layer.cornerRadius = 20.f;
    NSMutableAttributedString *commitAttrString = [[NSMutableAttributedString alloc] initWithString:@"✓ 提 交"];
    [commitAttrString setAttributes:@{NSFontAttributeName:BGWBoldFont(20), NSForegroundColorAttributeName:kWhiteColor} range:NSMakeRange(0, 1)];
    [commitAttrString setAttributes:@{NSFontAttributeName:BGWBoldFont(18), NSForegroundColorAttributeName:kWhiteColor} range:NSMakeRange(2, 3)];
//    NSAttributedString *commitAttrString = [[NSAttributedString alloc] initWithString:@"✓ 提交" attributes:@{NSForegroundColorAttributeName:kWhiteColor, NSFontAttributeName:BGWBoldFont(18)}];
    [submitBtn setAttributedTitle:commitAttrString forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(commitPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:submitBtn];
    [submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(textView.mas_bottom).with.offset(10);
        make.centerX.equalTo(@0);
        make.bottom.equalTo(@(-10));
        make.width.equalTo(@200);
        make.height.equalTo(@40);
    }];
    self.submitBtn = submitBtn;
}

- (void)commitPressed:(UIButton *)sender {
    if ([self.textView isFirstResponder]) {
        [self.textView resignFirstResponder];
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.submitPressed) {
            self.submitPressed();
        }
    });
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    self.placeholder.hidden = YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if (!textView.text || [textView.text isEqualToString:@""]) {
        self.placeholder.hidden = NO;
    }
    if (self.textViewEndEditing) {
        self.textViewEndEditing(textView);
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
