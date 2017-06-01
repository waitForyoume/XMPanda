//
//  HttpManager.h
//  Panda
//
//  Created by 街路口等你 on 17/6/1.
//  Copyright © 2017年 街路口等你. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpManager : NSObject

+ (void)requestMethod:(NSString *)method
                  url:(NSString *)url
               params:(NSDictionary *)parasms
              success:(void(^)(id response))success
              failure:(void(^)(NSError *error))failure;

+ (void)xl_GET:(NSString *)url
        params:(NSDictionary *)params
       success:(void(^)(id response))success
       failure:(void(^)(NSError *error))failure;


@end
