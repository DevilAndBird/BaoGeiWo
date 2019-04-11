//
//  FeedbackCell.m
//  BaoGeiWo
//
//  Created by wb on 2018/12/10.
//  Copyright © 2018 qyqs. All rights reserved.
//

#import "FeedbackCell.h"
#import "FeedbackListModel.h"

@interface FeedbackCell ()

//@property (nonatomic, strong) UIView *feedbackTimeView;
@property (nonatomic, strong) UILabel *feedbackTimeLabel;
//@property (nonatomic, strong) UIView *feedbackContentView;
@property (nonatomic, strong) UILabel *feedbackContentLabel;

//@property (nonatomic, strong) UIView *processTimeView;
//@property (nonatomic, strong) UIView *processTimeLabel;
//@property (nonatomic, strong) UIView *processContentView;
//@property (nonatomic, strong) UIView *processContentLabel;

@end

@implementation FeedbackCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupFeedbackCellUI];
    }
    return self;
}

- (void)setContentWithModel:(FeedbackListModel *)model {
    self.feedbackTimeLabel.text = model.time;
    self.feedbackContentLabel.text = [NSString stringWithFormat:@"【%@】%@", model.name, model.desc];
}

- (void)setupFeedbackCellUI {
    
    UIView *separator = [[UIView alloc] init];
    separator.backgroundColor = kMSeparateColor;
    [self.contentView addSubview:separator];
    [separator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(@0);
        make.height.equalTo(@.5);
    }];
    
    UIView *feedbackTimeView = [self initializeFeedbackTitle:@"反馈时间"];
    self.feedbackTimeLabel = [feedbackTimeView viewWithTag:1129];
    [self.contentView addSubview:feedbackTimeView];
    [feedbackTimeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@15);
        make.left.right.equalTo(@0);
    }];
    
    UIView *feedbackContentView = [self initializeFeedbackTitle:@"反馈内容"];
    self.feedbackContentLabel = [feedbackContentView viewWithTag:1129];
    [self.contentView addSubview:feedbackContentView];
    [feedbackContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(feedbackTimeView.mas_bottom);
        make.left.right.equalTo(@0);
        make.bottom.equalTo(@(-15));
    }];
}


- (UIView *)initializeFeedbackTitle:(NSString *)title {
    
    UIView *view = [[UIView alloc] init];
    
    UIImageView *dotView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"feedback_msg_unprocessed"]];
    [view addSubview:dotView];
    [dotView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.width.height.equalTo(@8);
    }];
    
    UILabel *titleLabel = [[UILabel alloc] initWithTextColor:kMBlackColor font:BGWFont(14)];
    titleLabel.text = [title stringByAppendingString:@":"];
    [view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(dotView.mas_right).offset(10);
        make.top.equalTo(@4);
    }];
    [dotView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(titleLabel);
    }];
    
    UILabel *contentLabel = [[UILabel alloc] initWithTextColor:kMBlackColor font:BGWFont(14)];
    contentLabel.numberOfLines = 0;
    contentLabel.tag = 1129;
    contentLabel.text = @"123333";
    [view addSubview:contentLabel];
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLabel.mas_right).offset(10);
        make.right.equalTo(@(-10));
        make.centerY.equalTo(@0);
        make.top.equalTo(@4);
    }];
    [contentLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh-1 forAxis:UILayoutConstraintAxisHorizontal];
    
    return view;
    
}

@end



@interface FeedbackProcessCell ()

@property (nonatomic, strong) UILabel *feedbackTimeLabel;
@property (nonatomic, strong) UILabel *feedbackContentLabel;

@property (nonatomic, strong) UILabel *processTimeLabel;
@property (nonatomic, strong) UILabel *processContentLabel;

@end

@implementation FeedbackProcessCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupFeedbackProcessCellUI];
    }
    return self;
}

- (void)setContentWithProcessedModel:(FeedbackListModel *)model {
    
    self.feedbackTimeLabel.text = model.time;
    self.feedbackContentLabel.text = [NSString stringWithFormat:@"【%@】%@", model.name, model.desc];

    self.processTimeLabel.text = model.processTime;
    self.processContentLabel.text = [NSString stringWithFormat:@"【%@】%@", model.processName, model.processDesc];
}

- (void)setupFeedbackProcessCellUI {
    
    UIView *separator = [[UIView alloc] init];
    separator.backgroundColor = kMSeparateColor;
    [self.contentView addSubview:separator];
    [separator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(@0);
        make.height.equalTo(@.5);
    }];
    
    UIView *feedbackTimeView = [self initializeFeedbackTitle:@"反馈时间"];
    self.feedbackTimeLabel = [feedbackTimeView viewWithTag:1129];
    [self.contentView addSubview:feedbackTimeView];
    [feedbackTimeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@15);
        make.left.right.equalTo(@0);
    }];
    
    UIView *feedbackContentView = [self initializeFeedbackTitle:@"反馈内容"];
    self.feedbackContentLabel = [feedbackContentView viewWithTag:1129];
    [self.contentView addSubview:feedbackContentView];
    [feedbackContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(feedbackTimeView.mas_bottom);
        make.left.right.equalTo(@0);
    }];
    
    UIView *processTimeView = [self initializeFeedbackTitle:@"处理时间"];
    self.processTimeLabel = [processTimeView viewWithTag:1129];
    [self.contentView addSubview:processTimeView];
    [processTimeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(feedbackContentView.mas_bottom);
        make.left.right.equalTo(@0);
    }];
    
    UIView *processContentView = [self initializeFeedbackTitle:@"处理内容"];
    self.processContentLabel = [processContentView viewWithTag:1129];
    [self.contentView addSubview:processContentView];
    [processContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(processTimeView.mas_bottom);
        make.left.right.equalTo(@0);
        make.bottom.equalTo(@(-15));
    }];
}


- (UIView *)initializeFeedbackTitle:(NSString *)title {
    
    UIView *view = [[UIView alloc] init];
    
    UIImageView *dotView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"feedback_msg_processed"]];
    [view addSubview:dotView];
    [dotView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.width.height.equalTo(@8);
    }];
    
    UILabel *titleLabel = [[UILabel alloc] initWithTextColor:kMBlackColor font:BGWFont(14)];
    titleLabel.text = [title stringByAppendingString:@":"];
    [view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(dotView.mas_right).offset(10);
        make.top.equalTo(@4);
    }];
    [dotView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(titleLabel);
    }];
    
    UILabel *contentLabel = [[UILabel alloc] initWithTextColor:kMBlackColor font:BGWFont(14)];
    contentLabel.numberOfLines = 0;
    contentLabel.tag = 1129;
    contentLabel.text = @"45666666";
    [view addSubview:contentLabel];
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLabel.mas_right).offset(10);
        make.right.equalTo(@(-10));
        make.centerY.equalTo(@0);
        make.top.equalTo(@4);
    }];
    [contentLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh-1 forAxis:UILayoutConstraintAxisHorizontal];
    
    return view;
    
}

@end
