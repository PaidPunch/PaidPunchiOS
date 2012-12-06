//
//  InfoExpert.m
//  paidPunch
//
//  Created by mobimedia technologies on 28/11/11.
//  Copyright (c) 2011 mobimedia. All rights reserved.
//

#import "InfoExpert.h"

@implementation InfoExpert

@synthesize appUrl;
@synthesize userId;
@synthesize email;
@synthesize mobileNumber;
@synthesize username;
@synthesize zipcode;
@synthesize password;
@synthesize buyFlag;
@synthesize isProfileCreated;

@synthesize totalMilesValue;
@synthesize cityOrZipCodeValue;
@synthesize searchByNameValue;

@synthesize searchCriteria;
@synthesize searchType;

@synthesize maskedId;

static InfoExpert *sharedInstance=nil;

+(InfoExpert *)sharedInstance{
    
	if(sharedInstance==nil)
	{
		sharedInstance=[[super allocWithZone:NULL]init];
	}
	return sharedInstance;
}

+(id)allocWithZone:(NSZone *)zone{
	return [self sharedInstance];
}

-(id)copyWithZone:(NSZone *)zone{
	return self;
}
@end
