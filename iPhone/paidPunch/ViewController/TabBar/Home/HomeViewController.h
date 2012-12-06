//
//  HomeViewController.h
//  paidPunch
//
//  Created by mobimedia technologies on 25/11/11.
//  Copyright (c) 2011 mobimedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingsViewController.h"
#import "UsingPaidPunchViewController.h"
#import "FAQViewController.h"
#import "NetworkManager.h"
#import "CustomMoviePlayer.h"

@interface HomeViewController : UIViewController<NetworkManagerDelegate>
{
    NetworkManager *networkManager;    
}
@property (strong, nonatomic) IBOutlet UITableView *homeOptionsTableView;
@property (strong, nonatomic) IBOutlet UIImageView *watchVideoImageView;

@property (strong, nonatomic) IBOutlet UIView *playVideoOptionsView;
@property (strong, nonatomic) IBOutlet UIView *homeView;

-(void)goToMyAccountView;
-(void)goToFAQView;
-(void)goToUsingPaidPunchView;
-(void)goToDualSignInView;
-(void)signout;
-(void)playVideo; 
-(void)requestAppIp;
@end
