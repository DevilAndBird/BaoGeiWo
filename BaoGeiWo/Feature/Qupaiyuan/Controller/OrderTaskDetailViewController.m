//
//  OrderTaskDetailViewController.m
//  BaoGeiWo
//
//  Created by wb on 2018/5/14.
//  Copyright © 2018年 qyqs. All rights reserved.
//

#import "OrderTaskDetailViewController.h"
#import "ScanViewController.h"
#import "QPYOrderListContainerViewController.h"
#import "GTFreeSuccessViewController.h"
#import "QPYUserSignViewController.h"
#import "OrderImagePreviewViewController.h"
#import "FeedbackViewController.h"

#import "BaggagePreviewView.h"

#import "OrderTaskDetailCell.h"
#import "OrderTaskFirstDetailCell.h"
#import "OrderTaskAnotherDetailCell.h"
#import "OrderTaskDetailBaggageCell.h"

#import "QPYOrderTaskListModel.h"
#import "OrderDetailModel.h"
#import "OrderBaggageModel.h"

#import "OrderRequest.h"
#import "AliyunOSSService.h"

@interface OrderTaskDetailViewController ()<UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, assign) BGWOrderTaskType taskType;  //底部按钮是否显示
@property (nonatomic, assign) BGWRoleActionType roleType; //判断底部按钮显示状态

//@property (nonatomic, strong) QPYOrderTaskListModel *taskModel;

@property (nonatomic, strong) OrderDetailModel *orderDetail;

@property (nonatomic, copy) NSString *orderId;  //订单id
@property (nonatomic, copy) NSString *orderNo;  //订单编号
@property (nonatomic, copy) NSString *baggageId;//行李qr码

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) NSInteger currentRow;

@property (nonatomic, assign) BOOL baggageIsEdit; //行李是否可编辑
@property (nonatomic, assign) BOOL takeTask; //取件任务
@property (nonatomic, assign) BOOL sendTask; //派件任务

@end

@implementation OrderTaskDetailViewController

//TODO:替换taskModel为orderDetail
- (instancetype)initWithOrderId:(NSString *)orderId taskType:(BGWOrderTaskType)taskType roleType:(BGWRoleActionType )roleType {
    self = [super init];
    if (self) {
        self.orderId = orderId;
        self.taskType = taskType;
        self.roleType = roleType;
    }
    
    return self;
}
- (instancetype)initWithOrderNo:(NSString *)orderNo taskType:(BGWOrderTaskType)taskType roleType:(BGWRoleActionType)roleType {
    self = [super init];
    if (self) {
        self.taskType = taskType;
        self.orderNo = orderNo;
        self.roleType = roleType;
    }
    return self;
}

- (instancetype)initWithBaggageId:(NSString *)baggageId taskType:(BGWOrderTaskType)taskType roleType:(BGWRoleActionType)roleType {
    self = [super init];
    if (self) {
        self.taskType = taskType;
        self.baggageId = baggageId;
        self.roleType = roleType;
    }
    return self;
}





#pragma mark- vc life-cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBar.titleLabel.text = @"任务详情";
    [self.navigationBar.rightButton setTitle:@"反馈" forState:UIControlStateNormal];
    [self.navigationBar.rightButton addTarget:self action:@selector(feedbackPressed) forControlEvents:UIControlEventTouchUpInside];
    self.navigationBar.rightButtonWidth = 60;

    [SVProgressHUD show];

    if (self.orderId) {
        //根据订单id获取详情
        [OrderRequest getOrderTaskDetailWithOrderId:self.orderId detailsType:@[@"ORDERCUS", @"ORDERADDRESS", @"ORDERBAGGAGE", @"ORDERTRANSIT", @"ORDERNOTES", @"ORDER_PRICE_DETAIL"] success:^(id responseObject) {
            [self getDetailSuccess:responseObject];
        } failure:^(id error) {
             [SVProgressHUD dismiss];
        }];

    } else if (self.orderNo) {
        //订单编号获取详情
        [OrderRequest getOrderTaskDetailWithOrderNo:self.orderNo detailsType:@[@"ORDERCUS", @"ORDERADDRESS", @"ORDERBAGGAGE", @"ORDERNOTES", @"ORDER_PRICE_DETAIL"] success:^(id responseObject) {
            [self getDetailSuccess:responseObject];
        } failure:^(id error) {
            [SVProgressHUD dismiss];
        }];
        
    } else if (self.baggageId) {
        //行李qr码获取详情
        [OrderRequest getOrderTaskDetailWithBaggageId:self.baggageId detailsType:@[@"ORDERCUS", @"ORDERADDRESS", @"ORDERBAGGAGE", @"ORDERNOTES", @"ORDER_PRICE_DETAIL"] success:^(id responseObject) {
            [self getDetailSuccess:responseObject];
        } failure:^(id error) {
            [SVProgressHUD dismiss];
        }];
    } else {
        POPUPINFO(@"获取详情失败");
        [self.navigationController popViewControllerAnimated:YES];
    }

}

- (void)getDetailSuccess:(id)responseObject {
    [SVProgressHUD dismiss];
    self.orderDetail = responseObject;
    [self addEmptybaggage];
    [self setupTaskDetailUI];
}


- (void)addEmptybaggage {
    if (self.orderDetail.orderBaggages.count != self.orderDetail.baggageNumber.integerValue) {
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
        [array addObjectsFromArray:self.orderDetail.orderBaggages];
        for (NSInteger i = array.count; i < self.orderDetail.baggageNumber.integerValue; i++) {
            OrderBaggageModel *baggage = [OrderBaggageModel new];
            [array addObject:baggage];
        }
        self.orderDetail.orderBaggages = array;
    }
}

- (void)setupTaskDetailUI {
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigationBar.mas_bottom);
        make.left.right.equalTo(@0);
    }];
    
    if (self.taskType == BGWOrderTaskTypeFinished || self.taskType == BGWOrderTaskTypePrepareReceive || self.taskType == BGWOrderTaskTypePrepareSend) {
        self.baggageIsEdit = NO;

        [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            if (@available(iOS 11.0, *)) {
                make.bottom.equalTo(@0).with.insets(self.view.safeAreaInsets);
            } else {
                make.bottom.equalTo(@0);
            }
        }];
    } else { //BGWOrderTaskTypeOnGoing
        
        UIButton *operateButton = [[UIButton alloc] init];
        operateButton.backgroundColor = kMThemeColor;
        operateButton.titleLabel.font = BGWFont(16);
        [operateButton setCornerRadius:4.f boderWidth:.5f borderColor:kMThemeColor];
        [self.view addSubview:operateButton];
        [operateButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@100);
            make.centerX.equalTo(@0);
            make.height.equalTo(@40);
            if (@available(iOS 11.0, *)) {
                make.bottom.equalTo(@0).with.insets(self.view.safeAreaInsets).with.offset(-40);
            } else {
                make.bottom.mas_offset(-20);
            }
        }];
        
        [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(operateButton.mas_top).with.offset(-20);
        }];
        
        self.baggageIsEdit = NO;
        switch ([BGWUser getCurremtUserType]) {
            case AppUserTypeDeliveryMan:
                if (self.taskType == BGWOrderTaskTypePrepareReceive || self.taskType == BGWOrderTaskTypePrepareSend) {
                    [operateButton setTitle:@"确认发车去外面点" forState:UIControlStateNormal];
//                    [operateButton addTarget:self action:@selector(comfirmStart) forControlEvents:UIControlEventTouchUpInside];
                } else {
                    switch (self.roleType) {
                        case BGWRoleActionTypeTransitTask:
                        case BGWRoleActionTypeAirportTask:
                        case BGWRoleActionTypeAirportSend:
                        case BGWRoleActionTypeTransitSend:
                            [operateButton setTitle:@"交接订单" forState:UIControlStateNormal];
                            [operateButton addTarget:self action:@selector(applyHandover) forControlEvents:UIControlEventTouchUpInside];
                            break;
                        case BGWRoleActionTypeHotelTask:
                            self.baggageIsEdit = YES;
                            self.takeTask = YES;
                            self.sendTask = NO;
                            [operateButton setTitle:@"确认取件" forState:UIControlStateNormal];
                            [operateButton addTarget:self action:@selector(comfirmTake) forControlEvents:UIControlEventTouchUpInside];
                            break;
                        case BGWRoleActionTypeHotelSend:
                        {
                            self.baggageIsEdit = YES;
                            self.takeTask = NO;
                            self.sendTask = YES;
                            [operateButton setTitle:@"确认派件送达" forState:UIControlStateNormal];
                            [operateButton addTarget:self action:@selector(comfirmSend) forControlEvents:UIControlEventTouchUpInside];
                            
                            BGWOrderMailingWay mailingWay = [self.orderDetail.destMailingWay orderMailingWay];
                            if (mailingWay == BGWOrderMailingWayOneSelf || mailingWay == BGWOrderMailingWayOtherSend) {
                                //显示签名按钮
                                [operateButton mas_remakeConstraints:^(MASConstraintMaker *make) {
//                                    make.left.equalTo(@24);
                                    make.right.mas_equalTo(-24);
                                    make.bottom.mas_offset(-20);
                                    make.height.equalTo(@40);
                                }];
                                
                                UIButton *signButton = [[UIButton alloc] init];
                                signButton.backgroundColor = kMThemeColor;
                                signButton.titleLabel.font = BGWFont(16);
                                [signButton setTitle:@"签名" forState:UIControlStateNormal];
                                [signButton addTarget:self action:@selector(signClick) forControlEvents:UIControlEventTouchUpInside];
                                [signButton setCornerRadius:4.f boderWidth:.5f borderColor:kMThemeColor];
                                [self.view addSubview:signButton];
                                [signButton mas_makeConstraints:^(MASConstraintMaker *make) {
                                    make.left.equalTo(@24);
                                    make.right.equalTo(operateButton.mas_left).with.offset(-48);
                                    make.width.height.bottom.equalTo(operateButton);
                                }];
                            }
                        }
                            
                            break;
                        default:
                            //没这玩意儿
                            break;
                    }
                }
                break;
                
            case AppUserTypeServiceCenter:
                if (self.roleType == BGWRoleActionTypeHotelTask) {
                    self.baggageIsEdit = YES;
                    self.takeTask = YES;
                    self.sendTask = NO;
                    [operateButton setTitle:@"生成订单" forState:UIControlStateNormal];
                    [operateButton addTarget:self action:@selector(createOrder) forControlEvents:UIControlEventTouchUpInside];
                } else if (self.roleType == BGWRoleActionTypeAirportSend) {
                    self.baggageIsEdit = YES;
                    self.takeTask = NO;
                    self.sendTask = YES;
                    [operateButton setTitle:@"释放行李" forState:UIControlStateNormal];
                    [operateButton addTarget:self action:@selector(baggageFree) forControlEvents:UIControlEventTouchUpInside];
                }
                break;
                
            case AppUserTypeTransitCenter:
                break;
                
                
            case AppUserTypeAirportPicker:
            case AppUserTypeRegularDriver:
            default:
                break;
        }

    }
}




#pragma mark- Request

#pragma mark- qupaiyuan
//- (void)comfirmStart {
//
//    [SVProgressHUD show];
//    [OrderRequest confirmDriverStartedWithTaskListModel:self.taskModel success:^(id responseObject) {
//        [SVProgressHUD dismiss];
//
//        POPUPINFO(@"确认发车成功，请到进行中列表查看");
//        [self confirmSuccess];
//
//    } failure:^(id error) {
//        [SVProgressHUD dismiss];
//    }];
//}

- (void)applyHandover {
    //跳到机场交接列表
//    BGWRoleActionType roleType = [self.taskModel.roleType roleActionType];
    if (!self.isArrived) {
        POPUPINFO(@"此件未到达");
        return;
    }
    
    BGWRoleActionType roleType = self.roleType;
    if (roleType == BGWRoleActionTypeTransitTask || roleType == BGWRoleActionTypeTransitSend) {
        //跳转集散中心交接
        QPYOrderListContainerViewController *vc = [[QPYOrderListContainerViewController alloc] initWithCityNodeType:BGWCityNodeTypeTransitCenter];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (roleType == BGWRoleActionTypeAirportTask || roleType == BGWRoleActionTypeAirportSend) {
        //跳转机场交接
        QPYOrderListContainerViewController *vc = [[QPYOrderListContainerViewController alloc] initWithCityNodeType:BGWCityNodeTypeCounterCenter];
        [self.navigationController pushViewController:vc animated:YES];
    }

}

- (BOOL)judgeBagaggeIsScan {
    for (OrderBaggageModel *baggage in self.orderDetail.orderBaggages) {
        if (!baggage.baggageQRCode || !(baggage.image || baggage.baggageImage.takeImageUrls.count)) {
            POPUPINFO(@"请完善行李信息");
            return NO;
        }
    }
    return YES;
}
- (BOOL)judgeBaggageIsSend {
    for (OrderBaggageModel *baggage in self.orderDetail.orderBaggages) {
        if (!baggage.baggageQRCode || !(baggage.image || baggage.baggageImage.sendImageUrls.count)) {
            POPUPINFO(@"请先给行李拍照");
            return NO;
        }
    }
    return YES;
}

- (void)comfirmTake {

    if (![self judgeBagaggeIsScan]) {
        return;
    }

    [OrderRequest confirmTakeOrderWithOrderId:self.orderDetail.orderId success:^(id responseObject) {
        [SVProgressHUD dismiss];

        POPUPINFO(@"取件成功，请到待派列表查看");
        [self confirmSuccess];

    } failure:^(id error) {
        [SVProgressHUD dismiss];
    }];
    
}

- (void)comfirmSend {
    
    if (![self judgeBaggageIsSend]) {
        return;
    }
    
    [self alertWithTitle:nil message:@"是否确认派件" cancel:nil confirm:^{
        [SVProgressHUD dismiss];
        [OrderRequest confirmSendOrderWithOrderId:self.orderDetail.orderId success:^(id responseObject) {
            [SVProgressHUD dismiss];
            
            POPUPINFO(@"派件成功");
            [self confirmSuccess];
        } failure:^(id error) {
            [SVProgressHUD dismiss];
        }];
    }];
}

- (void)signClick {
    QPYUserSignViewController *vc = [[QPYUserSignViewController alloc] initWithUserName:self.orderDetail.destName orderId:self.orderDetail.orderId];
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark- jicahng
- (void)createOrder {
    
    if (![self judgeBagaggeIsScan]) {
        return;
    }
    
    [SVProgressHUD show];
    [OrderRequest generateOrderWithStatue:BGWOrderStatusTakeGoodsOver orderId:self.orderDetail.orderId success:^(id responseObject) {
        [SVProgressHUD dismiss];

        POPUPINFO(@"生成订单成功");
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popToRootViewControllerAnimated:YES];
        });
    } failure:^(id error) {
        [SVProgressHUD dismiss];
    }];

}

- (void)baggageFree {
    if (![self judgeBaggageIsSend]) {
        return;
    }
    
    [SVProgressHUD show];
    [OrderRequest updateOrderStatue:BGWOrderStatusReleaseOver orderId:self.orderDetail.orderId success:^(id responseObject) {
        [SVProgressHUD dismiss];
        GTFreeSuccessViewController *vc = [[GTFreeSuccessViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } failure:^(id error) {
        [SVProgressHUD dismiss];
    }];
}

#pragma mark- jisanzhongxin


#pragma mark- uploadImage
- (void)uploadImage:(UIImage *)image {
    
    OrderBaggageModel *baggage = self.orderDetail.orderBaggages[self.currentRow-1];
//    OrderTaskBaggageModel *baggage = self.taskModel.orderBaggageArray[self.currentRow-1];

    [SVProgressHUD show];
    [[AliyunOSSService shareInstance] uploadObjectWithImage:image success:^(id responseObject) {
        //
        NSLog(@"%@", responseObject);
        if (responseObject) {
            [OrderRequest baggageImageUploadWithImageUrl:responseObject baggageId:baggage.baggageQRCode orderId:self.orderDetail.orderId success:^(id responseObject) {
                //
                baggage.image = image;
                
                [SVProgressHUD dismiss];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.currentRow inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
                });
                
            } failure:^(id error) {
                [SVProgressHUD dismiss];
            }];
        }

    } failure:^(id error) {
        [SVProgressHUD dismiss];
    }];
}



#pragma mark- Event Response
- (void)feedbackPressed {
    FeedbackViewController *vc = [[FeedbackViewController alloc] initWithOrderId:self.orderDetail.orderId];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)confirmSuccess {
    if (self.confirmBlock) {
        self.confirmBlock();
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)priceDetail {
    
    OrderPriceDetailViewController *priceDetailVC = [[OrderPriceDetailViewController alloc] initWithPriceModel:self.orderDetail.priceDetail];
    priceDetailVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [self presentViewController:priceDetailVC animated:NO completion:nil];
}

- (void)takePreview {
    OrderBaggageModel *baggage = self.orderDetail.orderBaggages[self.currentRow-1];
    if (!baggage.baggageQRCode) {
        POPUPINFO(@"请先扫描行李qr码");
        return;
    }
    OrderImagePreviewViewController *vc = [[OrderImagePreviewViewController alloc] initWithImageUrls:baggage.baggageImage.takeImageUrls baggageId:baggage.baggageQRCode orderId:self.orderDetail.orderId];
    vc.take = YES;
    vc.preview = YES;
    if (self.baggageIsEdit && self.takeTask) {
        vc.preview = NO;
    }
    vc.uploadSuccess = ^(NSArray *imageUrls) {
        baggage.baggageImage.takeImageUrls = imageUrls;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.currentRow inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
        });
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)sendPreview {
    OrderBaggageModel *baggage = self.orderDetail.orderBaggages[self.currentRow-1];
    OrderImagePreviewViewController *vc = [[OrderImagePreviewViewController alloc] initWithImageUrls:baggage.baggageImage.sendImageUrls baggageId:baggage.baggageQRCode orderId:self.orderDetail.orderId];
    vc.send = YES;
    vc.preview = YES;
    if (self.baggageIsEdit && self.sendTask) {
        vc.preview = NO;
    }
    vc.uploadSuccess = ^(NSArray *imageUrls) {
        baggage.baggageImage.sendImageUrls = imageUrls;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.currentRow inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
        });
    };
    [self.navigationController pushViewController:vc animated:YES];
}

//预览图片(因为要上传多张照片,暂时废弃)
- (void)previewImage:(UIImageView *)imgView {
    UIWindow *window = [AppDelegate sharedAppDelegate].window;
    CGRect curRect = [imgView.superview convertRect:imgView.frame toView:window];
    NSLog(@"%@", NSStringFromCGRect(curRect));
    
    BaggagePreviewView *previewView = [[BaggagePreviewView alloc] initWithCover:imgView.image curRect:curRect];
    [self.view addSubview:previewView];
    [previewView show];
}
//拍照(同上)
- (void)takePhoto {
    //
    OrderBaggageModel *baggage = self.orderDetail.orderBaggages[self.currentRow-1];
    if (!baggage.baggageQRCode) {
        POPUPINFO(@"请先扫描行李qr码");
        return;
    }
    
    [BGWUtil cameraAuth:^{
        // 判断选择的模式是否为相机模式，如果没有则弹窗警告
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.allowsEditing = YES;    // 允许编辑
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            imagePicker.delegate = self;
            [self presentViewController:imagePicker animated:YES completion:nil];
            
        } else {
            // 未检测到摄像头弹出窗口
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"警告"
                                                                           message:@"未检测到摄像头"
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
            [alert addAction:confirm];
            [self presentViewController:alert animated:YES completion:nil];
            
        }
    } fail:^{
        POPUPINFO(@"请打开相机权限");
    }];
   
}

//扫描qr码
- (void)scan {
    ScanViewController *vc = [[ScanViewController alloc] initWithScanType:2];
    __weak typeof(vc) weakVC = vc;
    vc.scanSuccessBlock = ^(id result) {
        NSLog(@"%@", result);
        [self associateOrder:result success:^{
            [weakVC.navigationController popViewControllerAnimated:YES];
        } failure:^{
            [weakVC startScan];
        }];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

//qr码关联订单
- (void)associateOrder:(NSString *)result success:(void(^)(void))success failure:(void(^)(void))failure {
    //关联订单
    [SVProgressHUD show];
    [OrderRequest queryQRCodeIsUseful:result success:^(id responseObject) {
        
        OrderBaggageModel *baggage = self.orderDetail.orderBaggages[self.currentRow-1];
        NSNumber *baggageId = nil;
        if (baggage.baggageId != nil && ![baggage.baggageId isEqualToString:@""]) {
            baggageId = @(baggage.baggageId.integerValue);
        }
        [OrderRequest saveOrderBaggageWithQRCode:result orderId:self.orderDetail.orderId baggageId:baggageId success:^(id responseObject) {
            [SVProgressHUD dismiss];
            POPUPINFO(@"关联成功");
            OrderBaggageModel *baggage = self.orderDetail.orderBaggages[self.currentRow-1];
            baggage.baggageQRCode = result;
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.currentRow inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
            
            if (success) {
                success();
            }
        } failure:^(id error) {
            [SVProgressHUD dismiss];
            if (failure) {
                failure();
            }
        }];
        
    } failure:^(id error) {
        [SVProgressHUD dismiss];
        if (failure) {
            failure();
        }
    }];
    
}

#pragma mark UIImagePickerControllerDelegate

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-implementations"
//该代理方法仅适用于只选取图片时
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo {
    NSLog(@"didFinishPickingImage");
    [self dismissViewControllerAnimated:YES completion:^{
        [self uploadImage:image];
    }];
}
#pragma clang diagnostic pop


//允许编辑
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    NSLog(@"didFinishPickingMediaWithInfo");
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    [self dismissViewControllerAnimated:YES completion:^{
        [self uploadImage:image];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark- TableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger num;
    if (self.taskType == BGWOrderTaskTypePrepareReceive) {
        //待取不显示行李信息
        num = 1;
    } else {
        num = self.orderDetail.baggageNumber.integerValue+1;
    }
    return num;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        OrderTaskDetailCell *cell;
        BGWOrderMailingWay mailingWay = [self.orderDetail.destMailingWay orderMailingWay];
//        cell = [tableView dequeueReusableCellWithIdentifier:@"OrderTaskFirstDetailCell" forIndexPath:indexPath];
        if (mailingWay == BGWOrderMailingWayOtherSend) { //收件方式为他人,需要额外显示收件人的名字电话
            cell = [tableView dequeueReusableCellWithIdentifier:@"OrderTaskFirstDetailCell" forIndexPath:indexPath];
        } else {
            cell = [tableView dequeueReusableCellWithIdentifier:@"OrderTaskAnotherDetailCell" forIndexPath:indexPath];
        }
        [cell setOrderDetailModel:self.orderDetail];

        return cell;

    } else {
        OrderTaskDetailBaggageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderTaskDetailBaggageCell" forIndexPath:indexPath];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        OrderTaskDetailCell *tempCell = (OrderTaskDetailCell *)cell;
        tempCell.callBlock = ^(NSInteger tag) {
            if (tag == 111) {
                [UIWebView webViewCallWithPhoneNumber:self.orderDetail.srcPhone];
            } else if (tag == 222) {
                [UIWebView webViewCallWithPhoneNumber:self.orderDetail.destPhone];
            };
        };
        tempCell.priceTapBlock = ^{
            [self priceDetail];
        };
    } else {
        __weak typeof(self) weakSelf = self;
        OrderTaskDetailBaggageCell *tempCell = (OrderTaskDetailBaggageCell *)cell;
        [tempCell setBaggageInfo:self.orderDetail.orderBaggages[indexPath.row-1] roleType:self.roleType];
//        tempCell.previewImageBlock = ^(UIImageView *imgView) {
//            [weakSelf previewImage:imgView];
//        };
//        tempCell.takePhotoBlock = ^{
//            weakSelf.currentRow = indexPath.row;
//            [weakSelf takePhoto];
//        };
        tempCell.takePreviewBlock = ^{
            weakSelf.currentRow = indexPath.row;
            [weakSelf takePreview];
        };
        tempCell.sendPreviewBlock = ^{
            weakSelf.currentRow = indexPath.row;
            [weakSelf sendPreview];
        };
        tempCell.scanBlock = ^{
            weakSelf.currentRow = indexPath.row;
            [weakSelf scan];
        };
    }
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
        [tableView registerClass:[OrderTaskFirstDetailCell class] forCellReuseIdentifier:@"OrderTaskFirstDetailCell"];
        [tableView registerClass:[OrderTaskAnotherDetailCell class] forCellReuseIdentifier:@"OrderTaskAnotherDetailCell"];
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



//- (instancetype)initWithOrderTaskType:(BGWOrderTaskType)taskType taskModel:(QPYOrderTaskListModel *)taskModel {
//    self = [super init];
//    if (self) {
//        self.taskType = taskModel.taskType;
//        self.roleType = [taskModel.roleType roleActionType];
//        self.orderId = taskModel.orderId;
//
//        self.taskModel = taskModel;
//    }
//    return self;
//}
//
//- (instancetype)initWithOrderNo:(NSString *)orderNo roleType:(BGWRoleActionType)roleType {
//    self = [super init];
//    if (self) {
//        self.taskType = BGWOrderTaskTypeOther;
//        self.orderNo = orderNo;
//        self.roleType = roleType;
//    }
//    return self;
//}
//
//- (instancetype)initWithTaskType:(BGWOrderTaskType)taskType orderNo:(NSString *)orderNo roleType:(BGWRoleActionType)roleType {
//    self = [super init];
//    if (self) {
//        self.taskType = taskType;
//        self.orderNo = orderNo;
//        self.roleType = roleType;
//    }
//    return self;
//
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
