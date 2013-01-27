//
//  ProposedBusiness.h
//  paidPunch
//
//  Created by Aaron Khoo on 1/26/13.
//  Copyright (c) 2013 PaidPunch. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProposedBusiness : NSObject
{
    // internal
    NSString* _createdVersion;
    
    NSString* _proposedBusinessId;
    NSString* _name;
    NSString* _desc;
    NSString* _logoPath;
}
@property (nonatomic,strong) NSString* proposedBusinessId;
@property (nonatomic,strong) NSString* name;
@property (nonatomic,strong) NSString* desc;
@property (nonatomic,strong) NSString* logoPath;

- (id) initWithDictionary:(NSDictionary*)dict;

@end
