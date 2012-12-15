//
//  CongratulationsViewController.m
//  paidPunch
//
//  Created by mobimedia technologies on 25/11/11.
//  Copyright (c) 2011 mobimedia. All rights reserved.
//

#import "CongratulationsViewController.h"

@implementation CongratulationsViewController
@synthesize congratulationsLbl;
@synthesize punchCardDetailedLbl;
@synthesize punchCardName;
@synthesize isFreePunch;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)init:(NSString *)bName isFreePunchUnlocked:(BOOL)isFreePunchUnlocked
{
    self = [super init];
    if (self) {
        self.punchCardName=bName;
        self.isFreePunch=isFreePunchUnlocked;
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
    self.navigationItem.hidesBackButton=YES;
    //[[InfoExpert sharedInstance] setBuyFlag:YES];
    
    UIBarButtonItem *doneButton=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneBtnTouchUpInsideHandler:)];
    self.navigationItem.rightBarButtonItem=doneButton;
    [self setUpUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(userViewedMyPunchesPage) name:@"userViewedMyPunchesPage" object:nil];
}

- (void)userViewedMyPunchesPage {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)viewDidUnload
{
    [self setCongratulationsLbl:nil];
    [self setPunchCardDetailedLbl:nil];
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

    NSLog(@"In dealloc of CongratulationsViewController");
}

#pragma mark -

- (IBAction)doneBtnTouchUpInsideHandler:(id)sender {
    [self goToBuyPunchView];
}

#pragma mark -

-(void) goToBuyPunchView
{
    [self.navigationController popToRootViewControllerAnimated:NO];
}

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

-(void)setUpUI
{
    self.title = [NSString stringWithFormat:@"%@",punchCardName];
    //self.congratulationsLbl.textColor=[UIColor colorWithRed:244.0/255.0 green:123.0/255.0 blue:39.0/255.0 alpha:1];
    self.congratulationsLbl.text=@"Congratulations!";
    self.punchCardDetailedLbl.textColor=[UIColor colorWithRed:244.0/255.0 green:123.0/255.0 blue:39.0/255.0 alpha:1];
    if(isFreePunch)
    {
        self.punchCardDetailedLbl.text=[NSString stringWithFormat:@"You just unlocked a FREE %@ Punch.",punchCardName];
    }
    else
    {
        self.punchCardDetailedLbl.text=[NSString stringWithFormat:@"You have successfully purchased a %@ PaidPunch Card.",punchCardName];
    }
}

@end
