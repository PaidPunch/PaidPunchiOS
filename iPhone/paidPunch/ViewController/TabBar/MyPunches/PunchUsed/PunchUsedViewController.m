//
//  PunchUsedViewController.m
//  paidPunch
//
//  Created by mobimedia technologies on 01/12/11.
//  Copyright (c) 2011 mobimedia. All rights reserved.
//

#import "PunchUsedViewController.h"

@implementation PunchUsedViewController

@synthesize contentsWebView;
@synthesize punchCardDetails;
@synthesize barcodeImageView;
@synthesize businessLogoImageView;
@synthesize businessNameLbl;
@synthesize timeLbl;
@synthesize totalMinsLbl;
@synthesize totalSecsLbl;
@synthesize secLbl;
@synthesize minLbl;
@synthesize barcodeImageData;
@synthesize barcodeValue;
@synthesize lastRefreshTime;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}
- (id)init:(PunchCard *)punchCard barcodeImageData:(NSData *)imageData barcodeValue:(NSString *)bValue
{
    self = [super init];
    if (self) {
        self.punchCardDetails=punchCard;
        self.barcodeImageData=imageData;
        self.barcodeValue=bValue;
    }
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor=[UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:239.0/255.0 alpha:1];
    
    self.title = @"Punch Used";
    self.navigationItem.hidesBackButton=YES;     
    seconds=0;
    timer=[NSTimer scheduledTimerWithTimeInterval:(1.0/1.0)
                                           target:self
                                         selector:@selector(updateTimeLabel)
                                         userInfo:nil
                                          repeats:YES];
    self.contentsWebView.userInteractionEnabled=FALSE;
    contentsWebView.opaque = NO;
    contentsWebView.backgroundColor = [UIColor clearColor];
    [self setUpUI];
}

- (void)viewDidUnload
{
    [self setBusinessLogoImageView:nil];
    [self setBusinessNameLbl:nil];
    [self setTimeLbl:nil];
    [self setTotalMinsLbl:nil];
    [self setTotalSecsLbl:nil];
    [self setSecLbl:nil];
    [self setMinLbl:nil];
    [self setContentsWebView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark Cleanup

- (void)dealloc {
    NSLog(@"In dealloc of PunchUsedViewController");
}

#pragma mark -
#pragma mark UIAlertViewDelegate methods Implementation

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==0)
    {
        [self.navigationController popToRootViewControllerAnimated:NO];
        [timer invalidate];
    }
}

#pragma mark -
#pragma mark FBDialogDelegate methods Implementation

- (void)dialogCompleteWithUrl:(NSURL *)url {
    if([url.absoluteString rangeOfString:@"post_id="].location!=NSNotFound)
    {
        
    }
    else
    {
        
    }
    [[FacebookFacade sharedInstance] setPunchUsedViewController:nil];
}


- (void)dialogDidNotCompleteWithUrl:(NSURL *)url
{
    NSLog(@"2");
}


- (void)dialogDidNotComplete:(FBDialog *)dialog
{
    NSLog(@"3");
}


- (void)dialog:(FBDialog*)dialog didFailWithError:(NSError *)error
{
    NSLog(@"4");
    Reachability *hostReach = [Reachability reachabilityForInternetConnection];
	if ([hostReach currentReachabilityStatus] != NotReachable) 
	{		
        if(cnt<2)
            [self shareOnFacebook];
        
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Whoops!" message:@"Could not connect to server. Please try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }

}

#pragma mark -
#pragma mark FBRequestDelegate methods Implementation

- (void)request:(FBRequest *)request didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"received response %@",response);
}

- (void)request:(FBRequest *)request didLoad:(id)result {
    if ([result isKindOfClass:[NSArray class]]) {
        result = [result objectAtIndex:0];
    }
    // Processing permissions information
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [delegate setUserPermissions:[[result objectForKey:@"data"] objectAtIndex:0]];
}

- (void)request:(FBRequest *)request didFailWithError:(NSError *)error {
    NSLog(@"Err message: %@", [[error userInfo] objectForKey:@"error_msg"]);
    NSLog(@"Err code: %d", [error code]);
}

#pragma mark -

-(void)setUpUI
{
        if([self.punchCardDetails respondsToSelector:@selector(business_name)])
        {
            self.businessNameLbl.text=[NSString stringWithFormat:@"%@ PaidPunch Used",self.punchCardDetails.business_name];
            NSString *str;
            if([self.punchCardDetails.punch_expire intValue]==1)
            {
                str=[NSString stringWithFormat:@"<html><head></head><body><p align='center'><font color=#00B931 size=6 face='helvetica'><b>%@</b></font><br /><br /><br /><font color=#f47b27 size=7 face='helvetica'><b>$%.2f</b></font><font color=#f47b27 size=3 face='helvetica'><br /> off your bill!</font></p></body></html>",self.punchCardDetails.business_name,[self.punchCardDetails.discount_value_of_each_punch doubleValue]];
                
            }
            else
            {
                str=[NSString stringWithFormat:@"<html><head></head><body><p align='center'><font color=#00B931 size=6 face='helvetica'><b>%@</b></font><br /><br /><br /><font color=#f47b27 size=7 face='helvetica'><b>$%.2f</b></font><font color=#f47b27 size=3 face='helvetica'><br /> off your bill!</font></p></body></html>",self.punchCardDetails.business_name,[self.punchCardDetails.each_punch_value doubleValue]];
            }
            
            if([self.punchCardDetails.is_mystery_punch intValue]==1 && [self.punchCardDetails.is_mystery_used intValue]==0 && [self.punchCardDetails.total_punches intValue]-[self.punchCardDetails.total_punches_used intValue]<=0)
            {
             str=[NSString stringWithFormat:@"<html><head></head><body><p align='center'><font color=#00B931 size=6 face='helvetica'><b>%@</b></font><br /><br /><font color=#0084CC size=5 face='helvetica'><b>%@</b></font></p></body></html>",self.punchCardDetails.business_name, self.punchCardDetails.offer];
            }
            
            [self.contentsWebView loadHTMLString:str baseURL:nil];
        }
   
    self.secLbl.textColor=[UIColor colorWithRed:244.0/255.0 green:123.0/255.0 blue:39/255.0 alpha:1];
    self.minLbl.textColor=[UIColor colorWithRed:244.0/255.0 green:123.0/255.0 blue:39/255.0 alpha:1];
    self.totalMinsLbl.textColor=[UIColor colorWithRed:244.0/255.0 green:123.0/255.0 blue:39/255.0 alpha:1];
    self.totalSecsLbl.textColor=[UIColor colorWithRed:244.0/255.0 green:123.0/255.0 blue:39/255.0 alpha:1];
    
    self.totalMinsLbl.text=[NSString stringWithFormat:@"%d",minutes];
    self.totalSecsLbl.text=[NSString stringWithFormat:@"%d",seconds];
    
    self.timeLbl.textColor=[UIColor colorWithRed:244.0/255.0 green:123.0/255.0 blue:39/255.0 alpha:1];
    self.timeLbl.text=[NSString stringWithFormat:@"%d min %d sec",minutes,seconds];
    
    initialScreenBrightness = [[UIScreen mainScreen] brightness];
    [[UIScreen mainScreen] setBrightness:1.0];
}

-(void)updateTimeLabel
{
    if(self.lastRefreshTime==nil)
        self.lastRefreshTime=[NSDate date];
    else
    {
        NSTimeInterval interval=[[NSDate date] timeIntervalSinceDate:self.lastRefreshTime];
        //int hours=(int)interval/3600;
        //int minutes=(interval -(hours * 3600))/60;
        int secs=interval;
        if(secs > 1)
            seconds=seconds+secs;
        NSLog(@"seconds %d",secs);
        self.lastRefreshTime=[NSDate date];
    }
    if (seconds>=60) {
        minutes=seconds/60;
        seconds=0;
    }
    else
    {
        seconds +=1;
    }
    NSString *secStr;
    if(seconds < 10)
        secStr=[NSString stringWithFormat:@"0%d",seconds];
    else
        secStr=[NSString stringWithFormat:@"%d",seconds];
    
    NSString *minStr;
    if(minutes<10)
        minStr=[NSString stringWithFormat:@"0%d",minutes];
    else
        minStr=[NSString stringWithFormat:@"%d",minutes];
    
    self.totalMinsLbl.text=[NSString stringWithFormat:@"%@",minStr];
    self.totalSecsLbl.text=[NSString stringWithFormat:@"%@",secStr];
    
}

#pragma mark -

- (IBAction)doneBtnTouchUpInsideHandler:(id)sender {
    int rem=[self.punchCardDetails.total_punches intValue]-[self.punchCardDetails.total_punches_used intValue];
    if(rem==1 && [self.punchCardDetails.is_mystery_punch intValue]==1)
    {
        NSString *msg=[NSString stringWithFormat:@"You have unlocked your %@ Mystery Punch!",self.punchCardDetails.business_name];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Congratulations" message:msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else
    { 
        [timer invalidate];
        [self gotoRootView];
    }
    [[UIScreen mainScreen] setBrightness:initialScreenBrightness];
}

- (IBAction)shareToFaceBtnTouchUpInsideHandler:(id)sender {
    /*AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (![[delegate facebook] isSessionValid]) {
        [[delegate facebook] authorize:[delegate permissions]];
    } 
    else
    {
        if ([[delegate userPermissions] objectForKey:@"publish_stream"]) {
            [self shareOnFacebook]; //--> permission granted so open the post dialog
        } else {
            [self apiPromptPostToWallPermissions]; //--> get permission
        }
        [self shareOnFacebook];
    }
     */
    [[FacebookFacade sharedInstance] setPunchUsedViewController:self];
    [[FacebookFacade sharedInstance] apiLogin];
}


#pragma mark -

-(void) gotoRootView
{
    /*UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"Are you sure?" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"NO",nil];
    [alert show];
    [alert release];*/
    [self.navigationController popToRootViewControllerAnimated:NO];

}

#pragma mark -

-(void)loggedIn
{
    [[FacebookFacade sharedInstance] setPunchUsedViewController:nil];
    [self shareOnFacebook];
}

- (void)storeAuthData:(NSString *)accessToken expiresAt:(NSDate *)expiresAt {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:accessToken forKey:@"FBAccessTokenKey"];
    [defaults setObject:expiresAt forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
}

- (void)apiPromptPostToWallPermissions {
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSArray *postToWallPermissions = [[NSArray alloc] initWithObjects:@"publish_stream", nil];
    [[delegate facebook] authorize:postToWallPermissions];
}

- (void)shareOnFacebook {
    cnt++;
    SBJSON *jsonWriter = [SBJSON new];
    
    // The action links to be shown with the post in the feed
    NSString *url=@"http://itunes.apple.com/us/app/paidpunch/id501977872?mt=8";
    NSArray* actionLinks = [NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:
                                                      @"Get Started with PaidPunch",@"name",url,@"link", nil], nil];
    NSString *actionLinksStr = [jsonWriter stringWithObject:actionLinks];
    // Dialog parameters
    NSString *str;
    if([self.punchCardDetails.is_mystery_punch intValue]==1 && [self.punchCardDetails.is_mystery_used intValue]==0 && [self.punchCardDetails.total_punches intValue]-[self.punchCardDetails.total_punches_used intValue]<=0)
    {
        str=[NSString stringWithFormat:@"I just used a %@ Mystery Punch and got %@ using the PaidPunch iPhone app. Thank you %@!",self.punchCardDetails.business_name,self.barcodeValue,self.punchCardDetails.business_name];
    }
    else
    {
        str=[NSString stringWithFormat:@"I just used a %@ Punch and took $%.2f off my bill using the PaidPunch iPhone app. Thank you %@!",[self.punchCardDetails business_name],[self.punchCardDetails.each_punch_value doubleValue],[self.punchCardDetails business_name]];
    }
    
    NSString *logoUrl=[NSString stringWithFormat:@"%@",NSLocalizedString(@"FBShareLogoUrl", @"")];//[NSString stringWithFormat:@"%@%@",[[InfoExpert sharedInstance] appUrl], NSLocalizedString(@"FBShareLogoUrl", @"")];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"I'm saving money and winning prizes with PaidPunch!", @"name",
                                   @"PaidPunch for iPhone.", @"caption",
                                   str, @"description",
                                   @"http://www.paidpunch.com", @"link",
                                   logoUrl, @"picture",
                                   actionLinksStr, @"actions",
                                   nil];
    
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [[delegate facebook] dialog:@"feed"
                      andParams:params
                    andDelegate:self];
    
}

@end
