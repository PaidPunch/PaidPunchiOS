//
//  UrlImageManager.m
//  traderpog
//
//  Created by Aaron Khoo on 10/5/12.
//  Copyright (c) 2012 GeoloPigs. All rights reserved.
//

#import "UrlImageManager.h"

@implementation UrlImageManager

- (id) init
{
    self = [super init];
    if(self)
    {
        _urlImages = [[NSMutableDictionary alloc] initWithCapacity:10];
    }
    return self;
}

- (UrlImage*) getCachedImage:(NSString*)currentKey
{
    return [_urlImages objectForKey:currentKey];
}

- (void) insertImageToCache:(NSString*)currentKey image:(UrlImage*)image
{
    [_urlImages setObject:image forKey:currentKey];
}

#pragma mark - Singleton
static UrlImageManager* singleton = nil;
+ (UrlImageManager*) getInstance
{
	@synchronized(self)
	{
		if (!singleton)
		{
            // OK, no saved data available. Go ahead and create a new UrlImageManager.
            singleton = [[UrlImageManager alloc] init];
		}
	}
	return singleton;
}

+ (void) destroyInstance
{
	@synchronized(self)
	{
		singleton = nil;
	}
}

@end
