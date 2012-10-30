//
//  InfoExpert.h
//  paidPunch
//
//  Created by mobimedia technologies on 28/11/11.
//  Copyright (c) 2011 mobimedia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InfoExpert : NSObject
{
    NSString *appUrl;
    
    NSString *userId;
    NSString *username;
    NSString *zipcode;
    NSString *email;
    NSString *mobileNumber;
    NSString *password;
    
    // a hack to fetch punchcards after buying
    bool buyFlag;
}
@property(nonatomic,retain) NSString *appUrl;
@property(nonatomic,retain) NSString *userId;
@property(nonatomic,retain) NSString *username;
@property(nonatomic,retain) NSString *zipcode;
@property(nonatomic,retain) NSString *email;
@property(nonatomic,retain) NSString *mobileNumber;
@property(nonatomic,retain) NSString *password;
@property(nonatomic,assign) bool buyFlag;
@property(nonatomic,assign) bool isProfileCreated;

//global settings parameters set
@property(nonatomic,retain) NSNumber *totalMilesValue;
@property(nonatomic,retain) NSString *cityOrZipCodeValue;
@property(nonatomic,retain) NSString *searchByNameValue;

//current search Criteria
@property int searchCriteria;

@property(nonatomic,retain)NSString *maskedId;
@property(nonatomic,retain) NSString *searchType;

+(id)sharedInstance;

@end
