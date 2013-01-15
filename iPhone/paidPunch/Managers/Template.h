//
//  Template.h
//  paidPunch
//
//  Created by Aaron Khoo on 1/14/13.
//  Copyright (c) 2013 PaidPunch. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Template : NSObject
{
    // internal
    NSString* _createdVersion;
    
    NSString* _name;
    NSString* _templateValue;
}
@property (nonatomic,strong) NSString* name;
@property (nonatomic,strong) NSString* templateValue;

- (id) initWithDictionary:(NSDictionary*)dict;

@end
