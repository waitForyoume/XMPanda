//
//  NSString+Add.m
//  Panda
//
//  Created by panda on 17/7/12.
//  Copyright © 2017年 街路口等你. All rights reserved.
//

#import "NSString+Add.h"

@implementation NSString (Add)

- (CGSize)sizeWithFont:(UIFont *)font withMaxSize:(CGSize)maxSize {
    NSDictionary *attrs = @{NSFontAttributeName:font};
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil ].size;
}


@end
