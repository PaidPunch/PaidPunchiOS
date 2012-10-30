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
@property (retain, nonatomic) IBOutlet UITableView *homeOptionsTableView;
@property (retain, nonatomic) IBOutlet UIImageView *watchVideoImageView;

@property (retain, nonatomic) IBOutlet UIView *playVideoOptionsView;
@property (retain, nonatomic) IBOutlet UIView *homeView;

-(void)goToMyAccountView;
-(void)goToFAQView;
-(void)goToUsingPaidPunchView;
-(void)goToDualSignInView;
-(void)signout;
-(void)playVideo; 
-(void)requestAppIp;
@end
