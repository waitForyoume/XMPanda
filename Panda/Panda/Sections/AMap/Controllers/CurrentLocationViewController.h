//
//  CurrentLocationViewController.h
//  Panda
//
//  Created by panda on 17/7/12.
//  Copyright © 2017年 街路口等你. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CurrentLocDelegate <NSObject>

// 重新定位
- (void)xl_reposition;

// 当前位置
- (void)xl_currentLocation:(AMapPOI *)mapPOI;

@end

@interface CurrentLocationViewController : UIViewController

@property (nonatomic, strong) NSMutableArray<AMapPOI *> *locationArray;
@property (nonatomic, copy) NSString *currentLoc;
@property (nonatomic, weak) id<CurrentLocDelegate> delegate;


@end
