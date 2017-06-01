//
//  AMapLocationController.m
//  Panda
//
//  Created by 街路口等你 on 17/6/1.
//  Copyright © 2017年 街路口等你. All rights reserved.
//

#import "AMapLocationController.h"

@interface AMapLocationController ()<AMapLocationManagerDelegate>

@property (nonatomic, strong) AMapLocationManager *locationManager;
@property (nonatomic, copy) AMapLocatingCompletionBlock comletionBlock;


@end

@implementation AMapLocationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self xl_InitCompleteBlock];
    [self xl_ReGecodeAction];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    if ([self isViewLoaded] && !self.view.window) {
        self.view = nil;
    }
}

- (void)xl_InitCompleteBlock {
    self.comletionBlock = ^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        if (error != nil && error.code == AMapLocationErrorLocateFailed) {
            // 定位错误
            
            return ;
        }
        else if (error != nil && (error.code == AMapLocationErrorReGeocodeFailed
                                  || error.code == AMapLocationErrorTimeOut
                                  || error.code == AMapLocationErrorCannotFindHost
                                  || error.code == AMapLocationErrorBadURL
                                  || error.code == AMapLocationErrorNotConnectedToInternet
                                  || error.code == AMapLocationErrorCannotConnectToHost)) {
            // 逆地理错误：在带逆地理的单次定位中，逆地理过程可能发生错误，此时location有返回值，regeocode无返回值，进行annotation的添加
            NSLog(@"逆地理错误:{%ld - %@};", (long)error.code, error.localizedDescription);
        }
        else if (error != nil && error.code == AMapLocationErrorRiskOfFakeLocation) {
            // 存在虚拟定位的风险: 此时location和regeocode没有返回值, 不进行annotation的添加
            NSLog(@"存在虚拟定位的风险:{%ld - %@};", (long)error.code, error.localizedDescription);
            return;
        }
        
        if (regeocode) {
            
            // 逆地理信息
            NSLog(@"1 - %@", [NSString stringWithFormat:@"%@ \n %@-%@-%.2fm", regeocode.formattedAddress, regeocode.citycode, regeocode.adcode, location.horizontalAccuracy]);
        }
        else {
            
            NSLog(@"%@", [NSString stringWithFormat:@"lat:%f;lon:%f \n accuracy:%.2fm", location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy]);
        }
    };
}

- (void)xl_ReGecodeAction {
    // 进行单次逆地里地位请求
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:self.comletionBlock];
}

- (AMapLocationManager *)locationManager {
    if (!_locationManager) {
        self.locationManager = [[AMapLocationManager alloc] init];
        // 设置期望定位精度
        _locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
        // 设置允许在后台定位
        _locationManager.allowsBackgroundLocationUpdates = YES;
        // 设置定位超时时间
        _locationManager.locationTimeout = 5.0;
        // 设置逆地里超时时间
        _locationManager.reGeocodeTimeout = 5.0;
        _locationManager.delegate = self;
    }
    return _locationManager;
}

@end
