//
//  AirportReceiveScanViewController.m
//  BaoGeiWo
//
//  Created by wb on 2018/5/9.
//  Copyright © 2018年 qyqs. All rights reserved.
//

#import "AirportReceiveScanViewController.h"

#import "DeliveryManModel.h"
#import "BGWTransitCenter.h"
#import "QPYOrderListModel.h"

#import "OrderRequest.h"

#import "DeliverySuccessViewController.h"

@interface AirportReceiveScanViewController ()

@property (nonatomic, strong) DeliveryManModel *deliveryMan;
@property (nonatomic, strong) BGWTransitCenter *center;
@property (nonatomic, strong) NSArray *orderArray;

@property (nonatomic, copy) NSString *destName;
@property (nonatomic, copy) NSString *destId;

@property (nonatomic, strong) UILabel *baggageNumberLabel;
@property (nonatomic, strong) UIButton *deliverButton;

@end

@implementation AirportReceiveScanViewController


- (instancetype)initWithAirportId:(BGWTransitCenter *)center orderArray:(NSArray *)orderArray {
    
    self = [super initWithScanType:2];
    if (self) {
        self.center = center;
        self.orderArray = orderArray;
        self.destId = center.transitCenterId;
        self.destName = center.transitCenterName;
    }
    return self;
}


- (instancetype)initWithDeliveryMan:(DeliveryManModel *)deliveryMan orderArray:(NSArray *)orderArray {
    self = [super initWithScanType:2];
    if (self) {
        self.deliveryMan = deliveryMan;
        self.orderArray = orderArray;
        self.destId = deliveryMan.dmId;
        self.destName = deliveryMan.dmName;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    UIView *containerView = [[UIView alloc] init];
    containerView.backgroundColor = RGBA(255, 255, 255, 0.8);
    [self.view addSubview:containerView];
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scanView.mas_bottom).with.offset(60);
        make.left.equalTo(@15);
        make.right.mas_offset(-15);
    }];
    
    UIImageView *addressImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"scan_baggage"]];
    [containerView addSubview:addressImage];
    [addressImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@15);
        make.left.equalTo(@20);
    }];
    UILabel *addressLabel = [[UILabel alloc] initWithTextColor:kMGrayColor font:BGWFont(16)];
    addressLabel.text = [NSString stringWithFormat:@"来自：%@", self.destName];
    [containerView addSubview:addressLabel];
    [addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(addressImage.mas_right).with.offset(10);
        make.centerY.equalTo(addressImage);
    }];
    
    UIView *separateLine = [[UIView alloc] init];
    separateLine.backgroundColor = kMPromptColor;
    [containerView addSubview:separateLine];
    [separateLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(addressImage.mas_bottom).with.offset(15);
        make.left.mas_offset(10);
        make.right.mas_offset(-10);
        make.height.equalTo(@.5);
    }];
    
    UIImageView *baggageImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"scan_baggage"]];
    [containerView addSubview:baggageImage];
    [baggageImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(separateLine.mas_bottom).with.offset(15);
        make.left.equalTo(@20);
        make.bottom.mas_offset(-15);
    }];
    UILabel *numberLabel = [[UILabel alloc] initWithTextColor:kMGrayColor font:BGWFont(16)];
    numberLabel.text = @"数量：";
    [containerView addSubview:numberLabel];
    [numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(baggageImage.mas_right).with.offset(10);
        make.centerY.equalTo(baggageImage);
    }];
    self.baggageNumberLabel = numberLabel;
    
    
    UIButton *deliverButton = [[UIButton alloc] init];
    [deliverButton setTitle:@"确认交接" forState:UIControlStateNormal];
    deliverButton.backgroundColor = kMThemeColor;
    deliverButton.titleLabel.font = BGWFont(14);
    [deliverButton addTarget:self action:@selector(comfirmDeliver) forControlEvents:UIControlEventTouchUpInside];
    deliverButton.hidden = YES;
    [self.view addSubview:deliverButton];
    [deliverButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.top.equalTo(containerView.mas_bottom).with.offset(50);
        make.width.equalTo(@150);
        make.height.equalTo(@40);
    }];
    self.deliverButton = deliverButton;
    
}



- (void)scanResult:(NSString *)result {
    
    if (self.center) {
        [SVProgressHUD show];

        [OrderRequest getBaggageCountWithBagaggeId:result roleActionType:BGWRoleActionTypeAirportTask actionStatus:BGWRoleActionStatusOnGoing destType:BGWDestinationTypeServiceCenter destId:self.center.transitCenterId success:^(id responseObject) {
            [SVProgressHUD dismiss];
            POPUPINFO(@"扫描成功");
            
            self.baggageNumberLabel.text = [NSString stringWithFormat:@"数量：%@件", responseObject];
            self.deliverButton.hidden = NO;
        } failure:^(id error) {
            //
            [SVProgressHUD dismiss];
            [self startScan];
        }];
    } else if (self.deliveryMan) {
        [SVProgressHUD show];
        
        [OrderRequest getBaggageCountWithBagaggeId:result roleActionType:BGWRoleActionTypeAirportSend actionStatus:BGWRoleActionStatusOnGoing destType:BGWDestinationTypeServiceCenter destId:[BGWUser currentUser].userRole.userRoleId success:^(id responseObject) {
            [SVProgressHUD dismiss];
            POPUPINFO(@"扫描成功");
            
            self.baggageNumberLabel.text = [NSString stringWithFormat:@"数量：%@件", responseObject];
            self.deliverButton.hidden = NO;
        } failure:^(id error) {
            //
            [SVProgressHUD dismiss];
            [self startScan];
        }];
        
    }
    
    
}

- (void)comfirmDeliver {
    
    NSMutableArray *idArr = [NSMutableArray arrayWithCapacity:0];
    for (QPYOrderListModel *order in self.orderArray) {
        [idArr addObject:order.orderId];
    };
    
    if (self.center) {
        [SVProgressHUD show];
        
        [OrderRequest serviceCenterLoadDoneWithIdArray:idArr destId:self.center.transitCenterId success:^(id responseObject) {
            [SVProgressHUD dismiss];
            POPUPINFO(@"取派员端 取派员装车交接成功");
            DeliverySuccessViewController *vc = [[DeliverySuccessViewController alloc] initWithType:2];
            [self.navigationController pushViewController:vc animated:YES];
            
        } failure:^(id error) {
            [SVProgressHUD dismiss];
        }];
    } else if (self.deliveryMan) {
        [SVProgressHUD show];

        [OrderRequest serviceCenterUnloadDoneWithIdArray:idArr deliveryId:self.destId success:^(id responseObject) {
            [SVProgressHUD dismiss];

            POPUPINFO(@"机场端 取派员卸车交接成功");
            DeliverySuccessViewController *vc = [[DeliverySuccessViewController alloc] initWithType:2];
            [self.navigationController pushViewController:vc animated:YES];
        } failure:^(id error) {
            [SVProgressHUD dismiss];
        }];
       
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
