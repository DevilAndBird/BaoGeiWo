//
//  ScanViewController.m
//  BaoGeiWo
//
//  Created by wb on 2018/5/9.
//  Copyright © 2018年 qyqs. All rights reserved.
//

#import "ScanViewController.h"

@interface ScanViewController ()<AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic, assign) NSInteger type; //1:订单号  2:qr码

@property (nonatomic, strong) AVCaptureSession *captureSession;

@property (nonatomic, strong) UIImageView *scanBorderImage;

@end

@implementation ScanViewController

- (instancetype)initWithScanType:(NSInteger)type {
    self = [super init];
    if (self) {
        self.type = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBar.titleLabel.text = @"二维码扫描";
    self.view.backgroundColor = kGrayColor;
    
//    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
//        return;
//    }
    
    [self setupUI];
    
}

//- (void)viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:animated];
//    [self closeFlash];
//}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self closeFlash];
}

- (void)setupUI {
    UIView *scanView = [[UIView alloc] init];
    
    UILabel *scanTitleLabel = [[UILabel alloc] initWithTextColor:kWhiteColor font:BGWFont(14)];
    if (self.type == 1) {
        scanTitleLabel.text = @"将订单二维码放入框内，即可自动扫描";
    } else if (self.type == 2) {
        scanTitleLabel.text = @"将行李QR码放入框内，即可自动扫描";
    } else {
        scanTitleLabel.text = @"将二维码放入框内，即可自动扫描";
    }
    [scanView addSubview:scanTitleLabel];
    [scanTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@50);
//        make.top.equalTo(self.navigationBar.mas_bottom).with.offset(50);
        make.centerX.equalTo(@0);
    }];
    

    UIImageView *scanBorderImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"scan_border"]];
    [scanView addSubview:scanBorderImage];
    [scanBorderImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(scanTitleLabel.mas_bottom).with.offset(10);
//        make.top.mas_offset(70);
        make.centerX.equalTo(@0);
        make.bottom.mas_equalTo(0);
    }];
    self.scanBorderImage = scanBorderImage;
    
    [self.view addSubview:scanView];
    [scanView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigationBar.mas_bottom);
        make.left.right.equalTo(@0);
    }];
    self.scanView = scanView;
    
    UIView *shadowView1 = [[UIView alloc] init];
    shadowView1.backgroundColor = RGBA(0, 0, 0, .4);
    [self.view addSubview:shadowView1];
    [shadowView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigationBar.mas_bottom);
        make.left.right.equalTo(@0);
        make.bottom.equalTo(scanBorderImage.mas_top);
    }];
    UIView *shadowView2 = [[UIView alloc] init];
    shadowView2.backgroundColor = RGBA(0, 0, 0, .4);
    [self.view addSubview:shadowView2];
    [shadowView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(scanBorderImage);
        make.left.equalTo(@0);
        make.right.equalTo(scanBorderImage.mas_left);
        make.bottom.equalTo(scanBorderImage);
    }];
    UIView *shadowView3 = [[UIView alloc] init];
    shadowView3.backgroundColor = RGBA(0, 0, 0, .4);
    [self.view addSubview:shadowView3];
    [shadowView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(scanBorderImage);
        make.left.equalTo(scanBorderImage.mas_right);
        make.right.equalTo(@0);
        make.bottom.equalTo(scanBorderImage);
    }];
    UIView *shadowView4 = [[UIView alloc] init];
    shadowView4.backgroundColor = RGBA(0, 0, 0, .4);
    [self.view addSubview:shadowView4];
    [shadowView4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(scanBorderImage.mas_bottom);
        make.left.right.equalTo(@0);
        make.bottom.equalTo(@0);
    }];
    
    UIImageView *editImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"scan_edit"]];
    editImageView.userInteractionEnabled = YES;
    [self.view addSubview:editImageView];
    UITapGestureRecognizer *editTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(manualInput)];
    [editImageView addGestureRecognizer:editTap];
    [editImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(scanView.mas_bottom).with.offset(20);
        make.centerX.equalTo(@0).with.offset(-100);
    }];
    
    
    UIImageView *lightImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"scan_light"]];
    lightImageView.userInteractionEnabled = YES;
    [self.view addSubview:lightImageView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeFlash)];
    [lightImageView addGestureRecognizer:tap];
    [lightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(editImageView);
        make.centerX.equalTo(@0).with.offset(100);
    }];
    
//    [self.view bringSubviewToFront:scanTitleLabel];
    [BGWUtil cameraAuth:^{
        [self setupCamera];
    } fail:^{
        POPUPINFO(@"应用相机权限受限,请在设置中启用");
    }];
}

- (void)setupCamera {
    
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //创建输入流
    AVCaptureDeviceInput * input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    //创建输出流
    AVCaptureMetadataOutput * output = [[AVCaptureMetadataOutput alloc]init];
    //设置代理 在主线程里刷新
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    //CGRectMake(y1/y, x1/x, h1/h, w1/w)
    [output setRectOfInterest:CGRectMake(124/DEVICE_HEIGHT, ((DEVICE_WIDTH-200)/2)/DEVICE_WIDTH, 200/DEVICE_HEIGHT, 200/DEVICE_WIDTH)];
    //初始化链接对象
    AVCaptureSession *session = [[AVCaptureSession alloc]init];
    //高质量采集率
    [session setSessionPreset:AVCaptureSessionPresetHigh];
    self.captureSession = session;
    
    if (input) {
        [session addInput:input];
    }
    
    if (output) {
        [session addOutput:output];
        //设置扫码支持的编码格式(如下设置条形码和二维码兼容)
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        if ([output.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeQRCode]) {
            [arr addObject:AVMetadataObjectTypeQRCode];
        }
        if ([output.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeITF14Code]) {
            [arr addObject:AVMetadataObjectTypeITF14Code];
        }
        if ([output.availableMetadataObjectTypes containsObject:AVMetadataObjectTypePDF417Code]) {
            [arr addObject:AVMetadataObjectTypePDF417Code];
        }
        output.metadataObjectTypes = arr;
    }
    
    
    AVCaptureVideoPreviewLayer *layer = [AVCaptureVideoPreviewLayer layerWithSession:session];
    layer.videoGravity=AVLayerVideoGravityResizeAspectFill;
    layer.frame = self.view.bounds;
    [self.view.layer addSublayer:layer];
    
//    [self setupUI];
    
    //开始捕获
    [session startRunning];
    
    
    [self.view.layer insertSublayer:layer atIndex:0];
    
    
    //    [session addObserver:self forKeyPath:@"running" options:NSKeyValueObservingOptionNew context:nil];
    [self.view bringSubviewToFront:self.navigationBar];
    
}

- (void)startScan {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.captureSession startRunning];
    });
}


-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    
    if (metadataObjects.count>0) {
        [self.captureSession stopRunning];
        AVMetadataMachineReadableCodeObject *metadataObject = [metadataObjects objectAtIndex:0];
        
        //输出扫描字符串
        NSString *data = metadataObject.stringValue;
        NSLog(@"%@", data);
        //0x125d6fd70
        if (self.scanSuccessBlock) {
            self.scanSuccessBlock(data);
            self.scanSuccessBlock = nil;
        } else {
            [self scanResult:data];
        }
    }
}

- (void)scanSuccess:(void (^)(id))block {
    self.scanSuccessBlock = block;
}



- (void)scanResult:(NSString *)result {
    //
}

- (void)manualInput {
    NSString *title;
    if (self.type == 1) {
        title = @"请输入订单号";
    } else if (self.type == 2) {
        title = @"请输入QR码";
    } else {
        title = @"请输入";
    }
    
    NSString *message;
    if (self.type == 1) {
        message = @"(至少输入订单号后6位)";
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    __weak typeof(alert) weakAlert = alert;
    NSAttributedString *attrTitle = [[NSAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName:kMBlackColor, NSFontAttributeName:BGWFont(20)}];
    [alert setValue:attrTitle forKey:@"_attributedTitle"];
    if (message) {
        NSAttributedString *attrMessage = [[NSAttributedString alloc] initWithString:message attributes:@{NSForegroundColorAttributeName:kMGrayColor, NSFontAttributeName:BGWFont(14)}];
        [alert setValue:attrMessage forKey:@"_attributedMessage"];
    }

    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        //
    }];
    UIAlertAction *affirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //
        NSString *text = [weakAlert.textFields firstObject].text;
        if (self.type == 2) {
            text = [@"JPQR" stringByAppendingString:text?:@""];
        }
        if (self.scanSuccessBlock) {
            self.scanSuccessBlock(text);
        } else {
            [self scanResult:text];
        }
    }];
    affirm.enabled = NO;
    [cancel setValue:kMPromptColor forKey:@"_titleTextColor"];
    [affirm setValue:kMThemeColor forKey:@"_titleTextColor"];

    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        //
        textField.textAlignment = NSTextAlignmentCenter;
        textField.keyboardType = UIKeyboardTypeNumberPad;
        textField.font = BGWFont(16);
//        [textField setBackground:[]];
        
        [[NSNotificationCenter defaultCenter] addObserverForName:UITextFieldTextDidChangeNotification object:textField queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
            affirm.enabled = !([textField.text isEqualToString:@""]);
        }];
        
    }];
    
    [alert addAction:cancel];
    [alert addAction:affirm];

    [self presentViewController:alert animated:YES completion:nil];
    
}


- (void)changeFlash {
    
    //  获取摄像机单例对象
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //必须判定是否有闪光灯，否则如果没有闪光灯会崩溃
    if (![device hasFlash] || ![device hasTorch]) return;
    
    //修改前必须先锁定
    [device lockForConfiguration:nil];
    
    if (device.flashMode == AVCaptureFlashModeOff) {
        device.flashMode = AVCaptureFlashModeOn;
        device.torchMode = AVCaptureTorchModeOn;
    } else if (device.flashMode == AVCaptureFlashModeOn) {
        device.flashMode = AVCaptureFlashModeOff;
        device.torchMode = AVCaptureTorchModeOff;
    }
    
    [device unlockForConfiguration];
}

/** 关灯 用于退出时调用 */
- (void)closeFlash {
    
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    if (![device hasFlash] || ![device hasTorch]) return;

    [device lockForConfiguration:nil];
    if (device.flashMode == AVCaptureFlashModeOn) {
        device.flashMode = AVCaptureFlashModeOff;
        device.torchMode = AVCaptureTorchModeOff;
    }
    [device unlockForConfiguration];

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
