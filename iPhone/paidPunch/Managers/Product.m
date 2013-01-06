//
//  Product.m
//  paidPunch
//
//  Created by Aaron Khoo on 1/4/13.
//  Copyright (c) 2013 PaidPunch. All rights reserved.
//

#import "Product.h"


// encoding keys
static NSString* const kKeyVersion = @"version";
static NSString* const kKeyProductId = @"id";
static NSString* const kKeyName = @"localized_name";
static NSString* const kKeyDesc = @"localized_desc";
static NSString* const kKeyCredits = @"credits";
static NSString* const kKeyCost = @"cost";

@implementation Product
@synthesize productId = _productId;
@synthesize name = _name;
@synthesize desc = _desc;
@synthesize credits = _credits;
@synthesize cost = _cost;

- (id) initWithDictionary:(NSDictionary*)dict
{
    self = [super init];
    if(self)
    {
        _createdVersion = @"1.0";
        _productId = [dict valueForKeyPath:@"product_id"];
        _name = [dict valueForKeyPath:@"name"];
        _desc = [dict valueForKeyPath:@"desc"];
        _credits = [NSDecimalNumber decimalNumberWithString:[dict valueForKeyPath:@"credits"]];
        _cost = [NSDecimalNumber decimalNumberWithString:[dict valueForKeyPath:@"cost"]];
    }
    return self;
}

#pragma mark - NSCoding
- (void) encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_createdVersion forKey:kKeyVersion];
    [aCoder encodeObject:_productId forKey:kKeyProductId];
    [aCoder encodeObject:_name forKey:kKeyName];
    [aCoder encodeObject:_desc forKey:kKeyDesc];
    [aCoder encodeObject:_credits forKey:kKeyCredits];
    [aCoder encodeObject:_cost forKey:kKeyCost];
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
    _createdVersion = [aDecoder decodeObjectForKey:kKeyVersion];
    _productId = [aDecoder decodeObjectForKey:kKeyProductId];
    _name = [aDecoder decodeObjectForKey:kKeyName];
    _desc = [aDecoder decodeObjectForKey:kKeyDesc];
    _credits = [aDecoder decodeObjectForKey:kKeyCredits];
    _cost = [aDecoder decodeObjectForKey:kKeyCost];
    
    return self;
}

@end
