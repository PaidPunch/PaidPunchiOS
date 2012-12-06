//
//  Registration.h
//  paidPunch
//
//  Created by mobimedia technologies on 25/11/11.
//  Copyright (c) 2011 mobimedia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Registration : NSManagedObject

@property (nonatomic, strong) NSString * username;
@property (nonatomic, strong) NSString * password;
@property (nonatomic, strong) NSString * confirm_password;
@property (nonatomic, strong) NSString * email;
@property (nonatomic, strong) NSString * mobile;
@property (nonatomic, strong) NSString * zipcode;

@end
