//
//  BizButtonView.m
//  paidPunch
//
//  Created by Aaron Khoo on 2/10/13.
//  Copyright (c) 2013 PaidPunch. All rights reserved.
//

#import "BizButtonView.h"
#import "BusinessPageViewController.h"
#import "PunchCard.h"
#import "UrlImage.h"
#import "UrlImageManager.h"
#import "Utilities.h"

static const CGFloat kLogoHeight = 100;

@implementation BizButtonView

- (id)initWithFrameAndBusiness:(CGRect)frame current:(BusinessOffers*)current
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _businessOffers = current;
        _width = frame.size.width;
        
        _nameLabel = [self createNameLabel];
        _logoImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, _nameLabel.frame.size.height, _width, kLogoHeight)];
        [_logoImage setBackgroundColor:[UIColor blackColor]];
        _upsellLabel = [self createUpsellLabel:(_logoImage.frame.origin.y + _logoImage.frame.size.height)];
        
        CGFloat totalHeight = _nameLabel.frame.size.height + _logoImage.frame.size.height + _upsellLabel.frame.size.height;
        CGRect finalRect = self.frame;
        finalRect.size.height = totalHeight;
        self.frame = finalRect;        
        
        [self addSubview:_nameLabel];
        [self addSubview:_logoImage];
        [self addSubview:_upsellLabel];
        
        NSArray* offers = [_businessOffers getOffers];
        if (offers != nil)
        {
            [self fillInRemainingButtonDetails:[offers objectAtIndex:0]];
        }
        else
        {
            _spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            _spinner.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
            _spinner.hidesWhenStopped = YES;
            [self addSubview:_spinner];
            [_spinner startAnimating];

            [_businessOffers retrieveOffersFromServer:self];
        }
        
        // Create invisible button that goes on top of uiview
        _overlayButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_overlayButton addTarget:self action:@selector(didTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        [_overlayButton addTarget:self action:@selector(didTouchDown:) forControlEvents:UIControlEventTouchDown];
        [_overlayButton addTarget:self action:@selector(didDragOutside:) forControlEvents:UIControlEventTouchDragOutside];
        [_overlayButton setFrame:CGRectMake(0, 0, finalRect.size.width, finalRect.size.height)];
    }
    return self;
}

- (UIImageView*)createNameLabel
{    
    // Start with smaller image
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"tile-header-small" ofType:@"png"];
    NSData *imageData = [NSData dataWithContentsOfFile:filePath];
    UIImage *image = [[UIImage alloc] initWithData:imageData];
    CGRect originalRect = CGRectMake(0, 0, image.size.width, image.size.height);
    CGRect finalRect = [Utilities resizeProportionally:originalRect maxWidth:_width maxHeight:image.size.height];
    
    NSString* name = [[_businessOffers business] business_name];
    UIFont* textFont = [UIFont fontWithName:@"Helvetica-Bold" size:17.0f];
    CGSize sizeName = [name sizeWithFont:textFont
                       constrainedToSize:CGSizeMake(_width, CGFLOAT_MAX)
                           lineBreakMode:UILineBreakModeWordWrap];
    
    // Text is too large, use larger image
    if (finalRect.size.height < sizeName.height)
    {
        filePath = [[NSBundle mainBundle] pathForResource:@"tile-header-large" ofType:@"png"];
        imageData = [NSData dataWithContentsOfFile:filePath];
        image = [[UIImage alloc] initWithData:imageData];
        originalRect = CGRectMake(0, 0, image.size.width, image.size.height);
        finalRect = [Utilities resizeProportionally:originalRect maxWidth:_width maxHeight:image.size.height];
    }
    
    UILabel* nameLabel = [[UILabel alloc] initWithFrame:finalRect];
    [nameLabel setText:name];
    [nameLabel setBackgroundColor:[UIColor clearColor]];
    [nameLabel setTextColor:[UIColor whiteColor]];
    [nameLabel setTextAlignment:UITextAlignmentCenter];
    [nameLabel setFont:textFont];
    [nameLabel setAdjustsFontSizeToFitWidth:YES];
    [nameLabel setNumberOfLines:2];
    
    UIImageView* nameBackground = [[UIImageView alloc] initWithImage:image];
    nameBackground.frame = finalRect;
    [nameBackground addSubview:nameLabel];
    
    return nameBackground;
}

- (UIImageView*)createUpsellLabel:(CGFloat)ypos
{
    UIFont* textFont = [UIFont fontWithName:@"Helvetica-Bold" size:17.0f];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"orange-tab" ofType:@"png"];
    NSData *imageData = [NSData dataWithContentsOfFile:filePath];
    UIImage *image = [[UIImage alloc] initWithData:imageData];
    CGRect originalRect = CGRectMake(0, ypos, image.size.width, image.size.height);
    CGRect finalRect = [Utilities resizeProportionally:originalRect maxWidth:_width maxHeight:image.size.height];
    
    _upsellTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, finalRect.size.width, finalRect.size.height)];
    [_upsellTextLabel setBackgroundColor:[UIColor clearColor]];
    [_upsellTextLabel setTextColor:[UIColor whiteColor]];
    [_upsellTextLabel setTextAlignment:UITextAlignmentCenter];
    [_upsellTextLabel setFont:textFont];
    [_upsellTextLabel setAdjustsFontSizeToFitWidth:YES];
    [_upsellTextLabel setNumberOfLines:1];
    
    UIImageView* upsellBackground = [[UIImageView alloc] initWithImage:image];
    upsellBackground.frame = finalRect;
    [upsellBackground addSubview:_upsellTextLabel];
    
    return upsellBackground;
}

- (void) fillInRemainingButtonDetails:(PunchCard*)current
{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
    NSString *totalAmountAsString = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:([[current each_punch_value] doubleValue] * [[current total_punches] integerValue])]];
    NSString *saleAmountAsString = [numberFormatter stringFromNumber:[current selling_price]];
    NSString* upsellText = [NSString stringWithFormat:@"%@ for %@", totalAmountAsString, saleAmountAsString];
    [_upsellTextLabel setText:upsellText];
    
    UrlImage* urlImage = [[UrlImageManager getInstance] getCachedImage:[current business_logo_url]];
    if(urlImage)
    {
        if ([urlImage image])
        {
            [_logoImage setImage:[urlImage image]];
        }
        else
        {
            [urlImage addImageView:_logoImage];
        }
    }
    else
    {
        UrlImage* urlImage = [[UrlImage alloc] initWithUrl:[current business_logo_url] forImageView:_logoImage];
        [[UrlImageManager getInstance] insertImageToCache:[current business_logo_url] image:urlImage];
    }
    
    [self addSubview:_overlayButton];
}

- (void)greyoutView
{
    [_nameLabel setAlpha:0.5];
    [_logoImage setAlpha:0.5];
    [_upsellLabel setAlpha:0.5];
}

- (void)restoreView
{
    [_nameLabel setAlpha:1.0];
    [_logoImage setAlpha:1.0];
    [_upsellLabel setAlpha:1.0];
}

#pragma mark - HttpCallbackDelegate
- (void) didCompleteHttpCallback:(NSString*)type success:(BOOL)success message:(NSString*)message
{
    [_spinner stopAnimating];
    if(success)
    {
        NSArray* offers = [_businessOffers getOffers];
        if (offers != nil)
        {
            [self fillInRemainingButtonDetails:[offers objectAtIndex:0]];
        }
    }
    // Fail silently
}

#pragma mark - event actions

- (void) didTouchDown:(id)sender
{
    [self greyoutView];
}

- (void) didDragOutside:(id)sender
{
    [self restoreView];
}

- (void) didTouchUpInside:(id)sender
{
    [self restoreView];
    Business* business = [_businessOffers business];
    BusinessPageViewController* businessView = [[BusinessPageViewController alloc] initWithBusiness:[business business_id] business_name:[business business_name]];
    AppDelegate *delegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    [[delegate navigationController] pushViewController:businessView animated:NO];
}

@end
