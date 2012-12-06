//
//  FeedBackViewController.m
//  paidPunch
//
//  Created by mobimedia technologies on 25/11/11.
//  Copyright (c) 2011 mobimedia. All rights reserved.
//

#import "FeedBackViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation FeedBackViewController
@synthesize feedbackTextView;

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
    self.title = [NSString stringWithFormat:@"%@",@"Feedback"];
    self.feedbackTextView.layer.cornerRadius=8.0;
    [self.feedbackTextView.layer setBorderColor:[[UIColor grayColor] CGColor]];
    [self.feedbackTextView.layer setBorderWidth:1.0];
    [self.feedbackTextView.layer setMasksToBounds:YES];
    networkManager=[[NetworkManager alloc] initWithView:self.view];
    networkManager.delegate=self;
}

- (void)viewDidUnload
{
    [self setFeedbackTextView:nil];
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
    NSLog(@"In dealloc of FeedBackViewController");
}


#pragma mark -
#pragma mark UITextViewDelegate methods Implementation

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    textView.text=@"";
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    [feedbackTextView resignFirstResponder];
    return TRUE;
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(self.feedbackTextView.text.length==0)
    {
        self.feedbackTextView.text=@"Type your feedback here";
    }
    [feedbackTextView resignFirstResponder];
}

#pragma mark -
#pragma mark NetworkManagerDelegate methods Implementation

-(void) didFinishSendingFeedback:(NSString *)statusCode statusMessage:(NSString *)message
{
    if([statusCode isEqualToString:@"00"])
    {
        self.feedbackTextView.text=@"Type your feedback here";
        UIAlertView *logInAlert = [[UIAlertView alloc] initWithTitle:@"Message" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [logInAlert show];
    }
    else
    {
        UIAlertView *logInAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [logInAlert show];
    }
}

#pragma mark -

- (IBAction)submitFeedBackBtnTouchUpInsideHandler:(id)sender {
    
    if(self.feedbackTextView.text.length==0 || [self.feedbackTextView.text isEqualToString:@"Type your feedback here"])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" message:@"Enter Feedback" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        [networkManager sendFeedBack:feedbackTextView.text loggedInUserId:[[InfoExpert sharedInstance]userId]];
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

@end
