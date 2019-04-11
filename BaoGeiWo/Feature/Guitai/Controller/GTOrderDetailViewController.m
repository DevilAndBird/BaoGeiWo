//
//  GTOrderDetailViewController.m
//  BaoGeiWo
//
//  Created by wb on 2018/5/17.
//  Copyright © 2018年 qyqs. All rights reserved.
//

#import "GTOrderDetailViewController.h"

#import "OrderRequest.h"

@interface GTOrderDetailViewController ()<UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, copy) NSString *orderNo;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger currentRow;

@end

@implementation GTOrderDetailViewController

- (instancetype)initWithOrderNo:(NSString *)orderNo {
    self = [super init];
    if (self) {
        self.orderNo = orderNo;
    }
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBar.titleLabel.text = @"任务详情";

    //接口获取详情信息
    [OrderRequest getOrderTaskDetailWithOrderNo:self.orderNo detailsType:@[@"ORDERADDRESS"] success:^(id responseObject) {
        //
    } failure:^(id error) {
        //
    }];
    
}

- (void)setupTaskDetailUI {
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigationBar.mas_bottom);
        make.left.right.bottom.equalTo(@0);
    }];
    
    UIButton *operateButton = [[UIButton alloc] init];
    operateButton.backgroundColor = kMThemeColor;
    [self.view addSubview:operateButton];
    [operateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@100);
        make.centerX.equalTo(@0);
        make.bottom.mas_offset(-20);
        make.height.equalTo(@30);
    }];
    
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(operateButton.mas_top).with.offset(-20);
    }];
    
    [operateButton setTitle:@"确认发车" forState:UIControlStateNormal];
    [operateButton addTarget:self action:@selector(comfirmStart) forControlEvents:UIControlEventTouchUpInside];
    
    
        
}




#pragma mark- Properties
- (UITableView *)tableView {
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        tableView.backgroundColor = kMBgColor;
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.estimatedRowHeight = 150;
        tableView.rowHeight = UITableViewAutomaticDimension;
        [tableView registerClass:[OrderTaskDetailCell class] forCellReuseIdentifier:@"OrderTaskDetailCell"];
        [tableView registerClass:[OrderTaskDetailBaggageCell class] forCellReuseIdentifier:@"OrderTaskDetailBaggageCell"];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _tableView = tableView;
    }
    return _tableView;
}








- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
