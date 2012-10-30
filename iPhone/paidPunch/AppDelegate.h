//
//  AppDelegate.h
//  paidPunch
//
//  Created by mobimedia technologies on 24/11/11.
//  Copyright (c) 2011 mobimedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <CoreLocation/CoreLocation.h>
#import <QuartzCore/QuartzCore.h>
#import "PaidPunchTabBarController.h"
#import "InfoExpert.h"
#import "FBConnect.h"
#import "FacebookFacade.h"
#import "Common/MBProgressHUD.h"

@class DualSignInViewController, StartPageViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate,CLLocationManagerDelegate>
{
    @private
    NSManagedObjectContext *managedObjectContext_;
    NSManagedObjectModel *managedObjectModel_;
    NSPersistentStoreCoordinator *persistentStoreCoordinator_;
    UINavigationController *navigationController;
    Facebook *facebook;
    NSMutableDictionary *userPermissions;
    NSMutableArray *permissions;
    
    
    CLLocationManager *locationManager;
    CLLocation *currentLocation;
   
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UIViewController *viewController;
@property (nonatomic,retain) UINavigationController *navigationController;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic,retain) NSMutableArray *permissions;
@property (nonatomic, retain) Facebook *facebook;
@property (nonatomic, retain) NSMutableDictionary *userPermissions;
@property(nonatomic,retain) CLLocationManager *locationManager;
@property(nonatomic,retain) CLLocation *currentLocation;

- (NSURL*)applicationDocumentsDirectory;
- (void) saveContext;
- (void) customizeApperance;
- (void) initView;
- (void) initFB;

@end
