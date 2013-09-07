//
//  AlertViewController.m
//  Alert Here
//
//  Created by theChamps on 8/10/12.
//  Copyright (c) 2012 scoutic. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "AlertViewController.h"
#import "AppDelegate.h"

@interface AlertViewController ()

@end

@implementation AlertViewController
@synthesize alertText;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    AppDelegate     *theDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [alertText setText:theDelegate.title];
    
}

- (void)viewDidUnload
{
    [self setAlertText:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    AppDelegate     *theDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    theDelegate.title = [textField text];
    //[theDelegate upDate];
    NSLog(@"tada");
    return YES;
}

- (IBAction)alertSwitch:(UISwitch *)sender {
    NSString *string = @"OFF";
    AppDelegate     *theDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (sender.on)
    {
        string = @"ON";
        [theDelegate monitorOn];
    }
    else
    {
        
        [theDelegate monitorOff];
    }
    NSLog(@"switch %@", string);
}




- (void)dealloc {
    [alertText release];
    [super dealloc];
}
@end
