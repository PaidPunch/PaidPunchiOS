//
//  PunchCardOfferViewController.m
//  paidPunch
//
//  Created by mobimedia technologies on 25/11/11.
//  Copyright (c) 2011 mobimedia. All rights reserved.
//

#import "PunchCardOfferViewController.h"

@implementation PunchCardOfferViewController

@synthesize contentsScrollView;
@synthesize freePunchLbl;
@synthesize buisnesslogoImageView;
@synthesize punchCardDetails;
@synthesize qrCode;

@synthesize expiryLbl;
@synthesize finePrintView;
@synthesize finePrintDivider;

@synthesize punchCardNameLbl;
@synthesize payValueView;
@synthesize getValueView;
@synthesize totalValueLabel;
@synthesize savingsValueLabel;
@synthesize punchCardContentsView;
@synthesize punchCardContentsBG;

@synthesize punchesListTableView;
@synthesize getFreePunchBtn;
@synthesize lockImageView;
@synthesize cardView;
@synthesize activityIndicator;

#define kCellHeight		50.0

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)init:(NSString *)offerCode punchCardDetails:(PunchCard *)punchCard
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.qrCode=offerCode;
        self.punchCardDetails=punchCard;
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
    self.navigationItem.hidesBackButton=NO;
    
    payValueView.userInteractionEnabled = FALSE;
    payValueView.opaque = NO;
    payValueView.backgroundColor = [UIColor clearColor];
    
    getValueView.userInteractionEnabled = FALSE;
    getValueView.opaque = NO;
    getValueView.backgroundColor = [UIColor clearColor];
    
    punchCardContentsView.userInteractionEnabled = FALSE;
    punchCardContentsView.opaque = NO;
    punchCardContentsView.backgroundColor = [UIColor clearColor];
    
    finePrintView.userInteractionEnabled = FALSE;
    finePrintView.opaque = NO;
    finePrintView.backgroundColor = [UIColor clearColor];
    
    UIImage *leftBtnImage = [UIImage imageNamed:@"Back.png"];
	UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setTitle:@" Back" forState:UIControlStateNormal];
    [leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	leftButton.bounds = CGRectMake( 0, 0, leftBtnImage.size.width, leftBtnImage.size.height );    
	[leftButton setBackgroundImage:leftBtnImage forState:UIControlStateNormal];
    leftButton.titleLabel.font=[UIFont boldSystemFontOfSize:12.0];
	[leftButton addTarget:self action:@selector(backBtnTouchUpInsideHandler:) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *leftBtnOnNavigation = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
	self.navigationItem.leftBarButtonItem = leftBtnOnNavigation;
	[leftBtnOnNavigation release];

    self.punchesListTableView.backgroundColor = [UIColor clearColor];
	self.punchesListTableView.sectionFooterHeight = 0;
    self.punchesListTableView.sectionHeaderHeight = 0;
    self.punchesListTableView.separatorColor=[UIColor clearColor];
    
    networkManager=[[NetworkManager alloc] initWithView:self.view];
    networkManager.delegate=self;
    
    self.contentsScrollView.contentSize = CGSizeMake(320, 750);
    self.contentsScrollView.clipsToBounds = YES;
    self.contentsScrollView.scrollEnabled = TRUE;
    isFreePunch=NO;

    UIBarButtonItem *mapButton=[[UIBarButtonItem alloc] initWithTitle:@"Map" style:UIBarButtonItemStylePlain target:self action:@selector(mapBtnTouchUpInsideHandler:)];
    mapButton.title=@"Map";
    self.navigationItem.rightBarButtonItem=mapButton;
    [mapButton release];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [self setUpUI];
}
- (void)viewDidUnload
{
    [self setBuisnesslogoImageView:nil];
    [self setExpiryLbl:nil];
    [self setPunchCardNameLbl:nil];
    [self setPunchesListTableView:nil];
    [self setGetFreePunchBtn:nil];
    [self setFreePunchLbl:nil];
    [self setContentsScrollView:nil];
    [self setLockImageView:nil];
    [self setCardView:nil];
    [self setActivityIndicator:nil];
    [self setPunchCardContentsView:nil];
    [self setPayValueView:nil];
    [self setGetValueView:nil];
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
    [qrCode release];
    [buisnesslogoImageView release];
    [expiryLbl release];
    [punchCardNameLbl release];
    [punchesListTableView release];
    NSLog(@"Retain Count %d",[self.punchCardDetails retainCount]);
    [punchCardDetails release];
    [getFreePunchBtn release];
    [freePunchLbl release];
    [contentsScrollView release];
    [lockImageView release];
    [cardView release];
    [activityIndicator release];
    [super dealloc];
    NSLog(@"In dealloc of PunchCardOfferViewController");
}

#pragma mark -
#pragma mark SDWebImageManagerDelegate methods Implementation

-(void)webImageManager:(SDWebImageManager *)imageManager didFinishWithImage:(UIImage *)image
{
    [self.activityIndicator stopAnimating];
    self.activityIndicator.hidden=YES;
    self.buisnesslogoImageView.image=image;
}

#pragma mark -
#pragma mark UITableViewDataSource methods Implementation

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int totalPunches=[self.punchCardDetails.total_punches intValue];
    int mod=totalPunches%5;
    if(mod==0)
    {
        rowCnt = totalPunches / 5;
    }
    else
    {
        rowCnt = (totalPunches / 5)+1;
    }
    return rowCnt;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *punchesViewCellIdentifier = @"PunchesViewCellIdentifier";
    
    PunchesViewCell *cell = (PunchesViewCell *)[tableView dequeueReusableCellWithIdentifier:punchesViewCellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PunchesViewCell" owner:self options:nil];
        cell  = (PunchesViewCell *)[nib objectAtIndex:0];
    }
    
    int totalPunches=[self.punchCardDetails.total_punches intValue];
    UIImage *mysteryImage=[UIImage imageNamed:@"MysteryPunch.png"];
    if(indexPath.row == rowCnt-1)
    {
        int mod=totalPunches%5;
        if(mod == 4)
        {
            cell.button5.hidden=YES;
            if([self.punchCardDetails.is_mystery_punch intValue]==1)
                [cell.button4 setBackgroundImage:mysteryImage forState:UIControlStateNormal];
        }
        if(mod == 3)
        {
            cell.button5.hidden=YES;
            cell.button4.hidden=YES;
            if([self.punchCardDetails.is_mystery_punch intValue]==1)
                [cell.button3 setBackgroundImage:mysteryImage forState:UIControlStateNormal];
        }
        if(mod == 2)
        {
            cell.button5.hidden=YES;
            cell.button4.hidden=YES;
            cell.button3.hidden=YES;
            if([self.punchCardDetails.is_mystery_punch intValue]==1)
                [cell.button2 setBackgroundImage:mysteryImage forState:UIControlStateNormal];
        }
        if(mod == 1)
        {
            cell.button5.hidden=YES;
            cell.button4.hidden=YES;
            cell.button3.hidden=YES;
            cell.button2.hidden=YES;
            if([self.punchCardDetails.is_mystery_punch intValue]==1)
                [cell.button1 setBackgroundImage:mysteryImage forState:UIControlStateNormal];
        }
        if(mod==0)
        {
            if([self.punchCardDetails.is_mystery_punch intValue]==1)
                [cell.button5 setBackgroundImage:mysteryImage forState:UIControlStateNormal];
        }
    }
	cell.selectionStyle=UITableViewCellSelectionStyleNone; 
    cell.backgroundColor=[UIColor clearColor];
    return cell;	
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


#pragma mark -
#pragma mark UITableViewDelegate methods Implementation

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kCellHeight;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

#pragma mark -
#pragma mark NetworkManagerDelegate methods Implementation

-(void) didFinishBuying:(NSString *)statusCode statusMessage:(NSString *)message
{
    if([statusCode isEqualToString:@"00"])
    {
        if(isFreePunch)
        {
            self.punchCardDetails.is_free_punch=[NSNumber numberWithBool:NO];
        }
        [self goToCongratulationsView];
    }
    else
    if([statusCode isEqualToString:@"401"])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
        [[DatabaseManager sharedInstance] deleteEntity:self.punchCardDetails.business];
        [self.navigationController popToRootViewControllerAnimated:NO];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    
}

-(void) didFinishGettingProfile:(NSString *)statusCode statusMessage:(NSString *)message withMaskedId:(NSString *)maskedId withPaymentId:(NSString *)paymentId
{
    if([statusCode isEqualToString:@"00"])
    {
        [self goToConfirmPaymentView:paymentId withMaskedId:maskedId];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    
}

#pragma mark -
#pragma mark FBDialogDelegate methods Implementation

- (void)dialogCompleteWithUrl:(NSURL *)url {
    /*if (![url query]) {
     NSLog(@"User canceled dialog or there was an error");
     return;
     }
     NSDictionary *params = [self parseURLParams:[url query]];
     // Successful posts return a post_id
     if ([params valueForKey:@"post_id"]) {
     //[self showMessage:@"Published feed successfully."];
     NSLog(@"Feed post ID: %@", [params valueForKey:@"post_id"]);
     //Successfully posted...Unlock the free punch
     isFreePunch=YES;
     [self buy:@"" isFreePunch:true];
     
     }*/
    
    if([url.absoluteString rangeOfString:@"post_id="].location!=NSNotFound)
    {
        isFreePunch=YES;
        [self buy:@"" isFreePunch:true];
    }
    else
    {
    }
    [[FacebookFacade sharedInstance] setPunchCardOfferViewController:nil];
    
}


- (void)dialogDidNotCompleteWithUrl:(NSURL *)url
{

}


- (void)dialogDidNotComplete:(FBDialog *)dialog
{

}


- (void)dialog:(FBDialog*)dialog didFailWithError:(NSError *)error
{
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
        [alert release];
    }
   
}

#pragma mark -

- (IBAction)mapBtnTouchUpInsideHandler:(id)sender {
    [self goToMapView];
}

- (IBAction)buyBtnTouchUpInsideHandler:(id)sender {
    [self payBtnTouchUpInsideHandler:sender];
}

- (IBAction)getFreePunchBtnTouchUpInsideHandler:(id)sender 
{
    [[FacebookFacade sharedInstance] setPunchCardOfferViewController:self];
    [[FacebookFacade sharedInstance] apiLogin];
}

- (IBAction)payBtnTouchUpInsideHandler:(id)sender {
    if([[InfoExpert sharedInstance]isProfileCreated])
    {
        [networkManager getProfileRequest:[[InfoExpert sharedInstance] userId] withName:@""];
    }
    else
    {
        [self goToAddCardView];
    }
    
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

-(void)backBtnTouchUpInsideHandler:(id)sender
{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.5;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark -

- (void)shareOnFacebook {
    cnt++;
    SBJSON *jsonWriter = [[SBJSON new] autorelease];
    
    // The action links to be shown with the post in the feed
    NSString *url=@"http://itunes.apple.com/us/app/paidpunch/id501977872?mt=8";
    NSArray* actionLinks = [NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:
                                                      @"Get Started with PaidPunch",@"name",url,@"link", nil], nil];
    NSString *actionLinksStr = [jsonWriter stringWithObject:actionLinks];
    // Dialog parameters
    NSString *str=[NSString stringWithFormat:@"I just unlocked a free $%.2f %@ Punch using the PaidPunch iPhone app. Thank you %@!",[self.punchCardDetails.each_punch_value doubleValue],[self.punchCardDetails business_name],[self.punchCardDetails business_name]];
    
    NSString *logoUrl=[NSString stringWithFormat:@"%@",NSLocalizedString(@"FBShareLogoUrl", @"")];
    //[NSString stringWithFormat:@"%@%@",[[InfoExpert sharedInstance] appUrl], NSLocalizedString(@"FBShareLogoUrl", @"")];
    
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
-(void)loggedIn
{
    [[FacebookFacade sharedInstance] setPunchUsedViewController:nil];
    [self shareOnFacebook];
}

-(void) buy:(NSString *)orangeQrCode isFreePunch:(BOOL)unlockedFreePunch
{
    [networkManager buy:self.qrCode loggedInUserId:[[InfoExpert sharedInstance]userId] punchCardId:self.punchCardDetails.punch_card_id orangeQrCodeScanned:orangeQrCode isFreePunch:unlockedFreePunch withTransactionId:@"" withAmount:self.punchCardDetails.selling_price withPaymentId:@""];
}

#pragma mark -

-(void)setUpUI
{
    self.title = [NSString stringWithFormat:@"%@",punchCardDetails.business_name];
    self.buisnesslogoImageView.image=[UIImage imageWithData:punchCardDetails.business_logo_img];
    SDWebImageManager *manager=[SDWebImageManager sharedManager];
    UIImage *cachedImage=[manager imageWithURL:[NSURL URLWithString:self.punchCardDetails.business_logo_url]];
    if(cachedImage)
    {
        self.buisnesslogoImageView.image=cachedImage;
        self.activityIndicator.hidden=YES;
    }
    else
    {
        [self.activityIndicator startAnimating];
        self.activityIndicator.hidden=NO;
        [manager downloadWithURL:[NSURL URLWithString:self.punchCardDetails.business_logo_url] delegate:self];
    }

    self.punchCardNameLbl.text=[NSString stringWithFormat:@"%@",punchCardDetails.punch_card_desc];
    int totalPunches=[punchCardDetails.total_punches intValue];
    if([self.punchCardDetails.is_mystery_punch intValue]==1)
    {
        totalPunches-=1;
    }
    
    double eachPunchValue = [self.punchCardDetails.each_punch_value doubleValue];
    double actualPrice = [self.punchCardDetails.actual_price doubleValue];
    double discountPercent = 100*(1.0 - (eachPunchValue / actualPrice));
    
    double savingsValue = ([self.punchCardDetails.each_punch_value doubleValue] * totalPunches) - [self.punchCardDetails.selling_price doubleValue];
    
    NSString *payNowStr = [NSString stringWithFormat:@"<span style=\"font-size: 14pt\"><font color=#f47b27 face='helvetica'>Pay <b>$%.2f</b> right now...</font></span>", [punchCardDetails.selling_price doubleValue]];
    [payValueView loadHTMLString:payNowStr baseURL:nil];
    
    NSString *punchValueStr = [NSString stringWithFormat:@"<html><body><span style=\"font-size: 17pt\"><font color=#00B931 face='helvetica'>Get <b>$%.2f</b> off each of your next <b>%d</b> visits!</font><br /></span></body></html>", [punchCardDetails.each_punch_value doubleValue], totalPunches];
    [getValueView loadHTMLString:punchValueStr baseURL:nil];
    
    NSString *punchCardContentsStr;
    if([self.punchCardDetails.is_mystery_punch intValue]==1) {
        punchCardContentsStr = [NSString stringWithFormat:@"<html><head></head><body><center><font color=#565656 size=2 face='helvetica'><b>Buy now</b> and get a</font><font color=#00AFF4 size=2 face='helvetica'> FREE Mystery Punch!</center></body></html>"];
    }
    else {
        punchCardContentsView.hidden = YES;
        punchCardContentsBG.hidden = YES;
    }
    
    [punchCardContentsView loadHTMLString:punchCardContentsStr baseURL:nil];
    
    self.totalValueLabel.text = [NSString stringWithFormat:@"$%.2f", [punchCardDetails.actual_price doubleValue]];
    self.savingsValueLabel.text = [NSString stringWithFormat:@"$%.2f", savingsValue];
    
    self.freePunchLbl.text=[NSString stringWithFormat:@"Unlock a FREE $%.2f Punch",[self.punchCardDetails.each_punch_value doubleValue]];
    
    NSString *finePrintString;
    if ([punchCardDetails.expire_days integerValue] > 0) {
        finePrintString = [NSString stringWithFormat:@"<html><head></head><body><span style=\"font-size: 12pt\"><font color=#464646 face='helvetica'>- Must spend $%.2f or more to use a Punch towards purchase. <br />- One Punch may be used every %.0f minutes. <br/> - Promotional value expires %d days after purchase. <br/> - Not valid in combination with other discounts or promotional offers.</font></span><br /></body></html>", [punchCardDetails.minimum_value doubleValue], [punchCardDetails.redeem_time_diff doubleValue], [punchCardDetails.expire_days integerValue]];
    }
    else {
        finePrintString = [NSString stringWithFormat:@"<html><head></head><body><span style=\"font-size: 12pt\"><font color=#464646 face='helvetica'>- Must spend $%.2f or more to use a Punch towards purchase. <br />- One Punch may be used every %.0f minutes. <br/> - Does not expire. <br/> - Not valid in combination with other discounts or promotional offers.</font></span><br /></body></html>", [punchCardDetails.minimum_value doubleValue], [punchCardDetails.redeem_time_diff doubleValue]];
    }
        
    finePrintView = [[UIWebView alloc] initWithFrame:CGRectMake(6.0, 385.0, 308.0, 130.0)];
    [finePrintView loadHTMLString:finePrintString baseURL:nil];
    [[getFreePunchBtn superview] addSubview:finePrintView];
    
    finePrintDivider = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"FinePrintDivider.png"]];
    [finePrintDivider setFrame:CGRectMake(3.0, 355.0, 330.0f, 34.0)];
    [[getFreePunchBtn superview] addSubview:finePrintDivider];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *s=[defaults objectForKey:@"LoggedInFromFacebook"];
    if([s isEqualToString:@"YES"] && [self.punchCardDetails.is_free_punch intValue]==1)
    {
        self.getFreePunchBtn.enabled=YES;
    }
    else
    {
        self.getFreePunchBtn.enabled=NO;
        self.getFreePunchBtn.hidden=YES;
        self.freePunchLbl.hidden=YES;
        self.lockImageView.hidden=YES;
        self.cardView.frame=CGRectMake(0, 137, 320, 200);
    }
    [self.punchesListTableView reloadData];
}


-(void)setUpConfirmPurchaseUI:(ConfirmPurchaseView *)cview
{
    int totalPunches=[punchCardDetails.total_punches intValue];
    if([self.punchCardDetails.is_mystery_punch intValue]==1)
    {
        totalPunches-=1;
    }
    cview.totalCostOfPunchesValueLbl.text=[NSString stringWithFormat:@"%d x $%.2f",totalPunches,[self.punchCardDetails.discount_value_of_each_punch doubleValue]];
    cview.totalCostOfPunchesLbl.text=[NSString stringWithFormat:@"$%.2f",[self.punchCardDetails.selling_price doubleValue]];
    cview.totalRedeemablePunchesValueLbl.text=[NSString stringWithFormat:@"%d x $%.2f",totalPunches,[self.punchCardDetails.each_punch_value doubleValue]];
    cview.totalCostOfRedeemablePunches.text=[NSString stringWithFormat:@"$%.2f",[self.punchCardDetails.actual_price doubleValue]];
    double num=[self.punchCardDetails.actual_price doubleValue]-[self.punchCardDetails.selling_price doubleValue];
    cview.totalSavingsValueLbl.text=[NSString stringWithFormat:@"$%.2f",num];
    
    cview.totalSavingsLbl.textColor=[UIColor colorWithRed:244.0/255.0 green:123.0/255.0 blue:39.0/255.0 alpha:1];
    cview.totalSavingsValueLbl.textColor=[UIColor colorWithRed:244.0/255.0 green:123.0/255.0 blue:39.0/255.0 alpha:1];
    cview.expiryDateLbl.text=[NSString stringWithFormat:@"Promotional value expires %d days after purchase",[self.punchCardDetails.expire_days intValue]];
    cview.minimumPurchaseLbl.text=[NSString stringWithFormat:@"- Min. purchase of $%.2f required",[self.punchCardDetails.minimum_value doubleValue]];
    cview.timeDiffLbl.text=[NSString stringWithFormat:@"- 1 Punch may be used every %@ mins",self.punchCardDetails.redeem_time_diff];
}

#pragma mark -

-(void)goToConfirmPurchaseView
{
    ConfirmPurchaseView *confirmView;
    NSArray *xibUIObjects =[[NSBundle mainBundle] loadNibNamed:@"ConfirmPurchaseView" owner:self options:nil];
    confirmView= [xibUIObjects objectAtIndex:0];
    [confirmView.payBtn addTarget:self action:@selector(payBtnTouchUpInsideHandler:) forControlEvents:UIControlEventTouchUpInside];
    [self setUpConfirmPurchaseUI:confirmView];
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.window addSubview:confirmView];
}

- (void)goToAddCardView
{
    AddCardViewController *addCardViewController = [[AddCardViewController alloc] init:self.punchCardDetails];
    [self.navigationController pushViewController:addCardViewController animated:YES];
    [addCardViewController release];
}

- (void)goToPayToCashierView
{
    PayToCashierViewController *payToCashierView = [[PayToCashierViewController alloc] init:self.qrCode punchCardDetailsObj:self.punchCardDetails punchCardId:self.punchCardDetails.punch_card_id businessName:self.punchCardDetails.business_name];
    [self.navigationController pushViewController:payToCashierView animated:YES];
    [payToCashierView release];
}

-(void) gotoRootView
{
    [[DatabaseManager sharedInstance] deleteEntity:self.punchCardDetails];
    CATransition *transition = [CATransition animation];
    transition.duration = 0.5;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)goToCongratulationsView
{
    CongratulationsViewController *congratulationsView = [[CongratulationsViewController alloc] init:self.punchCardDetails.business_name isFreePunchUnlocked:isFreePunch];
    [self.navigationController pushViewController:congratulationsView animated:YES];
    [congratulationsView release];
    isFreePunch=NO;
}

- (void)goToConfirmPaymentView:(NSString *)paymentId withMaskedId:(NSString *)maskedId
{
    ConfirmPaymentViewController *confirmPaymentViewController = [[ConfirmPaymentViewController alloc] init:self.punchCardDetails withMaskedId:maskedId withPaymentId:paymentId];
    [self.navigationController pushViewController:confirmPaymentViewController animated:YES];
    [confirmPaymentViewController release];
}

-(void)goToMapView
{
    Business *b=[[DatabaseManager sharedInstance] getBusinessByBusinessId:punchCardDetails.business_id];
    punchCardDetails.business = b;
    NSArray *cardArray = [[NSArray alloc] initWithObjects:punchCardDetails, nil];
    BusinessLocatorViewController *businessMapViewController = [[BusinessLocatorViewController alloc] init:cardArray];
    //BusinessLocatorViewController *businessMapViewController = [[BusinessLocatorViewController alloc] init:self.punchCardDetails];
    [self.navigationController pushViewController:businessMapViewController animated:YES];
    [businessMapViewController release];
}

@end
