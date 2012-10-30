//
//  MyPunchesViewController.h
//  paidPunch
//
//  Created by mobimedia technologies on 25/11/11.
//  Copyright (c) 2011 mobimedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PunchCard.h"
#import "NetworkManager.h"
#import "SDWebImageManagerDelegate.h"
#import "SDImageCache.h"
#import "MyPunchViewCell.h"
#import "PunchViewController.h"

@class NetworkManager;
@protocol NetworkManagerDelegate;

@interface MyPunchesViewController : UIViewController<NetworkManagerDelegate,UITableViewDataSource,UITableViewDelegate,SDWebImageManagerDelegate,NSFetchedResultsControllerDelegate>
{
    NSFetchedResultsController *_fetchedResultsController;
    NSManagedObjectContext *_context;    
    NetworkManager *networkManager;
}

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext *context;
@property (nonatomic,retain) IBOutlet UITableView *punchesListTableView;
@property (retain, nonatomic) NSDate *lastRefreshTime;
@property (nonatomic, retain) IBOutlet UIImageView *noCardsAvailableImage;

-(void)getMyPunches;
-(void)goToPunchView:(PunchCard *)punchCard;
-(void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

@end
