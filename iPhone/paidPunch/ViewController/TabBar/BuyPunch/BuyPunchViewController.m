//
//  BuyPunchViewController.m
//  paidPunch
//
//  Created by Aaron Khoo on 1/15/13.
//  Copyright (c) 2013 PaidPunch. All rights reserved.
//

#import "BuyPunchViewController.h"

@implementation BuyPunchViewController
@synthesize businessLogoImageView;
@synthesize descriptionLbl;
@synthesize valueLbl;
@synthesize pinLbl;
@synthesize creditCardLbl;
@synthesize punchCardDetails;
@synthesize activityIndicator;

- (id)init:(PunchCard *)punchCard
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.punchCardDetails=punchCard;
    }
    return self;
}

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

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor=[UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:239.0/255.0 alpha:1];
    self.title=@"Confirm Payment";
    self.navigationItem.hidesBackButton=YES;
    
    networkManager=[[NetworkManager alloc] initWithView:self.view];
    networkManager.delegate = self;
    
    [self setUpUI];
}

-(void)viewWillAppear:(BOOL)animated
{
    if([[User getInstance] isPaymentProfileCreated])
    {
    }
    else
    {
        [self.navigationController popToRootViewControllerAnimated:NO];
    }
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark SDWebImageManagerDelegate methods Implementation

-(void)webImageManager:(SDWebImageManager *)imageManager didFinishWithImage:(UIImage *)image
{
    [self.activityIndicator stopAnimating];
    self.activityIndicator.hidden=YES;
    self.businessLogoImageView.image=image;
    [self.activityIndicator stopAnimating];
    self.activityIndicator.hidden=YES;
}

#pragma mark -
#pragma mark NetworkManagerDelegate methods Implementation

-(void) didFinishBuying:(NSString *)statusCode statusMessage:(NSString *)message
{
    if([statusCode isEqualToString:@"00"])
    {
        [self goToCongratulationsView];
    }
    else
        if([statusCode isEqualToString:@"401"])
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [[DatabaseManager sharedInstance] deleteEntity:self.punchCardDetails.business];
            [self.navigationController popToRootViewControllerAnimated:NO];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    
}

#pragma mark -

- (IBAction)purchaseBtnTouchUpInsideHandler:(id)sender {
    [self buy];
    //[self goToCongratulationsView];
}

- (IBAction)cancelBtnTouchUpInsideHandler:(id)sender {
    /*CATransition *transition = [CATransition animation];
     transition.duration = 0.5;
     transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
     transition.type = kCATransitionPush;
     transition.subtype = kCATransitionFromLeft;
     [self.navigationController.view.layer addAnimation:transition forKey:nil];
     
     [self.navigationController popViewControllerAnimated:NO];*/
    
    NSInteger noOfViewControllers = [self.navigationController.viewControllers count];
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:(noOfViewControllers - 3)] animated:YES];
}

#pragma mark -

- (void)goToCongratulationsView
{
    CongratulationsViewController *congratulationsView = [[CongratulationsViewController alloc] init:self.punchCardDetails.business_name isFreePunchUnlocked:NO];
    [self.navigationController pushViewController:congratulationsView animated:YES];
}

#pragma mark -

-(void)setUpUI
{
    self.valueLbl.textColor=[UIColor colorWithRed:244.0/255.0 green:123.0/255.0 blue:39.0/255.0 alpha:1];
    self.businessLogoImageView.image=[UIImage imageWithData:self.punchCardDetails.business_logo_img];
    self.descriptionLbl.text=self.punchCardDetails.punch_card_desc;
    
    self.valueLbl.text=[NSString stringWithFormat:@"PAY $%.2f",[self.punchCardDetails.selling_price doubleValue]];
    self.creditCardLbl.textColor=[UIColor colorWithRed:0/255.0 green:114/255.0 blue:180/255.0 alpha:1];
    self.pinLbl.text=[NSString stringWithFormat:@"%@", [[User getInstance] getCreditAsString]];
    SDWebImageManager *manager=[SDWebImageManager sharedManager];
    UIImage *cachedImage=[manager imageWithURL:[NSURL URLWithString:self.punchCardDetails.business_logo_url]];
    if(cachedImage)
    {
        self.businessLogoImageView.image=cachedImage;
    }
    else
    {
        [manager downloadWithURL:[NSURL URLWithString:self.punchCardDetails.business_logo_url] delegate:self];
    }
    
}

#pragma mark -

-(void)buy
{
    //[networkManager buy:@"" loggedInUserId:[[User getInstance] userId] punchCardId:self.punchCardDetails.punch_card_id orangeQrCodeScanned:@"" isFreePunch:false withTransactionId:@"123456" withAmount:self.punchCardDetails.selling_price withPaymentId:self.paymentId];
}

@end
