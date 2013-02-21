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

@property (nonatomic, strong) NSNumber * actual_price;
@property (nonatomic, strong) NSString * business_id;
@property (nonatomic, strong) NSData * business_logo_img;
@property (nonatomic, strong) NSString * business_logo_url;
@property (nonatomic, strong) NSString * business_name;
@property (nonatomic, strong) NSNumber * discount;
@property (nonatomic, strong) NSNumber * discount_value_of_each_punch;
@property (nonatomic, strong) NSNumber * each_punch_value;
@property (nonatomic, strong) NSDate * expiry_date;
@property (nonatomic, strong) NSNumber * flag;
@property (nonatomic, strong) NSNumber * is_free_punch;
@property (nonatomic, strong) NSNumber * is_mystery_punch;
@property (nonatomic, strong) NSNumber * is_mystery_used;
@property (nonatomic, strong) NSString * offer;
@property (nonatomic, strong) NSString * punch_card_desc;
@property (nonatomic, strong) NSString * punch_card_download_id;
@property (nonatomic, strong) NSString * punch_card_id;
@property (nonatomic, strong) NSString * punch_card_name;
@property (nonatomic, strong) NSNumber * punch_expire;
@property (nonatomic, strong) NSNumber * selling_price;
@property (nonatomic, strong) NSNumber * total_punches;
@property (nonatomic, strong) NSNumber * total_punches_used;
@property (nonatomic, strong) NSNumber * minimum_value;
@property (nonatomic, strong) NSNumber * expire_days;
@property (nonatomic, strong) NSString * redeem_time_diff;
@property (nonatomic, strong) NSString * code;
@property (nonatomic, strong) Business *business;

- (NSString*)getRemainingAmountAsString;

@end
