//
//  Business.h
//  paidPunch
//
//  Created by mobimedia technologies on 04/05/12.
//  Copyright (c) 2012 mobimedia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class PunchCard;

@interface Business : NSManagedObject

@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * business_id;
@property (nonatomic, retain) NSString * business_name;
@property (nonatomic, retain) NSString * category;
@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSString * country;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSDate * modified_date;
@property (nonatomic, retain) NSString * pincode;
@property (nonatomic, retain) NSString * qrcode;
@property (nonatomic, retain) NSString * state;
@property (nonatomic, retain) NSDate * time;
@property (nonatomic, retain) NSNumber * diff_in_miles;
@property (nonatomic, retain) PunchCard *punchCard;

@end
