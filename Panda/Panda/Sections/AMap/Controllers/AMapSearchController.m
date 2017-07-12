//
//  AMapSearchController.m
//  Panda
//
//  Created by 街路口等你 on 17/6/1.
//  Copyright © 2017年 街路口等你. All rights reserved.
//

#import "AMapSearchController.h"
#import "XMCollectionViewCell.h"
#import "XMPOIViewController.h"

@interface AMapSearchController ()<AMapSearchDelegate, CLLocationManagerDelegate, CurrentLocDelegate, MAMapViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, assign) CLLocationCoordinate2D locationCoordinate2D;

// 逆地理编码
@property (nonatomic, strong) AMapReGeocode *reGeocode;
// 搜索类
@property (nonatomic, strong) AMapSearchAPI *searchAPI;
// 地图
@property (nonatomic, strong) MAMapView *mapView;
// 大头针
@property (nonatomic, strong) MAPointAnnotation *pointAnnotaiton;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSArray *itemArray;

@end

@implementation AMapSearchController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *itemArr = @[
                         @{@"name": @"加油站",
                           @"image": @"\U0000e64b",
                           @"color": [UIColor redColor],
                           @"bgcolor": kSET_COLOR_RBG(151, 225, 138, 1)},
                         @{@"name": @"停车场",
                           @"image": @"\U0000e608",
                           @"color": kSET_COLOR_RBG(255, 233, 35, 1),
                           @"bgcolor": kSET_COLOR_RBG(108, 209, 253, 1)},
                         @{@"name": @"汽车维修",
                           @"image": @"\U0000e6a5",
                           @"color": kSET_COLOR_RBG(108, 209, 253, 1),
                           @"bgcolor": kSET_COLOR_RBG(242, 176, 163, 1)},
                         @{@"name": @"汽车销售",
                           @"image": @"\U0000e613",
                           @"color": [UIColor yellowColor],
                           @"bgcolor": kSET_COLOR_RBG(151, 225, 138, 1)}
                         ];
    self.itemArray = itemArr;
    
    [self layoutNavigationBar];
    [self initMapView];
    [self xl_InitProperty];
    [self xl_locate];
    
    [self collectionView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    if ([self isViewLoaded] && !self.view.window) {
        self.view = nil;
    }
}

- (void)layoutNavigationBar {
    
    UIBarButtonItem *locItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"panda_location"] style:UIBarButtonItemStyleDone target:self action:@selector(locItemAction)];
    
    self.navigationItem.leftBarButtonItem = locItem;
}

- (void)xl_InitProperty {
    self.searchAPI = [[AMapSearchAPI alloc] init];
    _searchAPI.delegate = self;
    
    self.locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
}

- (void)initMapView {
    if (self.mapView == nil) {
        self.mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 64, kXM_Width, kXM_Height * 0.4)];
        
        _mapView.delegate = self;
        _mapView.showsCompass = YES;
        _mapView.showsScale = YES;
        
        // 设备至少移动20米, 才通知委托更新
        _mapView.distanceFilter = 20.0;
        
        [self.view addSubview:self.mapView];
    }
}

- (void)xl_locate {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
       
        if (TARGET_IPHONE_SIMULATOR) {
            
            // 纬度:39.958186 经度:116.306107
            CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(35.703375, 114.316567);
            AMapCoordinateType type = AMapCoordinateTypeGPS;
            _locationCoordinate2D = AMapCoordinateConvert(CLLocationCoordinate2DMake(coordinate.latitude,coordinate.longitude), type);
        }
        else {
            if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
                
                NSLog(@"requestWhenInUseAuthorization");
                
                [self.locationManager requestWhenInUseAuthorization];
            }
            [self.locationManager startUpdatingLocation];
        }
        
    });
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(kXM_Width / 2.0f, kXM_Width * 0.4);
        
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, kXM_Height * 0.4 + 64, kXM_Width, kXM_Width) collectionViewLayout:layout];
        
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = kSET_COLOR_RBG(245, 245, 245, 1);
        
        [_collectionView registerClass:[XMCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([XMCollectionViewCell class])];
        
        [self.view addSubview:_collectionView];
    }
    return _collectionView;
}

// MARK: -
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.itemArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XMCollectionViewCell *collectionCell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([XMCollectionViewCell class]) forIndexPath:indexPath];
    
    collectionCell.itemName.text = self.itemArray[indexPath.item][@"name"];
    collectionCell.itemIcon.text = self.itemArray[indexPath.item][@"image"];
    collectionCell.itemIcon.textColor = self.itemArray[indexPath.item][@"color"];
    collectionCell.itemIcon.backgroundColor = self.itemArray[indexPath.item][@"bgcolor"];

    return collectionCell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    XMPOIViewController *poiView = [[XMPOIViewController alloc] init];
    
    poiView.navTitle = self.itemArray[indexPath.item][@"name"];
    poiView.locationCoordinate2D = _locationCoordinate2D;
    
    [self.navigationController pushViewController:poiView animated:YES];
}

// MARK: - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    // 获取用户位置的对象
    CLLocation *location = [locations lastObject];
    CLLocationCoordinate2D coordinate = location.coordinate;
    
    NSLog(@"经度 : %f, 维度 : %f", coordinate.latitude, coordinate.longitude);
    
    AMapCoordinateType type = AMapCoordinateTypeGPS;
    _locationCoordinate2D = AMapCoordinateConvert(CLLocationCoordinate2DMake(coordinate.latitude, coordinate.longitude), type);
    
    // 标记大头针
    [self xl_pointAnnotation:_locationCoordinate2D locationName:@""];
    
    // 搜索附近位置
    [self xl_MapReGoecodeSearch];
    
    // 停止定位
    [manager stopUpdatingLocation];
}

- (void)xl_MapReGoecodeSearch {
    AMapReGeocodeSearchRequest *regeocdeSearchRequest = [[AMapReGeocodeSearchRequest alloc] init];
    
    regeocdeSearchRequest.location = [AMapGeoPoint locationWithLatitude:_locationCoordinate2D.latitude longitude:_locationCoordinate2D.longitude];
    regeocdeSearchRequest.requireExtension = YES;
    [self.searchAPI AMapReGoecodeSearch:regeocdeSearchRequest];
}

// MARK: - AMapSearchDelegate
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response {
    if (response.regeocode != nil) {
        
        self.reGeocode = response.regeocode;
        
        NSString *currentLocation = response.regeocode.pois.firstObject.name;
        
        // 当前位置
        self.navigationItem.title = currentLocation;
        
//        NSLog(@"地址 : %@", response.regeocode.formattedAddress);
        
//        NSLog(@"neighborhood : %@, building : %@", response.regeocode.addressComponent.neighborhood, response.regeocode.addressComponent.building);
        
        [self xl_weather];
        
    }
}

- (void)xl_pointAnnotation:(CLLocationCoordinate2D)coordinate locationName:(NSString *)locationName {
    
    // 获取到定位信息, 更新annotation
    if (self.pointAnnotaiton == nil) {
        
        self.pointAnnotaiton = [[MAPointAnnotation alloc] init];
    }
    
    self.pointAnnotaiton.title = locationName;
    [self.pointAnnotaiton setCoordinate:coordinate];
    [self.mapView addAnnotation:self.pointAnnotaiton];
    [self.mapView setCenterCoordinate:coordinate];
    
    // 设置缩放级别
    [self.mapView setZoomLevel:17.0f animated:NO];
}

- (void)xl_weather {
    
    if ([self.reGeocode.addressComponent.province isEqualToString:@""] && [self.reGeocode.addressComponent.city isEqualToString:@""]) {
        
        return;
    }
    
    NSMutableDictionary *params = @{}.mutableCopy;
    [params setValue:@"1e4dfb2107e80" forKey:@"key"];
    [params setValue:[self.reGeocode.addressComponent.city substringToIndex:2] forKey:@"city"];
    [params setValue:[self.reGeocode.addressComponent.province substringToIndex:2] forKey:@"province"];
    
    [HttpManager xl_GET:kWeather_URL params:params success:^(id response) {
        
//        NSLog(@"天 -- 气 : %@", response);
        
    } failure:^(NSError *error) {
        
    }];
}

// MARK: -
- (void)locItemAction {

    CurrentLocationViewController *currentLocView = [[CurrentLocationViewController alloc] init];
    
    currentLocView.delegate = self;
    currentLocView.currentLoc = self.reGeocode.formattedAddress;
    
    NSMutableArray *pois = [NSMutableArray array];
    for (int i = 0; i < self.reGeocode.pois.count; i++) {
        
        [pois addObject:self.reGeocode.pois[i]];
    }
    
    currentLocView.locationArray = pois;
    UINavigationController *currentLocNA = [[UINavigationController alloc] initWithRootViewController:currentLocView];
    [self presentViewController:currentLocNA animated:YES completion:nil];
}

// MARK: - CurrentLocDelegate
- (void)xl_reposition {
    [self xl_locate];
}

- (void)xl_currentLocation:(AMapPOI *)mapPOI {
    self.navigationItem.title = mapPOI.name;
    
    AMapCoordinateType type = AMapCoordinateTypeGPS;
    CLLocationCoordinate2D coordinate2D = AMapCoordinateConvert(CLLocationCoordinate2DMake(mapPOI.location.latitude, mapPOI.location.longitude), type);
    [self xl_pointAnnotation:coordinate2D locationName:mapPOI.name];
    
    NSLog(@"%@, 经度 : %f, 维度 : %f", mapPOI.name, mapPOI.location.latitude, mapPOI.location.longitude);
}

// MARK: - MAMapViewDelegate
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation {
    
    if ([annotation isKindOfClass:[MAPointAnnotation class]]) {
        
        static NSString *pointReuseIndetifier = @"pointReuseIndetifier";
        
        MAPinAnnotationView *annotationView = (MAPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndetifier];
        
        if (annotationView == nil) {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndetifier];
        }
        
        annotationView.canShowCallout = NO;
        annotationView.animatesDrop = YES;
        annotationView.draggable = NO;
        annotationView.image = [UIImage imageNamed:@"icon_location"];
        
        return annotationView;
    }
    
    return nil;
}


@end
