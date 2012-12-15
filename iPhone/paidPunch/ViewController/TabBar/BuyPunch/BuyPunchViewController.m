//
//  BuyPunchViewController.m
//  paidPunch
//
//  Created by mobimedia technologies on 25/11/11.
//  Copyright (c) 2011 mobimedia. All rights reserved.
//

#import "BuyPunchViewController.h"
#import "User.h"


@implementation BuyPunchViewController
@synthesize qrCode;

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
    self.title = [NSString stringWithFormat:@"%@",@"Buy"];
    
    networkManager=[[NetworkManager alloc] initWithView:self.view];
    networkManager.delegate=self;
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
#pragma mark Cleanup

- (void)dealloc {
    NSLog(@"In dealloc of BuyPunchViewController");
}

/*#pragma mark -
#pragma mark ZXingDelegate methods Implementation

- (void)zxingController:(ZXingWidgetController*)controller didScanResult:(NSString *)result {
	if (self.isViewLoaded) 
	{
	}
    self.qrCode=result;
    [self dismissModalViewControllerAnimated:NO];
    [self getBusinessOffer];
}

- (void)zxingControllerDidCancel:(ZXingWidgetController*)controller {
	[self dismissModalViewControllerAnimated:NO];
}*/

#pragma mark -
#pragma mark NetworkManagerDelegate methods Implementation

-(void) didFinishLoadingBusinessOffer:(NSString *)statusCode statusMessage:(NSString *)message punchCardDetails:(PunchCard*)punchCard;
{
    if([statusCode isEqualToString:@"00"])
    {
        [self goToPunchCardOfferView:self.qrCode punchCardDetails:punchCard];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

#pragma mark -

- (IBAction)searchByQrCodeBtnTouchUpInsideHandler:(id)sender {
    [self goToScanQRCodeView];
}

- (IBAction)searchByBusinessBtnTouchUpInsideHandler:(id)sender {
    [self goToSearchByBusinessView];
}

#pragma mark -

-(void) goToSearchByBusinessView
{
    SearchByBusinessViewController *searchByBusinessView = [[SearchByBusinessViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:searchByBusinessView animated:YES];
    //[searchByBusinessView loadBusinessList];
}

- (void)goToPunchCardOfferView:(NSString *)offerQrCode punchCardDetails:(PunchCard *)punchCard
{
    PunchCardOfferViewController *punchCardOfferView = [[PunchCardOfferViewController alloc] init:offerQrCode punchCardDetails:punchCard];
    [self.navigationController pushViewController:punchCardOfferView animated:YES];
}

-(void)goToScanQRCodeView
{
    /*ZXingWidgetController *widController = [[ZXingWidgetController alloc] initWithDelegate:self showCancel:YES OneDMode:NO type:@"scan"];
    QRCodeReader* qrcodeReader = [[QRCodeReader alloc] init];
    NSSet *readers = [[NSSet alloc ] initWithObjects:qrcodeReader,nil];
    [qrcodeReader release];
    widController.readers = readers;
    [readers release];
    [self presentModalViewController:widController animated:NO];
    [widController release];*/
}

-(void) getBusinessOffer
{
    [networkManager getBusinessOffer:self.qrCode loggedInUserId:[[User getInstance] userId]];
}

@end
