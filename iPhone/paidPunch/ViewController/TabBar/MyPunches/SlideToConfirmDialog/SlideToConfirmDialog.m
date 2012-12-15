//
//  SlideToConfirmDialog.m
//  paidPunch
//
//  Created by mobimedia technologies on 16/03/12.
//  Copyright (c) 2012 mobimedia. All rights reserved.
//

#import "SlideToConfirmDialog.h"

@implementation SlideToConfirmDialog
@synthesize punchCardDetails;
@synthesize businessLogoImageView;
@synthesize businessNameLbl;
//@synthesize punchLbl;
@synthesize valueLbl;
@synthesize purchaseLbl;
@synthesize slideToUnlock;
@synthesize activityIndicator;
@synthesize showSlideLbl;
@synthesize slideBgImageView;
@synthesize instructionsImageView;
@synthesize mysteryoffer;
@synthesize orangeStripImageView;

BOOL UNLOCKED = NO;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)init:(PunchCard *)punchCard withMysteryOffer:(NSString *)mOffer
{
    self = [super init];
    if (self) {
        self.punchCardDetails=punchCard;
        self.mysteryoffer=mOffer;
    }
    return self;
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor=[UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:239.0/255.0 alpha:1];
    self.title = [NSString stringWithFormat:@"%@",@"Use a Punch"];
    
    self.businessNameLbl.text=self.punchCardDetails.business_name;
//    self.punchLbl.text=@"PaidPunch";
    int rem=[self.punchCardDetails.total_punches intValue] - [self.punchCardDetails.total_punches_used intValue];
    if(rem==1 && [self.punchCardDetails.is_mystery_punch intValue]==1)
    {
//        self.punchLbl.text=@"Mystery Punch";
//        self.punchLbl.textColor=[UIColor colorWithRed:0/255.0 green:114/255.0 blue:180/255.0 alpha:1];
        self.purchaseLbl.hidden=YES;
        self.valueLbl.text=self.mysteryoffer;
        self.valueLbl.textColor=[UIColor colorWithRed:0/255.0 green:114/255.0 blue:180/255.0 alpha:1];
    }
    else
    {
        if([punchCardDetails.punch_expire intValue]==1)
        {
            self.valueLbl.text=[NSString stringWithFormat:@"$%.2f",[self.punchCardDetails.discount_value_of_each_punch doubleValue]];
        }
        else
        {
            self.valueLbl.text=[NSString stringWithFormat:@"$%.2f",[self.punchCardDetails.each_punch_value doubleValue]];
        }
        self.valueLbl.textColor=[UIColor colorWithRed:244.0/255.0 green:123.0/255.0 blue:39/255.0 alpha:1];
        self.purchaseLbl.text=@"off your purchase";
        self.purchaseLbl.textColor=[UIColor colorWithRed:244.0/255.0 green:123.0/255.0 blue:39/255.0 alpha:1];
    }
    UIImage *stetchLeftTrack= [[UIImage imageNamed:@"Nothing.png"]
                               stretchableImageWithLeftCapWidth:30.0 topCapHeight:0.0];
	UIImage *stetchRightTrack= [[UIImage imageNamed:@"Nothing.png"]
                                stretchableImageWithLeftCapWidth:30.0 topCapHeight:0.0];
	[slideToUnlock setThumbImage: [UIImage imageNamed:@"slidebtn.png"] forState:UIControlStateNormal];
	[slideToUnlock setMinimumTrackImage:stetchLeftTrack forState:UIControlStateNormal];
	[slideToUnlock setMaximumTrackImage:stetchRightTrack forState:UIControlStateNormal];

    
    SDWebImageManager *manager=[SDWebImageManager sharedManager];
    UIImage *cachedImage=[manager imageWithURL:[NSURL URLWithString:self.punchCardDetails.business_logo_url]];
    if(cachedImage)
    {
        self.businessLogoImageView.image=cachedImage;
        self.activityIndicator.hidden=YES;
    }
    else
    {
        [self.activityIndicator startAnimating];
        self.activityIndicator.hidden=NO;
        [manager downloadWithURL:[NSURL URLWithString:self.punchCardDetails.business_logo_url] delegate:self];
    }
    
    networkManager=[[NetworkManager alloc] initWithView:self.view];
    networkManager.delegate=self;
    
    
    NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
    NSString *s=[ud objectForKey:@"isManualShown"];
    if(s==nil || [s isEqualToString:@"NO"])
    {
        NSLog(@"Show instructions");        
        [self showInstructionsView];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(doneWithInstructions) name:@"sliderInstructionsCompleted" object:nil];
    }
    
    [self lockSlider];
}

- (void)doneWithInstructions {
    NSLog(@"Done with instructions");
}

- (void)viewDidUnload
{
    [self setBusinessLogoImageView:nil];
    [self setBusinessNameLbl:nil];
//    [self setPunchLbl:nil];
    [self setValueLbl:nil];
    [self setPurchaseLbl:nil];
    [self setSlideToUnlock:nil];
    [self setActivityIndicator:nil];
    [self setShowSlideLbl:nil];
    [self setSlideBgImageView:nil];
    [self setInstructionsImageView:nil];
    [self setOrangeStripImageView:nil];
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


#pragma mark -
#pragma mark SDWebImageManagerDelegate methods Implementation

-(void)webImageManager:(SDWebImageManager *)imageManager didFinishWithImage:(UIImage *)image
{
    [self.activityIndicator stopAnimating];
    self.activityIndicator.hidden=YES;
    self.businessLogoImageView.image=image;
    
}

#pragma mark -
#pragma mark NetworkManagerDelegate methods Implementation

-(void) didFinishMarkingPunchUsed:(NSString *)statusCode statusMessage:(NSString *)message barcodeImage:(NSData *)imageData barcodeValue:(NSString *)barcode;
{
    if([statusCode isEqualToString:@"00"] || [statusCode isEqualToString:@"03"])
    {
        int pc=[self.punchCardDetails.total_punches_used intValue];
        [self.punchCardDetails setTotal_punches_used:[NSNumber numberWithInt:++pc]];
        int remaining=[self.punchCardDetails.total_punches intValue]-[self.punchCardDetails.total_punches_used intValue];
        if([self.punchCardDetails.is_mystery_punch intValue]==1)
        {
            if(remaining==0)
            {
                [self.punchCardDetails setTotal_punches_used:[NSNumber numberWithInt:++pc]];
            }
        }
        [[DatabaseManager sharedInstance] saveEntity:self.punchCardDetails];
        [self goToPunchUsedView:punchCardDetails barcodeImage:imageData barcodeValue:barcode];
    }
    else
    {
        if([statusCode isEqualToString:@"01"])
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Not so fast!" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
        }
        else
        if([statusCode isEqualToString:@"401"])
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Warning!" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
            self.punchCardDetails.punch_expire=[NSNumber numberWithBool:YES];
            [[DatabaseManager sharedInstance] saveEntity:nil];
            [self.navigationController popToRootViewControllerAnimated:NO];
        }
        else
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Whoops!" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
        }
        [self lockSlider];
    }
}

#pragma mark -
#pragma mark SlideToCancelDelegate methods Implementation

- (void) cancelled {
	
    [self hideSlider];
    [self markPunch];
}

#pragma mark -

/*
-(IBAction)LockIt {
	slideToUnlock.hidden = NO;
	slideBgImageView.hidden = NO;
	showSlideLbl.hidden = NO;
	showSlideLbl.alpha = 1.0;
	UNLOCKED = NO;
	slideToUnlock.value = 0.0;
}

-(IBAction)fadeLabel {
    
	showSlideLbl.alpha = 1.0 - slideToUnlock.value;
	
}

-(IBAction)UnLockIt {
	if (!UNLOCKED) {
		if (slideToUnlock.value >=1.0) {  // if user slide far enough, stop the operation	
            // Put here what happens when it is unlocked
			slideToUnlock.hidden = YES;
			slideBgImageView.hidden = YES;
			showSlideLbl.hidden = YES;
			UNLOCKED = YES;
            [self markPunch];
            UNLOCKED=NO;
		} else { 
            [self lockSlider];
		}
		
	}
	
}

-(void)lockSlider
{
    slideToUnlock.hidden=NO;
    // user did not slide far enough, so return back to 0 position
    [UIView beginAnimations: @"SlideCanceled" context: nil];
    [UIView setAnimationDelegate: self];
    [UIView setAnimationDuration: 0.35];
    [UIView setAnimationCurve: UIViewAnimationCurveEaseOut];	
    slideToUnlock.hidden = NO;
	slideBgImageView.hidden = NO;
	showSlideLbl.hidden = NO;
	showSlideLbl.alpha = 1.0;
	UNLOCKED = NO;
	slideToUnlock.value = 0.0;
    [UIView commitAnimations];
    
}
*/

-(void)lockSlider
{
    // Start the slider animation
    
    if (!slideToCancel) {
		// Create the slider
		slideToCancel = [[SlideToCancelViewController alloc] init];
		slideToCancel.delegate = self;
		
		// Position the slider off the bottom of the view, so we can slide it up
		CGRect sliderFrame = slideToCancel.view.frame;
		sliderFrame.origin.y = self.view.frame.size.height;
		slideToCancel.view.frame = sliderFrame;
		
		// Add slider to the view
		[self.view addSubview:slideToCancel.view];
	}
    
    slideToCancel.enabled = YES;
	
	// Slowly move up the slider from the bottom of the screen
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.5];
	CGPoint sliderCenter = slideToCancel.view.center;
	sliderCenter.y -= slideToCancel.view.bounds.size.height;
	slideToCancel.view.center = sliderCenter;
	[UIView commitAnimations];
}

-(void)hideSlider
{
    // Disable the slider and re-enable the button
	slideToCancel.enabled = NO;
    
	// Slowly move down the slider off the bottom of the screen
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.5];
	CGPoint sliderCenter = slideToCancel.view.center;
	sliderCenter.y += slideToCancel.view.bounds.size.height;
	slideToCancel.view.center = sliderCenter;
	[UIView commitAnimations];
}

-(void)markPunch
{
    BOOL isMystery=NO;
    int remaining=[self.punchCardDetails.total_punches intValue]-[self.punchCardDetails.total_punches_used intValue];
    if([self.punchCardDetails.is_mystery_punch intValue]==1 && [self.punchCardDetails.is_mystery_used intValue]==0)
    {
        if(remaining==1)
        {
            isMystery=YES;
        }
        
    }
    [networkManager markPunchUsed:self.punchCardDetails.punch_card_id punchCardDownloadId:self.punchCardDetails.punch_card_download_id loggedInUserId:[[User getInstance] userId] isMysteryPunch:isMystery isPunchExpired:[self.punchCardDetails.punch_expire boolValue]];
}

- (IBAction)goBack:(id)sender {
    CATransition *transition = [CATransition animation];
    transition.duration = 0.5;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark -

-(void)showInstructionsView
{
    InstructionsView *instructionsView;
    NSArray *xibUIObjects =[[NSBundle mainBundle] loadNibNamed:@"InstructionsView" owner:self options:nil];
    instructionsView= [xibUIObjects objectAtIndex:0];
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.window addSubview:instructionsView];
}

-(void) goToPunchUsedView:(PunchCard *)punchCard barcodeImage:(NSData *)imageData barcodeValue:(NSString *)barcode;
{
    PunchUsedViewController *punchView = [[PunchUsedViewController alloc] init:self.punchCardDetails barcodeImageData:imageData barcodeValue:self.mysteryoffer];
    punchView.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:punchView animated:YES];
}

@end
