//
//  CreditCardSettingsViewController.m
//  paidPunch
//
//  Created by mobimedia technologies on 12/04/12.
//  Copyright (c) 2012 mobimedia. All rights reserved.
//

#import "CreditCardSettingsViewController.h"

@implementation CreditCardSettingsViewController
@synthesize deleteCardBtn;
@synthesize addCardBtn;
@synthesize cardMaskedCodeLbl;
@synthesize linkAddCardLbl;
@synthesize creditCardPinImageView;
@synthesize maskedId;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (id)init:(NSString *)creditCardMaskedId 
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.maskedId=creditCardMaskedId;
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
    networkManager=[[NetworkManager alloc] initWithView:self.view];
    networkManager.delegate=self;
    
    self.view.backgroundColor=[UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:239.0/255.0 alpha:1];
    self.title = @"Credit Card";
    
    [self setUpUI];
}

-(void)viewWillAppear:(BOOL)animated
{
    if([[InfoExpert sharedInstance] isProfileCreated])
    {
        [self setUpUI];
    }
}
- (void)viewDidUnload
{
    [self setDeleteCardBtn:nil];
    [self setAddCardBtn:nil];
    [self setCardMaskedCodeLbl:nil];
    [self setLinkAddCardLbl:nil];
    [self setCreditCardPinImageView:nil];
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
    [deleteCardBtn release];
    [addCardBtn release];
    [cardMaskedCodeLbl release];
    [linkAddCardLbl release];
    [creditCardPinImageView release];
    [maskedId release];
    [super dealloc];
}

#pragma mark -
#pragma mark UIAlertViewDelegate methods Implementation

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==0)
    {
        [networkManager deleteProfile];
    }
    
}

#pragma mark -
#pragma mark NetworkManagerDelegate methods Implementation

-(void) didFinishDeletingProfile:(NSString *)statusCode statusMessage:(NSString *)message
{
    if([statusCode isEqualToString:@"00"])
    {
        UIAlertView *logInAlert = [[UIAlertView alloc] initWithTitle:@"Message" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [logInAlert show];
        [logInAlert release];
        NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
        [[InfoExpert sharedInstance] setIsProfileCreated:NO];
        if([[InfoExpert sharedInstance] isProfileCreated])
        {
            [ud setObject:@"YES" forKey:@"isProfileCreated"];
        }
        else
        {
            [ud setObject:@"NO" forKey:@"isProfileCreated"];
        }
        [ud synchronize];
        [self setUpUI];
    }
    else
    {
        UIAlertView *logInAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [logInAlert show];
        [logInAlert release];
    }
    
}

#pragma mark -

-(void)setUpUI
{
    if([[InfoExpert sharedInstance] isProfileCreated])
    {
        self.linkAddCardLbl.hidden=NO;
        self.linkAddCardLbl.text=@"We have the following credit card on file:";
        self.addCardBtn.hidden=YES;
        
        self.deleteCardBtn.hidden=NO;
        self.cardMaskedCodeLbl.hidden=NO;
        self.creditCardPinImageView.hidden=NO;
        if(self.maskedId==nil)
        {
            self.cardMaskedCodeLbl.text=[[InfoExpert sharedInstance] maskedId];
        }
        else
        {
            self.cardMaskedCodeLbl.text=self.maskedId;
        }
    }
    else
    {
        self.addCardBtn.hidden=NO;
        self.linkAddCardLbl.hidden=NO;
        self.linkAddCardLbl.text=@"Add your credit card to start buying Punches, saving money, and winning prizes!";
        self.cardMaskedCodeLbl.hidden=YES;
        self.deleteCardBtn.hidden=YES;
        self.creditCardPinImageView.hidden=YES;
    }

}

#pragma mark -

- (IBAction)addCardBtnTouchUpInsideHandler:(id)sender {
    [self goToAddCardView];
}

- (IBAction)deleteCardBtnTouchUpInsideHandler:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"Do you want to delete this card ?" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel",nil];
    [alert show];
    [alert release];
    
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

- (void)goToAddCardView
{
    AddCardViewController *addCardViewController = [[AddCardViewController alloc] init:nil];
    [self.navigationController pushViewController:addCardViewController animated:YES];
    [addCardViewController release];
}
@end
