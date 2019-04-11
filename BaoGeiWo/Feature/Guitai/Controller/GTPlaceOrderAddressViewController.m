//
//  GTPlaceOrderAddressViewController.m
//  BaoGeiWo
//
//  Created by wb on 2018/10/23.
//  Copyright © 2018 qyqs. All rights reserved.
//

#import "GTPlaceOrderAddressViewController.h"
#import <BaiduMapAPI_Search/BMKSuggestionSearch.h>
#import <BaiduMapAPI_Search/BMKPoiSearch.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>

#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>

@interface GTPlaceOrderAddressViewController ()<BMKSuggestionSearchDelegate, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, AMapSearchDelegate>

@property (nonatomic, strong) BMKSuggestionSearch *searcher;
@property (nonatomic, strong) BMKSuggestionSearchOption *option;
@property (nonatomic, strong) BMKSuggestionResult *result;

@property (nonatomic, strong) AMapSearchAPI *search;
@property (nonatomic, strong) AMapPOIKeywordsSearchRequest *request;
@property (nonatomic, strong) NSArray<AMapPOI *> *pois;
@property (nonatomic, strong) AMapPOI *selectedPoi;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *keyword;

@end

@implementation GTPlaceOrderAddressViewController

- (instancetype)initWithCityName:(NSString *)city {
    self = [super init];
    if (self) {
        self.city = city;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kWhiteColor;
    self.navigationBar.titleLabel.text = @"请选择地址";
    
    UIView *searchView = [[UIView alloc] init];
    searchView.layer.borderWidth = .5f;
    searchView.layer.borderColor = kMPromptColor.CGColor;
    searchView.layer.cornerRadius = 20;
    [self.view addSubview:searchView];
    [searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigationBar.mas_bottom).with.offset(20);
        make.left.equalTo(@10);
        make.right.equalTo(@0).with.offset(-10);
        make.height.equalTo(@40);
    }];
    
    UITextField *searchTF = [[UITextField alloc] init];
    searchTF.borderStyle = UITextBorderStyleNone;
    searchTF.clearButtonMode = UITextFieldViewModeAlways;
    searchTF.placeholder = @"搜地点";
    searchTF.delegate = self;
    [searchView addSubview:searchTF];
    [searchTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@5);
        make.left.equalTo(@20);
        make.right.equalTo(@0).with.offset(-20);
        make.centerY.equalTo(@0);
    }];
    
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(searchView.mas_bottom);
        make.left.right.equalTo(@0);
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.bottom.equalTo(@0);
        }
    }];
    
    
//    self.searcher = [[BMKSuggestionSearch alloc] init];
//    self.searcher.delegate = self;
//    self.option = [[BMKSuggestionSearchOption alloc] init];
//    self.option.cityname = @"上海";
    
    //xx脑子瓦特了, 一会百度一会高德
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;
    self.request = [[AMapPOIKeywordsSearchRequest alloc] init];
    self.request.city = self.city;
//    self.request.requireExtension = YES;
//    self.request.requireSubPOIs = YES;
    self.request.cityLimit = YES;
    
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
//    self.searcher.delegate = nil;
    self.search.delegate = nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.pois.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        cell.detailTextLabel.textColor = kMPromptColor;
        cell.detailTextLabel.font = BGWFont(14);
    }
    AMapPOI *poi = self.pois[indexPath.row];
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:poi.name attributes:@{NSFontAttributeName:BGWFont(16), NSForegroundColorAttributeName:kMBlackColor}];
    [attr setAttributes:@{NSForegroundColorAttributeName:RGB(253, 3, 3)} range:[poi.name rangeOfString:[self.keyword stringByReplacingOccurrencesOfString:@" " withString:@""]]];
    cell.textLabel.attributedText = attr;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@-%@-%@", poi.city, poi.district, poi.address];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    AMapPOI *poi = self.pois[indexPath.row];
    self.selectedPoi = poi;
    
    AMapReGeocodeSearchRequest *reGeoRequest = [[AMapReGeocodeSearchRequest alloc] init];
    reGeoRequest.location = poi.location;
    [self.search AMapReGoecodeSearch:reGeoRequest];
    
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (range.length == 0) {
        self.keyword = [textField.text stringByAppendingString:string];
    } else {
        self.keyword = [textField.text stringByReplacingCharactersInRange:range withString:string];
    }

    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    self.keyword = @"";
    return YES;
}


- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response {
    if (response.pois.count == 0)
    {
        return;
    }
    
//    for (AMapPOI *poi in response.pois) {
//        NSLog(@"name-%@, address-%@", poi.name, poi.address);
//    }
    
    self.pois = response.pois;
    [self.tableView reloadData];
    
}

- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response {
    
    AMapAddressComponent *component = response.regeocode.addressComponent;
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(request.location.latitude, request.location.longitude);
    NSDictionary *testdic = BMKConvertBaiduCoorFrom(coordinate,BMK_COORDTYPE_COMMON);
    CLLocationCoordinate2D baiduCoor = BMKCoorDictionaryDecode(testdic);//转换后的百度坐标
    NSDictionary *baiduCoorDic = @{@"lng" : @(baiduCoor.longitude).stringValue,
                                   @"lat" : @(baiduCoor.latitude).stringValue,
                                   };
    //        NSString *coorString = [NSString stringWithFormat:@"{'lng':'%f','lat':'%f'}", baiduCoor.longitude, baiduCoor.latitude];
    NSString *coorString = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:baiduCoorDic options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding];
    
    NSString *address = self.selectedPoi.address;
    NSString *landmark = self.selectedPoi.name;
    NSString *district = component.district;
    NSString *township = component.township;
    
    if ([self.delegate respondsToSelector:@selector(selectAddress:landmark:coordinate:district:township:)]) {
        [self.delegate selectAddress:address landmark:landmark coordinate:coorString district:district township:township];
    } else if (self.addressInfo) {
        self.addressInfo(address, landmark, coorString, district, township);
    }
        
    
    [self.navigationController popViewControllerAnimated:YES];

}

- (void)onGetSuggestionResult:(BMKSuggestionSearch *)searcher result:(BMKSuggestionResult *)result errorCode:(BMKSearchErrorCode)error {
    
    if (error == BMK_SEARCH_NO_ERROR) {
        
        self.result = result;
    } else {
        NSLog(@"sorry, no result");
        self.result = nil;
    }
    
    [self.tableView reloadData];
}

- (void)setKeyword:(NSString *)keyword {
    if ([keyword isEqualToString:_keyword]) {
        return;
    }
    _keyword = keyword;
    
//    self.option.keyword = keyword;
    
    self.request.keywords = keyword;
    [self.search AMapPOIKeywordsSearch:self.request];

//    BOOL flag = [self.searcher suggestionSearch:self.option];
//    if (!flag) {
//        NSLog(@"发送检索失败");
//        self.result = nil;
//        [self.tableView reloadData];
//    }
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
//        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        _tableView.estimatedRowHeight = 60;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
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
