//
//  UIView+XMAdd.h
//  街路口等你
//
//  Created by 心意答 on 16/11/30.
//  Copyright © 2016年 wait_foryou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (XMAdd)

@property (nonatomic) CGFloat left; // frame.origin.x
@property (nonatomic) CGFloat top; // frame.origin.y
@property (nonatomic) CGFloat right; // frame.origin.x + frame.size.width
@property (nonatomic) CGFloat bottom; // frame.origin.y + frame.size.height
@property (nonatomic) CGFloat width; // frame.size.width
@property (nonatomic) CGFloat height; // frame.size.height
@property (nonatomic) CGFloat centerX; // center.x
@property (nonatomic) CGFloat centerY; // center.y
@property (nonatomic) CGPoint origin; // frame.origin
@property (nonatomic) CGSize size; // frame.size


@end
