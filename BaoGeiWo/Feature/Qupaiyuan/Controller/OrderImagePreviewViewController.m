//
//  OrderImagePreviewViewController.m
//  BaoGeiWo
//
//  Created by wb on 2018/8/23.
//  Copyright © 2018年 qyqs. All rights reserved.
//

#import "OrderImagePreviewViewController.h"
#import "AliyunOSSService.h"
#import "OrderRequest.h"

#import "WQPhotoBrowser.h"


@interface OrderImagePreviewViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, copy) NSString *orderId;
@property (nonatomic, copy) NSString *baggageId;

@property (nonatomic, assign) NSInteger maxCount;

@property (nonatomic, strong) NSMutableArray *imageUrls;
@property (nonatomic, strong) NSMutableArray *imageBtns;
@property (nonatomic, strong) NSMutableArray *previewPhotos;

@property (nonatomic, strong) UIView *containerView;


@end

@implementation OrderImagePreviewViewController

- (instancetype)initWithImageUrls:(NSArray *)imageUrls {
    return [self initWithImageUrls:imageUrls baggageId:nil orderId:nil];
}

- (instancetype)initWithImageUrls:(NSArray *)imageUrls baggageId:(NSString *)baggageId orderId:(NSString *)orderId {
    self = [super init];
    if (self) {
        self.take = NO;
        self.send = NO;
        self.preview = NO;
        
        self.baggageId = baggageId;
        self.orderId = orderId;
        
        self.maxCount = 0;
        self.imageUrls = [NSMutableArray arrayWithCapacity:0];
        self.imageBtns = [NSMutableArray arrayWithCapacity:0];
        if (imageUrls) {
            [self.imageUrls addObjectsFromArray:imageUrls];
        }
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (self.isTake) {
        self.navigationBar.titleLabel.text = @"取件照片";
    } else if (self.isSend) {
        self.navigationBar.titleLabel.text = @"派件照片";
    } else {
        self.navigationBar.titleLabel.text = @"照片";
    }
    
    for (NSString *imageUrl in self.imageUrls) {
        UIButton *btn = [self createImageBtn:imageUrl];
        [self.imageBtns addObject:btn];
    }
    
    [self setupUI];
    [self layoutImagesContainerView];
}

- (void)takePhoto {
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

- (void)imagePreview:(UIButton *)sender {
    
    NSInteger index = [self.imageBtns indexOfObject:sender];
    
    WQPhotoBrowser *browser = [[WQPhotoBrowser alloc] initWithPhotos:self.imageUrls atIndex:index];
    if (!self.preview) {
        browser.deleteButtonShow = YES;
        browser.deleteImageBlock = ^(NSString *image) {
            NSUInteger index = [self.imageUrls indexOfObject:image];
            [self.imageUrls removeObjectAtIndex:index];
            [self.imageBtns removeObjectAtIndex:index];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self layoutImagesContainerView];
            });
        };
    }

    [self presentViewController:browser animated:YES completion:nil];
//    [self.navigationController pushViewController:browser animated:YES];
}


#pragma mark- uploadImage
- (void)uploadImage:(UIImage *)image {
    
//    OrderBaggageModel *baggage = self.orderDetail.orderBaggages[self.currentRow-1];
    //    OrderTaskBaggageModel *baggage = self.taskModel.orderBaggageArray[self.currentRow-1];
//    [self.imageUrls addObject:@""];
//    [self.imageBtns addObject:[self createImageBtn:image]];
//    [self layoutImagesContainerView];
//    return;
    
    [SVProgressHUD show];
    [[AliyunOSSService shareInstance] uploadObjectWithImage:image success:^(id responseObject) {
        //
        [SVProgressHUD dismiss];

        NSLog(@"%@", responseObject);
        [self.imageUrls addObject:responseObject];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.imageBtns addObject:[self createImageBtn:image]];
            [self layoutImagesContainerView];
        });
        
    } failure:^(id error) {
        POPUPINFO(@"保存失败, 请重试");
        [SVProgressHUD dismiss];
    }];
}

- (void)associateOrderWithImages {

    
    if (self.imageUrls.count) {
        
        if (self.orderId && self.baggageId) {
            [SVProgressHUD show];
            
            NSString *imageType;
            if (self.isTake) {
                imageType = @"COOLECT";
            } else if (self.isSend) {
                imageType = @"RELEASE";
            }
            
            [OrderRequest baggageImageUploadWithImageUrls:self.imageUrls imageType:imageType baggageId:self.baggageId orderId:self.orderId success:^(id responseObject) {
                
                [SVProgressHUD dismiss];
                POPUPINFO(@"上传成功");
                if (self.uploadSuccess) {
                    self.uploadSuccess(self.imageUrls);
                }
                [self.navigationController popViewControllerAnimated:YES];
                
            } failure:^(id error) {
                [SVProgressHUD dismiss];
            }];
        } else {
            // 柜台下单, 没有订单号, 不需关联订单
            if (self.uploadSuccess) {
                self.uploadSuccess(self.imageUrls);
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
       
    } else {
        POPUPINFO(@"请先给行李拍照");
    }
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


- (void)setupUI {
    
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, KNavBarHeight+40, DEVICE_WIDTH, 0)];
//    containerView.backgroundColor = kMSeparateColor;
    [self.view addSubview:containerView];
    self.containerView = containerView;
    
    if (self.isPreview) {
        if (self.imageUrls.count == 0) {
            NSString *message;
            if (self.isTake) {
                message = @"无取件照片";
            } else if (self.isSend) {
                message = @"无派件照片";
            }
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *confirmA = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self performSelector:@selector(back)];
                });
            }];
            [alert addAction:confirmA];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self presentViewController:alert animated:YES completion:nil];
            });
        }
    } else {
        UILabel *promptLabel = [[UILabel alloc] initWithTextColor:kMPromptColor font:BGWFont(12)];
        promptLabel.text = [NSString stringWithFormat:@"(最多上传%zd张图片)", self.maxCount];
        [self.view addSubview:promptLabel];
        [promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(containerView.mas_bottom).with.offset(20);
            make.left.equalTo(@34);
        }];
        
        UIButton *uploadBtn = [[UIButton alloc] init];
        [uploadBtn setTitle:@"确定上传" forState:UIControlStateNormal];
        uploadBtn.backgroundColor = kMThemeColor;
        [uploadBtn setCornerRadius:3.f boderWidth:.1f borderColor:kMThemeColor];
        [uploadBtn addTarget:self action:@selector(associateOrderWithImages) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:uploadBtn];
        [uploadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(promptLabel.mas_bottom).with.offset(30);
            make.centerX.equalTo(@0);
            make.width.equalTo(@120);
            make.height.equalTo(@44);
        }];
    }

}


NSInteger column = 3;
CGFloat padding = 34.f, spacing = 18.f;
//CGFloat imageW = (DEVICE_WIDTH-padding*2-spacing*(column-1))/column;
//CGFloat imageH = imageW;

- (UIButton *)createImageBtn:(id)image {
    CGFloat imageW = (DEVICE_WIDTH-padding*2-spacing*(column-1))/column;
    CGFloat imageH = imageW;
    UIButton *imageBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, imageW, imageH)];
    
    if ([image isKindOfClass:[UIImage class]]) {
        [imageBtn setImage:image forState:UIControlStateNormal];
    } else if ([image isKindOfClass:[NSString class]]) {
        [imageBtn sd_setImageWithURL:[NSURL URLWithString:image] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"task_detail_baggage_placeholder"]];
    } else {
        assert(@"image type error!");
//        imageBtn.backgroundColor = kRedColor;
    }
    [imageBtn addTarget:self action:@selector(imagePreview:) forControlEvents:UIControlEventTouchUpInside];
    
    return imageBtn;
}

- (void)layoutImagesContainerView {
    [self.containerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    CGFloat originX = padding, originY = 0.0;
    CGFloat imageW = (DEVICE_WIDTH-padding*2-spacing*(column-1))/column;
    CGFloat imageH = imageW;
    
    for (NSInteger i = 0; i < self.imageBtns.count; i++) {
        UIButton *image = self.imageBtns[i];
        image.bgw_x = originX;
        image.bgw_y = originY;
        [self.containerView addSubview:image];

        
        originX += (imageW+spacing);
        originY = (i+1)/column*(imageH+spacing);
        
        if ((originX+imageW) > DEVICE_WIDTH) {
            originX = padding;
        }
    }
    
    if (self.imageBtns.count < self.maxCount && !self.isPreview) {
        UIButton *imageBtn = [[UIButton alloc] initWithFrame:CGRectMake(originX, originY, imageW, imageH)];
        [imageBtn setImage:[UIImage imageNamed:@"task_detail_baggage_take_photo"] forState:UIControlStateNormal];
        [imageBtn addTarget:self action:@selector(takePhoto) forControlEvents:UIControlEventTouchUpInside];
        [self.containerView addSubview:imageBtn];
        
        self.containerView.bgw_h = originY+imageH;
//        self.containerView.bgw_h = imageH+(self.imageBtns.count)/column*(imageH+spacing);
    } else {
        self.containerView.bgw_h = MAX(imageH, originY-spacing);
//        self.containerView.bgw_h = imageH+(self.imageBtns.count-1)/column*(imageH+spacing);
    }

    
}

- (void)setTake:(BOOL)take {
    _take = take;
    self.maxCount = 6;
}

- (void)setSend:(BOOL)send {
    _send = send;
    self.maxCount = 3;
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
