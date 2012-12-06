//
//  Zipcodes_Cache.h
//  paidPunch
//
//  Created by mobimedia technologies on 04/05/12.
//  Copyright (c) 2012 mobimedia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Zipcodes_Cache : NSManagedObject

@property (nonatomic, strong) NSString * zip_code;
@property (nonatomic, strong) NSNumber * latitude;
@property (nonatomic, strong) NSNumber * longitude;

@end
