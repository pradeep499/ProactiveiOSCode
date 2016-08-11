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

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:HeaderKey forHTTPHeaderField:@"custom_user_header_key"];

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

   /* NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params options:0 error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:path parameters:nil error:nil];
    
    req.timeoutInterval= [[[NSUserDefaults standardUserDefaults] valueForKey:@"timeoutInterval"] longValue];
    [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [req setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [req setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    [[manager dataTaskWithRequest:req completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        if (!error) {
            NSLog(@"Reply JSON: %@", responseObject);
            
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                //blah blah
            }
        } else {
            NSLog(@"Error: %@, %@, %@", error, response, responseObject);
        }
    }] resume]; */
    
    /*
    NSString *strURL = @"https://exampleWeb.com/webservice";
    NSDictionary *dictParamiters = @{@"user[height]": height,@"user[weight]": weight};
    
    NSString *aStrParams = [self getFormDataStringWithDictParams:dictParamiters];
    
    NSData *aData = [aStrParams dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *aRequest = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:strURL]];
    [aRequest setHTTPMethod:@"POST"];
    [aRequest setHTTPBody:aData];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];
    [aRequest setHTTPBody:aData];
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:aRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        //
        if (error ==nil) {
            NSString *aStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"ResponseString:%@",aStr);
            NSMutableDictionary *aMutDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(aMutDict);
                
                NSLog(@"responce:%@",aMutDict)
                
            });
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"error:%@",error.locali)
            });
        }
    }];
    
    [postDataTask resume];
    */
    
    //------Migration to AFNetworking 3.0
    
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

+(void)postRequest:(NSString *)urlStr parameters:(NSDictionary *)parametersDictionary completionHandler:(void (^)(NSString*, NSDictionary*))completionBlock{
    

    NSURL *URL = [NSURL URLWithString:urlStr];

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:HeaderKey forHTTPHeaderField:@"custom_user_header_key"];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];

     [manager POST:URL.absoluteString parameters:parametersDictionary success:^(NSURLSessionDataTask *task, id responseObject) {
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

+(void)requestPostUrl:(NSString *)strURL parameters:(NSDictionary *)dictParams success:(void (^)(NSDictionary *responce))success failure:(void (^)(NSError *error))failure {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    
    [manager POST:[BASE_URL stringByAppendingString:strURL] parameters:dictParams success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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

@end
