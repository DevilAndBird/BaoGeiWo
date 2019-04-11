//
//  SystemMessageViewController.m
//  BaoGeiWo
//
//  Created by wb on 2018/5/25.
//  Copyright © 2018年 qyqs. All rights reserved.
//

#import "SystemMessageViewController.h"

@interface SystemMessageViewController ()

@end

@implementation SystemMessageViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBar.titleLabel.text = @"企业消息";
    self.msgType = BGWMessageTypeSystem;
    
    [self.tableView.mj_header beginRefreshing];

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.msgList.count == 0) {
        return DEVICE_HEIGHT-KNavBarHeight;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.msgList.count == 0) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT-KNavBarHeight)];
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"list_empty_placrholder"]];
        imageView.frame = CGRectMake(DEVICE_WIDTH/2-60, (DEVICE_HEIGHT)/2-KNavBarHeight-60-50, 120, 120);
        [view addSubview:imageView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, imageView.bgw_y+imageView.bgw_h+30, DEVICE_WIDTH, 15)];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"啊喔，什么也木有～";
        label.textColor = kMPromptColor;
        label.font = BGWFont(14);
        [view addSubview:label];
        
        return view;
        
    }else {
        return nil;
    }
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
