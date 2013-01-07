//
//  Products.h
//  paidPunch
//
//  Created by Aaron Khoo on 1/4/13.
//  Copyright (c) 2013 PaidPunch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpCallbackDelegate.h"

@interface Products : NSObject
{
    // internal
    NSString* _createdVersion;
    
    NSDate* _lastUpdate;
    NSMutableArray* _productsArray;
}
@property (nonatomic,strong) NSMutableArray* productsArray;
@property (nonatomic,readonly) NSDate* lastUpdate;

- (void) retrieveProductsFromServer:(NSObject<HttpCallbackDelegate>*) delegate;
- (BOOL) needsRefresh;

+ (Products*) getInstance;
+ (void) destroyInstance;

@end
