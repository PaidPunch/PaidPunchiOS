//
//  Template.m
//  paidPunch
//
//  Created by Aaron Khoo on 1/14/13.
//  Copyright (c) 2013 PaidPunch. All rights reserved.
//

#import "Template.h"
#import "User.h"

// encoding keys
static NSString* const kKeyVersion = @"version";
static NSString* const kKeyName = @"name";
static NSString* const kKeyTemplateValue = @"templateValue";

@implementation Template
@synthesize name = _name;
@synthesize templateValue = _templateValue;

- (id) initWithDictionary:(NSDictionary*)dict
{
    self = [super init];
    if(self)
    {
        _createdVersion = @"1.0";
        _name = [dict valueForKeyPath:@"name"];
        _templateValue = [self replacePlaceholders:[dict valueForKeyPath:@"templateValue"]];
    }
    return self;
}

- (NSString*) replacePlaceholders:(NSString*)original
{
    NSString* newStr = [original stringByReplacingOccurrencesOfString:@"[USERCODE]"
                                                           withString:[[User getInstance] userCode]];
    newStr = [newStr stringByReplacingOccurrencesOfString:@"[USERNAME]"
                                               withString:[[User getInstance] username]];
    return newStr;
}

#pragma mark - NSCoding
- (void) encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_createdVersion forKey:kKeyVersion];
    [aCoder encodeObject:_name forKey:kKeyName];
    [aCoder encodeObject:_templateValue forKey:kKeyTemplateValue];
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
    _createdVersion = [aDecoder decodeObjectForKey:kKeyVersion];
    _name = [aDecoder decodeObjectForKey:kKeyName];
    _templateValue = [aDecoder decodeObjectForKey:kKeyTemplateValue];
    return self;
}

@end
