//
//  Services.h
//  ProactiveLiving
//
//  Created by Hitesh on 1/12/16.
//  Copyright © 2016 MaverickHitesh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Services : NSObject

+ (void)serviceCallWithPath:(NSString*)path withParam:(NSDictionary*)params success:(void (^)(NSDictionary *responseDict))success failure:(void (^)(NSError *error))failure;

+(void)postRequest:(NSString *)urlStr parameters:(NSDictionary *)parametersDictionary completionHandler:(void (^)(NSString*, NSDictionary*))completionBlock;

 

+(void)requestPostUrlArr:(NSString *)strURL parameters:(NSDictionary *)params completionHandler:(void (^)(NSError*, NSArray*))completionBlock;

+(void)getRequest:(NSString *)urlStr parameters:(NSDictionary *)parametersDictionary completionHandler:(void (^)(NSString*, NSDictionary*))completionBlock;


@end
