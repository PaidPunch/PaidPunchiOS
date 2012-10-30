//
//  DatabaseManager.h
//  paidPunch
//
//  Created by mobimedia technologies on 28/11/11.
//  Copyright (c) 2011 mobimedia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import "Registration.h"
#import "PunchCard.h"
#import "Business.h"
#import "Feed.h"
#import "Zipcodes_Cache.h"

@interface DatabaseManager : NSObject


+ (id)sharedInstance;

-(NSArray *)fetchPunchCards;
-(void)deleteAllPunchCards;

-(Registration *)getRegistrationObject;
-(PunchCard *)getPunchCardObject;
-(Business *)getBusinessObject;
-(Feed *)getFeedObject;
-(Zipcodes_Cache*)getZipcodes_CacheObject;

-(void)saveEntity:(NSManagedObject *)object;
-(void)deleteEntity:(NSManagedObject *)object;
-(void)deleteMyPunches;
-(PunchCard *)getPunchCardById:(NSString *)pid;
-(void)deleteAllUsedPunches;
-(void)deleteOtherPunchCards;
-(void)deleteBusinesses;
-(void)deleteAllFeeds;

-(NSManagedObject *)getManagedObject:(NSManagedObjectID *)objId;

-(NSArray *)getBusinessesByCategory:(NSString *)category;
//-(NSArray *)getBusinessesByCityAndCategory:(NSString *)city withCategory:(NSString *)category;
//-(NSArray *)getBusinessesByZipCodeAndCategory:(NSString *)zipCode withCategory:(NSString *)category;
-(NSArray *)getBusinessesByName:(NSString *)bName;
-(NSArray *)getAllBusinesses;
-(NSArray *)getAllFeeds;
-(NSArray *)getBusinessesNearMe:(CLLocation *)location withMiles:(NSNumber *)miles withCategory:(NSString *)category;
-(NSArray *)getBusinessesByCurrentLocation:(NSArray *)businessList withCurrentLocation:(CLLocation *)location withMiles:(NSNumber *)miles;

-(Business *)getBusinessByBusinessId:(NSString *)bid;
-(Zipcodes_Cache *)getZipcodesCacheObject:(NSString *)zipcode;

-(NSArray *)getFriendsFeeds;
@end
