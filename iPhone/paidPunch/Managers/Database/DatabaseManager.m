//
//  DatabaseManager.m
//  paidPunch
//
//  Created by mobimedia technologies on 28/11/11.
//  Copyright (c) 2011 mobimedia. All rights reserved.
//

#import "DatabaseManager.h"

@implementation DatabaseManager


static DatabaseManager *sharedInstance=nil;

+(DatabaseManager *)sharedInstance{
	
	if(sharedInstance==nil)
	{
		sharedInstance=[[super allocWithZone:NULL]init];
	}
	return sharedInstance;
}

+(id)allocWithZone:(NSZone *)zone{
	return [[self sharedInstance]retain];
}

-(id)copyWithZone:(NSZone *)zone{
	return self;
}

-(id)retain{
	return self;
}

-(NSUInteger)retainCount{
	return NSUIntegerMax;
}

-(oneway void)release{
}

-(id)autorelease{
	return self;
}

-(void)dealloc{
    [super dealloc];
}



//////////////////// Fetch Punch Card Details from Database //////////////////////
-(NSArray *) fetchPunchCards
{
    [self deleteAllUsedPunches];
    AppDelegate *delegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context=[delegate managedObjectContext];
    NSError *error;
    NSEntityDescription *entityDesc=[NSEntityDescription entityForName:@"PunchCard" inManagedObjectContext:context];
    NSFetchRequest *request=[[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    
    //a hack to fetch only users punch cards
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"flag=%@",[[NSNumber numberWithBool:YES] stringValue]];
    request.predicate=predicate;
    NSArray *objects=[context executeFetchRequest:request error:&error];
    NSArray *dateSortDescriptors=[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"business_name" ascending:YES]];
    objects=[objects sortedArrayUsingDescriptors:dateSortDescriptors];
	[request release];
    return objects;
}

-(void)deleteAllPunchCards
{
    AppDelegate *delegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context=[delegate managedObjectContext];
    NSError *error;
    NSEntityDescription *entityDesc=[NSEntityDescription entityForName:@"PunchCard" inManagedObjectContext:context];
    NSFetchRequest *request=[[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    NSArray *objects=[context executeFetchRequest:request error:&error];
	if([objects count] >0)
	{
        for(NSManagedObject *obj in objects)
        {
            [context deleteObject:obj];
        }
	}

    if(![context save:&error])
        NSLog(@"%@",[error localizedDescription]);
	[request release];
}

-(void)deleteAllUsedPunches
{
    AppDelegate *delegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context=[delegate managedObjectContext];
    NSError *error;
    NSEntityDescription *entityDesc=[NSEntityDescription entityForName:@"PunchCard" inManagedObjectContext:context];
    NSFetchRequest *request=[[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    
    //a hack to delete only users punch cards
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"flag=%@",[[NSNumber numberWithBool:YES] stringValue]];
    request.predicate=predicate;
    NSArray *objects=[context executeFetchRequest:request error:&error];

	if([objects count] >0)
	{
        for(PunchCard *obj in objects)
        {
            if([obj.total_punches intValue]-[obj.total_punches_used intValue]==0)
            {
                NSLog(@"Deleting Punch Used Card %d",[obj.punch_card_id intValue]);
                [context deleteObject:obj];
            }
        }
	}
    
    if(![context save:&error])
        NSLog(@"%@",[error localizedDescription]);
	[request release];

}
-(void) deleteOtherPunchCards
{
    
    AppDelegate *delegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context=[delegate managedObjectContext];
    NSError *error;
    NSEntityDescription *entityDesc=[NSEntityDescription entityForName:@"PunchCard" inManagedObjectContext:context];
    NSFetchRequest *request=[[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    
    //a hack to delete only users punch cards
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"flag=%@",[[NSNumber numberWithBool:NO] stringValue]];
    request.predicate=predicate;
    NSArray *objects=[context executeFetchRequest:request error:&error];
    
	if([objects count] >0)
	{
        for(PunchCard *obj in objects)
        {
            NSLog(@"Deleting Punch card with id %d",[obj.punch_card_id intValue]);
            [context deleteObject:obj];
        }
	}
    
    if(![context save:&error])
        NSLog(@"%@",[error localizedDescription]);
	[request release];

}
-(void)deleteMyPunches
{
    AppDelegate *delegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context=[delegate managedObjectContext];
    NSError *error;
    NSEntityDescription *entityDesc=[NSEntityDescription entityForName:@"PunchCard" inManagedObjectContext:context];
    NSFetchRequest *request=[[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    NSArray *objects=[context executeFetchRequest:request error:&error];
	if([objects count] >0)
	{
        for(NSManagedObject *obj in objects)
        {
            PunchCard *pc=(PunchCard *)obj;
            if([pc.flag intValue]==1)
                [context deleteObject:obj];
        }
	}
    
    if(![context save:&error])
        NSLog(@"%@",[error localizedDescription]);
	[request release];
}

-(void)deleteBusinesses
{
    AppDelegate *delegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context=[delegate managedObjectContext];
    NSError *error;
    NSEntityDescription *entityDesc=[NSEntityDescription entityForName:@"Business" inManagedObjectContext:context];
    NSFetchRequest *request=[[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    NSArray *objects=[context executeFetchRequest:request error:&error];
	if([objects count] >0)
	{
        NSLog(@"Deleting businesss");
        for(NSManagedObject *obj in objects)
        {
            [context deleteObject:obj];
        }
	}
    
    if(![context save:&error])
        NSLog(@"%@",[error localizedDescription]);
	[request release];

}

-(Zipcodes_Cache*)getZipcodes_CacheObject
{
    AppDelegate *delegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context=[delegate managedObjectContext];
    Zipcodes_Cache *zipCodesCacheObj=[NSEntityDescription insertNewObjectForEntityForName:@"Zipcodes_Cache" inManagedObjectContext:context];
    return zipCodesCacheObj;
}

-(Registration *)getRegistrationObject
{
    AppDelegate *delegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context=[delegate managedObjectContext];
    Registration *registrationDetailsObj=[NSEntityDescription insertNewObjectForEntityForName:@"Registration" inManagedObjectContext:context];
    return registrationDetailsObj;
}

-(PunchCard *)getPunchCardObject
{
    AppDelegate *delegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context=[delegate managedObjectContext];
    PunchCard *punchcardDetailsObj=[NSEntityDescription insertNewObjectForEntityForName:@"PunchCard" inManagedObjectContext:context];
    return punchcardDetailsObj;
}

-(Business *)getBusinessObject
{
    AppDelegate *delegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context=[delegate managedObjectContext];
    Business *businessDetailsObj=[NSEntityDescription insertNewObjectForEntityForName:@"Business" inManagedObjectContext:context];
    return businessDetailsObj;
}

-(Feed *)getFeedObject
{
    AppDelegate *delegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context=[delegate managedObjectContext];
    Feed *feedDetailsObj=[NSEntityDescription insertNewObjectForEntityForName:@"Feed" inManagedObjectContext:context];
    return feedDetailsObj;
}

-(PunchCard *)getPunchCardById:(NSString *)pid
{
    AppDelegate *delegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context=[delegate managedObjectContext];
    NSError *error;
    NSEntityDescription *entityDesc=[NSEntityDescription entityForName:@"PunchCard" inManagedObjectContext:context];
    NSFetchRequest *request=[[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    
    //a hack to fetch only users punch cards
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"punch_card_download_id=%@",pid];
    request.predicate=predicate;
    NSArray *objects=[context executeFetchRequest:request error:&error];
    [request release];
    if([objects count]>0)
    {
        return [objects objectAtIndex:0];
    }
    return nil;
}
-(void)saveEntity:(NSManagedObject *)object
{
    AppDelegate *delegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context=[delegate managedObjectContext];
    NSError *error;
    if(![context save:&error])
        NSLog(@"%@",[error localizedDescription]);
}
-(void)deleteEntity:(NSManagedObject *)object
{
    AppDelegate *delegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context=[delegate managedObjectContext];
    NSError *error;
    [context deleteObject:object];
    if(![context save:&error])
        NSLog(@"%@",[error localizedDescription]);
}

-(NSManagedObject *)getManagedObject:(NSManagedObjectID *)objId
{
    AppDelegate *delegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context=[delegate managedObjectContext];
    return [context objectWithID:objId];
}


-(NSArray *)getBusinessesByCategory:(NSString *)category
{
    AppDelegate *delegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context=[delegate managedObjectContext];
    NSError *error;
    NSEntityDescription *entityDesc=[NSEntityDescription entityForName:@"Business" inManagedObjectContext:context];
    NSFetchRequest *request=[[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"category=%@",category];
    request.predicate=predicate;
    NSArray *objects=[context executeFetchRequest:request error:&error];
    NSArray *dateSortDescriptors=[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"business_name" ascending:YES]];
    objects=[objects sortedArrayUsingDescriptors:dateSortDescriptors];
	[request release];
    return objects;
}

/*-(NSArray *)getBusinessesByCityAndCategory:(NSString *)city withCategory:(NSString *)category
{
    AppDelegate *delegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context=[delegate managedObjectContext];
    NSError *error;
    NSEntityDescription *entityDesc=[NSEntityDescription entityForName:@"Business" inManagedObjectContext:context];
    NSFetchRequest *request=[[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"category=%@ and city contains[cd] %@",category,city];
    request.predicate=predicate;
    NSArray *objects=[context executeFetchRequest:request error:&error];
    NSArray *dateSortDescriptors=[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"business_name" ascending:YES]];
    objects=[objects sortedArrayUsingDescriptors:dateSortDescriptors];
	[request release];
    return objects;
}

-(NSArray *)getBusinessesByZipCodeAndCategory:(NSString *)zipCode withCategory:(NSString *)category
{
    AppDelegate *delegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context=[delegate managedObjectContext];
    NSError *error;
    NSEntityDescription *entityDesc=[NSEntityDescription entityForName:@"Business" inManagedObjectContext:context];
    NSFetchRequest *request=[[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"category=%@ and pincode contains[cd] %@",category,zipCode];
    request.predicate=predicate;
    NSArray *objects=[context executeFetchRequest:request error:&error];
    NSArray *dateSortDescriptors=[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"business_name" ascending:YES]];
    objects=[objects sortedArrayUsingDescriptors:dateSortDescriptors];
	[request release];
    return objects;
}*/

-(NSArray *)getBusinessesByName:(NSString *)bName
{
    AppDelegate *delegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context=[delegate managedObjectContext];
    NSError *error;
    NSEntityDescription *entityDesc=[NSEntityDescription entityForName:@"Business" inManagedObjectContext:context];
    NSFetchRequest *request=[[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"business_name BEGINSWITH[cd] %@",bName];
    request.predicate=predicate;
    NSArray *objects=[context executeFetchRequest:request error:&error];
    NSArray *dateSortDescriptors=[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"business_name" ascending:YES]];
    objects=[objects sortedArrayUsingDescriptors:dateSortDescriptors];
	[request release];
    return objects;
}

-(NSArray *)getAllBusinesses
{
    AppDelegate *delegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context=[delegate managedObjectContext];
    NSError *error;
    NSEntityDescription *entityDesc=[NSEntityDescription entityForName:@"Business" inManagedObjectContext:context];
    NSFetchRequest *request=[[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    NSArray *objects=[context executeFetchRequest:request error:&error];
    NSArray *dateSortDescriptors=[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"business_name" ascending:YES]];
    objects=[objects sortedArrayUsingDescriptors:dateSortDescriptors];
	[request release];
    return objects;
}

-(NSArray *)getAllFeeds
{
    AppDelegate *delegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context=[delegate managedObjectContext];
    NSError *error;
    NSEntityDescription *entityDesc=[NSEntityDescription entityForName:@"Feed" inManagedObjectContext:context];
    NSFetchRequest *request=[[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    NSArray *objects=[context executeFetchRequest:request error:&error];
    NSArray *dateSortDescriptors=[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"time_stamp" ascending:NO]];
    objects=[objects sortedArrayUsingDescriptors:dateSortDescriptors];
	[request release];
    return objects;
}

-(NSArray *)getFriendsFeeds
{
    AppDelegate *delegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context=[delegate managedObjectContext];
    NSError *error;
    NSEntityDescription *entityDesc=[NSEntityDescription entityForName:@"Feed" inManagedObjectContext:context];
    NSFetchRequest *request=[[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"is_friend=%@",[[NSNumber numberWithBool:YES] stringValue]];
    request.predicate=predicate;
    NSArray *objects=[context executeFetchRequest:request error:&error];
    NSArray *dateSortDescriptors=[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"time_stamp" ascending:NO]];
    objects=[objects sortedArrayUsingDescriptors:dateSortDescriptors];
	[request release];
    return objects;

}
#define DegreesToRadians(degrees) (degrees * M_PI / 180)
#define M_PI   3.14159265358979323846264338327950288 
#define kOneMileMeters 1609.344

-(NSArray *)getBusinessesNearMe:(CLLocation *)location withMiles:(NSNumber *)miles withCategory:(NSString *)category
{
    NSMutableArray *retList=[[[NSMutableArray alloc] init] autorelease];
    NSArray *businesses=[self getAllBusinesses];
    if([businesses count]>0)
    {
        for(Business *bObj in businesses)
        {
            if([bObj.category isEqualToString:category])
            {
                CLLocation *item1 =location;
                CLLocation *item2 = [[CLLocation alloc] initWithLatitude:[bObj.latitude doubleValue] longitude:[bObj.longitude doubleValue]];
        
                CLLocationDistance meters = [item1 distanceFromLocation:item2]; 
                NSLog(@"Distance in metres: %f", meters);
                double distanceInMiles=meters/kOneMileMeters;
                NSLog(@"%@ Distance in miles: %f", bObj.business_name , distanceInMiles);
                [bObj setDiff_in_miles:[NSNumber numberWithDouble:distanceInMiles]];
                if(distanceInMiles<[miles doubleValue])
                {
                    [retList addObject:bObj];
                }
                [item2 release];
            }
        }

    }
    return retList;
}

-(NSArray *)getBusinessesByCurrentLocation:(NSArray *)businessList withCurrentLocation:(CLLocation *)location withMiles:(NSNumber *)miles
{
    NSMutableArray *retList=[[[NSMutableArray alloc] init] autorelease];
    if([businessList count]>0)
    {
        for(Business *bObj in businessList)
        {
            CLLocation *item1 =location;
            CLLocation *item2 = [[CLLocation alloc] initWithLatitude:[bObj.latitude doubleValue] longitude:[bObj.longitude doubleValue]];
                
            CLLocationDistance meters = [item1 distanceFromLocation:item2]; 
            //NSLog(@"Distance in metres: %f", meters);
            double distanceInMiles=meters/kOneMileMeters;
            //NSLog(@"%@ Distance in miles: %f", bObj.business_name,distanceInMiles);
            [bObj setDiff_in_miles:[NSNumber numberWithDouble:distanceInMiles]];
            if(distanceInMiles<[miles doubleValue])
            {
                [retList addObject:bObj];
            }
            [item2 release];
        }
        
    }
    return retList;
}
-(Business *)getBusinessByBusinessId:(NSString *)bid
{
    //business_id
    AppDelegate *delegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context=[delegate managedObjectContext];
    NSError *error;
    NSEntityDescription *entityDesc=[NSEntityDescription entityForName:@"Business" inManagedObjectContext:context];
    NSFetchRequest *request=[[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"business_id=%@",bid];
    request.predicate=predicate;
    NSArray *objects=[context executeFetchRequest:request error:&error];
    NSArray *dateSortDescriptors=[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"business_name" ascending:YES]];
    objects=[objects sortedArrayUsingDescriptors:dateSortDescriptors];
	[request release];
    if(objects!=nil && [objects count]>0)
        return [objects objectAtIndex:0];
    return nil;
}

-(Zipcodes_Cache *)getZipcodesCacheObject:(NSString *)zipcode
{
    AppDelegate *delegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context=[delegate managedObjectContext];
    NSError *error;
    NSEntityDescription *entityDesc=[NSEntityDescription entityForName:@"Zipcodes_Cache" inManagedObjectContext:context];
    NSFetchRequest *request=[[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"zip_code=%@",zipcode];
    request.predicate=predicate;
    NSArray *objects=[context executeFetchRequest:request error:&error];
	[request release];
    if(objects!=nil && [objects count]>0)
        return [objects objectAtIndex:0];
    return nil;

}

-(void)deleteAllFeeds
{
    AppDelegate *delegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context=[delegate managedObjectContext];
    NSError *error;
    NSEntityDescription *entityDesc=[NSEntityDescription entityForName:@"Feed" inManagedObjectContext:context];
    NSFetchRequest *request=[[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    NSArray *objects=[context executeFetchRequest:request error:&error];
	if([objects count] >0)
	{
        NSLog(@"Deleting Feed");
        for(NSManagedObject *obj in objects)
        {
            [context deleteObject:obj];
        }
	}
    
    if(![context save:&error])
        NSLog(@"%@",[error localizedDescription]);
	[request release];
    
}
@end
