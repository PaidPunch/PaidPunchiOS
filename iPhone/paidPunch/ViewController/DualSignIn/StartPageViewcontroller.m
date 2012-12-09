//
//  StartPageViewcontroller.m
//  paidPunch
//
//  Created by Alexander Nabavi-Noori on 7/26/12.
//  Copyright (c) 2012 mobimedia. All rights reserved.
//

#import "StartPageViewController.h"

@implementation StartPageViewController

@synthesize scrollView;
@synthesize pageControl;
@synthesize viewControllers;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        totalContentCount = 0;
        userHasInteracted = NO;
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

- (CGRect) getPlacardFrame:(int)placardIndex
{
    CGRect frame;
    frame.origin.x = self.scrollView.frame.size.width * placardIndex;
    frame.origin.y = 0;
    frame.size = self.scrollView.frame.size;
    return frame;
}

- (int) initializeInfoPlacards:(int)currentIndex
{
    NSArray *placardFiles = [NSArray arrayWithObjects:@"InformationPlacardThree.png", @"InformationPlacardTwo.png", @"InformationPlacardOne.png", nil];
    int count;
    for (count = currentIndex; count < placardFiles.count; count++)
    {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:[self getPlacardFrame:count]];
        [imageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@", [placardFiles objectAtIndex:count]]]];
        [self.scrollView addSubview:imageView];
    }
    return count;
}

- (UITextField*) initializeUITextField:(CGRect)frame placeholder:(NSString*)placeholder font:(UIFont*)font
{
    UITextField *textField = [[UITextField alloc] initWithFrame:frame];
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.font = font;
    textField.placeholder = placeholder;
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.keyboardType = UIKeyboardTypeDefault;
    textField.returnKeyType = UIReturnKeyDone;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textField.delegate = self;
    return textField;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}

- (int) initializeLoginPlacard:(int)currentIndex
{
    CGFloat distanceFromTop = 30;
    CGFloat textHeight = 50;
    CGFloat constrainedSize = 265.0f;
    UIFont* textFont = [UIFont fontWithName:@"Helvetica" size:15.0f];
    UIFont* buttonFont = [UIFont systemFontOfSize:13];
    UIColor* separatorColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0];
    
    UIView *loginView = [[UIView alloc] initWithFrame:[self getPlacardFrame:currentIndex]];
    
    CGFloat textFieldWidth = loginView.frame.size.width - 40;
    CGFloat leftSpacing = (loginView.frame.size.width - textFieldWidth)/2;
    
    // Create textfield for email
    CGRect emailFrame = CGRectMake(leftSpacing, distanceFromTop, textFieldWidth, textHeight);
    UITextField *emailTextField = [self initializeUITextField:emailFrame placeholder:@"Email: example@example.com" font:textFont];
    
    // Create textfield for password
    CGRect passwordFrame = CGRectMake(leftSpacing, emailFrame.size.height + emailFrame.origin.y + 5, textFieldWidth, textHeight);
    UITextField *passwordTextField = [self initializeUITextField:passwordFrame placeholder:@"Password" font:textFont];
    
    // Create login button
    UIButton* loginButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    //[loginButton addTarget:self action:@selector(didPressLoginButton:) forControlEvents:UIControlEventTouchUpInside];
    NSString* loginText = @"Sign In";
    CGSize sizeLoginText = [loginText sizeWithFont:buttonFont
                                 constrainedToSize:CGSizeMake(constrainedSize, CGFLOAT_MAX)
                                     lineBreakMode:UILineBreakModeWordWrap];
    CGFloat loginButtonWidth = sizeLoginText.width + 30;
    CGFloat loginButtonHeight = sizeLoginText.height + 10;
    [loginButton setFrame:CGRectMake(loginView.frame.size.width - leftSpacing - loginButtonWidth, passwordFrame.size.height + passwordFrame.origin.y + 10, loginButtonWidth, loginButtonHeight)];
    [loginButton setTitle:loginText forState:UIControlStateNormal];
    loginButton.titleLabel.font = buttonFont;
    
    // Create forgot password button
    UIButton* forgotPasswordButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    //[forgotPasswordButton addTarget:self action:@selector(didPressLoginButton:) forControlEvents:UIControlEventTouchUpInside];
    NSString* forgotPasswordText = @"Forgot Password";
    CGSize sizeforgotPasswordText = [forgotPasswordText sizeWithFont:buttonFont
                                                   constrainedToSize:CGSizeMake(constrainedSize, CGFLOAT_MAX)
                                                       lineBreakMode:UILineBreakModeWordWrap];
    CGFloat forgotPasswordButtonWidth = sizeforgotPasswordText.width + 30;
    CGFloat forgotPasswordButtonHeight = sizeforgotPasswordText.height + 10;
    [forgotPasswordButton setFrame:CGRectMake(leftSpacing, passwordFrame.size.height + passwordFrame.origin.y + 10, forgotPasswordButtonWidth, forgotPasswordButtonHeight)];
    [forgotPasswordButton setTitle:forgotPasswordText forState:UIControlStateNormal];
    forgotPasswordButton.titleLabel.font = buttonFont;
    
    // Create OR label
    CGFloat orLabelYPos = forgotPasswordButton.frame.size.height + forgotPasswordButton.frame.origin.y + 20;
    NSString* lbtext = @" or ";
    CGSize sizeText = [lbtext sizeWithFont:textFont
                         constrainedToSize:CGSizeMake(constrainedSize, CGFLOAT_MAX)
                             lineBreakMode:UILineBreakModeWordWrap];
    UILabel *orLabel = [[UILabel alloc] initWithFrame:CGRectMake((loginView.frame.size.width - sizeText.width)/2, orLabelYPos, sizeText.width, sizeText.height)];
    orLabel.text = lbtext;
    orLabel.backgroundColor = [UIColor clearColor];
    orLabel.textColor = separatorColor;
    [orLabel setNumberOfLines:1];
    [orLabel setFont:textFont];
    orLabel.textAlignment = UITextAlignmentLeft;
    
    // Draw horizontal lines
    CGFloat hortLineYPos = orLabelYPos + (orLabel.frame.size.height/2);
    CGFloat hortLineWidth = (loginView.frame.size.width - leftSpacing*2 - orLabel.frame.size.width)/2;
    UIView *hortLine1 = [[UIView alloc] initWithFrame:CGRectMake(leftSpacing, hortLineYPos, hortLineWidth, 1.0)];
    UIView *hortLine2 = [[UIView alloc] initWithFrame:CGRectMake(leftSpacing + hortLineWidth + orLabel.frame.size.width, hortLineYPos, hortLineWidth, 1.0)];
    hortLine1.backgroundColor = separatorColor;
    hortLine2.backgroundColor = separatorColor;
    
    // Insert facebook signup/signin image
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"SignInFacebook" ofType:@"png"];
    NSData *imageData = [NSData dataWithContentsOfFile:filePath];
    UIImage *image = [[UIImage alloc] initWithData:imageData];
    UIButton* btnFacebook = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat imageLeftEdge = loginView.frame.size.width/2 - image.size.width/2;
    btnFacebook.frame = CGRectMake(imageLeftEdge, orLabel.frame.origin.y + orLabel.frame.size.height + 20, image.size.width, image.size.height);
    [btnFacebook setBackgroundImage:image forState:UIControlStateNormal];
    [btnFacebook setTitle:@"          Sign In With Facebook" forState:UIControlStateNormal];
    [btnFacebook setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnFacebook.titleLabel.font = textFont;
    
    [loginView addSubview:emailTextField];
    [loginView addSubview:passwordTextField];
    [loginView addSubview:orLabel];
    [loginView addSubview:hortLine1];
    [loginView addSubview:hortLine2];
    [loginView addSubview:btnFacebook];
    [loginView addSubview:loginButton];
    [loginView addSubview:forgotPasswordButton];
    [self.scrollView addSubview:loginView];
    
    return (currentIndex+1);
}

- (void) initializeAllPlacards
{    
    // Initialize informational placards
    totalContentCount = [self initializeInfoPlacards:totalContentCount];

    // Add login page
    totalContentCount = [self initializeLoginPlacard:totalContentCount];
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * totalContentCount, self.scrollView.frame.size.height);
	
	self.pageControl.currentPage = 0;
	self.pageControl.numberOfPages = totalContentCount;
    
    pagingTimer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(autoChangePage) userInfo:nil repeats:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	pageControlBeingUsed = NO;
	
    [self initializeAllPlacards];
}

- (void)viewDidUnload
{
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	self.scrollView = nil;
	self.pageControl = nil;
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden=YES;
}

- (void)awakeFromNib
{    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)loadScrollViewWithPage:(int)page
{
    
}

#pragma mark - Scroll View Delegate
- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    if (!pageControlBeingUsed)
    {
		// Switch the indicator when more than 50% of the previous/next page is visible
		CGFloat pageWidth = self.scrollView.frame.size.width;
		int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
		self.pageControl.currentPage = page;
	}
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
	pageControlBeingUsed = NO;
    
    // Turn off auto-scroll since user has started interacting with the pages
    userHasInteracted = YES;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
	pageControlBeingUsed = NO;
}

#pragma mark -
#pragma mark MPMoviePlayerPlaybackDidFinishNotification handler

- (void) movieFinishedCallback:(NSNotification*) aNotification
{
    NSNumber *reason = [[aNotification userInfo] objectForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey]; 
	switch ([reason integerValue]) 
	{
            /* The end of the movie was reached. */
		case MPMovieFinishReasonPlaybackEnded:
            /*
             Add your code here to handle MPMovieFinishReasonPlaybackEnded.
             */
			break;
            
            /* An error was encountered during playback. */
		case MPMovieFinishReasonPlaybackError:
            NSLog(@"An error was encountered during playback");
			break;
            
            /* The user stopped playback. */
		case MPMovieFinishReasonUserExited:
			break;
		default:
			break;
	}
    
    MPMoviePlayerController *player = [aNotification object];
    [[NSNotificationCenter defaultCenter] 
     removeObserver:self
     name:MPMoviePlayerPlaybackDidFinishNotification
     object:player];
    [player stop];
    [self dismissMoviePlayerViewControllerAnimated];
}

- (void) switchPage:(NSInteger)page
{
    // Update the scroll view to the appropriate page
	CGRect frame;
	frame.origin.x = self.scrollView.frame.size.width * page;
	frame.origin.y = 0;
	frame.size = self.scrollView.frame.size;
	[self.scrollView scrollRectToVisible:frame animated:YES];
	
	// Keep track of when scrolls happen in response to the page control
	// value changing. If we don't do this, a noticeable "flashing" occurs
	// as the the scroll delegate will temporarily switch back the page
	// number.
	pageControlBeingUsed = YES;
}

#pragma mark - Interface Actions

- (IBAction)changePage:(id)sender
{
    [self switchPage:self.pageControl.currentPage];
}

- (IBAction)pressPlay:(id)sender
{
    NSString *url = [[NSBundle mainBundle] 
                     pathForResource:@"paidpunch_iphone" 
                     ofType:@"mp4"];
    
    CustomMoviePlayer *playerViewController = 
    [[CustomMoviePlayer alloc] 
     initWithContentURL:[NSURL fileURLWithPath:url]];
    
    [[NSNotificationCenter defaultCenter] 
     addObserver:self
     selector:@selector(movieFinishedCallback:)
     name:MPMoviePlayerPlaybackDidFinishNotification
     object:[playerViewController moviePlayer]];
    
    //---play movie---
    MPMoviePlayerController *player = [playerViewController moviePlayer];
    
    [player setControlStyle:MPMovieControlStyleFullscreen];
    player.shouldAutoplay=YES;
    [player setFullscreen:YES];
    player.movieSourceType=MPMovieSourceTypeFile;
    
    [[player view]setFrame:[self.view bounds]];
    [UIView transitionWithView:self.view.window duration:1.0f options:0 animations:^{[self presentMoviePlayerViewControllerAnimated:playerViewController];} completion:nil];
    //[self presentMoviePlayerViewControllerAnimated:playerViewController];
    [player play];
}

- (IBAction)showFAQ:(id)sender
{
    FAQViewController *faqViewController= [[FAQViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:faqViewController animated:YES];
}

- (IBAction)signIn:(id)sender
{
    //DualSignInViewController *dualSignInViewController = [[DualSignInViewController alloc] initWithNibName:nil bundle:nil];
    //[self.navigationController pushViewController:dualSignInViewController animated:YES];
    pageControl.currentPage = 3;
    [self switchPage:self.pageControl.currentPage];
    
    userHasInteracted = YES;
}

- (void)autoChangePage
{
    if(userHasInteracted == NO)
    {
        if(pageControl.currentPage < (totalContentCount - 1))
        {
            pageControl.currentPage += 1;
        }
        else
        {
            pageControl.currentPage = 0;
        }
        
        [self switchPage:self.pageControl.currentPage];
    }
}

@end
