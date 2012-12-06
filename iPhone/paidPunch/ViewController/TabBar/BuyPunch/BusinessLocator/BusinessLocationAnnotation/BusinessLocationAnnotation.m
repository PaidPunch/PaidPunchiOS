//
//  BusinessLocationAnnotation.m
//  paidPunch
//
//  Created by mobimedia technologies on 26/04/12.
//  Copyright (c) 2012 mobimedia. All rights reserved.
//

#import "BusinessLocationAnnotation.h"

@implementation BusinessLocationAnnotation

@synthesize title, subtitle, coordinate, punchCard;

- (id)initWithCoord:(CLLocationCoordinate2D)coord {
	if (self = [super init]) {
		coordinate = coord;
	}
	return self;
}


@end
