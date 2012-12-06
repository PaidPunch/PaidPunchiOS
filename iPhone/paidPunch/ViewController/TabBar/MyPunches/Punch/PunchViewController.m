//
//  PunchViewController.m
//  paidPunch
//
//  Created by mobimedia technologies on 01/12/11.
//  Copyright (c) 2011 mobimedia. All rights reserved.
//

#import "PunchViewController.h"

@implementation PunchViewController

@synthesize punchCardDetails;
@synthesize buisnesslogoImageView;
@synthesize punchesListTableView;
@synthesize businessNameMarqueeLabel;
@synthesize eachPunchValueLbl;
@synthesize remainingMysterPunchesLbl;
@synthesize remainingPunchesLbl;
//@synthesize usedPunchesLbl;
@synthesize expiryLbl;
@synthesize activityIndicator;
@synthesize punchDiscountValueLbl;
@synthesize punchId;

@synthesize usingPunchesInstructionsImage;
@synthesize doneUsingPunchesInstructionsButton;

#define kCellHeight		50.0

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
    self.title = [NSString stringWithFormat:@"%@",@""];
    self.navigationController.navigationBarHidden = YES;
    
    self.punchesListTableView.backgroundColor = [UIColor clearColor];
	self.punchesListTableView.sectionFooterHeight = 0;
    self.punchesListTableView.sectionHeaderHeight = 0;
    self.punchesListTableView.separatorColor=[UIColor clearColor];
    
    networkManager=[[NetworkManager alloc] initWithView:self.view];
    networkManager.delegate=self;
    
    passwordAlert = [[UIAlertView alloc] initWithTitle:@"Enter Password" message:@"\n\n" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK",nil];
    [passwordAlert dismissWithClickedButtonIndex:0 animated:NO];
    passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake(12, 60, 260, 25)];
    
    CGAffineTransform myTransform = CGAffineTransformMakeTranslation(0, 0);
    [passwordAlert setTransform:myTransform];
    
    passwordTextField.borderStyle=UITextBorderStyleRoundedRect;
    passwordTextField.returnKeyType=UIReturnKeyDone;
    passwordTextField.delegate=self;
    passwordTextField.secureTextEntry=YES;
    [passwordTextField setBackgroundColor:[UIColor whiteColor]];
    [passwordAlert addSubview:passwordTextField];
    
    //[self setUpUI];
    
    NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
    NSString *s=[ud objectForKey:@"isMyPunchesManualShown"];
    if(s==nil || [s isEqualToString:@"NO"])
    {
        usingPunchesInstructionsImage.hidden = NO;
        doneUsingPunchesInstructionsButton.hidden = NO;
    }
}

- (IBAction)doneWithUsingPunchesInstructions:(id)sender {
    NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
    [ud setObject:@"YES" forKey:@"isMyPunchesManualShown"];
    [ud synchronize];
    
    usingPunchesInstructionsImage.hidden = YES;
    doneUsingPunchesInstructionsButton.hidden = YES;
}

- (void)viewDidUnload
{
    [self setPunchDiscountValueLbl:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewWillAppear:(BOOL)animated
{
    [self setUpUI];
}

#pragma mark -
#pragma mark Cleanup

- (void)dealloc {
    
//    [usedPunchesLbl release];
    NSLog(@"In dealloc of PunchViewController");
}

#pragma mark -
#pragma mark UITableViewDataSource methods Implementation

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int totalPunches=[self.punchCardDetails.total_punches intValue];
//    if(self.punchCardDetails.is_mystery_punch==[NSNumber numberWithInt:1])
//        totalPunches+=1;
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
//    if(self.punchCardDetails.is_mystery_punch==[NSNumber numberWithInt:1])
//        totalPunches+=1;
    
    UIImage *mysteryImage=[UIImage imageNamed:@"MysteryPunch.png"];
    
    if(indexPath.row == rowCnt-1)
    {
        int mod=totalPunches%5;
        if(mod == 4)
        {
            cell.button5.hidden=YES;
            if([self.punchCardDetails.is_mystery_punch intValue]==1)
            {
                [cell.button4 setBackgroundImage:mysteryImage forState:UIControlStateNormal];
                cell.button4.tag=2;
            }
        }
        if(mod == 3)
        {
            cell.button5.hidden=YES;
            cell.button4.hidden=YES;
            if([self.punchCardDetails.is_mystery_punch intValue]==1)
            {
                [cell.button3 setBackgroundImage:mysteryImage forState:UIControlStateNormal];
                cell.button3.tag=2;
            }
        }
        if(mod == 2)
        {
            cell.button5.hidden=YES;
            cell.button4.hidden=YES;
            cell.button3.hidden=YES;
            if([self.punchCardDetails.is_mystery_punch intValue]==1)
            {
                [cell.button2 setBackgroundImage:mysteryImage forState:UIControlStateNormal];
                cell.button2.tag=2;
            }
        }
        if(mod == 1)
        {
            cell.button5.hidden=YES;
            cell.button4.hidden=YES;
            cell.button3.hidden=YES;
            cell.button2.hidden=YES;
            if([self.punchCardDetails.is_mystery_punch intValue]==1)
            {
                [cell.button1 setBackgroundImage:mysteryImage forState:UIControlStateNormal];
                cell.button1.tag=2;
            }
        }
        if(mod == 0)
        {
            if([self.punchCardDetails.is_mystery_punch intValue]==1)
            {
                [cell.button5 setBackgroundImage:mysteryImage forState:UIControlStateNormal];
                cell.button5.tag=2;
            }
        }
    }
    int x=[self.punchCardDetails.total_punches_used intValue] / 5;
    int rcnt=[self.punchCardDetails.total_punches_used intValue] % 5;
    if(rcnt!=0)
        x = x+1;
    
    if(indexPath.row < x)
    {
        if(indexPath.row==0)
            usedCnt =[self.punchCardDetails.total_punches_used intValue];
        else
        if(indexPath.row==x-1)
        {
            int m=[self.punchCardDetails.total_punches_used intValue]%5;
            if(m==0)
                usedCnt=5;
            else
                usedCnt=m;
        }
        else
        {
            usedCnt=indexPath.row * 5 - ((indexPath.row)-1 * 5);
        }
        
        if(usedCnt!=0)
        {
            [cell.button1 setBackgroundImage:[UIImage imageNamed:@"UsedPunch.png"] forState:UIControlStateNormal];
            cell.button1.tag=1;
            usedCnt--;
        }
        if(usedCnt!=0)
        {
            [cell.button2 setBackgroundImage:[UIImage imageNamed:@"UsedPunch.png"] forState:UIControlStateNormal];
            cell.button2.tag=1;
            usedCnt--;
        }
        if(usedCnt!=0)
        {
            [cell.button3 setBackgroundImage:[UIImage imageNamed:@"UsedPunch.png"] forState:UIControlStateNormal];
            cell.button3.tag=1;
            usedCnt--;
        }
        if(usedCnt!=0)
        {
            [cell.button4 setBackgroundImage:[UIImage imageNamed:@"UsedPunch.png"] forState:UIControlStateNormal];
            cell.button4.tag=1;
            usedCnt--;
        }
        if(usedCnt!=0)
        {
            [cell.button5 setBackgroundImage:[UIImage imageNamed:@"UsedPunch.png"] forState:UIControlStateNormal];
            cell.button5.tag=1;
            usedCnt--;
        }
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone; 
    cell.backgroundColor=[UIColor clearColor];
    
    [cell.button1 addTarget: self action: @selector(mark:) forControlEvents: UIControlEventTouchUpInside];
    [cell.button2 addTarget: self action: @selector(mark:) forControlEvents: UIControlEventTouchUpInside];
    [cell.button3 addTarget: self action: @selector(mark:) forControlEvents: UIControlEventTouchUpInside];
    [cell.button4 addTarget: self action: @selector(mark:) forControlEvents: UIControlEventTouchUpInside];
    [cell.button5 addTarget: self action: @selector(mark:) forControlEvents: UIControlEventTouchUpInside];
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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    /*if([passwordTextField.text isEqualToString:[[InfoExpert sharedInstance]password]])
    {
        if(buttonIndex==1)
        {
            [networkManager markPunchUsed:punchCardDetails.punch_card_id punchCardDownloadId:punchCardDetails.punch_card_download_id loggedInUserId:[[InfoExpert sharedInstance]userId]];
        }
    }
    else
    {
        if(buttonIndex==1)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Incorrect password" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
    }
    passwordTextField.text=@"";
    [passwordTextField resignFirstResponder];*/
    if(self.punchCardDetails.offer==nil)
    {
        [networkManager getMysteryOffer:[[InfoExpert sharedInstance] userId] withPunchCardId:self.punchCardDetails.punch_card_id withPunchCardDownloadId:self.punchCardDetails.punch_card_download_id];
    }
    else
    {
        [self goToConfirmView:self.punchCardDetails.offer];
    }
}


#pragma mark -
#pragma mark UITextFieldDelegate methods Implementation

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [passwordAlert dismissWithClickedButtonIndex:0 animated:NO];
    
    if([passwordTextField.text isEqualToString:[[InfoExpert sharedInstance]password]])
    {
        /*[networkManager markPunchUsed:punchCardDetails.punch_card_id punchCardDownloadId:punchCardDetails.punch_card_download_id loggedInUserId:[[InfoExpert sharedInstance]userId]];*/
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Incorrect password" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    [passwordTextField resignFirstResponder];
    passwordTextField.text=@"";
	return TRUE;
}


#pragma mark -
#pragma mark NetworkManagerDelegate methods Implementation

-(void) didFinishMarkingPunchUsed:(NSString *)statusCode statusMessage:(NSString *)message barcodeImage:(NSData *)imageData barcodeValue:(NSString *)barcode;
{
    if([statusCode isEqualToString:@"00"] || [statusCode isEqualToString:@"03"])
    {
        int pc=[self.punchCardDetails.total_punches_used intValue];
        [self.punchCardDetails setTotal_punches_used:[NSNumber numberWithInt:++pc]];
        [[DatabaseManager sharedInstance] saveEntity:self.punchCardDetails];
        [self goToPunchUsedView:punchCardDetails barcodeImage:imageData barcodeValue:barcode];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
}


-(void) didFinishGettingMysteryOffer:(NSString *)statusCode statusMessage:(NSString *)message withOffer:(NSString *)offer
{
    if([statusCode isEqualToString:@"00"])
    {
        [self.punchCardDetails setOffer:offer];
        [[DatabaseManager sharedInstance] saveEntity:nil];
        [self goToConfirmView:offer];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
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

-(IBAction)mark:(id)sender
{
    UIButton *btn=sender;
    if(btn.tag==1)
    {
    }
    else
    if(btn.tag==2)
    {
        int rem=[self.punchCardDetails.total_punches intValue]-[self.punchCardDetails.total_punches_used intValue];
        if(rem==1)
        {
            /*UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mystery Punch" message:@"You have successfully unlocked your Mystery Punch." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [alert release];*/
            if(self.punchCardDetails.offer==nil)
            {
                [networkManager getMysteryOffer:[[InfoExpert sharedInstance] userId] withPunchCardId:self.punchCardDetails.punch_card_id withPunchCardDownloadId:self.punchCardDetails.punch_card_download_id];
            }
            else
            {
                [self goToConfirmView:self.punchCardDetails.offer];
            }
            
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mystery Punch" message:@"Use all your regular Punches to unlock the Mystery Punch." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    }
    else
    {
        [self goToConfirmView:nil];
    }
}


#pragma mark -

- (IBAction)punchBtnTouchUpInsideHandler:(id)sender {
    /*[networkManager markPunchUsed:punchCardDetails.punch_card_id punchCardDownloadId:punchCardDetails.punch_card_download_id loggedInUserId:[[InfoExpert sharedInstance]userId]];*/
}

- (IBAction)goBack:(id)sender {
    [self gotoRootView];
}

#pragma mark -

-(void)goToConfirmView:(NSString *)moffer
{
    SlideToConfirmDialog *confirmViewController = [[SlideToConfirmDialog alloc] init:self.punchCardDetails withMysteryOffer:moffer];
    confirmViewController.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:confirmViewController animated:YES];
}

-(void) goToPunchUsedView:(PunchCard *)punchCard barcodeImage:(NSData *)imageData barcodeValue:(NSString *)barcode;
{
    PunchUsedViewController *punchView = [[PunchUsedViewController alloc] init:punchCard barcodeImageData:imageData barcodeValue:barcode];
    punchView.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:punchView animated:YES];
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
    self.punchCardDetails=[[DatabaseManager sharedInstance] getPunchCardById:punchId];
    self.title = [NSString stringWithFormat:@"%@",punchCardDetails.business_name];

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

    businessNameMarqueeLabel = [[MarqueeLabel alloc] initWithFrame:CGRectMake(80.0, 0.0, 170.0, 45.0) rate:20.0f andFadeLength:10.0f];
    [businessNameMarqueeLabel setFont:[UIFont systemFontOfSize:21.0]];
    [businessNameMarqueeLabel setTextColor:[UIColor colorWithRed:255.0/255.0 green:136.0/255.0 blue:55.0/255.0 alpha:1.0]];
    self.businessNameMarqueeLabel.text=[NSString stringWithFormat:@"%@",punchCardDetails.business_name];
    [self.view addSubview:businessNameMarqueeLabel];
    
    int remaining=[punchCardDetails.total_punches intValue]-[punchCardDetails.total_punches_used intValue];
    if([self.punchCardDetails.is_mystery_punch intValue]==1)
    {
        remaining-=1;
    }
    
    if ([self.punchCardDetails.is_mystery_punch intValue]==1 && [self.punchCardDetails.is_mystery_used intValue] == 0) {
        [remainingMysterPunchesLbl setText:@"1"];
    }
    else {
        [remainingMysterPunchesLbl setText:@"0"];
    }
    
    self.remainingPunchesLbl.text=[NSString stringWithFormat:@"%d",remaining];
    self.remainingPunchesLbl.textColor=[UIColor colorWithRed:244.0/255.0 green:123.0/255.0 blue:39/255.0 alpha:1];
//    self.usedPunchesLbl.text=[NSString stringWithFormat:@"%@",[punchCardDetails.total_punches_used stringValue]];
//    self.usedPunchesLbl.textColor=[UIColor colorWithRed:244.0/255.0 green:123.0/255.0 blue:39/255.0 alpha:1];
    
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM-dd-yyyy"];
    NSString *dateString=[dateFormat stringFromDate:punchCardDetails.expiry_date];
    if([punchCardDetails.punch_expire intValue]==1)
    {
        self.expiryLbl.text=[NSString stringWithFormat:@"Card Expired"];
        self.punchDiscountValueLbl.text=[NSString stringWithFormat:@"$%.2f",[punchCardDetails.discount_value_of_each_punch doubleValue]];
        self.punchDiscountValueLbl.textColor=[UIColor colorWithRed:244.0/255.0 green:123.0/255.0 blue:39/255.0 alpha:1];
        [self.eachPunchValueLbl setStrokeColor:[UIColor blackColor]];
        [self.eachPunchValueLbl setStroke:2];
        self.eachPunchValueLbl.text=[NSString stringWithFormat:@"$%.2f Punches",[punchCardDetails.each_punch_value doubleValue]];
    }
    else
    {
        self.expiryLbl.text=[NSString stringWithFormat:@"Expires %@",dateString];
        self.eachPunchValueLbl.text=[NSString stringWithFormat:@"$%.2f Punches",[punchCardDetails.each_punch_value doubleValue]];
        self.eachPunchValueLbl.textColor=[UIColor colorWithRed:244.0/255.0 green:123.0/255.0 blue:39/255.0 alpha:1];
    }
    self.expiryLbl.textColor=[UIColor colorWithRed:139.0/255.0 green:137.0/255.0 blue:139.0/255.0 alpha:1];
    usedCnt=[punchCardDetails.total_punches_used intValue];
    [self.punchesListTableView reloadData];
}

@end
