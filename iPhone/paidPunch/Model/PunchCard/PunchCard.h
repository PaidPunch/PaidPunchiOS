//
//  PunchCard.h
//  paidPunch
//
//  Created by mobimedia technologies on 18/04/12.
//  Copyright (c) 2012 mobimedia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Business;

@interface PunchCard : NSManagedObject

@property (nonatomic, retain) NSNumber * actual_price;
@property (nonatomic, retain) NSString * business_id;
@property (nonatomic, retain) NSData * business_logo_img;
@property (nonatomic, retain) NSString * business_logo_url;
@property (nonatomic, retain) NSString * business_name;
@property (nonatomic, retain) NSNumber * discount;
@property (nonatomic, retain) NSNumber * discount_value_of_each_punch;
@property (nonatomic, retain) NSNumber * each_punch_value;
@property (nonatomic, retain) NSDate * expiry_date;
@property (nonatomic, retain) NSNumber * flag;
@property (nonatomic, retain) NSNumber * is_free_punch;
@property (nonatomic, retain) NSNumber * is_mystery_punch;
@property (nonatomic, retain) NSNumber * is_mystery_used;
@property (nonatomic, retain) NSString * offer;
@property (nonatomic, retain) NSString * punch_card_desc;
@property (nonatomic, retain) NSString * punch_card_download_id;
@property (nonatomic, retain) NSString * punch_card_id;
@property (nonatomic, retain) NSString * punch_card_name;
@property (nonatomic, retain) NSNumber * punch_expire;
@property (nonatomic, retain) NSNumber * selling_price;
@property (nonatomic, retain) NSNumber * total_punches;
@property (nonatomic, retain) NSNumber * total_punches_used;
@property (nonatomic, retain) NSNumber * minimum_value;
@property (nonatomic, retain) NSNumber * expire_days;
@property (nonatomic, retain) NSString * redeem_time_diff;
@property (nonatomic, retain) Business *business;

@end
