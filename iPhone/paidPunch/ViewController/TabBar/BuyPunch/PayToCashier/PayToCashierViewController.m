//
//  PayToCashierViewController.m
//  paidPunch
//
//  Created by mobimedia technologies on 25/11/11.
//  Copyright (c) 2011 mobimedia. All rights reserved.
//

#import "PayToCashierViewController.h"

@implementation PayToCashierViewController

@synthesize offerQrCode;
@synthesize punchCardDetails;
@synthesize punchCardValueLbl;
@synthesize punchCardNameLbl;
@synthesize noOfPunchesLbl;
@synthesize imageView;
@synthesize punchId;
@synthesize businessName;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)init:(NSString *)offerCode punchCardDetailsObj:(PunchCard *)punchCard punchCardId:(NSString *)pid businessName:(NSString *)bName;
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.offerQrCode=offerCode;
        self.punchCardDetails=punchCard;
        self.punchId=pid;
        self.businessName=bName;
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
    
    networkManager=[[NetworkManager alloc] initWithView:self.view];
    networkManager.delegate=self;
    
    orangeCodeAlert = [[UIAlertView alloc] initWithTitle:@"Please Enter Security Code" message:@"\n\n" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK",nil];
    [orangeCodeAlert dismissWithClickedButtonIndex:0 animated:NO];
    orangeCodeTextField = [[UITextField alloc] initWithFrame:CGRectMake(12, 60, 260, 25)];
    
    CGAffineTransform myTransform = CGAffineTransformMakeTranslation(0, 0);
    [orangeCodeAlert setTransform:myTransform];
    
    orangeCodeTextField.borderStyle=UITextBorderStyleRoundedRect;
    orangeCodeTextField.returnKeyType=UIReturnKeyDone;
    orangeCodeTextField.delegate=self;
    orangeCodeTextField.secureTextEntry=YES;
    [orangeCodeTextField setBackgroundColor:[UIColor whiteColor]];
    orangeCodeTextField.keyboardType=UIKeyboardTypeNumberPad;
    [orangeCodeAlert addSubview:orangeCodeTextField];
    
    attempts=0;
    [self setUpUI];

}

- (void)viewDidUnload
{
    [self setPunchCardValueLbl:nil];
    [self setPunchCardNameLbl:nil];
    [self setNoOfPunchesLbl:nil];
    [self setImageView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void) viewWillAppear:(BOOL)animated
{
}
#pragma mark -
#pragma mark Cleanup

- (void)dealloc {
    NSLog(@"In dealloc of PayToCashierViewController");
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
    {
        attempts++;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    
}

#pragma mark -
#pragma mark AlertViewDelegate methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if([orangeCodeTextField.text isEqualToString:@""])
    {
        if(buttonIndex==1)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Enter Code" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    }
    else
    {
        if(buttonIndex==1)
        {
            [self buy:orangeCodeTextField.text];
        }
        orangeCodeTextField.text=@"";
        [orangeCodeTextField resignFirstResponder];
    }
}

#pragma mark -
#pragma mark TextFieldDelegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if([orangeCodeTextField.text isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Enter Code" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        [self buy:orangeCodeTextField.text];
    }
    [orangeCodeAlert dismissWithClickedButtonIndex:0 animated:NO];
    [orangeCodeTextField resignFirstResponder];
    orangeCodeTextField.text=@"";
	return TRUE;
}

#pragma mark -

- (IBAction)nextBtnTouchUpInsideHandler:(id)sender {
    [self goToScanQRCodeView];
}

#pragma mark -

/*
 #pragma mark -
 #pragma mark ZXingDelegate methods Implementation
 
- (void)zxingController:(ZXingWidgetController*)controller didScanResult:(NSString *)result {
	if (self.isViewLoaded) 
	{
	}
    [self buy:result];
    [self dismissModalViewControllerAnimated:NO];
}

- (void)zxingControllerDidCancel:(ZXingWidgetController*)controller {
	[self dismissModalViewControllerAnimated:NO];
}
*/

#pragma mark -

-(void) gotoRootView
{
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
    /*CongratulationsViewController *congratulationsView = [[CongratulationsViewController alloc] init:self.businessName];
    congratulationsView.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:congratulationsView animated:YES];
    [congratulationsView release];*/
}

-(void)goToScanQRCodeView
{
    /*ZXingWidgetController *widController = [[ZXingWidgetController alloc] initWithDelegate:self showCancel:YES OneDMode:NO type:@"redeem"];
     QRCodeReader* qrcodeReader = [[QRCodeReader alloc] init];
     NSSet *readers = [[NSSet alloc ] initWithObjects:qrcodeReader,nil];
     [qrcodeReader release];
     widController.readers = readers;
     [readers release];
     [self presentModalViewController:widController animated:NO];
     [widController release];*/
    if(attempts >= 3)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Maximum Attempts Failed" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else    
        [orangeCodeAlert show];
}

#pragma mark -

-(void) buy:(NSString *)orangeQrCode;
{
    /*[networkManager buy:self.offerQrCode loggedInUserId:[[InfoExpert sharedInstance]userId] punchCardId:punchId orangeQrCodeScanned:orangeQrCode];*/
}

#pragma mark -

-(void)setUpUI
{
    self.title = [NSString stringWithFormat:@"%@",punchCardDetails.business_name];
    self.imageView.image=[UIImage imageWithData:punchCardDetails.business_logo_img];
    self.punchCardNameLbl.text=[NSString stringWithFormat:@"%@ \nPaidPunch Card",punchCardDetails.business_name];
    self.noOfPunchesLbl.text=[NSString stringWithFormat:@"%@ $%@ punches ($%@ value)",[punchCardDetails.total_punches stringValue],[punchCardDetails.each_punch_value stringValue],[punchCardDetails.actual_price stringValue]];
    self.punchCardValueLbl.text=[NSString stringWithFormat:@"$%@",[punchCardDetails.selling_price stringValue]];
}

@end
