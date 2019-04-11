//
//  GTPlaceOrderScanPersonInfoViewController.m
//  BaoGeiWo
//
//  Created by wb on 2018/10/24.
//  Copyright © 2018 qyqs. All rights reserved.
//

#import "GTPlaceOrderScanPersonInfoViewController.h"
#import <AipOcrSdk/AipOcrSdk.h>


@interface GTPersonInfoViewController : UIViewController
@property (nonatomic, readonly, copy) NSString *name;
@property (nonatomic, readonly, copy) NSString *number;
@property (nonatomic, copy) void(^personInfo)(NSString *name, NSString *number);
@end

@interface GTPersonInfoViewController ()
@property (nonatomic, strong) SpringView *modalView;
@property (nonatomic, readwrite, copy) NSString *name;
@property (nonatomic, readwrite, copy) NSString *number;
@end

@implementation GTPersonInfoViewController

- (instancetype)initWithName:(NSString *)name number:(NSString *)number {
    self = [super init];
    if (self) {
        self.name = name;
        self.number = number;
    }
    return self;
}

- (void)dismissTap:(UITapGestureRecognizer *)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)cancelClick {
    [self dismissTap:nil];
}

- (void)confirmClick {
    
    [self dismissViewControllerAnimated:NO completion:^{
        if (self.personInfo) {
            self.personInfo(self.name, self.number);
        }
    }];
}

- (void)viewDidLoad {
    
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = RGBA(0, 0, 0, 0.5);
    [self.view addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissTap:)];
    [bgView addGestureRecognizer:tap];
    
    SpringView *modalView = [[SpringView alloc] init];
    modalView.backgroundColor = kWhiteColor;
    modalView.layer.cornerRadius = 4.f;
    [self.view addSubview:modalView];
    [modalView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@40);
        make.center.equalTo(@0);
    }];
    self.modalView = modalView;
    
    UILabel *nameLabel = [[UILabel alloc] initWithTextColor:kMBlackColor font:BGWFont(16)];
    nameLabel.text = [@"姓        名: " stringByAppendingString:self.name];
    [modalView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@30);
        make.left.equalTo(@15);
        make.right.mas_equalTo(-15);
    }];
    
    UILabel *numberLabel = [[UILabel alloc] initWithTextColor:kMBlackColor font:BGWFont(16)];
    numberLabel.text = [@"身份证号: " stringByAppendingString:self.number];
    [modalView addSubview:numberLabel];
    [numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameLabel.mas_bottom).with.offset(30);
        make.left.right.equalTo(nameLabel);
    }];
    
    UIView *hSeparateLine = [[UIView alloc] init];
    hSeparateLine.backgroundColor = kMSeparateColor;
    [modalView addSubview:hSeparateLine];
    [hSeparateLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(numberLabel.mas_bottom).with.offset(30);
        make.left.right.equalTo(@0);
        make.height.equalTo(@(0.5));
    }];
    
    UIButton *cancelButton = [[UIButton alloc] init];
    NSAttributedString *cancelAttr = [[NSAttributedString alloc] initWithString:@"取消" attributes:@{NSFontAttributeName:BGWFont(16), NSForegroundColorAttributeName:kMBlackColor}];
    [cancelButton setAttributedTitle:cancelAttr forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
    [modalView addSubview:cancelButton];
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(hSeparateLine.mas_bottom);
        make.left.equalTo(@0);
        make.bottom.equalTo(@0);
        make.height.equalTo(@40);
    }];
    
    UIButton *confirmButton = [[UIButton alloc] init];
    NSAttributedString *confirmAttr = [[NSAttributedString alloc] initWithString:@"确认" attributes:@{NSFontAttributeName:BGWFont(16), NSForegroundColorAttributeName:kMBlackColor}];
    [confirmButton setAttributedTitle:confirmAttr forState:UIControlStateNormal];
    [confirmButton addTarget:self action:@selector(confirmClick) forControlEvents:UIControlEventTouchUpInside];
    [modalView addSubview:confirmButton];
    [confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.height.width.equalTo(cancelButton);
        make.left.equalTo(cancelButton.mas_right);
        make.right.equalTo(@0);
    }];
    
    UIView *vSepareteLine = [[UIView alloc] init];
    vSepareteLine.backgroundColor = kMSeparateColor;
    [modalView addSubview:vSepareteLine];
    [vSepareteLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(cancelButton);
        make.left.equalTo(cancelButton.mas_right);
        make.width.equalTo(@(0.5));
    }];
}

@end




@interface GTPlaceOrderScanPersonInfoViewController ()
@property (nonatomic, copy)  void(^idcardFrontImage)(UIImage *image);
@end

@implementation GTPlaceOrderScanPersonInfoViewController

- (void)back {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIButton *idcardButton = [[UIButton alloc] init];
    idcardButton.backgroundColor = kMThemeColor;
    [idcardButton setTitle:@"身份证识别" forState:UIControlStateNormal];
    [idcardButton addTarget:self action:@selector(idcardOcr:) forControlEvents:UIControlEventTouchUpInside];
    idcardButton.layer.cornerRadius = 4.f;
    [self.view addSubview:idcardButton];
    [idcardButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scanView.mas_bottom).with.offset(100);
        make.centerX.equalTo(@0);
        make.height.equalTo(@45);
        make.width.equalTo(@170);
    }];
    
    __weak typeof(self) weakSelf = self;
    self.idcardFrontImage = ^(UIImage *image) {
        [[AipOcrService shardService] detectIdCardFrontFromImage:image withOptions:nil successHandler:^(id result) {
            
            NSLog(@"%@", result);
            NSString *name = [[[result objectForKey:@"words_result"] objectForKey:@"姓名"] objectForKey:@"words"];
            NSString *number = [[[result objectForKey:@"words_result"] objectForKey:@"公民身份号码"] objectForKey:@"words"];
            [weakSelf showPersonInfoWithName:name number:number];

        } failHandler:^(NSError *err) {
            NSLog(@"%@", err);
        }];
    };
    
}

- (void)scanResult:(NSString *)result {
    //
    NSRange startRange = [result rangeOfString:@"NI"];
    NSRange endRange = [result rangeOfString:@"#90"];
    NSRange range = NSMakeRange(startRange.location + startRange.length, endRange.location - startRange.location - startRange.length);
    NSString *idcardNumber = [result substringWithRange:range];
    
    NSRange nameStartRange = [result rangeOfString:@"#90"];
    NSRange nameEndRange = [result rangeOfString:@"#91"];
    NSRange nameRange = NSMakeRange(nameStartRange.location + nameStartRange.length, nameEndRange.location - nameStartRange.location - nameStartRange.length);
    NSString *name = [result substringWithRange:nameRange];
    
    NSLog(@"%@, %@", idcardNumber, name);
    [self showPersonInfoWithName:name number:idcardNumber];
    
}

- (void)showPersonInfoWithName:(NSString *)name number:(NSString *)number {
    GTPersonInfoViewController *vc = [[GTPersonInfoViewController alloc] initWithName:name number:number];
    vc.modalPresentationStyle = UIModalPresentationOverFullScreen;
    vc.personInfo = ^(NSString *name, NSString *number) {
        if (self.getPersonInfo) {
            self.getPersonInfo(name, number);
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    };
    [self presentViewController:vc animated:NO completion:nil];
}


- (void)idcardOcr:(UIButton *)sender {
    UIViewController *vc = [AipCaptureCardVC ViewControllerWithCardType:CardTypeLocalIdCardFont andImageHandler:^(UIImage *image) {
        
        if (self.idcardFrontImage) {
            self.idcardFrontImage(image);
        }
        [self dismissViewControllerAnimated:YES completion:nil];
        
//         成功扫描出身份证
//        __weak typeof(self) weakSelf = self;
//        __strong typeof(weakSelf) strongSelf = weakSelf;
//        [[AipOcrService shardService] detectIdCardFrontFromImage:image withOptions:nil successHandler:^(id result) {
//
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"detectIdCardSuccess" object:nil];
//            [strongSelf dismissViewControllerAnimated:YES completion:nil];
//            NSLog(@"%@", result);
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                NSString *name = [[[result objectForKey:@"words_result"] objectForKey:@"姓名"] objectForKey:@"words"];
//                NSString *number = [[[result objectForKey:@"words_result"] objectForKey:@"公民身份号码"] objectForKey:@"words"];
//                GTPersonInfoViewController *vc = [[GTPersonInfoViewController alloc] initWithName:name number:number];
//                [weakSelf presentViewController:vc animated:NO completion:nil];
//            });
//            [self dismissViewControllerAnimated:YES completion:nil];
//
//        } failHandler:^(NSError *err) {
//            NSLog(@"%@", err);
//        }];

    }];

        // 展示ViewController
    [self presentViewController:vc animated:YES completion:nil];
   
}

@end


