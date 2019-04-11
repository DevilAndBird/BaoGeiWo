//
//  InviteViewController.m
//  BaoGeiWo
//
//  Created by wb on 2018/5/22.
//  Copyright © 2018年 qyqs. All rights reserved.
//

#import "InviteViewController.h"
#import <WebKit/WebKit.h>

@interface InviteViewController ()<WKNavigationDelegate, WKScriptMessageHandler, WKUIDelegate, BMKMapViewDelegate>


@end

@implementation InviteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navBackButtonHidder = YES;
    self.navigationBar.titleLabel.text = @"邀请";
    
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    configuration.userContentController = [[WKUserContentController alloc] init];
    [configuration.userContentController addScriptMessageHandler:self name:@"shareApp"];
    WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:configuration];
    webView.navigationDelegate = self;
    webView.UIDelegate = self;
    [self.view addSubview:webView];
    [webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigationBar.mas_bottom);
        if (@available(iOS 11.0, *)) {
            make.left.bottom.right.equalTo(@0).with.insets(self.view.safeAreaInsets);
        } else {
            make.left.bottom.right.equalTo(@0);
        }
    }];
    
//    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"invite" ofType:@"html"];
//    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:filePath] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:20];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http:wangqing.space/bgw/invite.html"] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:20];
    [webView loadRequest:request];
    
    
    
//    BMKMapView *mapView = [[BMKMapView alloc] init];
//    mapView.mapType = BMKMapTypeStandard;
//    mapView.delegate = self;
//    mapView.centerCoordinate = CLLocationCoordinate2DMake(39.915, 116.404);
//    [self.view addSubview:mapView];
//    [mapView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.navigationBar.mas_bottom);
//        make.left.bottom.right.equalTo(@0);
//    }];
//
//    BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
//    annotation.coordinate = CLLocationCoordinate2DMake(39.915, 116.404);
//    annotation.title = @"这里是北京";
//    [mapView addAnnotation:annotation];
}

- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id<BMKOverlay>)overlay{
    if ([overlay isKindOfClass:[BMKGroundOverlay class]]){
        BMKGroundOverlayView* groundView = [[BMKGroundOverlayView alloc] initWithOverlay:overlay];
        return groundView;
    }
    return nil;
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    if ([message.name isEqualToString:@"shareApp"]) {
        [self shareApp];
    }
}


- (void)shareApp {
//    POPUPINFO(@"share");
}


// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    [SVProgressHUD show];
}
// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
}
// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [SVProgressHUD dismiss];
}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation {
    [SVProgressHUD dismiss];
    POPUPINFO(@"加载失败");
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    NSURL *URL = navigationAction.request.URL;
    NSString *scheme = [URL scheme];
    if ([scheme isEqualToString:@"tel"]) {
        NSString *resourceSpecifier = [URL resourceSpecifier];
        NSString *callPhone = [NSString stringWithFormat:@"telprompt://%@", resourceSpecifier];
        /// 防止iOS 10及其之后，拨打电话系统弹出框延迟出现
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone]];
        });
        
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
    
}

- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }])];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
}


- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:prompt message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = defaultText;
    }];
    [alertController addAction:([UIAlertAction actionWithTitle:@"完成" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(alertController.textFields[0].text?:@"");
    }])];
    
    
    [self presentViewController:alertController animated:YES completion:nil];
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
