//
//  Product.h
//  paidPunch
//
//  Created by Aaron Khoo on 1/4/13.
//  Copyright (c) 2013 PaidPunch. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Product : NSObject
{
    // internal
    NSString* _createdVersion;
    
    NSString* _productId;
    NSDecimalNumber* _credits;
    NSDecimalNumber* _cost;
    NSString* _name;
    NSString* _desc;
}
@property (nonatomic,strong) NSString* productId;
@property (nonatomic,strong) NSString* name;
@property (nonatomic,strong) NSString* desc;
@property (nonatomic) NSDecimalNumber* cost;
@property (nonatomic,readonly) NSDecimalNumber* credits;

- (id) initWithDictionary:(NSDictionary*)dict;

@end
