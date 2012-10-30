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

@property (nonatomic, retain) NSString * zip_code;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;

@end
