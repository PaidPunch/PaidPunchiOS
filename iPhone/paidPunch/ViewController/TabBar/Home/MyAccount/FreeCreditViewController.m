//
//  FreeCreditViewController.m
//  paidPunch
//
//  Created by Aaron Khoo on 1/8/13.
//  Copyright (c) 2013 PaidPunch. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "FreeCreditViewController.h"

@interface FreeCreditViewController ()

@end

@implementation FreeCreditViewController
@synthesize btnFacebook = _btnFacebook;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    CGFloat currentYPos = 80.0;
    CGFloat spacing = 20.0;
    currentYPos = [self createFreeCreditLabel:currentYPos];
    currentYPos = [self createFacebookButton:currentYPos + spacing];
    currentYPos = [self createEmailButton:currentYPos + spacing];
    currentYPos = [self createBusinessButton:currentYPos + spacing];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private functions

- (CGFloat)createFreeCreditLabel:(CGFloat)ypos
{
    CGFloat constrainedSize = 265.0f;
    UIFont* textFont = [UIFont fontWithName:@"Helvetica" size:15.0f];
    NSString* lbtext = @"Get Free Credit by referring your friends, or suggesting businesses for the PaidPunch network!";
    CGSize sizeText = [lbtext sizeWithFont:textFont
                         constrainedToSize:CGSizeMake(constrainedSize, CGFLOAT_MAX)
                             lineBreakMode:UILineBreakModeWordWrap];
    _lblFreeCredit = [[UILabel alloc] initWithFrame:CGRectMake((self.view.frame.size.width - sizeText.width)/2, ypos, sizeText.width, sizeText.height)];
    _lblFreeCredit.text = lbtext;
    _lblFreeCredit.backgroundColor = [UIColor clearColor];
    _lblFreeCredit.textColor = [UIColor blackColor];
    [_lblFreeCredit setFont:textFont];
    _lblFreeCredit.numberOfLines = 3;
    _lblFreeCredit.textAlignment = UITextAlignmentLeft;
    
    [self.view addSubview:_lblFreeCredit];
    
    return (_lblFreeCredit.frame.origin.y + _lblFreeCredit.frame.size.height);
}

- (CGFloat)createFacebookButton:(CGFloat)ypos
{
    // Create Facebook Post button
    UIFont* textFont = [UIFont fontWithName:@"Helvetica" size:15.0f];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"SignInFacebook" ofType:@"png"];
    NSData *imageData = [NSData dataWithContentsOfFile:filePath];
    UIImage *image = [[UIImage alloc] initWithData:imageData];
    _btnFacebook = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat imageLeftEdge = self.view.frame.size.width/2 - image.size.width/2;
    _btnFacebook.frame = CGRectMake(imageLeftEdge, ypos, image.size.width, image.size.height);
    [_btnFacebook setBackgroundImage:image forState:UIControlStateNormal];
    [_btnFacebook setTitle:@"          Invite Via Facebook" forState:UIControlStateNormal];
    [_btnFacebook setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _btnFacebook.titleLabel.font = textFont;
    [_btnFacebook addTarget:self action:@selector(didPressFacebookButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_btnFacebook];
    
    return (_btnFacebook.frame.origin.y + _btnFacebook.frame.size.height);
}

- (CGFloat)createEmailButton:(CGFloat)ypos
{
    // Create Email Invite button
    UIFont* textFont = [UIFont fontWithName:@"Helvetica" size:15.0f];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"SignInFacebook" ofType:@"png"];
    NSData *imageData = [NSData dataWithContentsOfFile:filePath];
    UIImage *image = [[UIImage alloc] initWithData:imageData];
    _btnEmail = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    CGFloat imageLeftEdge = self.view.frame.size.width/2 - image.size.width/2;
    _btnEmail.frame = CGRectMake(imageLeftEdge, ypos, image.size.width, image.size.height);
    [_btnEmail setTitle:@"Invite Via Email" forState:UIControlStateNormal];
    [_btnEmail setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _btnEmail.titleLabel.font = textFont;
    [_btnEmail addTarget:self action:@selector(didPressFacebookButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_btnEmail];
    
    return (_btnEmail.frame.origin.y + _btnEmail.frame.size.height);
}


// TODO: Refactor code with EmailButton above if the Business button isn't significantly different
- (CGFloat)createBusinessButton:(CGFloat)ypos
{
    // Create Email Invite button
    UIFont* textFont = [UIFont fontWithName:@"Helvetica" size:15.0f];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"SignInFacebook" ofType:@"png"];
    NSData *imageData = [NSData dataWithContentsOfFile:filePath];
    UIImage *image = [[UIImage alloc] initWithData:imageData];
    _btnBusiness = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    CGFloat imageLeftEdge = self.view.frame.size.width/2 - image.size.width/2;
    _btnBusiness.frame = CGRectMake(imageLeftEdge, ypos, image.size.width, image.size.height);
    [_btnBusiness setTitle:@"Suggest A Business" forState:UIControlStateNormal];
    [_btnBusiness setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _btnBusiness.titleLabel.font = textFont;
    [_btnBusiness addTarget:self action:@selector(didPressFacebookButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_btnBusiness];
    
    return (_btnEmail.frame.origin.y + _btnEmail.frame.size.height);
}

#pragma mark - Event actions

- (IBAction)goBack:(id)sender
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
