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
@property(nonatomic,strong) IBOutlet UILabel *headingLabel;
@property(nonatomic,strong) IBOutlet UITextField *valueTextField;
@end
