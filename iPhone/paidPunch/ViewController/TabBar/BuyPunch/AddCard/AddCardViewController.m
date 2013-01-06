//
//  AddCardViewController.m
//  paidPunch
//
//  Created by mobimedia technologies on 21/03/12.
//  Copyright (c) 2012 mobimedia. All rights reserved.
//

#import "AddCardViewController.h"

@implementation AddCardViewController
@synthesize addCardDetailsTableView;
@synthesize scrollView;
@synthesize secureNetworkLbl;
@synthesize cardDetailsTableView;
@synthesize punchCardDetails;
@synthesize monthsDataSource;
@synthesize yearsDataSource;

#define kCellHeight		44.0

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (id)init:(PunchCard *)punchCard
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.punchCardDetails=punchCard;
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
    self.secureNetworkLbl.textColor=[UIColor colorWithRed:244.0/255.0 green:123.0/255.0 blue:39.0/255.0 alpha:1];
    self.title=@"Add Card";
    
    UIBarButtonItem *doneButton=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveBtnTouchUpInsideHandler:)];
    doneButton.title=@"Save";
    self.navigationItem.rightBarButtonItem=doneButton;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleTap:) name:@"scrollViewTouchEvent" object:nil];
    
    networkManager=[[NetworkManager alloc] initWithView:self.view];
    networkManager.delegate=self;
    
    self.monthsDataSource=[NSMutableArray arrayWithObjects:@"January(1)",@"February(2)",@"March(3)",@"April(4)",@"May(5)",@"June(6)",@"July(7)",@"August(8)",@"September(9)",@"October(10)",@"November(11)",@"December(12)",nil];
    
    NSCalendar *gregorian=[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components=[gregorian components:NSYearCalendarUnit | NSMonthCalendarUnit fromDate:[NSDate date]];
    NSInteger year=[components year];
    yearsDataSource=[[NSMutableArray alloc] init];
    for (int i=year; i<year+25; i++) {
        [self.yearsDataSource addObject:[NSString stringWithFormat:@"%d",i]];
    }

    
    numberToolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolBar.barStyle = UIBarStyleBlackTranslucent;
    numberToolBar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelNumberPad)],
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"Apply" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)],
                           nil];
    [numberToolBar sizeToFit];
}

-(void)viewWillAppear:(BOOL)animated
{
    if([[User getInstance] isPaymentProfileCreated])
    {
        if(self.punchCardDetails==nil)
        {
            CATransition *transition = [CATransition animation];
            transition.duration = 0.5;
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
            transition.type = kCATransitionPush;
            transition.subtype = kCATransitionFromLeft;
            [self.navigationController.view.layer addAnimation:transition forKey:nil];
            
            [self.navigationController popViewControllerAnimated:NO];
        }
        else
        {
            [networkManager getProfileRequest:[[User getInstance] userId] withName:@""];
        }
    }
}
- (void)viewDidUnload
{
    [self setSecureNetworkLbl:nil];
    [self setCardDetailsTableView:nil];
    [self setScrollView:nil];
    [self setAddCardDetailsTableView:nil];
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



#pragma mark -
#pragma mark UITableViewDataSource methods Implementation

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    if(section==0)
        return 2;
    else
        return 3;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *addCardCellIdentifier = @"AddCardCellIdentifier";
    
    AddCardViewCell *cell = (AddCardViewCell *)[tableView dequeueReusableCellWithIdentifier:addCardCellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AddCardViewCell" owner:self options:nil];
        cell  = (AddCardViewCell *)[nib objectAtIndex:0];
    }
	cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.valueTxtField.delegate=self;
    cell.backgroundColor=[UIColor clearColor];
    cell.textLabel.font=[UIFont fontWithName:@"Helvetica" size:14.0];
    if(indexPath.section==0)
    {
        if (indexPath.row==0) 
        {
            cell.valueTxtField.placeholder=@"Name";
            cell.valueTxtField.tag=1;
            cell.backgroundView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HomeLinkUpbox.png"]];
        }
        if(indexPath.row==1)
        {
            cell.valueTxtField.placeholder=@"Email";
            cell.valueTxtField.tag=2;
            cell.valueTxtField.keyboardType=UIKeyboardTypeEmailAddress;
            cell.backgroundView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HomeLinkDownbox.png"]];
        }
    }
    if(indexPath.section==1)
    {
        if (indexPath.row==0) 
        {
            cell.valueTxtField.placeholder=@"Card Number";
            cell.valueTxtField.tag=3;
            //cell.valueTxtField.secureTextEntry=YES;
            cell.valueTxtField.keyboardType=UIKeyboardTypeNumberPad;
            cell.backgroundView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HomeLinkUpbox.png"]];
        }
        if(indexPath.row==1)
        {
            cell.valueTxtField.placeholder=@"Expiration Date (MM-YYYY)";
            cell.valueTxtField.tag=4;
            cell.valueTxtField.keyboardType=UIKeyboardTypeDefault;
            cell.backgroundView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MiddleLinkBox.png"]];
        }
        if(indexPath.row==2)
        {
            cell.valueTxtField.placeholder=@"CVV (3 or 4 digit security code)";
            cell.valueTxtField.tag=5;
            cell.valueTxtField.keyboardType=UIKeyboardTypeNumberPad;
            cell.valueTxtField.returnKeyType = UIReturnKeyDone;
            cell.valueTxtField.inputAccessoryView = numberToolBar;
            cell.backgroundView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HomeLinkDownbox.png"]];
        }
    }
    return cell;
}

#pragma mark -
#pragma mark UITableViewDelegate methods Implementation

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self dismissKeyboard];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section 
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0,0,tableView.frame.size.width,38)];
    UIImageView *imageView =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"AddCartSmallBgStrip.png"]];
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, -10, headerView.frame.size.width,headerView.frame.size.height)];
    headerLabel.textAlignment = UITextAlignmentCenter;
    headerLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:12];
    headerLabel.backgroundColor = [UIColor clearColor];
    
    if(section==0)
        headerLabel.text=@"Personal Details";
    if(section==1)
        headerLabel.text=@"Credit Card Details";
    headerLabel.textColor=[UIColor colorWithRed:139.0/255.0 green:137.0/255.0 blue:139.0/255.0 alpha:1];
    [headerView addSubview:imageView];
    [headerView addSubview:headerLabel];
    return headerView;
    
}

#pragma mark -
#pragma mark UITextFieldDelegate methods Implementation

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField.tag==5)
    {
        if([textField.text length]<4)
            return YES;
        else
        {
            if([string isEqualToString:@""])
                return YES;
            return NO;
        }
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(textField.tag==3 ||textField.tag==4 ||textField.tag==5 || textField.tag==6)
    {
        [self.scrollView setContentOffset:CGPointMake(0.0, 180.0) animated:YES];
        scrollView.contentSize = CGSizeMake(320, 700);
        scrollView.scrollEnabled = TRUE;
        if(textField.tag==4)
        {
            [self showPickerView];
        }
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    AddCardViewCell *cell;
    NSIndexPath *indexPath;
    
    if(textField.tag==1)
    {
        indexPath=[NSIndexPath indexPathForRow:1 inSection:0];
        cell = (AddCardViewCell *)[addCardDetailsTableView cellForRowAtIndexPath:indexPath];
        [cell.valueTxtField becomeFirstResponder];
    }
    if(textField.tag==2)
    {
        indexPath=[NSIndexPath indexPathForRow:0 inSection:1];
        cell = (AddCardViewCell *)[addCardDetailsTableView cellForRowAtIndexPath:indexPath];
        [cell.valueTxtField becomeFirstResponder];
    }
    if(textField.tag==3)
    {
        indexPath=[NSIndexPath indexPathForRow:1 inSection:1];
        cell = (AddCardViewCell *)[addCardDetailsTableView cellForRowAtIndexPath:indexPath];
        [cell.valueTxtField becomeFirstResponder];
    }
    
    if(textField.tag==4)
    {
        indexPath=[NSIndexPath indexPathForRow:2 inSection:1];
        cell = (AddCardViewCell *)[addCardDetailsTableView cellForRowAtIndexPath:indexPath];
        [cell.valueTxtField becomeFirstResponder];
    }
    
    if(textField.tag == 5){
        [textField resignFirstResponder];
    }
    return TRUE;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self populateFields];
}

#pragma mark -
#pragma mark UIPickerViewDataSource methods Implementation

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView{
    return 2;
}

-(NSInteger)pickerView:(UIPickerView *)PickerView numberOfRowsInComponent:(NSInteger)component
{
    if(component==0)
        return [monthsDataSource count];
    else
        if(component==1)
            return [yearsDataSource count];
    return 0;
}

#pragma mark -
#pragma mark UIPickerViewDelegate methods Implementation

-(NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component 
{
    if(component==0)
        return [monthsDataSource objectAtIndex:row];
    else
        if(component==1)
            return [yearsDataSource objectAtIndex:row];
    return nil;
}

-(void) pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if(component==0)
        selectedMonth=row;
    if(component==1)
        selectedYear=row;
}

#pragma mark -
#pragma mark NetworkManagerDelegate methods Implementation

-(void) didFinishCreatingProfile:(NSString *)statusCode statusMessage:(NSString *)message
{
    if([statusCode isEqualToString:@"00"])
    {
        [[User getInstance] setIsPaymentProfileCreated:TRUE];
        
        if(self.punchCardDetails==nil)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];

            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        else
        {
            [networkManager getProfileRequest:[[User getInstance] userId] withName:@""];
        }
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

-(void) didFinishGettingProfile:(NSString *)statusCode statusMessage:(NSString *)message withMaskedId:(NSString *)maskedId withPaymentId:(NSString *)paymentId
{
    if([statusCode isEqualToString:@"00"])
    {
        if(self.navigationController.visibleViewController==self)
            [self goToConfirmPaymentView:paymentId withMaskedId:maskedId];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    
}

#pragma mark -

-(BOOL)validate
{
    [self populateFields];
    if(name.length==0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Add Card Error" message:@"Enter Name" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return NO;
    }
    if(email.length==0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Add Card Error" message:@"Enter Email Id" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return NO;
    }
    if(email.length!=0)
    {
        if(![self validateEmail:email])
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Add Card Error" message:@"Enter valid Email ID" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            return NO;
        }
    }
    
    if(cardNumber.length==0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Add Card Error" message:@"Enter Card Number" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return NO;
    }
    if(cardNumber.length!=0)
    {
        if(![self validateCard:cardNumber])
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Add Card Error" message:@"Enter Valid Card Number" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            return NO;
        }
    }
    if(expDate.length==0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Add Card Error" message:@"Enter Expiry Date" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return NO;
    }
    if(cvv.length==0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Add Card Error" message:@"Enter CVV" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return NO;
    }

    return YES;
}

-(void)dismissKeyboard
{
    NSIndexPath *userNameIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
	AddCardViewCell *cell = (AddCardViewCell *)[addCardDetailsTableView cellForRowAtIndexPath:userNameIndexPath];
    [cell.valueTxtField resignFirstResponder];
    
    NSIndexPath *emailIdIndexPath=[NSIndexPath indexPathForRow:1 inSection:0];
    cell = (AddCardViewCell *)[addCardDetailsTableView cellForRowAtIndexPath:emailIdIndexPath];
    [cell.valueTxtField resignFirstResponder]; 
    
    NSIndexPath *cardNumberIndexPath = [NSIndexPath indexPathForRow:0 inSection:1];
	cell = (AddCardViewCell *)[addCardDetailsTableView cellForRowAtIndexPath:cardNumberIndexPath];
    [cell.valueTxtField resignFirstResponder];
    
    NSIndexPath *expiryDateIndexPath = [NSIndexPath indexPathForRow:1 inSection:1];
	cell = (AddCardViewCell *)[addCardDetailsTableView cellForRowAtIndexPath:expiryDateIndexPath];
	[cell.valueTxtField resignFirstResponder];
    
    NSIndexPath *cvvIndexPath=[NSIndexPath indexPathForRow:2 inSection:1];
    cell = (AddCardViewCell *)[addCardDetailsTableView cellForRowAtIndexPath:cvvIndexPath];
    [cell.valueTxtField resignFirstResponder];
    
    [self.scrollView setContentOffset:CGPointMake(0.0, 0.0) animated:YES] ;
	scrollView.scrollEnabled = FALSE;
    
}

-(void)populateFields
{
    NSIndexPath *userNameIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
	AddCardViewCell *cell = (AddCardViewCell *)[addCardDetailsTableView cellForRowAtIndexPath:userNameIndexPath];
    name=cell.valueTxtField.text;
    
    NSIndexPath *emailIdIndexPath=[NSIndexPath indexPathForRow:1 inSection:0];
    cell = (AddCardViewCell *)[addCardDetailsTableView cellForRowAtIndexPath:emailIdIndexPath];
    email=cell.valueTxtField.text; 
    
    NSIndexPath *cardNumberIndexPath = [NSIndexPath indexPathForRow:0 inSection:1];
	cell = (AddCardViewCell *)[addCardDetailsTableView cellForRowAtIndexPath:cardNumberIndexPath];
    cardNumber=cell.valueTxtField.text;
    
    NSIndexPath *expiryDateIndexPath = [NSIndexPath indexPathForRow:1 inSection:1];
	cell = (AddCardViewCell *)[addCardDetailsTableView cellForRowAtIndexPath:expiryDateIndexPath];
	expDate=cell.valueTxtField.text;
    
    NSIndexPath *cvvIndexPath=[NSIndexPath indexPathForRow:2 inSection:1];
    cell = (AddCardViewCell *)[addCardDetailsTableView cellForRowAtIndexPath:cvvIndexPath];
    cvv=cell.valueTxtField.text;    
}

- (BOOL)validateEmail:(NSString *)emailId
{
	NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
	NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
	BOOL isValid = [emailTest evaluateWithObject:emailId];
	return isValid;
}
/*
- (BOOL) validateCard:(NSString *)ccNumberString
{
    BOOL validCard = NO;
    NSString *isAMEX=@"";
    NSString *ccNumber=ccNumberString;
    NSString * ccNumberReversed = @"";
    NSString * doubleNumbers = @"";
    NSString * everyOtherNumber = @"";
    NSString * lastChar = @"";
    NSString * intDoubled;
    NSString * stringToSum;
    NSUInteger count = [ccNumberString length];
    NSUInteger len = 1;
    NSRange r;
    
    //since American Express is American Express....., we have to do something special for them.... assholes....
    r = NSMakeRange( 0, 1);
    lastChar = [ccNumberString substringWithRange:r];
    if ([lastChar compare:@"3"] ==0) {
        
        isAMEX = @"YES";
        
    }
    else {
        isAMEX = @"NO";
    }
    //reverse the string
    
    for ( int i=0; i<count; i++){
        r = NSMakeRange( count-i-1, len);
        lastChar = [ccNumberString substringWithRange:r];
        ccNumberReversed = [ccNumberReversed stringByAppendingString:lastChar];
    }
    
    //double every other number
    
    int loc = 1;
    int ttr = ccNumberReversed.length/2;
    for ( int i=0; i<ttr; i++){
        
        r = NSMakeRange( loc, len);
        loc = loc+2;
        lastChar = [ccNumberReversed substringWithRange:r];
        int dv = [lastChar intValue];
        dv = (dv * 2);
        intDoubled = [NSString stringWithFormat:@"%d",dv];
        doubleNumbers = [doubleNumbers stringByAppendingString:intDoubled];
    }
    
    // get every other number starting at index 0
    loc = 0;
    if ([isAMEX compare:@"YES"] ==0) {
        ttr = ccNumber.length/2+1;
    }
    else {
        ttr = ccNumber.length/2;
    }
    
    
    for ( int i=0; i<ttr; i++){
        
        r = NSMakeRange( loc, len);
        loc = loc+2;
        lastChar = [ccNumberReversed substringWithRange:r];
        everyOtherNumber = [everyOtherNumber stringByAppendingString:lastChar];
    }
    
    //combine both strings so we can sum them up
    stringToSum = [doubleNumbers stringByAppendingString:everyOtherNumber];
    
    // add all the numbers up one by one and divide by 10... if no remainder - its a valid card
    
    loc = 0;
    ttr = stringToSum.length;
    int stringSum = 0;
    for ( int i=0; i<ttr; i++){
        
        r = NSMakeRange( loc, len);
        lastChar = [stringToSum substringWithRange:r];
        int cc = [lastChar intValue];
        stringSum = stringSum+cc;
        
        loc ++;
    }
    
    if (stringSum%10 == 0) {
        
        validCard = YES;
    }
    else {
        
        validCard = NO;
    }
    
    return validCard;
}*/

-(BOOL) validateCard:(NSString *)ccNumberString
{
    
    const char *str = [ccNumberString UTF8String];
    int n, i, alternate, sum;
    
    n = strlen(str);
    
    if ( n < 13 || n > 19 )
        return NO;
    
    for (alternate = 0, sum = 0, i = n-1; i>-1; --i) {
        if ( !isdigit(str[i]))
            return NO;
        
        n = str[i]-'0';
        
        if ( alternate ) {
            n*=2;
            if ( n > 9 )
                n = ( n % 10 ) + 1;
        }
        
        alternate = !alternate;
        
        sum += n;
    }
    
    return ( sum % 10 == 0 );
}


-(void)handleTap:(NSNotification *) notification
{
    [self dismissKeyboard];
}

#pragma mark -

- (IBAction)saveBtnTouchUpInsideHandler:(id)sender {
    
    [self dismissKeyboard];
        
    if([self validate])
    {
        NSArray *arr=[expDate componentsSeparatedByString:@"-"];
        [networkManager createProfile:name withUserID:[[User getInstance] userId] withEmail:email withExpDate:[NSString stringWithFormat:@"%@-%@",[arr objectAtIndex:1],[arr objectAtIndex:0]] withCVV:cvv withCardNo:cardNumber];
    }
}

- (IBAction)goBack:(id)sender {
    NSInteger noOfViewControllers = [self.navigationController.viewControllers count];
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:(noOfViewControllers - 3)] animated:YES];
}

-(void)donebtnClickEventHandler
{
    [self dismissKeyboard];
	[actionSheet dismissWithClickedButtonIndex:0 animated:YES];

    NSString *monthStr=@"";
    if(selectedMonth<9)
        monthStr=[NSString stringWithFormat:@"0%d",selectedMonth+1];
    else    
        monthStr=[NSString stringWithFormat:@"%d",selectedMonth+1];
    NSString *str=[NSString stringWithFormat:@"%@-%@",monthStr,[yearsDataSource objectAtIndex:selectedYear]];

    NSIndexPath *expiryDateIndexPath = [NSIndexPath indexPathForRow:1 inSection:1];
	AddCardViewCell *cell = (AddCardViewCell *)[addCardDetailsTableView cellForRowAtIndexPath:expiryDateIndexPath];
	cell.valueTxtField.text=str;
}

- (void)cancelNumberPad {
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:2 inSection:1];
    AddCardViewCell *cell = (AddCardViewCell *)[addCardDetailsTableView cellForRowAtIndexPath:indexPath];
    [cell.valueTxtField setText:@""];
    [self dismissKeyboard];
}

- (void)doneWithNumberPad {
    [self dismissKeyboard];
}

#pragma mark -

-(void) showPickerView
{
	UIToolbar *pickerToolBar=[[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
	pickerToolBar.barStyle=UIBarStyleBlackOpaque;
	[pickerToolBar sizeToFit];
	
	NSMutableArray *baritems=[[NSMutableArray alloc] init];
	
	UIBarButtonItem *flexSpace=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
	[baritems addObject:flexSpace];
	
	UIBarButtonItem *doneBtn=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(donebtnClickEventHandler)];
	[baritems addObject:doneBtn];
	[pickerToolBar setItems:baritems animated:YES];
	
	
	actionSheet=[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
	[actionSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
	pickerView=[[UIPickerView alloc]initWithFrame:CGRectMake(0, 44, 0, 0)];
	pickerView.delegate=self;
	pickerView.showsSelectionIndicator=YES;
	
	[actionSheet addSubview:pickerToolBar];
	[actionSheet addSubview:pickerView];
	[actionSheet showInView:[self.view superview]];
	[actionSheet setBounds:CGRectMake(0, 0, 320, 464)];
	
    
    NSCalendar *gregorian=[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components=[gregorian components:NSYearCalendarUnit | NSMonthCalendarUnit fromDate:[NSDate date]];
    NSInteger month=[components month];
    
    selectedMonth=month-1;
    selectedYear=0;
    [pickerView selectRow:month-1 inComponent:0 animated:YES];
    [pickerView selectRow:0 inComponent:1 animated:YES];
    [pickerView reloadAllComponents];
    
}

#pragma mark -

- (void)goToConfirmPaymentView:(NSString *)paymentId withMaskedId:(NSString *)maskedId
{
    /*
    [[InfoExpert sharedInstance] setMaskedId:maskedId];
    ConfirmPaymentViewController *confirmPaymentViewController = [[ConfirmPaymentViewController alloc] init:self.punchCardDetails withMaskedId:maskedId withPaymentId:paymentId];
    [self.navigationController pushViewController:confirmPaymentViewController animated:YES];
     */
}


@end
