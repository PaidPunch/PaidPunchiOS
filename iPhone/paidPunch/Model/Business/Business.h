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

@property (nonatomic, strong) NSString * address;
@property (nonatomic, strong) NSString * business_id;
@property (nonatomic, strong) NSString * business_name;
@property (nonatomic, strong) NSString * category;
@property (nonatomic, strong) NSString * city;
@property (nonatomic, strong) NSString * country;
@property (nonatomic, strong) NSNumber * latitude;
@property (nonatomic, strong) NSNumber * longitude;
@property (nonatomic, strong) NSDate * modified_date;
@property (nonatomic, strong) NSString * pincode;
@property (nonatomic, strong) NSString * qrcode;
@property (nonatomic, strong) NSString * state;
@property (nonatomic, strong) NSDate * time;
@property (nonatomic, strong) NSNumber * diff_in_miles;
@property (nonatomic, strong) PunchCard *punchCard;

@end
