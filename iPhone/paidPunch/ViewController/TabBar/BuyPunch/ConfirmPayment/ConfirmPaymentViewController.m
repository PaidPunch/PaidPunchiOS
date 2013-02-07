//
//  ConfirmPaymentViewController.m
//  paidPunch
//
//  Created by mobimedia technologies on 21/03/12.
//  Copyright (c) 2012 mobimedia. All rights reserved.
//

#import "ConfirmPaymentViewController.h"
#import "Product.h"
#import "Products.h"
#import "User.h"

@implementation ConfirmPaymentViewController
@synthesize businessLogoImageView;
@synthesize descriptionLbl;
@synthesize valueLbl;
@synthesize pinLbl;
@synthesize creditCardLbl;

- (id)init:(NSUInteger)index
{
    self = [super init];
    if (self)
    {
        // Custom initialization
        _index = index;
        _popBackToHome = FALSE;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
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
    
    [self setUpUI];
}

-(void)viewWillAppear:(BOOL)animated
{
}

- (void)viewDidUnload
{
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
#pragma mark SDWebImageManagerDelegate methods Implementation

-(void)webImageManager:(SDWebImageManager *)imageManager didFinishWithImage:(UIImage *)image
{
    self.businessLogoImageView.image=image;
}

#pragma mark -

- (IBAction)purchaseBtnTouchUpInsideHandler:(id)sender
{
    [self buy];
}

- (IBAction)cancelBtnTouchUpInsideHandler:(id)sender
{    
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0 && _popBackToHome)
    {
        AppDelegate *delegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
        CATransition *transition = [CATransition animation];
        transition.duration = 0.5;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
        transition.type = kCATransitionPush;
        transition.subtype = kCATransitionFromLeft;
        [self.navigationController.view.layer addAnimation:transition forKey:nil];
        
        [self.navigationController popToViewController:[delegate rootController] animated:NO];
    }
    _popBackToHome = FALSE;
}

#pragma mark -

-(void)setUpUI
{
    self.valueLbl.textColor=[UIColor colorWithRed:244.0/255.0 green:123.0/255.0 blue:39.0/255.0 alpha:1];
    
    Product* current = [[[Products getInstance] productsArray] objectAtIndex:_index];
    
    NSNumberFormatter * formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle: NSNumberFormatterCurrencyStyle];
    NSString* costString = [formatter stringFromNumber:[current cost]];
    NSString* creditString = [formatter stringFromNumber:[current credits]];
    
    self.valueLbl.text=[NSString stringWithFormat:@"PAY $%@",costString];
    self.creditCardLbl.textColor=[UIColor colorWithRed:0/255.0 green:114/255.0 blue:180/255.0 alpha:1];
    self.pinLbl.text=[NSString stringWithFormat:@"for %@ credits",creditString];
    
}

#pragma mark - HttpCallbackDelegate
- (void) didCompleteHttpCallback:(NSString*)type success:(BOOL)success message:(NSString*)message
{
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:NO];
    
    if(success)
    {
        // Force user data to be refreshed from server
        [[User getInstance] forceRefresh];
        
        _popBackToHome = TRUE;
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Credit Purchased" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark -

-(void)buy
{
    _hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    _hud.labelText = @"Purchasing Credit";
    [[Products getInstance] purchaseProduct:self index:_index];
}

@end
