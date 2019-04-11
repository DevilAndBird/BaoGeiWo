//
//  TaskMapListView.m
//  BaoGeiWo
//
//  Created by wb on 2018/7/13.
//  Copyright © 2018年 qyqs. All rights reserved.
//

#import "TaskMapListView.h"

#import "QPYOrderTaskListModel.h"

#import "TaskMapListTakeCell.h"
#import "TaskMapListSendCell.h"

@interface TaskMapListView ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *array;

@property (nonatomic, assign) CGFloat viewHeight;

@end

static const NSInteger kMaxTaskListHeight = 410;


@implementation TaskMapListView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = RGBA(255, 255, 255, .3);
        [self setupTaskMapListUI];
    }
    return self;
}


- (void)setTaskList:(NSArray *)list height:(CGFloat)height{
    self.viewHeight = height;
    self.array = list;
    [self.tableView reloadData];
    
    [self setListViewHeight:MIN(height, kMaxTaskListHeight)];


}

/*
 container:
 top:25
 单个地址信息:60
 
 cell:
 container + 8
 */
- (void)setListViewHeight:(CGFloat)height {
    
    [UIView animateWithDuration:.25 animations:^{
        self.bgw_h = height;
        self.bgw_y = DEVICE_HEIGHT-height;
        self.tableView.bgw_h = height;
    } completion:^(BOOL finished) {
        //        self.tableView.scrollEnabled = height > 410;
    }];

}


- (void)setupTaskMapListUI {
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_HEIGHT, 0) style:UITableViewStylePlain];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = kClearColor;
    [tableView registerClass:[TaskMapListTakeCell class] forCellReuseIdentifier:@"TaskMapListTakeCell"];
    [tableView registerClass:[TaskMapListSendCell class] forCellReuseIdentifier:@"TaskMapListSendCell"];
    [self addSubview:tableView];
    self.tableView = tableView;
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 10)];
    headView.backgroundColor = kClearColor;
    tableView.tableHeaderView = headView;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TaskMapListCell *cell;
    QPYOrderTaskListModel *taskModel = self.array[indexPath.row];
    
    if (taskModel.nextBindAction) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"TaskMapListTakeCell" forIndexPath:indexPath];
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"TaskMapListSendCell" forIndexPath:indexPath];
    }
    [cell setContent:taskModel];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    QPYOrderTaskListModel *taskModel = self.array[indexPath.row];
    if (taskModel.nextBindAction) {
        return 35+60+60+8;
    } else {
        return 35+60+8;
    }

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    QPYOrderTaskListModel *taskModel = self.array[indexPath.row];
    if (self.selectTaskDetaik) {
        self.selectTaskDetaik(taskModel);
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.viewHeight < kMaxTaskListHeight && scrollView.contentOffset.y > 0) {
        scrollView.contentOffset = CGPointMake(0, 0);
    }
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (scrollView.contentOffset.y < -30.f) {
        [self setListViewHeight:MIN(0, kMaxTaskListHeight)];
        if (self.deselectAnnotation) {
            self.deselectAnnotation();
        }
    }
}




@end
