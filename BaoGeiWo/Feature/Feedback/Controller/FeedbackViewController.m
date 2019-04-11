//
//  FeedbackViewController.m
//  BaoGeiWo
//
//  Created by wb on 2018/12/10.
//  Copyright © 2018 qyqs. All rights reserved.
//

#import "FeedbackViewController.h"
#import "FeedbackView.h"
#import "FeedbackCell.h"
#import "OrderRequest.h"
#import "FeedbackListModel.h"

@interface FeedbackViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) FeedbackView *feedbackView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *feedbackList;

@property (nonatomic, copy) NSString *orderId;
@property (nonatomic, copy) NSString *feedbackContent;

@end

@implementation FeedbackViewController

- (instancetype)initWithOrderId:(NSString *)orderId {
    self = [super init];
    if (self) {
        self.orderId = orderId;
        if (!orderId) {
            self.orderId = @"3541";
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBar.backgroundColor = kWhiteColor;
    self.navigationBar.titleLabel.text = @"反 馈";
    self.navigationBar.titleLabel.textColor = kMBlackColor;
    [self.navigationBar.backButton setImage:[UIImage imageNamed:@"feedback_nav_back"] forState:UIControlStateNormal];
    self.navigationBar.backButton.bounds = CGRectMake(0, 0, 10, 15);
    [self.navigationBar.backButton setupLeastRecommendRange:YES];
    
    UIView *separator = [[UIView alloc] init];
    separator.backgroundColor = kMSeparateColor;
    [self.view addSubview:separator];
    [separator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigationBar.mas_bottom);
        make.left.right.equalTo(@0);
        make.height.equalTo(@.5);
    }];
    
    __weak typeof(self) weakSelf = self;
    FeedbackView *feedbackView = [[FeedbackView alloc] initWithTextViewEndEditing:^(UITextView * _Nonnull textView) {
        NSLog(@"%@", textView.text);
        weakSelf.feedbackContent = textView.text;
    } submitPressed:^{
        [weakSelf feedbackSubmit];
    }];
    [self.view addSubview:feedbackView];
    [feedbackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(separator.mas_bottom);
        make.left.right.equalTo(@0);
    }];
    self.feedbackView = feedbackView;
    
    self.feedbackList = [NSMutableArray arrayWithCapacity:0];
    [OrderRequest GetFeedbackListWithOrderId:self.orderId success:^(id responseObject) {
        
        [self.feedbackList addObjectsFromArray:responseObject];
        [self reloadTableView];
        
    } failure:^(id error) {
        //
    }];
}

- (void)reloadTableView {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.feedbackView.mas_bottom).offset(10);
        make.left.equalTo(@10);
        make.right.equalTo(@(-10));
        make.bottom.equalTo(@0);
    }];
}

- (void)feedbackSubmit {
    if (self.feedbackContent && ![[self.feedbackContent stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@""]) {
        [OrderRequest orderFeedbackWithOrderId:self.orderId content:self.feedbackContent success:^(id responseObject) {
            POPUPINFO(responseObject);
            
            FeedbackListModel *model = [[FeedbackListModel alloc] init];
            model.time = [[NSString getCurrentTimestamp] yymmddhhmmString];
            model.name = [BGWUser getCurremtUserName];
            model.desc = self.feedbackContent;
            [self.feedbackList insertObject:model atIndex:0];
            [self.tableView reloadData];
            
        } failure:^(id error) {
            //
        }];
    } else {
        POPUPINFO(@"请填写反馈内容");
    }
    
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.feedbackList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FeedbackListModel *model = self.feedbackList[indexPath.row];
    if ([model.processStatus isEqualToString:@"SOLVED"]) {
        FeedbackProcessCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FeedbackProcessCell" forIndexPath:indexPath];
        [cell setContentWithProcessedModel:model];
        return cell;
    } else {
        FeedbackCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FeedbackCell" forIndexPath:indexPath];
        [cell setContentWithModel:model];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 40)];
    view.backgroundColor = kWhiteColor;
    
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"feedback_list_icon"]];
    [view addSubview:imgView];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.centerY.equalTo(@0);
        make.width.height.equalTo(@20);
    }];
    
    UILabel *label = [[UILabel alloc] initWithTextColor:kMGrayColor font:BGWFont(14)];
    label.text = @"最近反馈记录";
    [view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imgView.mas_right).offset(10);
        make.centerY.equalTo(@0);
    }];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    if (self.feedbackList.count) {
        return 0;
    }
    return 250;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    view.backgroundColor = kWhiteColor;

    if (!self.feedbackList.count) {
        view.frame = CGRectMake(0, 0, DEVICE_WIDTH, 250);
        
        UIView *separator = [[UIView alloc] init];
        separator.backgroundColor = kMSeparateColor;
        [view addSubview:separator];
        [separator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@0);
            make.left.right.equalTo(@0);
            make.height.equalTo(@.5);
        }];
        
        UIImageView *emptyImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"feedback_list_empty"]];
        [view addSubview: emptyImage];
        [emptyImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(@0);
            make.width.height.equalTo(@120);
        }];
    }
    
    return view;
}



- (UITableView *)tableView {
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [tableView registerClass:[FeedbackCell class] forCellReuseIdentifier:@"FeedbackCell"];
        [tableView registerClass:[FeedbackProcessCell class] forCellReuseIdentifier:@"FeedbackProcessCell"];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.backgroundColor = kMBgColor;
        tableView.estimatedRowHeight = 100;
        tableView.rowHeight = UITableViewAutomaticDimension;
        tableView.showsVerticalScrollIndicator = NO;
        
        _tableView = tableView;
    }
    return _tableView;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
