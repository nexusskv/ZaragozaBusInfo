//
//  ApiConnector.h
//  ZaragozaBusInfo
//
//  Created by rost on 29.03.16.
//  Copyright © 2016 Rost Gress. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ApiConnectorCallback)(id);


@interface ApiConnector : NSObject

@property (nonatomic, copy) ApiConnectorCallback callbackBlock;

- (id)initWithCallback:(ApiConnectorCallback)block;
- (void)loadBusesInfo;

@end
