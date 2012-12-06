//
//  FacebookFacade.m
//  paidPunch
//
//  Created by mobimedia technologies on 03/04/12.
//  Copyright (c) 2012 mobimedia. All rights reserved.
//

#import "DualSignInViewController.h"
#import "FacebookFacade.h"
#import "FeedsTableViewController.h"
#import "PunchCardOfferViewController.h"

@implementation FacebookFacade
@synthesize savedAPIResult;
@synthesize feedsViewController;
@synthesize punchUsedViewController;
@synthesize punchCardOfferViewController;
@synthesize dualSignInViewController;

static FacebookFacade *sharedInstance=nil;

+(FacebookFacade *)sharedInstance{
	
	if(sharedInstance==nil)
	{
		sharedInstance=[[super allocWithZone:NULL]init];
        //childIndex = index;
        sharedInstance.savedAPIResult = [[NSMutableArray alloc] initWithCapacity:1];
	}
	return sharedInstance;
}

+(id)allocWithZone:(NSZone *)zone{
	return [self sharedInstance];
}

-(id)copyWithZone:(NSZone *)zone{
	return self;
}




-(void)apiLogin
{
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (![[delegate facebook] isSessionValid]) {
        currentAPICall = kAPILogin;
        [[delegate facebook] authorize:[delegate permissions]];
    } 
    else
    {
        [self.feedsViewController loggedIn];
        [self.dualSignInViewController loggedIn];
        [self.punchUsedViewController loggedIn];
        [self.punchCardOfferViewController loggedIn];
    }
}
/*
 * Graph API: Method to get the user's friends.
 */
- (void)apiGraphFriends {
    [self showActivityIndicator];
    // Do not set current API as this is commonly called by other methods
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [[delegate facebook] requestWithGraphPath:@"me/friends" andDelegate:self];
}

/*
 * Graph API: Method to get the user's permissions for this app.
 */
- (void)apiGraphUserPermissions {
    [self showActivityIndicator];
    currentAPICall = kAPIGraphUserPermissions;
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [[delegate facebook] requestWithGraphPath:@"me/permissions" andDelegate:self];
}

/*
 * Dialog: Authorization to grant the app check-in permissions.
 */
- (void)apiPromptCheckinPermissions {
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSArray *checkinPermissions = [[NSArray alloc] initWithObjects:@"user_checkins", @"publish_checkins", nil];
    [[delegate facebook] authorize:checkinPermissions];
}

/*
 * --------------------------------------------------------------------------
 * Login and Permissions
 * --------------------------------------------------------------------------
 */

/*
 * iOS SDK method that handles the logout API call and flow.
 */
- (void)apiLogout {
    currentAPICall = kAPILogout;
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [[delegate facebook] logout];
}

/*
 * Graph API: App unauthorize
 */
- (void)apiGraphUserPermissionsDelete {
    [self showActivityIndicator];
    currentAPICall = kAPIGraphUserPermissionsDelete;
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    // Passing empty (no) parameters unauthorizes the entire app. To revoke individual permissions
    // add a permission parameter with the name of the permission to revoke.
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:nil];
    [[delegate facebook] requestWithGraphPath:@"me/permissions"
                                    andParams:params
                                andHttpMethod:@"DELETE"
                                  andDelegate:self];
}

/*
 * Dialog: Authorization to grant the app user_likes permission.
 */
- (void)apiPromptExtendedPermissions {
    currentAPICall = kDialogPermissionsExtended;
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSArray *extendedPermissions = [[NSArray alloc] initWithObjects:@"user_likes", nil];
    [[delegate facebook] authorize:extendedPermissions];
}

/**
 * --------------------------------------------------------------------------
 * News Feed
 * --------------------------------------------------------------------------
 */

/*
 * Dialog: Feed for the user
 */
- (void)apiDialogFeedUser {
    currentAPICall = kDialogFeedUser;
    SBJSON *jsonWriter = [SBJSON new];
    
    // The action links to be shown with the post in the feed
    NSArray* actionLinks = [NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:
                                                      @"Get Started",@"name",@"http://m.facebook.com/apps/hackbookios/",@"link", nil], nil];
    NSString *actionLinksStr = [jsonWriter stringWithObject:actionLinks];
    // Dialog parameters
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"I'm using the Hackbook for iOS app", @"name",
                                   @"Hackbook for iOS.", @"caption",
                                   @"Check out Hackbook for iOS to learn how you can make your iOS apps social using Facebook Platform.", @"description",
                                   @"http://m.facebook.com/apps/hackbookios/", @"link",
                                   @"http://www.facebookmobileweb.com/hackbook/img/facebook_icon_large.png", @"picture",
                                   actionLinksStr, @"actions",
                                   nil];
    
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [[delegate facebook] dialog:@"feed"
                      andParams:params
                    andDelegate:self];
    
}

/*
 * Helper method to first get the user's friends then
 * pick one friend and post on their wall.
 */
- (void)getFriendsCallAPIDialogFeed {
    // Call the friends API first, then set up for targeted Feed Dialog
    currentAPICall = kAPIFriendsForDialogFeed;
    [self apiGraphFriends];
}

/*
 * Dialog: Feed for friend
 */
- (void)apiDialogFeedFriend:(NSString *)friendID {
    currentAPICall = kDialogFeedFriend;
    SBJSON *jsonWriter = [SBJSON new];
    
    NSArray* actionLinks = [NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:
                                                      @"Get Started",@"name",@"http://m.facebook.com/apps/hackbookios/",@"link", nil], nil];
    NSString *actionLinksStr = [jsonWriter stringWithObject:actionLinks];
    // The "to" parameter targets the post to a friend
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   friendID, @"to",
                                   @"I'm using the Hackbook for iOS app", @"name",
                                   @"Hackbook for iOS.", @"caption",
                                   @"Check out Hackbook for iOS to learn how you can make your iOS apps social using Facebook Platform.", @"description",
                                   @"http://m.facebook.com/apps/hackbookios/", @"link",
                                   @"http://www.facebookmobileweb.com/hackbook/img/facebook_icon_large.png", @"picture",
                                   actionLinksStr, @"actions",
                                   nil];
    
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [[delegate facebook] dialog:@"feed"
                      andParams:params
                    andDelegate:self];
    
}

/*
 * --------------------------------------------------------------------------
 * Requests
 * --------------------------------------------------------------------------
 */

/*
 * Dialog: Requests - send to all.
 */
- (void)apiDialogRequestsSendToMany {
    currentAPICall = kDialogRequestsSendToMany;
    SBJSON *jsonWriter = [SBJSON new];
    NSDictionary *gift = [NSDictionary dictionaryWithObjectsAndKeys:
                          @"5", @"social_karma",
                          @"1", @"badge_of_awesomeness",
                          nil];
    
    NSString *giftStr = [jsonWriter stringWithObject:gift];
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"Learn how to make your iOS apps social.",  @"message",
                                   @"Check this out", @"notification_text",
                                   giftStr, @"data",
                                   nil];
    
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [[delegate facebook] dialog:@"apprequests"
                      andParams:params
                    andDelegate:self];
}

/*
 * API: Legacy REST for getting the friends using the app. This is a helper method
 * being used to target app requests in follow-on examples.
 */
- (void)apiRESTGetAppUsers {
    [self showActivityIndicator];
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"friends.getAppUsers", @"method",
                                   nil];
    [[delegate facebook] requestWithParams:params
                               andDelegate:self];
}

/*
 * Dialog: Requests - send to friends not currently using the app.
 */
- (void)apiDialogRequestsSendToNonUsers:(NSArray *)selectIDs {
    currentAPICall = kDialogRequestsSendToSelect;
    NSString *selectIDsStr = [selectIDs componentsJoinedByString:@","];
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"Learn how to make your iOS apps social.",  @"message",
                                   @"Check this out", @"notification_text",
                                   selectIDsStr, @"suggestions",
                                   nil];
    
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [[delegate facebook] dialog:@"apprequests"
                      andParams:params
                    andDelegate:self];
}

/*
 * Dialog: Requests - send to select users, in this case friends
 * that are currently using the app.
 */
- (void)apiDialogRequestsSendToUsers:(NSArray *)selectIDs {
    currentAPICall = kDialogRequestsSendToSelect;
    NSString *selectIDsStr = [selectIDs componentsJoinedByString:@","];
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"It's your turn to visit the Hackbook for iOS app.",  @"message",
                                   selectIDsStr, @"suggestions",
                                   nil];
    
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [[delegate facebook] dialog:@"apprequests"
                      andParams:params
                    andDelegate:self];
}

/*
 * Dialog: Request - send to a targeted friend.
 */
- (void)apiDialogRequestsSendTarget:(NSString *)friend {
    currentAPICall = kDialogRequestsSendToTarget;
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"Learn how to make your iOS apps social.",  @"message",
                                   friend, @"to",
                                   nil];
    
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [[delegate facebook] dialog:@"apprequests"
                      andParams:params
                    andDelegate:self];
}

/*
 * Helper method to get friends using the app which will in turn
 * send a request to NON users.
 */
- (void)getAppUsersFriendsNotUsing {
    currentAPICall = kAPIGetAppUsersFriendsNotUsing;
    [self apiRESTGetAppUsers];
}

/*
 * Helper method to get friends using the app which will in turn
 * send a request to current app users.
 */
- (void)getAppUsersFriendsUsing {
    currentAPICall = kAPIGetAppUsersFriendsUsing;
    [self apiRESTGetAppUsers];
}

/*
 * Helper method to get the users friends which will in turn
 * pick one to send a request.
 */
- (void)getUserFriendTargetDialogRequest {
    currentAPICall = kAPIFriendsForTargetDialogRequests;
    [self apiGraphFriends];
}

/*
 * --------------------------------------------------------------------------
 * Graph API
 * --------------------------------------------------------------------------
 */

/*
 * Graph API: Get the user's basic information, picking the name and picture fields.
 */
- (void)apiGraphMe {
    [self showActivityIndicator];
    currentAPICall = kAPIGraphMe;
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"name,picture",  @"fields",
                                   nil];
    [[delegate facebook] requestWithGraphPath:@"me" andParams:params andDelegate:self];
}

/*
 * Graph API: Get the user's friends
 */
- (void)getUserFriends {
    currentAPICall = kAPIGraphUserFriends;
    [self apiGraphFriends];
}

/*
 * Graph API: Get the user's check-ins
 */
- (void)apiGraphUserCheckins {
    [self showActivityIndicator];
    currentAPICall = kAPIGraphUserCheckins;
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [[delegate facebook] requestWithGraphPath:@"me/checkins" andDelegate:self];
}

/*
 * Helper method to check the user permissions which were stored in the app session
 * when the app was started. After the check decide on whether to prompt for user
 * check-in permissions first or get the check-in information.
 */
- (void)getPermissionsCallUserCheckins {
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if ([[delegate userPermissions] objectForKey:@"user_checkins"]) {
        [self apiGraphUserCheckins];
    } else {
        currentAPICall = kDialogPermissionsCheckinForRecent;
        [self apiPromptCheckinPermissions];
    }
}

/*
 * Graph API: Search query to get nearby location.
 */
- (void)apiGraphSearchPlace:(CLLocation *)location {
    [self showActivityIndicator];
    currentAPICall = kAPIGraphSearchPlace;
    NSString *centerLocation = [[NSString alloc] initWithFormat:@"%f,%f",
                                location.coordinate.latitude,
                                location.coordinate.longitude];
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"place",  @"type",
                                   centerLocation, @"center",
                                   @"1000",  @"distance",
                                   nil];
    [[delegate facebook] requestWithGraphPath:@"search" andParams:params andDelegate:self];
}

/*
 * Helper method to check the user permissions which were stored in the app session
 * when the app was started. After the check decide on whether to prompt for user
 * check-in permissions first or get the user's location which will in turn search
 * for nearby places the user can then check-in to.
 */
- (void)getPermissionsCallNearby {
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if ([[delegate userPermissions] objectForKey:@"publish_checkins"]) {
    } else {
        currentAPICall = kDialogPermissionsCheckinForPlaces;
        [self apiPromptCheckinPermissions];
    }
}

/*
 * Graph API: Upload a photo. By default, when using me/photos the photo is uploaded
 * to the application album which is automatically created if it does not exist.
 */
- (void)apiGraphUserPhotosPost {
    [self showActivityIndicator];
    currentAPICall = kAPIGraphUserPhotosPost;
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    // Download a sample photo
    NSURL *url = [NSURL URLWithString:@"http://www.facebook.com/images/devsite/iphone_connect_btn.jpg"];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *img  = [[UIImage alloc] initWithData:data];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   img, @"picture",
                                   nil];
    [[delegate facebook] requestWithGraphPath:@"me/photos"
                                    andParams:params
                                andHttpMethod:@"POST"
                                  andDelegate:self];
}

/*
 * Graph API: Post a video to the user's wall.
 */
- (void)apiGraphUserVideosPost {
    [self showActivityIndicator];
    currentAPICall = kAPIGraphUserVideosPost;
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    // Download a sample video
    NSURL *url = [NSURL URLWithString:@"https://developers.facebook.com/attachment/sample.mov"];
    NSData *data = [NSData dataWithContentsOfURL:url];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   data, @"video.mov",
                                   @"video/quicktime", @"contentType",
                                   @"Video Test Title", @"title",
                                   @"Video Test Description", @"description",
								   nil];
	[[delegate facebook] requestWithGraphPath:@"me/videos"
                                    andParams:params
                                andHttpMethod:@"POST"
                                  andDelegate:self];
}


#pragma mark - FBRequestDelegate Methods
/**
 * Called when the Facebook API request has returned a response. This callback
 * gives you access to the raw response. It's called before
 * (void)request:(FBRequest *)request didLoad:(id)result,
 * which is passed the parsed response object.
 */
- (void)request:(FBRequest *)request didReceiveResponse:(NSURLResponse *)response {
    //NSLog(@"received response");
}

/**
 * Called when a request returns and its response has been parsed into
 * an object. The resulting object may be a dictionary, an array, a string,
 * or a number, depending on the format of the API response. If you need access
 * to the raw response, use:
 *
 * (void)request:(FBRequest *)request
 *      didReceiveResponse:(NSURLResponse *)response
 */
- (void)request:(FBRequest *)request didLoad:(id)result {
    [self hideActivityIndicator];
    if ([result isKindOfClass:[NSArray class]] && ([result count] > 0)) {
        result = [result objectAtIndex:0];
    }
    switch (currentAPICall) {
        case kAPIGraphUserPermissionsDelete:
        {
            [self showMessage:@"User uninstalled app"];
            AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            // Nil out the session variables to prevent
            // the app from thinking there is a valid session
            [delegate facebook].accessToken = nil;
            [delegate facebook].expirationDate = nil;
            
            // Notify the root view about the logout.
            /*RootViewController *rootViewController = (RootViewController *)[[self.navigationController viewControllers] objectAtIndex:0];
            [rootViewController fbDidLogout];*/
            break;
        }
        case kAPIFriendsForDialogFeed:
        {
            NSArray *resultData = [result objectForKey: @"data"];
            // Check that the user has friends
            if ([resultData count] > 0) {
                // Pick a random friend to post the feed to
                int randomNumber = arc4random() % [resultData count];
                [self apiDialogFeedFriend: 
                 [[resultData objectAtIndex: randomNumber] objectForKey: @"id"]];
            } else {
                [self showMessage:@"You do not have any friends to post to."];
            }
            break;
        }
        case kAPIGetAppUsersFriendsNotUsing:
        {
            // Save friend results
            savedAPIResult = nil;
            // Many results
            if ([result isKindOfClass:[NSArray class]]) {
                savedAPIResult = [[NSMutableArray alloc] initWithArray:result copyItems:YES];
            } else if ([result isKindOfClass:[NSDecimalNumber class]]) {
                savedAPIResult = [[NSMutableArray alloc] initWithObjects:[result stringValue], nil];
            }
            
            // Set up to get friends
            currentAPICall = kAPIFriendsForDialogRequests;
            [self apiGraphFriends];
            break;
        }
        case kAPIGetAppUsersFriendsUsing:
        {
            NSMutableArray *friendsWithApp = [[NSMutableArray alloc] initWithCapacity:1];
            // Many results
            if ([result isKindOfClass:[NSArray class]]) {
                friendsWithApp = [[NSMutableArray alloc] initWithArray:result copyItems:YES];
            } else if ([result isKindOfClass:[NSDecimalNumber class]]) {
                friendsWithApp = [[NSMutableArray alloc] initWithObjects:[result stringValue], nil];
            }
            if ([friendsWithApp count] > 0) {
                [self apiDialogRequestsSendToUsers:friendsWithApp];
            } else {
                [self showMessage:@"None of your friends are using the app."];
            }
            break;
        }
        case kAPIFriendsForDialogRequests:
        {
            NSArray *resultData = [result objectForKey:@"data"];
            if ([resultData count] == 0) {
                [self showMessage:@"You have no friends to select."];
            } else {
                NSMutableArray *friendsWithoutApp = [[NSMutableArray alloc] initWithCapacity:1];
                // Loop through friends and find those who do not have the app
                for (NSDictionary *friendObject in resultData) {
                    BOOL foundFriend = NO;
                    for (NSString *friendWithApp in savedAPIResult) {
                        if ([[friendObject objectForKey:@"id"] isEqualToString:friendWithApp]) {
                            foundFriend = YES;
                            break;
                        }
                    }
                    if (!foundFriend) {
                        [friendsWithoutApp addObject:[friendObject objectForKey:@"id"]];
                    }
                }
                if ([friendsWithoutApp count] > 0) {
                    [self apiDialogRequestsSendToNonUsers:friendsWithoutApp];
                } else {
                    [self showMessage:@"All your friends are using the app."];
                }
            }
            break;
        }
        case kAPIFriendsForTargetDialogRequests:
        {
            NSArray *resultData = [result objectForKey: @"data"];
            // got friends?
            if ([resultData count] > 0) { 
                // pick a random one to send a request to
                int randomIndex = arc4random() % [resultData count];	
                NSString* randomFriend = 
                [[resultData objectAtIndex: randomIndex] objectForKey: @"id"];
                [self apiDialogRequestsSendTarget:randomFriend];
            } else {
                [self showMessage: @"You have no friends to select."];
            }
            break;
        }
        case kAPIGraphMe:
        {
            NSString *nameID = [[NSString alloc] initWithFormat: @"%@ (%@)", 
                                [result objectForKey:@"name"], 
                                [result objectForKey:@"id"]];
            NSMutableArray *userData = [[NSMutableArray alloc] initWithObjects:
                                        [NSDictionary dictionaryWithObjectsAndKeys:
                                         [result objectForKey:@"id"], @"id",
                                         nameID, @"name",
                                         [result objectForKey:@"picture"], @"details",
                                         nil], nil];
            // Show the basic user information in a new view controller
            /*APIResultsViewController *controller = [[APIResultsViewController alloc]
                                                    initWithTitle:@"Your Information"
                                                    data:userData
                                                    action:@""];
            [self.navigationController pushViewController:controller animated:YES];
            [controller release];*/
            break;
        }
        case kAPIGraphUserFriends:
        {
            NSMutableArray *friends = [[NSMutableArray alloc] initWithCapacity:1];
            NSArray *resultData = [result objectForKey:@"data"];
            if ([resultData count] > 0) {
                for (NSUInteger i=0; i<[resultData count] && i < 25; i++) {
                    [friends addObject:[resultData objectAtIndex:i]];
                }
                // Show the friend information in a new view controller
                /*APIResultsViewController *controller = [[APIResultsViewController alloc]
                                                        initWithTitle:@"Friends"
                                                        data:friends action:@""];
                [self.navigationController pushViewController:controller animated:YES];
                [controller release];*/
                [[self feedsViewController] getFeeds:result];
            } else {
                [self showMessage:@"You have no friends."];
                [self.feedsViewController getFeeds:nil];
            }
            break;
        }
        case kAPIGraphUserCheckins:
        {
            NSMutableArray *places = [[NSMutableArray alloc] initWithCapacity:1];
            NSArray *resultData = [result objectForKey:@"data"];
            for (NSUInteger i=0; i<[resultData count] && i < 5; i++) {
                NSString *placeID = [[[resultData objectAtIndex:i] objectForKey:@"place"] objectForKey:@"id"];
                NSString *placeName = [[[resultData objectAtIndex:i] objectForKey:@"place"] objectForKey:@"name"];
                NSString *checkinMessage = [[resultData objectAtIndex:i] objectForKey:@"message"] ?
                [[resultData objectAtIndex:i] objectForKey:@"message"] : @"";
                [places addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                   placeID,@"id",
                                   placeName,@"name",
                                   checkinMessage,@"details",
                                   nil]];
            }
            // Show the user's recent check-ins a new view controller
            /*APIResultsViewController *controller = [[APIResultsViewController alloc]
                                                    initWithTitle:@"Recent Check-ins"
                                                    data:places
                                                    action:@"recentcheckins"];
            [self.navigationController pushViewController:controller animated:YES];
            [controller release];*/
            break;
        }
        case kAPIGraphSearchPlace:
        {
            NSMutableArray *places = [[NSMutableArray alloc] initWithCapacity:1];
            NSArray *resultData = [result objectForKey:@"data"];
            for (NSUInteger i=0; i<[resultData count] && i < 5; i++) {
                [places addObject:[resultData objectAtIndex:i]];
            }
            // Show the places nearby in a new view controller
            /*APIResultsViewController *controller = [[APIResultsViewController alloc]
                                                    initWithTitle:@"Nearby"
                                                    data:places
                                                    action:@"places"];
            [self.navigationController pushViewController:controller animated:YES];
            [controller release];*/
            break;
        }
        case kAPIGraphUserPhotosPost:
        {
            [self showMessage:@"Photo uploaded successfully."];
            break;
        }
        case kAPIGraphUserVideosPost:
        {
            [self showMessage:@"Video uploaded successfully."];
            break;
        }
        default:
            break;
    }
}

/**
 * Called when an error prevents the Facebook API request from completing
 * successfully.
 */
- (void)request:(FBRequest *)request didFailWithError:(NSError *)error {
    [self hideActivityIndicator];
    NSLog(@"Error message: %@", [[error userInfo] objectForKey:@"error_msg"]);
    [self showMessage:@"Oops, something went haywire."];
}

#pragma mark - FBDialogDelegate Methods

/**
 * Called when a UIServer Dialog successfully return. Using this callback
 * instead of dialogDidComplete: to properly handle successful shares/sends
 * that return ID data back.
 */
- (void)dialogCompleteWithUrl:(NSURL *)url {
    if (![url query]) {
        NSLog(@"User canceled dialog or there was an error");
        return;
    }
    
    NSDictionary *params = [self parseURLParams:[url query]];
    switch (currentAPICall) {
        case kDialogFeedUser:
        case kDialogFeedFriend:
        {
            // Successful posts return a post_id
            if ([params valueForKey:@"post_id"]) {
                [self showMessage:@"Published feed successfully."];
                NSLog(@"Feed post ID: %@", [params valueForKey:@"post_id"]);
            }
            break;
        }
        case kDialogRequestsSendToMany:
        case kDialogRequestsSendToSelect:
        case kDialogRequestsSendToTarget:
        {
            // Successful requests return one or more request_ids.
            // Get any request IDs, will be in the URL in the form
            // request_ids[0]=1001316103543&request_ids[1]=10100303657380180
            NSMutableArray *requestIDs = [[NSMutableArray alloc] init];
            for (NSString *paramKey in params) {
                if ([paramKey hasPrefix:@"request_ids"]) {
                    [requestIDs addObject:[params objectForKey:paramKey]];
                }
            }
            if ([requestIDs count] > 0) {
                [self showMessage:@"Sent request successfully."];
                NSLog(@"Request ID(s): %@", requestIDs);
            }
            break;
        }
        default:
            break;
    }
}

- (void)dialogDidNotComplete:(FBDialog *)dialog {
    NSLog(@"Dialog dismissed.");
}

- (void)dialog:(FBDialog*)dialog didFailWithError:(NSError *)error {
    NSLog(@"Error message: %@", [[error userInfo] objectForKey:@"error_msg"]);
    [self showMessage:@"Oops, something went haywire."];
}

/**
 * Called when the user granted additional permissions.
 */
- (void)userDidGrantPermission {
    // After permissions granted follow up with next API call
    switch (currentAPICall) {
        case kDialogPermissionsCheckinForRecent:
        {
            // After the check-in permissions have been
            // granted, save them in app session then
            // retrieve recent check-ins
            [self updateCheckinPermissions];
            [self apiGraphUserCheckins];
            break;
        }
        case kDialogPermissionsCheckinForPlaces:
        {
            // After the check-in permissions have been
            // granted, save them in app session then
            // get nearby locations
            break;
        }
        case kDialogPermissionsExtended:
        {
            // In the sample test for getting user_likes
            // permssions, echo that success.
            [self showMessage:@"Permissions granted."]; 
            break;
        }
        default:
            break;
    }
}

/**
 * Called when the user canceled the authorization dialog.
 */
- (void)userDidNotGrantPermission {
    [self showMessage:@"Extended permissions not granted."];
}


#pragma mark - FBSessionDelegate Methods
- (void)fbDidLogin {
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [self storeAuthData:[[delegate facebook] accessToken] expiresAt:[[delegate facebook] expirationDate]];
    
    [self.feedsViewController loggedIn];
    [self.dualSignInViewController loggedIn];
    [self.punchUsedViewController loggedIn];
    [self.punchCardOfferViewController loggedIn];
     [self userDidGrantPermission];
    //[self getUserProfileInfo];
}

-(void)fbDidExtendToken:(NSString *)accessToken expiresAt:(NSDate *)expiresAt {
    NSLog(@"token extended");
    [self storeAuthData:accessToken expiresAt:expiresAt];
}

-(void)fbDidNotLogin:(BOOL)cancelled {
    //[pendingApiCallsController userDidNotGrantPermission];
}

- (void)fbDidLogout {
    NSLog(@"FB Did Logout");
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"FBAccessTokenKey"];
    [defaults removeObjectForKey:@"FBExpirationDateKey"];
    [defaults synchronize];
    [self hideActivityIndicator];
}


/**
 * Called when the session has expired.
 */
- (void)fbSessionInvalidated {
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:@"Auth Exception"
                              message:@"Your session has expired."
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil,
                              nil];
    [alertView show];
    [self showActivityIndicator];
    [self fbDidLogout];
    
}

- (void)storeAuthData:(NSString *)accessToken expiresAt:(NSDate *)expiresAt {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:accessToken forKey:@"FBAccessTokenKey"];
    [defaults setObject:expiresAt forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
}

/*
 * This method shows the activity indicator and
 * deactivates the table to avoid user input.
 */
- (void)showActivityIndicator {
    
    /*NSArray *xibUIObjects =[[NSBundle mainBundle] loadNibNamed:@"NetworkActivity" owner:self options:nil];
    activityView= [xibUIObjects objectAtIndex:0];
    activityView.backgroundColor=[UIColor clearColor];
    //[self.view addSubview:activityView];*/
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    if(!popupHUD){
        popupHUD = [[MBProgressHUD alloc] initWithView:appDelegate.window];
        [appDelegate.window addSubview:popupHUD];
    }
    [popupHUD show:YES];
    /*[appDelegate.window addSubview:activityView];
    [((UIActivityIndicatorView *)[activityView viewWithTag:2]) setHidden:YES];
    ((UITextView *)[activityView viewWithTag:1]).hidden=YES;*/
}

/*
 * This method hides the activity indicator
 * and enables user interaction once more.
 */
- (void)hideActivityIndicator {
    /*if([activityView respondsToSelector:@selector(viewWithTag:)])
	{
        [activityView removeFromSuperview];
        activityView=nil;
    }*/
    [popupHUD hide:YES];
}


/*
 * This method is used to display API confirmation and
 * error messages to the user.
 */
- (void)showMessage:(NSString *)message {
    /*CGRect labelFrame = messageView.frame;
    labelFrame.origin.y = [UIScreen mainScreen].bounds.size.height - self.navigationController.navigationBar.frame.size.height - 20;
    messageView.frame = labelFrame;
    messageLabel.text = message;
    messageView.hidden = NO;
    
    // Use animation to show the message from the bottom then
    // hide it.
    [UIView animateWithDuration:0.5
                          delay:1.0
                        options: UIViewAnimationCurveEaseOut
                     animations:^{
                         CGRect labelFrame = messageView.frame;
                         labelFrame.origin.y -= labelFrame.size.height;
                         messageView.frame = labelFrame;
                     }
                     completion:^(BOOL finished){
                         if (finished) {
                             [UIView animateWithDuration:0.5
                                                   delay:3.0
                                                 options: UIViewAnimationCurveEaseOut
                                              animations:^{
                                                  CGRect labelFrame = messageView.frame;
                                                  labelFrame.origin.y += messageView.frame.size.height;
                                                  messageView.frame = labelFrame;
                                              }
                                              completion:^(BOOL finished){
                                                  if (finished) {
                                                      messageView.hidden = YES;
                                                      messageLabel.text = @"";
                                                  }
                                              }];
                         }
                     }];*/
}

/*
 * This method hides the message, only needed if view closed
 * and animation still going on.
 */
- (void)hideMessage {
    /*messageView.hidden = YES;
    messageLabel.text = @"";*/
}
#pragma mark - Private Helper Methods
/*
 * This method is called to store the check-in permissions
 * in the app session after the permissions have been updated.
 */
- (void)updateCheckinPermissions {
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [[delegate userPermissions] setObject:@"1" forKey:@"user_checkins"];
    [[delegate userPermissions] setObject:@"1" forKey:@"publish_checkins"];
}
/**
 * Helper method to parse URL query parameters
 */
- (NSDictionary *)parseURLParams:(NSString *)query {
	NSArray *pairs = [query componentsSeparatedByString:@"&"];
	NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
	for (NSString *pair in pairs) {
		NSArray *kv = [pair componentsSeparatedByString:@"="];
		NSString *val =
        [[kv objectAtIndex:1]
         stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
		[params setObject:val forKey:[kv objectAtIndex:0]];
	}
    return params;
}

@end
