//
//  ApiConnector.m
//  ZaragozaBusInfo
//
//  Created by rost on 29.03.16.
//  Copyright © 2016 Rost Gress. All rights reserved.
//

#import "ApiConnector.h"

#define BUS_API_URL     @"http://api.dndzgz.com/services/bus"


@implementation ApiConnector


#pragma mark - initWithCallback:
- (id)initWithCallback:(ApiConnectorCallback)block {
    if (self = [super init])
        self.callbackBlock = block;
    
    return self;
}
#pragma mark -


#pragma mark - loadBusesInfo
- (void)loadBusesInfo {
    NSURL *requestURL = [NSURL URLWithString:BUS_API_URL];
    
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *urlSession = [NSURLSession sessionWithConfiguration:sessionConfiguration];
    NSMutableURLRequest *requestToApi = [NSMutableURLRequest requestWithURL:requestURL];
    requestToApi.HTTPMethod = @"GET";
    
    NSURLSessionDataTask *dataTask =
    [urlSession dataTaskWithRequest:requestToApi
                  completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                      
                      if ((data) && (data.length > 0)) {
                          NSError *jsonError = nil;
                          NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data
                                                                                     options:NSJSONReadingMutableLeaves
                                                                                       error:&jsonError];
                          
                          if (!jsonObject) {
                              NSLog(@"Parsing JSON error: %@", jsonError);
                              self.callbackBlock(jsonError);
                          } else {
                              self.callbackBlock([jsonObject objectForKey:@"locations"]);
                          }
                      }
                  }];
    
    [dataTask resume];
}
#pragma mark -


@end
