//
//  NumberPadViewController.m
//  paidPunch
//
//  Created by mobimedia technologies on 04/04/12.
//  Copyright (c) 2012 mobimedia. All rights reserved.
//

#import "NumberPadViewController.h"

@implementation NumberPadViewController

@synthesize numberPadDoneImageNormal;
@synthesize numberPadDoneImageHighlighted;
@synthesize numberPadDoneButton;

- (id)initWithNibName:(NSString *)nibName bundle:(NSBundle *)nibBundle {
    if ([super initWithNibName:nibName bundle:nibBundle] == nil)
        return nil;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 3.0) {
        self.numberPadDoneImageNormal = [UIImage imageNamed:@"Back.png"];
        self.numberPadDoneImageHighlighted = [UIImage imageNamed:@"Back.png"];
    } else {        
        self.numberPadDoneImageNormal = [UIImage imageNamed:@"Back.png"];
        self.numberPadDoneImageHighlighted = [UIImage imageNamed:@"Back.png"];
    }        
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Add listener for keyboard display events
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 3.2) {
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(keyboardDidShow:) 
                                                     name:UIKeyboardDidShowNotification 
                                                   object:nil];     
    } else {
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(keyboardWillShow:) 
                                                     name:UIKeyboardWillShowNotification 
                                                   object:nil];
    }
    
    // Add listener for all text fields starting to be edited
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(textFieldDidBeginEditing:)
                                                 name:UITextFieldTextDidBeginEditingNotification 
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 3.2) {
        [[NSNotificationCenter defaultCenter] removeObserver:self 
                                                        name:UIKeyboardDidShowNotification 
                                                      object:nil];      
    } else {
        [[NSNotificationCenter defaultCenter] removeObserver:self 
                                                        name:UIKeyboardWillShowNotification 
                                                      object:nil];
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self 
                                                    name:UITextFieldTextDidBeginEditingNotification 
                                                  object:nil];
    [super viewWillDisappear:animated];
}

- (UIView *)findFirstResponderUnder:(UIView *)root {
    if (root.isFirstResponder)
        return root;    
    for (UIView *subView in root.subviews) {
        UIView *firstResponder = [self findFirstResponderUnder:subView];        
        if (firstResponder != nil)
            return firstResponder;
    }
    return nil;
}

- (UITextField *)findFirstResponderTextField {
    UIResponder *firstResponder = [self findFirstResponderUnder:[self.view window]];
    if (![firstResponder isKindOfClass:[UITextField class]])
        return nil;
    return (UITextField *)firstResponder;
}

- (void)updateKeyboardButtonFor:(UITextField *)textField {
    
    // Remove any previous button
    [self.numberPadDoneButton removeFromSuperview];
    self.numberPadDoneButton = nil;
    
    // Does the text field use a number pad?
    if (textField.keyboardType != UIKeyboardTypeNumberPad)
        return;
    
    // If there's no keyboard yet, don't do anything
    if ([[[UIApplication sharedApplication] windows] count] < 2)
        return;
    UIWindow *keyboardWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:1];
    
    // Create new custom button
    self.numberPadDoneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.numberPadDoneButton.frame = CGRectMake(0, 163, 106, 53);
    self.numberPadDoneButton.adjustsImageWhenHighlighted = FALSE;
    [self.numberPadDoneButton setImage:self.numberPadDoneImageNormal forState:UIControlStateNormal];
    [self.numberPadDoneButton setImage:self.numberPadDoneImageHighlighted forState:UIControlStateHighlighted];
    [self.numberPadDoneButton addTarget:self action:@selector(numberPadDoneButton:) forControlEvents:UIControlEventTouchUpInside];
    
    // Locate keyboard view and add button
    NSString *keyboardPrefix = [[[UIDevice currentDevice] systemVersion] floatValue] >= 3.2 ? @"<UIPeripheralHost" : @"<UIKeyboard";
    for (UIView *subView in keyboardWindow.subviews) {
        if ([[subView description] hasPrefix:keyboardPrefix]) {
            [subView addSubview:self.numberPadDoneButton];
            [self.numberPadDoneButton addTarget:self action:@selector(numberPadDoneButton:) forControlEvents:UIControlEventTouchUpInside];
            break;
        }
    }
}

- (void)textFieldDidBeginEditing:(NSNotification *)note {
    [self updateKeyboardButtonFor:[note object]];
}

- (void)keyboardWillShow:(NSNotification *)note {
    [self updateKeyboardButtonFor:[self findFirstResponderTextField]];
}

- (void)keyboardDidShow:(NSNotification *)note {
    [self updateKeyboardButtonFor:[self findFirstResponderTextField]];
}

- (IBAction)numberPadDoneButton:(id)sender {
    UITextField *textField = [self findFirstResponderTextField];
    [textField resignFirstResponder];
}

- (void)dealloc {
    [numberPadDoneImageNormal release];
    [numberPadDoneImageHighlighted release];
    [numberPadDoneButton release];
    [super dealloc];
}

@end