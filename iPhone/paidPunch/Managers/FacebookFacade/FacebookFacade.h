//
//  FacebookFacade.h
//  paidPunch
//
//  Created by mobimedia technologies on 03/04/12.
//  Copyright (c) 2012 mobimedia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import "Facebook.h"
#import "FacebookPaidPunchDelegate.h"
#import "MBProgressHUD.h"

@class FeedsTableViewController;
@class PunchCardOfferViewController;
@class PunchUsedViewController;

typedef enum apiCall {
    kAPILogin,
    kAPILogout,
    kAPIGraphUserPermissionsDelete,
    kDialogPermissionsExtended,
    kDialogRequestsSendToMany,
    kAPIGetAppUsersFriendsNotUsing,
    kAPIGetAppUsersFriendsUsing,
    kAPIFriendsForDialogRequests,
    kDialogRequestsSendToSelect,
    kAPIFriendsForTargetDialogRequests,
    kDialogRequestsSendToTarget,
    kDialogFeedUser,
    kAPIFriendsForDialogFeed,
    kDialogFeedFriend,
    kAPIGraphUserPermissions,
    kAPIGraphMe,
    kAPIGraphUserFriends,
    kDialogPermissionsCheckin,
    kDialogPermissionsCheckinForRecent,
    kDialogPermissionsCheckinForPlaces,
    kAPIGraphSearchPlace,
    kAPIGraphUserCheckins,
    kAPIGraphUserPhotosPost,
    kAPIGraphUserVideosPost,
} apiCall;


@interface FacebookFacade : NSObject<FBRequestDelegate,FBDialogDelegate,FBSessionDelegate>
{
    int currentAPICall;
    NSMutableArray *savedAPIResult;    
    UIView *activityView;
    MBProgressHUD *popupHUD;
    __weak NSObject<FacebookPaidPunchDelegate>* _callbackDelegate;
}

@property (nonatomic, strong) NSMutableArray *savedAPIResult;

@property (nonatomic, weak) FeedsTableViewController *feedsViewController;
@property (nonatomic, weak) PunchUsedViewController *punchUsedViewController;
@property (nonatomic, weak) PunchCardOfferViewController *punchCardOfferViewController;
@property (nonatomic, weak) NSObject<FacebookPaidPunchDelegate>* callbackDelegate;

+ (id)sharedInstance;

- (void)userDidGrantPermission;

- (void)userDidNotGrantPermission;

- (void)showActivityIndicator;
- (void)hideActivityIndicator;
- (void)showMessage:(NSString *)message;
- (void)hideMessage;

- (NSDictionary *)parseURLParams:(NSString *)query;
- (void)updateCheckinPermissions;


- (void)apiLogin;
- (void)apiLogout;
- (void)getUserFriends;
- (void)storeAuthData:(NSString *)accessToken expiresAt:(NSDate *)expiresAt; 

@end
