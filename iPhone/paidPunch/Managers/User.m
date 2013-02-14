//
//  User.m
//  paidPunch
//
//  Created by Aaron Khoo on 12/11/12.
//  Copyright (c) 2012 PaidPunch. All rights reserved.
//

#import "AFClientManager.h"
#import "AFHTTPRequestOperation.h"
#import "AppDelegate.h"
#import "User.h"
#import "Utilities.h"

static NSString* const kKeyVersion = @"version";
static NSString* const kKeyUserId = @"user_id";
static NSString* const kKeyReferral = @"refer_code";
static NSString* const kKeyName = @"username";
static NSString* const kKeyEmail = @"email";
static NSString* const kKeyZipcode = @"zipcode";
static NSString* const kKeyUseZipcode = @"usezipcode";
static NSString* const kKeyPhone = @"mobile_no";
static NSString* const kTxType = @"txtype";
static NSString* const kKeyPassword = @"password";
static NSString* const kKeyNewPassword = @"new_password";
static NSString* const kKeyFacebook = @"fbid";
static NSString* const kKeyUniqueId = @"sessionid";
static NSString* const kKeyStatusMessage = @"statusMessage";
static NSString* const kKeyUserValidate = @"userValidated";
static NSString* const kKeyPaymentProfileCreated = @"isprofile_created";
static NSString* const kKeyTotalMiles = @"totalMiles";
static NSString* const kKeyCredits = @"credit";
static NSString* const kKeyUserCode = @"user_code";
static NSString* const kKeyLastUpdate = @"lastUpdate";
static NSString* const kEmailRegister = @"EMAIL-REGISTER";
static NSString* const kFacebookRegister = @"FACEBOOK-REGISTER";
static NSString* const kEmailLogin= @"EMAIL-LOGIN";
static NSString* const kFacebookLogin = @"FACEBOOK-LOGIN";
static NSString* const kPasswordChange = @"PASSWORD-CHANGE";
static NSString* const kInfoChange = @"INFO-CHANGE";
static NSString* const kUserFilename = @"user.sav";
static CLLocationDistance const kMaxDistance = 5000; // 5 kilometers

// 30 min refresh schedule
static double const refreshTime = -(30 * 60);
// 5 min refresh schedule
static double const locationRefreshTime = -(5 * 60);

@implementation User
@synthesize referralCode = _referralCode;
@synthesize userId = _userId;
@synthesize username = _username;
@synthesize email = _email;
@synthesize zipcode = _zipcode;
@synthesize phone = _phone;
@synthesize uniqueId = _uniqueId;
@synthesize isUserValidated = _isUserValidated;
@synthesize isPaymentProfileCreated = _isPaymentProfileCreated;
@synthesize totalMiles = _totalMiles;
@synthesize userCode = _userCode;
@synthesize maskedId = _maskedId;
@synthesize credits = _credits;
@synthesize lastUpdate = _lastUpdate;
@synthesize useZipcodeForLocation = _useZipcodeForLocation;

- (id) init
{
    self = [super init];
    if(self)
    {
        [self clearUser];
    }
    return self;
}

- (void) clearUser
{
    _createdVersion = @"1.0";
    _referralCode = @"";
    _userId = @"";
    _username = @"";
    _email = @"";
    _zipcode = @"";
    _phone = @"";
    _facebookId = @"";
    [self getUniqueId];
    _isUserValidated = FALSE;
    _totalMiles = [NSNumber numberWithInt:10];
    _credits = 0;
    _phone = @"";
    _useZipcodeForLocation = FALSE;
    
    [self forceLocationRefresh];
    [self forceRefresh];
    
    _callType = no_call;
    
    // Remove any stored user data
    [self removeUserData];
}

- (void) forceRefresh
{
    _lastUpdate = nil;
}

- (void) forceLocationRefresh
{
    _locationLastUpdated = nil;
    _lastLocation = nil;
}

- (void) indicateLocationRefreshed
{
    _locationLastUpdated = [NSDate date];
}

- (NSString*) getCreditAsString
{
    NSNumberFormatter * formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle: NSNumberFormatterCurrencyStyle];
    NSString* creditString = [formatter stringFromNumber:_credits];
    return creditString;
}

- (BOOL) needsRefresh
{
    return (_lastUpdate == nil) || ([_lastUpdate timeIntervalSinceNow] < refreshTime);
}

- (BOOL) locationNeedsRefresh
{
    // Zipcode for location never has to be refreshed if _locationLastUpdated is not null
    return (_locationLastUpdated == nil) || ((!_useZipcodeForLocation) && ([_locationLastUpdated timeIntervalSinceNow] < locationRefreshTime));
}

- (BOOL) isUserInNewLocation:(CLLocation*)current
{
    BOOL newLocation = FALSE;
    if (_lastLocation != nil)
    {
        CLLocationDistance meters = [current distanceFromLocation:_lastLocation];
        newLocation = (meters > kMaxDistance);
    }
    else
    {
        newLocation = TRUE;
    }
    _lastLocation = current;
    _locationLastUpdated = [NSDate date];
    return newLocation;
}

#pragma mark - NSCoding
- (void) encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_createdVersion forKey:kKeyVersion];
    [aCoder encodeObject:_userId forKey:kKeyUserId];
    [aCoder encodeObject:_username forKey:kKeyName];
    [aCoder encodeObject:_email forKey:kKeyEmail];
    [aCoder encodeObject:_phone forKey:kKeyPhone];
    [aCoder encodeObject:_zipcode forKey:kKeyZipcode];
    [aCoder encodeObject:_facebookId forKey:kKeyFacebook];
    [aCoder encodeObject:_uniqueId forKey:kKeyUniqueId];
    [aCoder encodeObject:_referralCode forKey:kKeyReferral];
    [aCoder encodeBool:_isPaymentProfileCreated forKey:kKeyPaymentProfileCreated];
    [aCoder encodeBool:_isUserValidated forKey:kKeyUserValidate];
    [aCoder encodeObject:_totalMiles forKey:kKeyTotalMiles];
    [aCoder encodeObject:_credits forKey:kKeyCredits];
    [aCoder encodeObject:_userCode forKey:kKeyUserCode];
    [aCoder encodeObject:_lastUpdate forKey:kKeyLastUpdate];
    [aCoder encodeBool:_useZipcodeForLocation forKey:kKeyUseZipcode];
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
    _createdVersion = [aDecoder decodeObjectForKey:kKeyVersion];
     _userId = [aDecoder decodeObjectForKey:kKeyUserId];
    _username = [aDecoder decodeObjectForKey:kKeyName];
    _email = [aDecoder decodeObjectForKey:kKeyEmail];
    _phone = [aDecoder decodeObjectForKey:kKeyPhone];
    _zipcode = [aDecoder decodeObjectForKey:kKeyZipcode];
    _facebookId = [aDecoder decodeObjectForKey:kKeyFacebook];
    _uniqueId = [aDecoder decodeObjectForKey:kKeyUniqueId];
    _referralCode = [aDecoder decodeObjectForKey:kKeyReferral];
    _isPaymentProfileCreated = [aDecoder decodeBoolForKey:kKeyPaymentProfileCreated];
    _isUserValidated = [aDecoder decodeBoolForKey:kKeyUserValidate];
    _totalMiles = [aDecoder decodeObjectForKey:kKeyTotalMiles];
    _credits = [aDecoder decodeObjectForKey:kKeyCredits];
    _userCode = [aDecoder decodeObjectForKey:kKeyUserCode];
    _lastUpdate = [aDecoder decodeObjectForKey:kKeyLastUpdate];
    _useZipcodeForLocation = [aDecoder decodeBoolForKey:kKeyUseZipcode];
    return self;
}

#pragma mark - private functions

-(void) facebookLogin
{    
    [[FacebookFacade sharedInstance] setCallbackDelegate:self];
    [[FacebookFacade sharedInstance] apiLogin];
}

-(NSString *)getUniqueId
{
    if (!_uniqueId)
    {
        // Create universally unique identifier (object)
        CFUUIDRef uuidObject = CFUUIDCreate(kCFAllocatorDefault);
        
        // Get the string representation of CFUUID object.
        _uniqueId = (NSString *)CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault, uuidObject));
        CFRelease(uuidObject);
    }
    
    return _uniqueId;
}

+ (NSString*) documentsDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return documentsDirectory;
}

+ (NSString*) userFilepath
{
    NSString* docsDir = [User documentsDirectory];
    NSString* filepath = [docsDir stringByAppendingPathComponent:kUserFilename];
    return filepath;
}

#pragma mark - saved game data loading and unloading
+ (User*) loadUserData
{
    User* current_user = nil;
    NSFileManager* fileManager = [NSFileManager defaultManager];
    NSString* filepath = [User userFilepath];
    if ([fileManager fileExistsAtPath:filepath])
    {
        NSData* readData = [NSData dataWithContentsOfFile:filepath];
        if(readData)
        {
            current_user = [NSKeyedUnarchiver unarchiveObjectWithData:readData];
        }
    }
    return current_user;
}

- (void) saveUserData
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self];
    NSError* error = nil;
    BOOL writeSuccess = [data writeToFile:[User userFilepath]
                                  options:NSDataWritingAtomic
                                    error:&error];
    if(writeSuccess)
    {
        NSLog(@"user file saved successfully");
    }
    else
    {
        NSLog(@"user file save failed: %@", error);
    }
}

- (void) removeUserData
{
    NSFileManager* fileManager = [NSFileManager defaultManager];
    NSString* filepath = [User userFilepath];
    NSError *error = nil;
    if ([fileManager fileExistsAtPath:filepath])
    {
        [fileManager removeItemAtPath:filepath error:&error];
    }
}

#pragma mark - Server calls

- (void) registerUserWithEmail:(NSObject<HttpCallbackDelegate>*) delegate password:(NSString*)password
{
    // post parameters
    NSDictionary* parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                kEmailRegister, kTxType,
                                _username, kKeyName,
                                password, kKeyPassword,
                                _email, kKeyEmail,
                                _phone, kKeyPhone,
                                _zipcode, kKeyZipcode,
                                _referralCode, kKeyReferral,
                                nil];
    
    // make a post request
    AFHTTPClient* httpClient = [[AFClientManager sharedInstance] paidpunch];
    NSString* path = @"paid_punch/Users";
    [httpClient postPath:path
             parameters:parameters
                success:^(AFHTTPRequestOperation *operation, id responseObject){
                    NSLog(@"%@", responseObject);
                    [delegate didCompleteHttpCallback:kKeyUsersEmailRegister success:TRUE message:[responseObject valueForKeyPath:kKeyStatusMessage]];
                }
                failure:^(AFHTTPRequestOperation* operation, NSError* error){
                    NSLog(@"User registration failed with status code: %d", [operation.response statusCode]);
                    [delegate didCompleteHttpCallback:kKeyUsersEmailRegister success:FALSE message:[Utilities getStatusMessageFromResponse:operation]];
                }
     ];
}

- (void) registerUserWithFacebook:(NSObject<HttpCallbackDelegate>*) delegate
{
    facebookDelegate = delegate;
    [self facebookLogin];
    _callType = register_call;
}

- (void) registerUserWithFacebookInternal
{
    // post parameters
    NSDictionary* parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                kFacebookRegister, kTxType,
                                _username, kKeyName,
                                _email, kKeyEmail,
                                _zipcode, kKeyZipcode,
                                _facebookId, kKeyFacebook,
                                _uniqueId, kKeyUniqueId,
                                _referralCode, kKeyReferral,
                                nil];
    
    // make a post request
    AFHTTPClient* httpClient = [[AFClientManager sharedInstance] paidpunch];
    NSString* path = @"paid_punch/Users";
    [httpClient postPath:path
              parameters:parameters
                 success:^(AFHTTPRequestOperation *operation, id responseObject){
                     NSLog(@"%@", responseObject);
                     _userId = [NSString stringWithFormat:@"%@", [responseObject valueForKeyPath:kKeyUserId]];
                     _credits = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%@", [responseObject valueForKeyPath:kKeyCredits]]];
                     _userCode = [NSString stringWithFormat:@"%@", [responseObject valueForKeyPath:kKeyUserCode]];
                     _isUserValidated = TRUE;
                     _lastUpdate = [NSDate date];
                     [self saveUserData];
                     [facebookDelegate didCompleteHttpCallback:kKeyUsersFacebookRegister success:TRUE message:[responseObject valueForKeyPath:kKeyStatusMessage]];
                 }
                 failure:^(AFHTTPRequestOperation* operation, NSError* error){
                     NSLog(@"User registration failed with status code: %d", [operation.response statusCode]);
                     [facebookDelegate didCompleteHttpCallback:kKeyUsersFacebookRegister success:FALSE message:[Utilities getStatusMessageFromResponse:operation]];
                 }
     ];
}

- (void) loginUserWithEmail:(NSObject<HttpCallbackDelegate>*) delegate password:(NSString*)password
{
    // post parameters
    NSDictionary* parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                kEmailLogin, kTxType,
                                _email, kKeyEmail,
                                password, kKeyPassword,
                                nil];
    
    // make a post request
    AFHTTPClient* httpClient = [[AFClientManager sharedInstance] paidpunch];
    NSString* path = @"paid_punch/Users/login";
    [httpClient putPath:path
              parameters:parameters
                 success:^(AFHTTPRequestOperation *operation, id responseObject){
                     NSLog(@"%@", responseObject);
                     [self storeUserInfo:responseObject];
                     _isUserValidated = TRUE;
                     [self saveUserData];
                     [delegate didCompleteHttpCallback:kKeyUsersEmailLogin success:TRUE message:[responseObject valueForKeyPath:kKeyStatusMessage]];
                 }
                 failure:^(AFHTTPRequestOperation* operation, NSError* error){
                     NSLog(@"User registration failed with status code: %d", [operation.response statusCode]);
                     [delegate didCompleteHttpCallback:kKeyUsersEmailLogin success:FALSE message:[Utilities getStatusMessageFromResponse:operation]];
                 }
     ];
}

- (void) loginUserWithFacebook:(NSObject<HttpCallbackDelegate>*) delegate
{
    facebookDelegate = delegate;
    [self facebookLogin];
    _callType = login_call;
}

- (void) loginUserWithFacebookInternal
{
    // post parameters
    NSDictionary* parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                kFacebookLogin, kTxType,
                                _email, kKeyEmail,
                                _facebookId, kKeyFacebook,
                                nil];
    
    // make a post request
    AFHTTPClient* httpClient = [[AFClientManager sharedInstance] paidpunch];
    NSString* path = @"paid_punch/Users/login";
    [httpClient putPath:path
              parameters:parameters
                 success:^(AFHTTPRequestOperation *operation, id responseObject){
                     NSLog(@"%@", responseObject);
                     [self storeUserInfo:responseObject];
                     _isUserValidated = TRUE;
                     [self saveUserData];
                     [facebookDelegate didCompleteHttpCallback:kKeyUsersFacebookLogin success:TRUE message:[responseObject valueForKeyPath:kKeyStatusMessage]];
                 }
                 failure:^(AFHTTPRequestOperation* operation, NSError* error){
                     NSLog(@"User login failed with status code: %d", [operation.response statusCode]);
                     [facebookDelegate didCompleteHttpCallback:kKeyUsersFacebookLogin success:FALSE message:[Utilities getStatusMessageFromResponse:operation]];
                 }
     ];
}

- (void) changePassword:(NSObject<HttpCallbackDelegate>*)delegate oldPassword:(NSString*)oldPassword newPassword:(NSString*)newPassword
{
    // post parameters
    NSDictionary* parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                kPasswordChange, kTxType,
                                _userId, kKeyUserId,
                                oldPassword, kKeyPassword,
                                newPassword, kKeyNewPassword,
                                nil];
    
    // make a post request
    AFHTTPClient* httpClient = [[AFClientManager sharedInstance] paidpunch];
    NSString* path = [NSString stringWithFormat:@"paid_punch/Users/%@/password", _userId];
    [httpClient putPath:path
             parameters:parameters
                success:^(AFHTTPRequestOperation *operation, id responseObject){
                    NSLog(@"%@", responseObject);
                    [delegate didCompleteHttpCallback:kKeyUsersChangePassword success:TRUE message:[responseObject valueForKeyPath:kKeyStatusMessage]];
                }
                failure:^(AFHTTPRequestOperation* operation, NSError* error){
                    NSLog(@"User password change failed with status code: %d", [operation.response statusCode]);
                    [delegate didCompleteHttpCallback:kKeyUsersChangePassword success:FALSE message:[Utilities getStatusMessageFromResponse:operation]];
                }
     ];
}

- (void) changeInfo:(NSObject<HttpCallbackDelegate>*)delegate parameters:(NSMutableDictionary*)parameters
{
    [parameters setObject:kInfoChange forKey:kTxType];
    [parameters setObject:_userId forKey:kKeyUserId];
    [parameters setObject:_uniqueId forKey:kKeyUniqueId];
    
    // make a post request
    AFHTTPClient* httpClient = [[AFClientManager sharedInstance] paidpunch];
    NSString* path = [NSString stringWithFormat:@"paid_punch/Users/%@", _userId];
    [httpClient putPath:path
             parameters:parameters
                success:^(AFHTTPRequestOperation *operation, id responseObject){
                    NSLog(@"%@", responseObject);
                    
                    // Update local copies after successfully updating server
                    NSString* value = [parameters valueForKey:kKeyName];
                    if (value != NULL)
                    {
                        _username = value;
                    }
                    
                    value = [parameters valueForKey:kKeyPhone];
                    if (value != NULL)
                    {
                        _phone = value;
                    }
                    
                    value = [parameters valueForKey:kKeyZipcode];
                    if (value != NULL)
                    {
                        _zipcode = value;
                    }
                    
                    [self saveUserData];
                    
                    [delegate didCompleteHttpCallback:kKeyUsersChangeInfo success:TRUE message:[responseObject valueForKeyPath:kKeyStatusMessage]];
                }
                failure:^(AFHTTPRequestOperation* operation, NSError* error){
                    NSLog(@"User info change failed with status code: %d", [operation.response statusCode]);
                    [delegate didCompleteHttpCallback:kKeyUsersChangeInfo success:FALSE message:[Utilities getStatusMessageFromResponse:operation]];
                }
     ];
}

- (void) storeUserInfo:(id)responseObject
{
    _userId = [NSString stringWithFormat:@"%@", [responseObject valueForKeyPath:kKeyUserId]];
    
    id obj = [responseObject valueForKeyPath:kKeyPhone];
    if (obj == NULL || (NSNull *)obj == [NSNull null])
    {
        _phone = @"";
    }
    else
    {
       _phone = [NSString stringWithFormat:@"%@", [responseObject valueForKeyPath:kKeyPhone]];
    }
    
    obj = [responseObject valueForKeyPath:kKeyName];
    if (obj == NULL || (NSNull *)obj == [NSNull null])
    {
        _username = @"";
    }
    else
    {
        _username = [NSString stringWithFormat:@"%@", [responseObject valueForKeyPath:kKeyName]];
    }
    
    obj = [responseObject valueForKeyPath:kKeyZipcode];
    if (obj == NULL || (NSNull *)obj == [NSNull null])
    {
        _zipcode = @"";
    }
    else
    {
        _zipcode = [NSString stringWithFormat:@"%@", [responseObject valueForKeyPath:kKeyZipcode]];
    }
    
    _credits = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%@", [responseObject valueForKeyPath:kKeyCredits]]];
    _userCode = [NSString stringWithFormat:@"%@", [responseObject valueForKeyPath:kKeyUserCode]];
    _isPaymentProfileCreated = [[responseObject valueForKeyPath:kKeyPaymentProfileCreated] boolValue];
    _lastUpdate = [NSDate date];
}

- (void) getUserInfoFromServer:(NSObject<HttpCallbackDelegate>*)delegate
{    
    // make a post request
    AFHTTPClient* httpClient = [[AFClientManager sharedInstance] paidpunch];
    NSString* path = [NSString stringWithFormat:@"paid_punch/Users/%@", _userId];
    [httpClient getPath:path
             parameters:nil
                success:^(AFHTTPRequestOperation *operation, id responseObject){
                    NSLog(@"%@", responseObject);
                    [self storeUserInfo:responseObject];
                    _isUserValidated = TRUE;
                    [self saveUserData];
                    [delegate didCompleteHttpCallback:kKeyUsersGetInfo success:TRUE message:[responseObject valueForKeyPath:kKeyStatusMessage]];
                }
                failure:^(AFHTTPRequestOperation* operation, NSError* error){
                    NSLog(@"User info retrieval failed with status code: %d", [operation.response statusCode]);
                    [delegate didCompleteHttpCallback:kKeyUsersGetInfo success:FALSE message:[Utilities getStatusMessageFromResponse:operation]];
                }
     ];
}

- (void) requestInvite:(NSObject<HttpCallbackDelegate>*) delegate email:(NSString*)email
{
    // post parameters
    NSDictionary* parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                email, kKeyEmail,
                                nil];
    
    // make a post request
    AFHTTPClient* httpClient = [[AFClientManager sharedInstance] paidpunch];
    NSString* path = @"paid_punch/Users/requestinvite";
    [httpClient postPath:path
              parameters:parameters
                 success:^(AFHTTPRequestOperation *operation, id responseObject){
                     NSLog(@"%@", responseObject);
                     [delegate didCompleteHttpCallback:kKeyUsersEmailRegister success:TRUE message:[responseObject valueForKeyPath:kKeyStatusMessage]];
                 }
                 failure:^(AFHTTPRequestOperation* operation, NSError* error){
                     NSLog(@"Invite request failed with status code: %d", [operation.response statusCode]);
                     [delegate didCompleteHttpCallback:kKeyUsersEmailRegister success:FALSE message:[Utilities getStatusMessageFromResponse:operation]];
                 }
     ];
}

#pragma mark - Facebook data

- (void)updateFacebookFeed:(NSString*)message
{
    NSMutableDictionary* params1 = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    message, @"message",
                                    @"https://itunes.apple.com/us/app/paidpunch/id501977872?mt=8", @"link",
                                    @"https://s3-us-west-2.amazonaws.com/paidpunch.company/APPicon.png", @"picture",
                                    @"PaidPunch", @"name",
                                    @"Save Money. Get Free Stuff. What are you waiting for?", @"description",
                                    nil];
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [[delegate facebook] requestWithGraphPath:@"me/feed" andParams:params1 andHttpMethod:@"POST" andDelegate:self];
}

- (void) didCompleteFacebookLogin:(BOOL) success
{
    [self getUserProfileInfo];
}

- (void)getUserProfileInfo
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"SELECT uid, name ,email FROM user WHERE uid=me()", @"query",
                                   nil];
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [[delegate facebook] requestWithMethodName:@"fql.query"
                                     andParams:params
                                 andHttpMethod:@"POST"
                                   andDelegate:self];
}

- (void)request:(FBRequest *)request didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"received response %@",response);
}

- (void)request:(FBRequest *)request didLoad:(id)result
{
    if ([[request url] rangeOfString:@"me/feed"].location != NSNotFound)
    {
        // Updating facebook newsfeed completed
        NSLog(@"Facebook /me/feed call completed");
    }
    else
    {
        if ([result isKindOfClass:[NSArray class]])
        {
            result = [result objectAtIndex:0];
        }
        
        // This callback can be a result of getting the user's basic
        // information or getting the user's permissions.
        if ([result objectForKey:@"name"])
        {
            // Store the information retrieved from facebook
            _username = [result objectForKey:@"name"];
            if([result objectForKey:@"uid"])
            {
                _facebookId = [NSString stringWithFormat:@"%@", [result objectForKey:@"uid"]];
            }
            if([result objectForKey:@"email"])
            {
                _email=[result objectForKey:@"email"];
            }
            
            if (_callType == register_call)
            {
                // Call the facebook registration API
                [self registerUserWithFacebookInternal];
            }
            else if (_callType == login_call)
            {
                // Call the facebook login API
                [self loginUserWithFacebookInternal];
            }
            else
            {
                NSLog(@"Unknown callType in didLoad.");
            }
        }
        else
        {
            NSLog(@"Unknown facebook callback in didLoad.");
        }
    }
}

- (void)request:(FBRequest *)request didFailWithError:(NSError *)error
{
    NSLog(@"Err message: %@", [[error userInfo] objectForKey:@"error_msg"]);
    NSLog(@"Err code: %d", [error code]);
}

- (void)requestLoading:(FBRequest *)request
{
}

- (void)request:(FBRequest *)request didLoadRawResponse:(NSData *)data
{
}

#pragma mark - Public function

- (BOOL) isFacebookProfile
{
    return !([_facebookId length] == 0);
}

#pragma mark - Singleton
static User* singleton = nil;
+ (User*) getInstance
{
	@synchronized(self)
	{
		if (!singleton)
		{
            // First, try to load the user data from disk
            singleton = [User loadUserData];
            if (!singleton)
            {
                // OK, no saved data available. Go ahead and create a new User.
                singleton = [[User alloc] init];
            }
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
