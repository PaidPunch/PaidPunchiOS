//
//  ProposedBusiness.m
//  paidPunch
//
//  Created by Aaron Khoo on 1/26/13.
//  Copyright (c) 2013 PaidPunch. All rights reserved.
//

#import "ProposedBusiness.h"

// encoding keys
static NSString* const kKeyVersion = @"version";
static NSString* const kKeyProposedBusinessId = @"itemName";
static NSString* const kKeyName = @"name";
static NSString* const kKeyDesc = @"desc";
static NSString* const kKeyLogoPath = @"logo_path";

@implementation ProposedBusiness
@synthesize proposedBusinessId = _proposedBusinessId;
@synthesize name = _name;
@synthesize desc = _desc;
@synthesize logoPath = _logoPath;

- (id) initWithDictionary:(NSDictionary*)dict
{
    self = [super init];
    if(self)
    {
        _createdVersion = @"1.0";
        _proposedBusinessId = [dict valueForKeyPath:kKeyProposedBusinessId];
        _name = [dict valueForKeyPath:kKeyName];
        _desc = [dict valueForKeyPath:kKeyDesc];
        _logoPath = [dict valueForKey:kKeyLogoPath];
    }
    return self;
}

#pragma mark - NSCoding
- (void) encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_createdVersion forKey:kKeyVersion];
    [aCoder encodeObject:_proposedBusinessId forKey:kKeyProposedBusinessId];
    [aCoder encodeObject:_name forKey:kKeyName];
    [aCoder encodeObject:_desc forKey:kKeyDesc];
    [aCoder encodeObject:_logoPath forKey:kKeyLogoPath];
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
    _createdVersion = [aDecoder decodeObjectForKey:kKeyVersion];
    _proposedBusinessId = [aDecoder decodeObjectForKey:kKeyProposedBusinessId];
    _name = [aDecoder decodeObjectForKey:kKeyName];
    _desc = [aDecoder decodeObjectForKey:kKeyDesc];
    _logoPath = [aDecoder decodeObjectForKey:kKeyLogoPath];
    
    return self;
}

@end
