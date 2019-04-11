//
//  QPYTaskMapViewController.m
//  BaoGeiWo
//
//  Created by wb on 2018/5/24.
//  Copyright © 2018年 qyqs. All rights reserved.
//

#import "QPYTaskMapViewController.h"
#import "QPYOrderTaskListModel.h"
#import "OrderRequest.h"
#import "BGWPointAnnotation.h"
#import "TaskMapListView.h"

#import <BaiduMapAPI_Location/BMKLocationService.h>
#import "OrderTaskDetailViewController.h"

@interface QPYTaskMapViewController ()<BMKMapViewDelegate, BMKLocationServiceDelegate>

@property (nonatomic, strong) NSMutableArray *taskList;
@property (nonatomic, strong) NSMutableArray *annotations;

@property (nonatomic, strong) BMKMapView *mapView;
@property (nonatomic, strong) BGWPointAnnotation *selectAnnotation;
@property (nonatomic, strong) TaskMapListView *taskMapListView;

@property (nonatomic, strong) BMKLocationService *locService;

@end



@implementation QPYTaskMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBar.titleLabel.text = @"任务列表（Map）";
    
    self.taskList = [NSMutableArray arrayWithCapacity:0];
    self.locService = [[BMKLocationService alloc] init];
    
    BMKMapView *mapView = [[BMKMapView alloc] init];
    mapView.delegate = self;
    mapView.mapType = BMKMapTypeStandard;
//    mapView.centerCoordinate = CLLocationCoordinate2DMake(31.23, 121.48);
    mapView.zoomLevel = 12;
    [self.view addSubview:mapView];
    self.mapView = mapView;
    [mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigationBar.mas_bottom);
        make.left.bottom.right.equalTo(@0);
    }];


    
    UIButton *refresh = [[UIButton alloc] init];
    [refresh setImage:[UIImage imageNamed:@"task_map_refresh"] forState:UIControlStateNormal];
    [refresh addTarget:self action:@selector(getMapTaskList) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:refresh];
    [refresh mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigationBar.mas_bottom).with.offset(10);
        make.right.mas_equalTo(-10);
    }];
    
    
    
//        CLLocationCoordinate2D coor = CLLocationCoordinate2DMake(31.23, 121.48);
//
//        BGWPointAnnotation* annotation = [[BGWPointAnnotation alloc]init];
//        annotation.coordinate = coor;
//        annotation.title = @"这里是北京";
//        annotation.tag = @"take";
//        [self.mapView addAnnotation:annotation];
    self.annotations = [NSMutableArray arrayWithCapacity:0];
    [self getMapTaskList];
    
    [self.view addSubview:self.taskMapListView];
    __weak typeof(self) weakSelf = self;
    self.taskMapListView.deselectAnnotation = ^{
        [weakSelf.mapView deselectAnnotation:weakSelf.selectAnnotation animated:NO];
    };
    self.taskMapListView.selectTaskDetaik = ^(QPYOrderTaskListModel *task) {
        [weakSelf selectTaskOrderDetail:task];
    };
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.locService startUserLocationService];
    });
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getMapTaskList) name:kBGWNewOrderNotification object:nil];
    
    [self.mapView viewWillAppear];
    self.mapView.delegate = self;
    self.locService.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    [self.mapView viewWillDisappear];
    self.mapView.delegate = nil;
    self.locService.delegate = nil;
}


- (void)getMapTaskList {
    [self.taskMapListView setListViewHeight:0];
    
    [OrderRequest getMapTaskList:^(id responseObject) {
        [self.taskList removeAllObjects];
        [self.taskList addObjectsFromArray:responseObject];
        [self loadMapPointAnnotation];
    } failure:^(id error) {
    }];
}


- (void)loadMapPointAnnotation {
    [self.mapView removeAnnotations:self.annotations];
    [self.annotations removeAllObjects];
    
    if (self.taskList.count == 0) {
        POPUPINFO(@"当前没有进行中的订单");
        self.mapView.showsUserLocation = NO;
        self.mapView.userTrackingMode = BMKUserTrackingModeFollow;
        self.mapView.showsUserLocation = YES;
        return;
    } else {
        self.mapView.showsUserLocation = NO;
        self.mapView.userTrackingMode = BMKUserTrackingModeHeading;
        self.mapView.showsUserLocation = YES;
    }
    
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionaryWithCapacity:0];
    for (QPYOrderTaskListModel *taskModel in self.taskList) {
        if (tempDic[taskModel.addressCoordinate.latitudeStr]) {
            continue;
        }
        [tempDic setObject:@"1" forKey:taskModel.addressCoordinate.latitudeStr];
        
        CLLocationCoordinate2D coor = CLLocationCoordinate2DMake(taskModel.addressCoordinate.latitudeStr.doubleValue, taskModel.addressCoordinate.longitudeStr.doubleValue);
        BGWPointAnnotation* annotation = [[BGWPointAnnotation alloc]init];
        annotation.coordinate = coor;
        annotation.title = taskModel.destAddress;
        
        BGWRoleActionType roleAction = [taskModel.roleType roleActionType];
        switch ([taskModel.destAddressType destType]) {
            case BGWDestinationTypeServiceCenter:
                annotation.tag = @"airport";
                break;
            case BGWDestinationTypeTransitCenter:
                break;
            case BGWDestinationTypeHouse:
                if (roleAction == BGWRoleActionTypeHotelTask) {
                    annotation.tag = @"house_take";
                } else if (roleAction == BGWRoleActionTypeHotelSend) {
                    annotation.tag = @"house_send";
                }
                break;
            case BGWDestinationTypeHotel:
                if (roleAction == BGWRoleActionTypeHotelTask) {
                    annotation.tag = @"hotel_take";
                } else if (roleAction == BGWRoleActionTypeHotelSend) {
                    annotation.tag = @"hotel_send";
                }
                break;
            case BGWDestinationTypeOther:
            default:
                break;
        }

        [self.annotations addObject:annotation];
    }
    
    [self.mapView addAnnotations:self.annotations];
    [self.mapView showAnnotations:self.annotations animated:YES];
}



- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation {
    if ([annotation isKindOfClass:[BGWPointAnnotation class]]) {
        BGWPointAnnotation *notation = (BGWPointAnnotation *)annotation;
        static NSString *reuseIndetifier = @"annotationReuseIndetifier";
        BMKAnnotationView *annotationView = (BMKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
        if (annotationView == nil) {
            annotationView = [[BMKAnnotationView alloc] initWithAnnotation:annotation
                                                           reuseIdentifier:reuseIndetifier];
            annotationView.canShowCallout = NO;
        }
        annotationView.image = [self getAnnotationImage:notation.tag];
        
        return annotationView;
    }
    return nil;
}

- (void)selectTaskOrderDetail:(QPYOrderTaskListModel *)task {
    
    OrderTaskDetailViewController *vc = [[OrderTaskDetailViewController alloc] initWithOrderId:task.orderId taskType:BGWOrderTaskTypeFinished roleType:BGWRoleActionTypeOther];
    [self.navigationController pushViewController:vc animated:YES];
}





- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view {
    BGWPointAnnotation *annotation = (BGWPointAnnotation *)view.annotation;
    self.selectAnnotation = annotation;
//    POPUPINFO(annotation.tag);
    
    CGFloat takeHeight = 163;
    CGFloat sendHeight = 103;
    
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
    for (QPYOrderTaskListModel *taskModel in self.taskList) {
        if (taskModel.addressCoordinate.latitudeStr.doubleValue == annotation.coordinate.latitude) {
            [arr addObject:taskModel];
        }
    }
    
    CGFloat height = 0.0;
    for (QPYOrderTaskListModel *taskModel in arr) {
        switch ([taskModel.roleType roleActionType]) {
            case BGWRoleActionTypeHotelTask:
            case BGWRoleActionTypeAirportTask:
            case BGWRoleActionTypeTransitTask:
                height += takeHeight;
                break;
            case BGWRoleActionTypeHotelSend:
            case BGWRoleActionTypeAirportSend:
            case BGWRoleActionTypeTransitSend:
                height += sendHeight;
                break;
            default:
                break;
        }
    }

    [self.taskMapListView setTaskList:arr height:height+10];
}

- (void)mapView:(BMKMapView *)mapView didDeselectAnnotationView:(BMKAnnotationView *)view {
//    POPUPINFO(@"deselect");
//    [self.taskMapListView setTaskList:nil height:0];
}



- (TaskMapListView *)taskMapListView {
    if (!_taskMapListView) {
        _taskMapListView = [[TaskMapListView alloc] initWithFrame:CGRectMake(0, DEVICE_HEIGHT, DEVICE_WIDTH, 0)];
    }
    return _taskMapListView;
}

- (UIImage *)getAnnotationImage:(NSString *)tag {
    return [UIImage imageNamed:[NSString stringWithFormat:@"task_map_%@", tag]];
}


- (void)willStartLocatingUser
{
    NSLog(@"start locate");
}

- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    [_mapView updateLocationData:userLocation];
//    NSLog(@"heading is %@",userLocation.heading);
}

- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    //    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    [_mapView updateLocationData:userLocation];
}

- (void)didStopLocatingUser
{
    NSLog(@"stop locate");
}

- (void)didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"location error");
}


@end
