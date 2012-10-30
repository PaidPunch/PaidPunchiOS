//
//  Feed.h
//  paidPunch
//
//  Created by mobimedia technologies on 18/04/12.
//  Copyright (c) 2012 mobimedia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Feed : NSManagedObject

@property (nonatomic, retain) NSString * action;
@property (nonatomic, retain) NSString * business_name;
@property (nonatomic, retain) NSNumber * each_punch_value;
@property (nonatomic, retain) NSString * fbid;
@property (nonatomic, retain) NSNumber * is_friend;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * no_of_punches;
@property (nonatomic, retain) NSString * offer;
@property (nonatomic, retain) NSNumber * price;
@property (nonatomic, retain) NSNumber * selling_price;
@property (nonatomic, retain) NSDate * time_stamp;
@property (nonatomic, retain) NSNumber * discount_value_of_each_punch;
@property (nonatomic, retain) NSNumber * actual_value_of_each_punch;

@end
