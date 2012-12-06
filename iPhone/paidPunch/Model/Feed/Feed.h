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

@property (nonatomic, strong) NSString * action;
@property (nonatomic, strong) NSString * business_name;
@property (nonatomic, strong) NSNumber * each_punch_value;
@property (nonatomic, strong) NSString * fbid;
@property (nonatomic, strong) NSNumber * is_friend;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSNumber * no_of_punches;
@property (nonatomic, strong) NSString * offer;
@property (nonatomic, strong) NSNumber * price;
@property (nonatomic, strong) NSNumber * selling_price;
@property (nonatomic, strong) NSDate * time_stamp;
@property (nonatomic, strong) NSNumber * discount_value_of_each_punch;
@property (nonatomic, strong) NSNumber * actual_value_of_each_punch;

@end
