//
//  XMPOIViewController.m
//  Panda
//
//  Created by panda on 17/7/12.
//  Copyright © 2017年 街路口等你. All rights reserved.
//

#import "XMPOIViewController.h"

@interface XMPOIViewController ()<AMapSearchDelegate>

@property (nonatomic, strong) AMapSearchAPI *mapSearch;
@property (nonatomic, strong) AMapPOISearchResponse *searchResponse;
@property (nonatomic, strong) UITableView *poiTableView;

@end

@implementation XMPOIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self xl_poiViewLayoutNav];
    [self xl_initWithProperty];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    if ([self isViewLoaded] && !self.view.window) {
        self.view = nil;
    }
}

- (void)xl_poiViewLayoutNav {
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = self.navTitle;
}

// MARK: -
- (void)xl_initWithProperty {
    
    self.mapSearch = [[AMapSearchAPI alloc] init];
    _mapSearch.delegate = self;
    [AMapServices sharedServices].enableHTTPS = YES;
    
    // 初始化地图
    MAMapView *mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 64.0f, kXM_Width, kXM_Height * 0.4)];
    mapView.showsScale = NO;
    mapView.showsCompass = NO;
    mapView.zoomLevel = 16.0f;
    mapView.minZoomLevel = 14.0f;
    mapView.maxZoomLevel = 17.0f;
    
    // 把地图添加至 view
    [self.view insertSubview:mapView atIndex:0];
    
    mapView.showsUserLocation = YES;
    mapView.userTrackingMode = MAUserTrackingModeFollow;
}

@end
