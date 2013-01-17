//
//  Products.h
//  paidPunch
//
//  Created by Aaron Khoo on 1/4/13.
//  Copyright (c) 2013 PaidPunch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpCallbackDelegate.h"

static NSString* const kKeyProductsRetrieve = @"products_retrieve";
static NSString* const kKeyProductsPurchase = @"products_purchase";

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
- (void) purchaseProduct:(NSObject<HttpCallbackDelegate>*) delegate index:(NSUInteger)index;
- (BOOL) needsRefresh;

+ (Products*) getInstance;
+ (void) destroyInstance;

@end
