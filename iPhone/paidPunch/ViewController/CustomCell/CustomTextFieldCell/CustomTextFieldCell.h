//
//  CustomTextFieldCell.h
//  paidPunch
//
//  Created by mobimedia technologies on 28/11/11.
//  Copyright (c) 2011 mobimedia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTextFieldCell : UITableViewCell
{
    UILabel *headingLabel;
    UITextField *valueTextField;
}
@property(nonatomic,retain) IBOutlet UILabel *headingLabel;
@property(nonatomic,retain) IBOutlet UITextField *valueTextField;
@end
