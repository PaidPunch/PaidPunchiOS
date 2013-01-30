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
#import "Common/MBProgressHUD.h"
#import "FacebookFacade.h"
#import "FBConnect.h"
#import "PaidPunchTabBarController.h"
#import "User.h"

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
    
    UIViewController* _rootController;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UIViewController *viewController;
@property (nonatomic,strong) UINavigationController *navigationController;
@property (nonatomic, strong, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic,strong) NSMutableArray *permissions;
@property (nonatomic, strong) Facebook *facebook;
@property (nonatomic, strong) NSMutableDictionary *userPermissions;
@property(nonatomic,strong) CLLocationManager *locationManager;
@property(nonatomic,strong) CLLocation *currentLocation;
@property(nonatomic,strong) UIViewController* rootController;

- (NSURL*)applicationDocumentsDirectory;
- (void) saveContext;
- (void) customizeApperance;
- (void) initView;
- (void) initFB;

@end
