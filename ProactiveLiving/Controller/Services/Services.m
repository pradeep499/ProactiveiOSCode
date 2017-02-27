//
//  Services.m
//  ProactiveLiving
//
//  Created by Hitesh on 1/12/16.
//  Copyright © 2016 MaverickHitesh. All rights reserved.
//

#import "Services.h"
#import "Defines.h"
#import <AFNetworking/AFNetworking.h>

@implementation Services
+ (void)serviceCallWithPath:(NSString *)path withParam:(NSDictionary *)params success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure {
    
    
    // replce UserID with _ID
    params = [self replaceUserIDWith_ID:params];
    

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:HeaderKey forHTTPHeaderField:@"customuserheaderkey"];
    
    NSLog(@"%@",manager.requestSerializer.HTTPRequestHeaders);
    
    NSLog(@"Service: %@",path);
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSLog(@"Parameter: %@",jsonString);
    
    //manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager POST:[BASE_URL stringByAppendingString:path] parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        for(NSString *aKey in [params allKeys]){
            NSLog(@"Key: %@ - Value: %@",aKey, [params objectForKey:aKey]);
            [formData appendPartWithFormData:[[params objectForKey:aKey] dataUsingEncoding:NSUTF8StringEncoding] name:aKey];
        }
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //TROUBLESHOOTING by printing logs
        //NSLog(@"Response: %@", responseObject);
        //NSLog(@"%@",operation.responseString);
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"failure    : %@",[error description]);
        NSLog(@"%@",operation.responseString);
        failure(error);
        
    }];
    
}

+ (void)serviceCallWithPath:(NSString *)path withParams:(NSDictionary *)params success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure {
    
    //------Migration to AFNetworking 3.0
    
    // replce UserID with _ID
    params = [self replaceUserIDWith_ID:params];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:[BASE_URL stringByAppendingString:path] parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        for(NSString *aKey in [params allKeys]){
            NSLog(@"Key: %@ - Value: %@",aKey, [params objectForKey:aKey]);
            [formData appendPartWithFormData:[[params objectForKey:aKey] dataUsingEncoding:NSUTF8StringEncoding] name:aKey];
        }
    }success:^(NSURLSessionDataTask *task, id responseObject) {
        NSError* error;
        
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseObject
                                                             options:kNilOptions
                                                               error:&error];
        
        NSData *errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
        NSDictionary *serializedData = [NSJSONSerialization JSONObjectWithData: errorData options:kNilOptions error:nil];
        
        NSHTTPURLResponse* r = (NSHTTPURLResponse*)task.response;
        NSLog( @"success: %d", (int)r.statusCode );
        
        NSLog(@"Response: %@", responseObject);
        success(responseObject);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSData *errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
        NSDictionary *serializedData = [NSJSONSerialization JSONObjectWithData: errorData options:kNilOptions error:nil];
        
        NSHTTPURLResponse* r = (NSHTTPURLResponse*)task.response;
        NSLog( @"success: %d", (int)r.statusCode );
        
        
        NSLog(@"failure    : %@",[error description]);
        failure(error);
    }];
    
}

+(void)postRequest:(NSString *)urlStr parameters:(NSDictionary *)params completionHandler:(void (^)(NSString*, NSDictionary*))completionBlock{
    
     // replce UserID with _ID
    params = [self replaceUserIDWith_ID:params];
    

    NSURL *URL = [NSURL URLWithString:[BASE_URL stringByAppendingString:urlStr]];

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:HeaderKey forHTTPHeaderField:@"customuserheaderkey"];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];

     [manager POST:URL.absoluteString parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        NSError* error;
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseObject
                                                             options:kNilOptions
                                                               error:&error];
        
        completionBlock(@"Success",json);
         
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Error: %@", error);
        completionBlock(@"Error",nil);
    }];
}

+(void)requestPostUrl:(NSString *)strURL parameters:(NSDictionary *)params success:(void (^)(NSDictionary *responce))success failure:(void (^)(NSError *error))failure {
    
     // replce UserID with _ID
    params = [self replaceUserIDWith_ID:params];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    
    [manager POST:[BASE_URL stringByAppendingString:strURL] parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if([responseObject isKindOfClass:[NSDictionary class]]) {
            if(success) {
                success(responseObject);
            }
        }
        else {
            NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            if(success) {
                success(response);
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if(failure) {
            failure(error);
        }
        
    }];
}

+(void)requestPostUrlArr:(NSString *)strURL parameters:(NSDictionary *)params completionHandler:(void (^)(NSError*, NSArray*))completionBlock{
    
    // replce UserID with _ID
    params = [self replaceUserIDWith_ID:params];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    
    [manager POST:[BASE_URL stringByAppendingString:strURL] parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if([responseObject isKindOfClass:[NSDictionary class]]) {
            
            completionBlock(nil, responseObject);
            
            
        }
        else {
            NSArray *responseArr = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            
            completionBlock(nil, responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completionBlock(error, nil);
        
    }];
}


/*
 NSData *imageData = UIImagePNGRepresentation([UIImage imageNamed:@"attachment"]);

 constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
 
 if (imageData)
 [formData appendPartWithFileData:imageData
 name:@"profile_image"
 fileName:@"profile.png"
 mimeType:@"image/png"];
 
 }
 */


//Replce UserID with _ID for backened Dublication
+(NSDictionary *)replaceUserIDWith_ID:(NSDictionary *)paramsDict{
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithDictionary:paramsDict];
    NSString *key = @"UserID";
    
    NSArray * keys = [paramsDict allKeys];
    
    if ([keys containsObject:key]) {
        
        NSString *userId =  [[NSUserDefaults standardUserDefaults]valueForKey:_ID];
        [dict setValue:userId forKey:key];
        
    }
    
    return dict;
}

@end
