//
//  HttpManager.m
//  Panda
//
//  Created by 街路口等你 on 17/6/1.
//  Copyright © 2017年 街路口等你. All rights reserved.
//

#import "HttpManager.h"

@implementation HttpManager

- (void)requestMethod:(NSString *)method url:(NSString *)url params:(NSDictionary *)parasms success:(void (^)(id))success failure:(void (^)(NSError *))failure {
    
}

- (void)xl_GET:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:url parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
       
        if (responseObject) {
            success(responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (error) {
            failure(error);
        }
    }];
    
}

@end
