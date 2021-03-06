//
//  HiAccuracyLocator.m
//  traderpog
//
//  Created by Shu Chiun Cheah on 5/11/12.
//  Copyright (c) 2012 GeoloPigs. All rights reserved.
//

#import "HiAccuracyLocator.h"

NSString* const kUserLocated = @"UserLocated";
NSString* const kUserLocationFailed = @"UserLocationFailed";

static NSTimeInterval kLocationUpdateTimeout = 10.0;

@interface HiAccuracyLocator ()
{
    CLLocationManager* _locationManager;
    BOOL        _isLocating;
    NSDate*     _startTimestamp;
}

- (void) internalInitWithAccuracy:(CLLocationAccuracy)accuracy;
- (void) updatingLocationTimedOut;
- (void) stopUpdatingLocation:(StopReason)reason;
@end

@implementation HiAccuracyLocator
@synthesize bestLocation = _bestLocation;
@synthesize delegate;

- (void) internalInitWithAccuracy:(CLLocationAccuracy)accuracy
{
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = accuracy;
    _bestLocation = nil;
    _isLocating = NO;
    _startTimestamp = [NSDate date];
    self.delegate = nil;    
}

- (id) initWithAccuracy:(CLLocationAccuracy)accuracy
{
    self = [super init];
    if(self)
    {
        [self internalInitWithAccuracy:accuracy];
    }
    return self;    
}

- (id) init
{
    self = [super init];
    if(self)
    {
        [self internalInitWithAccuracy:kCLLocationAccuracyKilometer];
    }
    return self;
}


#pragma mark - controls
- (void) startUpdatingLocation
{
    [self performSelector:@selector(updatingLocationTimedOut) withObject:nil afterDelay:kLocationUpdateTimeout];
    [_locationManager startUpdatingLocation];
    _startTimestamp = [NSDate date];
    _bestLocation = nil;
    _isLocating = YES;
}

- (void) updatingLocationTimedOut
{
    if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined)
    {
        // if user not yet determined authorization, renew the timeout
        [self performSelector:@selector(updatingLocationTimedOut) withObject:nil afterDelay:kLocationUpdateTimeout];
    }
    else 
    {
        if ([self bestLocation])
        {
            // timeout occurred, but a best location exists, so let's use that.
            [self stopUpdatingLocation:kStopReasonDesiredAccuracy];
        }
        else
        {
            // otherwise, just timeout
            [self stopUpdatingLocation:kStopReasonTimedOut];
        }
    }
}

- (void) stopUpdatingLocation:(StopReason)reason
{
    if(_isLocating)
    {
        [_locationManager stopUpdatingLocation];
        switch (reason) 
        {
            case kStopReasonDesiredAccuracy:
                [[NSNotificationCenter defaultCenter] postNotificationName:kUserLocated object:self];
                if([self delegate])
                {
                    [self.delegate locator:self didLocateUser:YES reason:reason];
                }
                break;
                
            case kStopReasonLocationUnknown:
                NSLog(@"location unknown");
                [[NSNotificationCenter defaultCenter] postNotificationName:kUserLocationFailed object:self];
                if([self delegate])
                {
                    [self.delegate locator:self didLocateUser:NO reason:reason];
                }
                break;
                
            case kStopReasonTimedOut:
            {
                NSLog(@"location timed out");
                BOOL hasRealLocation = YES;
                if(nil == [self bestLocation])
                {
                    hasRealLocation = NO;
                    [[NSNotificationCenter defaultCenter] postNotificationName:kUserLocationFailed object:self];
                }
                else
                {
                    [[NSNotificationCenter defaultCenter] postNotificationName:kUserLocated object:self];
                }
                
                if([self delegate])
                {
                    [self.delegate locator:self didLocateUser:hasRealLocation reason:reason];
                }
            }
                break;
                
            case kStopReasonDenied:
            {
                if([self delegate])
                {
                    [self.delegate locator:self didLocateUser:NO reason:reason];
                }
            }
                break;

            default:
                // do nothing
                break;
        }
        
        _isLocating = NO;
    }
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation 
{
    if(_isLocating)
    {
        // test the age of the location measurement to determine if the measurement is cached
        // in most cases you will not want to rely on cached measurements
        NSTimeInterval locationAge = -[newLocation.timestamp timeIntervalSinceNow];
        NSTimeInterval bestAge = -[_startTimestamp timeIntervalSinceNow];
        if([self bestLocation])
        {
            bestAge = -[self.bestLocation.timestamp timeIntervalSinceNow];
        }
        
        if (locationAge <= bestAge)
        {
            // test that the horizontal accuracy does not indicate an invalid measurement
            if (newLocation.horizontalAccuracy > 0)
            {
                // test the measurement to see if it is more accurate than the previous measurement
                NSTimeInterval bestLocationAge = -[self.bestLocation.timestamp timeIntervalSinceNow];
                if ([self bestLocation] == nil || self.bestLocation.horizontalAccuracy > newLocation.horizontalAccuracy ||
                    (bestLocationAge > locationAge))
                {
                    // store best location
                    self.bestLocation = newLocation;

                    // test the measurement to see if it meets the desired accuracy
                    if (newLocation.horizontalAccuracy <= _locationManager.desiredAccuracy) 
                    {
                        // we can also cancel our previous performSelector:withObject:afterDelay: - it's no longer necessary
                        [NSObject cancelPreviousPerformRequestsWithTarget:self 
                                                                 selector:@selector(updatingLocationTimedOut) 
                                                                   object:nil];
                        // we have a measurement that meets our requirements, so we can stop updating the location
                        [self stopUpdatingLocation:kStopReasonDesiredAccuracy];
                    }
                }
            }
        }
    }
}


- (void) locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    switch([error code])
    {            
        case kCLErrorDenied:
            [self stopUpdatingLocation:kStopReasonDenied];
            break;
            
        default:
        case kCLErrorLocationUnknown:
            [self stopUpdatingLocation:kStopReasonLocationUnknown];
            break;
    }
}

#pragma mark - Singleton
static HiAccuracyLocator* singleton = nil;
+ (HiAccuracyLocator*) getInstance
{
	@synchronized(self)
	{
		if (!singleton)
		{
            singleton = [[HiAccuracyLocator alloc] init];
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
