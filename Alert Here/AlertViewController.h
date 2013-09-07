//
//  AlertViewController.h
//  Alert Here
//
//  Created by theChamps on 8/10/12.
//  Copyright (c) 2012 scoutic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlertViewController : UIViewController <UITextFieldDelegate>

- (IBAction)alertSwitch:(id)sender;

@property (retain, nonatomic) IBOutlet UITextField *alertText;

@end
