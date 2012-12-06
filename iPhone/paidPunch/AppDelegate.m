//
//  AppDelegate.m
//  paidPunch
//
//  Created by mobimedia technologies on 24/11/11.
//  Copyright (c) 2011 mobimedia. All rights reserved.
//

#import "AppDelegate.h"

#import "SignInViewController.h"
#import "StartPageViewController.h"
#import "iRate.h"

@implementation AppDelegate

@synthesize window = _window;
//@synthesize viewController = _viewController;
@synthesize navigationController;
@synthesize facebook;
@synthesize userPermissions;
@synthesize permissions;
@synthesize locationManager;
@synthesize currentLocation;


static NSString* kAppId = @"159848747459550";

#pragma mark -
#pragma mark Cleanup


#pragma mark -

-(void) customizeApperance
{
    UIImage *gradientImage44 = [[UIImage imageNamed:@"NavigationBar.png"] 
                                resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    UIImage *gradientImage32 = [[UIImage imageNamed:@"NavigationBar.png"] 
                                resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    // Set the background image for *all* UINavigationBars
    [[UINavigationBar appearance] setBackgroundImage:gradientImage44 
                                       forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setBackgroundImage:gradientImage32 
                                       forBarMetrics:UIBarMetricsLandscapePhone];
}

- (void)initView 
{    
    NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
    NSString *stat=[ud objectForKey:@"loggedIn"];
    if(ud==nil)
    {
        [ud setObject:@"NO" forKey:@"loggedIn"];
    }
    if ([stat isEqualToString:@"YES"]) {
        
        [[InfoExpert sharedInstance] setUserId:[ud objectForKey:@"userId"]];
        [[InfoExpert sharedInstance] setEmail:[ud objectForKey:@"email"]];
        [[InfoExpert sharedInstance] setUsername:[ud objectForKey:@"username"]];
        [[InfoExpert sharedInstance] setZipcode:[ud objectForKey:@"zipcode"]];
        [[InfoExpert sharedInstance] setMobileNumber:[ud objectForKey:@"mobileNumber"]];
        [[InfoExpert sharedInstance] setPassword:[ud objectForKey:@"password"]];
        
        NSString *s=[ud objectForKey:@"isProfileCreated"];
        if([s isEqualToString:@"YES"])
        {
            [[InfoExpert sharedInstance] setIsProfileCreated:YES];
        }
        else
        {
            [[InfoExpert sharedInstance] setIsProfileCreated:NO];
        }

        PaidPunchTabBarController *tabBarController = [[PaidPunchTabBarController alloc] initWithNibName:nil bundle:nil];
        self.window.rootViewController=tabBarController;
        [self.window makeKeyAndVisible];
    }
    else
    {
        //self.viewController=[[DualSignInViewController alloc] initWithNibName:@"DualSignInViewController" bundle:nil];
        /*DualSignInViewController *dualSignInViewController=[[DualSignInViewController alloc] initWithNibName:@"DualSignInViewController" bundle:nil];
        UINavigationController *navController=[[UINavigationController alloc] initWithRootViewController:dualSignInViewController];
        self.navigationController=navController;
        self.navigationController.navigationBar.tintColor=[UIColor blackColor];
        self.window.rootViewController=self.navigationController;
        [self.window makeKeyAndVisible];
        [dualSignInViewController release];
        [navController release];*/
        
        StartPageViewController *startPageViewController = [[StartPageViewController alloc] initWithNibName:@"StartPageViewcontroller" bundle:nil];
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:startPageViewController];
        self.navigationController = navController;
        self.navigationController.navigationBar.tintColor = [UIColor blackColor];
        self.window.rootViewController=self.navigationController;
        [self.window makeKeyAndVisible];
    }
    [ud synchronize];
}

-(void)initFB
{
    // Initialize Facebook
    facebook = [[Facebook alloc] initWithAppId:kAppId andDelegate:[FacebookFacade sharedInstance]];
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    
    // Check and retrieve authorization information
    if ([defaults objectForKey:@"FBAccessTokenKey"] && [defaults objectForKey:@"FBExpirationDateKey"]) {
        facebook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
        facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
    }
    
    // Initialize API data (for views, etc.)
    //apiData = [[DataSet alloc] init];
    
    // Initialize user permissions
    userPermissions = [[NSMutableDictionary alloc] initWithCapacity:1];
    
    // Check App ID:
    // This is really a warning for the developer, this should not
    // happen in a completed app
    if (!kAppId) {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Setup Error"
                                  message:@"Missing app ID. You cannot run the app until you provide this in the code."
                                  delegate:self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil,
                                  nil];
        [alertView show];
    } else {
        // Now check that the URL scheme fb[app_id]://authorize is in the .plist and can
        // be opened, doing a simple check without local app id factored in here
        NSString *url = [NSString stringWithFormat:@"fb%@://authorize",kAppId];
        BOOL bSchemeInPlist = NO; // find out if the sceme is in the plist file.
        NSArray* aBundleURLTypes = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleURLTypes"];
        if ([aBundleURLTypes isKindOfClass:[NSArray class]] &&
            ([aBundleURLTypes count] > 0)) {
            NSDictionary* aBundleURLTypes0 = [aBundleURLTypes objectAtIndex:0];
            if ([aBundleURLTypes0 isKindOfClass:[NSDictionary class]]) {
                NSArray* aBundleURLSchemes = [aBundleURLTypes0 objectForKey:@"CFBundleURLSchemes"];
                if ([aBundleURLSchemes isKindOfClass:[NSArray class]] &&
                    ([aBundleURLSchemes count] > 0)) {
                    NSString *scheme = [aBundleURLSchemes objectAtIndex:0];
                    if ([scheme isKindOfClass:[NSString class]] &&
                        [url hasPrefix:scheme]) {
                        bSchemeInPlist = YES;
                    }
                }
            }
        }
        // Check if the authorization callback will work
        BOOL bCanOpenUrl = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString: url]];
        if (!bSchemeInPlist || !bCanOpenUrl) {
            UIAlertView *alertView = [[UIAlertView alloc]
                                      initWithTitle:@"Setup Error"
                                      message:@"Invalid or missing URL scheme. You cannot run the app until you set up a valid URL scheme in your .plist."
                                      delegate:self
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil,
                                      nil];
            [alertView show];
        }
        else
        {
        }
    }

}

#pragma mark -

+ (void)initialize
{
    //configure iRate
    [iRate sharedInstance].appStoreID = 501977872;
    [iRate sharedInstance].applicationName = @"PaidPunch";
    [iRate sharedInstance].applicationBundleID = @"com.PaidPunch.CustomerApp";
    [iRate sharedInstance].daysUntilPrompt = 4;
    [iRate sharedInstance].usesUntilPrompt = 4;
    [iRate sharedInstance].eventsUntilPrompt = 8;
    [iRate sharedInstance].messageTitle = @"We want to hear from you!";
    [iRate sharedInstance].message = @"Do you love PaidPunch? Please take a few seconds out of your day to let us know how we're doing and rate PaidPunch in the App Store!";
    [iRate sharedInstance].cancelButtonLabel = @"No, Thanks";
    [iRate sharedInstance].rateButtonLabel = @"Rate Now";
    [iRate sharedInstance].remindButtonLabel = @"Rate Later";

}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //Splash screen waiting time
	[NSThread sleepForTimeInterval:1];
    
    ////////////////////// Select device language for app //////////////////
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSArray *languages = [defaults objectForKey:@"AppleLanguages"];
	NSString *currentLanguage = [languages objectAtIndex:0];	
	NSLog(@"Current Locale: %@", [[NSLocale currentLocale] localeIdentifier]);
	NSLog(@"Current language: %@", currentLanguage);
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
   
    permissions=[[NSMutableArray alloc] initWithObjects:@"read_friendlists", @"user_about_me", @"publish_stream",@"email", nil];
    

    /*NSString *url=@"https://122.179.131.164:8186/paid_punch";
    //NSString *url=@"https://192.168.1.28:8443/paid_punch";
    [[InfoExpert sharedInstance] setAppUrl:url];
    [defaults setObject:url forKey:@"appUrl"];
    [defaults synchronize];*/
    
    if([[InfoExpert sharedInstance] totalMilesValue]==nil || [[InfoExpert sharedInstance] totalMilesValue]==0)
        [[InfoExpert sharedInstance] setTotalMilesValue:[NSNumber numberWithInt:10]];
    
    CLLocation *loc=[[CLLocation alloc] init];
    self.currentLocation=loc;
    CLLocationManager *locMgr=[[CLLocationManager alloc] init];
    self.locationManager=locMgr;
    self.locationManager.delegate=self;
    if([CLLocationManager locationServicesEnabled])
        [self.locationManager startUpdatingLocation];
    
    [self initFB];
    [self initView];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
    //[[DatabaseManager sharedInstance] deleteOtherPunchCards];
    [self saveContext];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
    NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
    NSString *appUrl=[ud objectForKey:@"appUrl"];
    [[InfoExpert sharedInstance] setAppUrl:appUrl];
    if([[InfoExpert sharedInstance] totalMilesValue]==nil || [[InfoExpert sharedInstance] totalMilesValue]==0)
        [[InfoExpert sharedInstance] setTotalMilesValue:[NSNumber numberWithInt:10]];
    
    if([CLLocationManager locationServicesEnabled])
        [self.locationManager startUpdatingLocation];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
    [[self facebook] extendAccessTokenIfNeeded];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
     [self saveContext];
}


- (void)saveContext {
    
    NSError *error = nil;
	NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}    


#pragma mark -
#pragma mark Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)managedObjectContext {
    
    if (managedObjectContext_ != nil) {
        return managedObjectContext_;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext_ = [[NSManagedObjectContext alloc] init];
        [managedObjectContext_ setPersistentStoreCoordinator:coordinator];
    }
    return managedObjectContext_;
}


/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel {
    
    if (managedObjectModel_ != nil) {
        return managedObjectModel_;
    }
    NSString *modelPath = [[NSBundle mainBundle] pathForResource:@"paidPunch" ofType:@"momd"];
    NSURL *modelURL = [NSURL fileURLWithPath:modelPath];
    managedObjectModel_ = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];    
    return managedObjectModel_;
}

/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    
    if (persistentStoreCoordinator_ != nil) {
        return persistentStoreCoordinator_;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"paidPunch.sqlite"];
    
    NSError *error = nil;
    persistentStoreCoordinator_ = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    
    //added by deepti
    NSMutableDictionary *options=[[NSMutableDictionary alloc] init] ;
    [options setObject:[NSNumber numberWithBool:YES] forKey:NSMigratePersistentStoresAutomaticallyOption];
    [options setObject:[NSNumber numberWithBool:YES] forKey:NSInferMappingModelAutomaticallyOption];
    
    /*NSDictionary *options=[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],NSMigratePersistentStoresAutomaticallyOption,[NSNumber numberWithBool:YES],NSInferMappingModelAutomaticallyOption,nil];*/
    
    // if (![persistentStoreCoordinator_ addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
    if (![persistentStoreCoordinator_ addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter: 
         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    return persistentStoreCoordinator_;
}


#pragma mark -
#pragma mark Application's Documents directory

/**
 Returns the URL to the application's Documents directory.
 */
- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [self.facebook handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [self.facebook handleOpenURL:url];
}

#pragma mark -
#pragma mark CLLocationManagerDelegate methods Implementation
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    if(abs([newLocation.timestamp timeIntervalSinceDate:[NSDate date]]<120))
    {
        self.currentLocation=newLocation;
    }
    [locationManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [locationManager stopUpdatingLocation];
    switch ([error code]) {
        case kCLErrorLocationUnknown:
            break;
        case kCLErrorDenied:
        {
            /*UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"Whoops!" message:@"We could not find your current location. Make sure you are sharing your location with us. Go to Settings >> Location Services >> PaidPunch." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
            [alertView release];*/
        }
            break;
        default:
        {
            UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"Error" message:[error description] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
        }
            break;
    }
}



@end
