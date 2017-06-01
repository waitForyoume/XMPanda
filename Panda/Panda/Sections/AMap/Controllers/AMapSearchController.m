//
//  AMapSearchController.m
//  Panda
//
//  Created by 街路口等你 on 17/6/1.
//  Copyright © 2017年 街路口等你. All rights reserved.
//

#import "AMapSearchController.h"

@interface AMapSearchController ()<AMapSearchDelegate, CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, assign) CLLocationCoordinate2D locationCoordinate2D;

@property (nonatomic, strong) AMapReGeocode *reGeocode;
@property (nonatomic, strong) AMapSearchAPI *searchAPI;

@end

@implementation AMapSearchController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self xl_InitProperty];
    [self xl_locate];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    if ([self isViewLoaded] && !self.view.window) {
        self.view = nil;
    }
}

- (void)xl_InitProperty {
    self.searchAPI = [[AMapSearchAPI alloc] init];
    _searchAPI.delegate = self;
    
    self.locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
}

- (void)xl_locate {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
       
        if (TARGET_IPHONE_SIMULATOR) {
            
            // 纬度:39.958186 经度:116.306107
            CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(39.958186, 116.306107);
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

// MARK: - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    // 获取用户位置的对象
    CLLocation *location = [locations lastObject];
    CLLocationCoordinate2D coordinate = location.coordinate;
    
    NSLog(@"经度 : %f, 维度 : %f", coordinate.latitude, coordinate.longitude);
    
    [self xl_MapReGoecodeSearch];
    
    AMapCoordinateType type = AMapCoordinateTypeGPS;
    _locationCoordinate2D = AMapCoordinateConvert(CLLocationCoordinate2DMake(coordinate.latitude,coordinate.longitude), type);
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
        
        NSLog(@"neighborhood : %@, building : %@", response.regeocode.addressComponent.neighborhood, response.regeocode.addressComponent.building);
        
        [self xl_weather];
        
    }
}

- (void)xl_weather {
    
    if ([self.reGeocode.addressComponent.province isEqualToString:@""] && [self.reGeocode.addressComponent.city isEqualToString:@""]) {
        
        return;
    }
    
    NSMutableDictionary *params = @{}.mutableCopy;
    [params setValue:@"1e4dfb2107e80" forKey:@"key"];
    [params setValue:[self.reGeocode.addressComponent.city substringToIndex:2] forKey:@"city"];
    [params setValue:[self.reGeocode.addressComponent.province substringToIndex:2] forKey:@"province"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:kWeather_URL parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"天气 : %@", responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"error %@", error);
        
    }];
    
//    [HttpManager xl_GET:url params:@{} success:^(id response) {
//        
//        NSLog(@"天气 : %@", response);
//        
//    } failure:^(NSError *error) {
//        
//    }];
    
}

@end
