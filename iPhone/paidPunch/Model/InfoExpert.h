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
@property(nonatomic,strong) NSString *appUrl;
@property(nonatomic,strong) NSString *userId;
@property(nonatomic,strong) NSString *username;
@property(nonatomic,strong) NSString *zipcode;
@property(nonatomic,strong) NSString *email;
@property(nonatomic,strong) NSString *mobileNumber;
@property(nonatomic,strong) NSString *password;
@property(nonatomic,assign) bool buyFlag;
@property(nonatomic,assign) bool isProfileCreated;

//global settings parameters set
@property(nonatomic,strong) NSNumber *totalMilesValue;
@property(nonatomic,strong) NSString *cityOrZipCodeValue;
@property(nonatomic,strong) NSString *searchByNameValue;

//current search Criteria
@property int searchCriteria;

@property(nonatomic,strong)NSString *maskedId;
@property(nonatomic,strong) NSString *searchType;

+(id)sharedInstance;

@end
