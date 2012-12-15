//
//  ChangePasswordViewController.m
//  paidPunch
//
//  Created by mobimedia technologies on 25/11/11.
//  Copyright (c) 2011 mobimedia. All rights reserved.
//

#import "ChangePasswordViewController.h"
#import "User.h"

@implementation ChangePasswordViewController
@synthesize oldPasswordTextField;
@synthesize nwPasswordTextField;
@synthesize confirmPasswordTextField;
@synthesize scrollView;

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
    
    self.title = [NSString stringWithFormat:@"%@",@"Change Password"];
    oldPasswordTextField.secureTextEntry=YES;
    nwPasswordTextField.secureTextEntry=YES;
    confirmPasswordTextField.secureTextEntry=YES;
    
    [self.scrollView setContentOffset:CGPointMake(0.0, 0.0) animated:YES] ;
	scrollView.scrollEnabled = FALSE;
    
    networkManager =[[NetworkManager alloc] initWithView:self.view];
    networkManager.delegate=self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleTap:) name:@"scrollViewTouchEvent" object:nil];
    
}

- (void)viewDidUnload
{
    [self setOldPasswordTextField:nil];
    [self setNwPasswordTextField:nil];
    [self setConfirmPasswordTextField:nil];
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
    NSLog(@"In dealloc of ChangePasswordViewController");
}

#pragma mark -
#pragma mark Text field delegate methods

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(textField==nwPasswordTextField || textField==confirmPasswordTextField)
    {
        [self.scrollView setContentOffset:CGPointMake(0.0, 180.0) animated:YES];
        scrollView.contentSize = CGSizeMake(320, 600);
        scrollView.scrollEnabled = TRUE;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if(textField==oldPasswordTextField)
        [nwPasswordTextField becomeFirstResponder];
    if (textField==nwPasswordTextField) {
        [confirmPasswordTextField becomeFirstResponder];
    }
    if(textField==confirmPasswordTextField)
    {
        [self.scrollView setContentOffset:CGPointMake(0.0, 0.0) animated:YES] ;
        scrollView.scrollEnabled = FALSE;

        if([self validate])
        {
            [networkManager changePassword:oldPasswordTextField.text newPassword:nwPasswordTextField.text loggedInUserId:[[User getInstance] userId]];
        }
    }
	return TRUE;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
}

#pragma mark -
#pragma mark NetworkManagerDelegate methods Implementation

-(void) didFinishChangingPassword:(NSString *)statusCode statusMessage:(NSString *)message
{
    if([statusCode rangeOfString:@"00"].location == NSNotFound)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        [[User getInstance] setPassword:nwPasswordTextField.text];
        
        oldPasswordTextField.text=@"";
        nwPasswordTextField.text=@"";
        confirmPasswordTextField.text=@"";
       
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];

    }

}

#pragma mark -
#pragma mark UIAlertViewDelegate methods Implementation

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController popToRootViewControllerAnimated:NO];
}

#pragma mark -

- (IBAction)saveBtnTouchUpInsideHandler:(id)sender {
    
    [oldPasswordTextField resignFirstResponder];
    [nwPasswordTextField resignFirstResponder];
    [confirmPasswordTextField resignFirstResponder];
    [self.scrollView setContentOffset:CGPointMake(0.0, 0.0) animated:YES];
	scrollView.scrollEnabled = FALSE;
    if([self validate])
    {
        [networkManager changePassword:oldPasswordTextField.text newPassword:nwPasswordTextField.text loggedInUserId:[[User getInstance] userId]];
    }
}

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

#pragma mark -

-(BOOL) validate
{
    if(oldPasswordTextField.text.length==0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Enter Old Password" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return NO;
    }
    if(![oldPasswordTextField.text isEqualToString:[[User getInstance] password]])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Enter correct Old Password" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return NO;
    }
    if(nwPasswordTextField.text.length==0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Enter New Password" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return NO;
    }
    if([nwPasswordTextField.text isEqualToString:oldPasswordTextField.text])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Old Password and New Password should be different" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return NO;
    }
    if(confirmPasswordTextField.text.length==0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Enter Confirm Password" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return NO;
    }
    if(![nwPasswordTextField.text isEqualToString:confirmPasswordTextField.text])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"New Password and Confirm password should be same" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return NO;
    }
    return YES;
}

-(void)handleTap:(NSNotification *) notification
{
    [oldPasswordTextField resignFirstResponder];
    [nwPasswordTextField resignFirstResponder];
    [confirmPasswordTextField resignFirstResponder];
    [self.scrollView setContentOffset:CGPointMake(0.0, 0.0) animated:YES];
	scrollView.scrollEnabled = FALSE;
}
@end
