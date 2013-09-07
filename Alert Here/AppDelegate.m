//
//  AppDelegate.m
//  Alert Here
//
//  Created by theChamps on 8/10/12.
//  Copyright (c) 2012 scoutic. All rights reserved.
//

#import "AppDelegate.h"
#import <MapKit/MapKit.h>


@implementation AppDelegate

@synthesize title;
@synthesize subtitle;
@synthesize coords;
@synthesize first;
@synthesize manager;


-(void) monitorOn
{
    
    if(manager == nil)
    {
        manager = [[CLLocationManager alloc]init];
    }
    
    
    manager.delegate=self;
    
    CLRegion *region=[[CLRegion alloc] initCircularRegionWithCenter:coords
                                                             radius:100
                                                         identifier:@"alerthere"];
    
    
    [manager startMonitoringForRegion:region desiredAccuracy:kCLLocationAccuracyBestForNavigation];
    NSLog(@"monitoring %f %f", coords.latitude, coords.longitude);
    
    //[manager startMonitoringSignificantLocationChanges];
}

-(void) monitorOff
{
    if(manager == nil)
    {
        manager = [[CLLocationManager alloc]init];
    }
    
    CLRegion *region=[[CLRegion alloc] initCircularRegionWithCenter:coords
                                                             radius:100
                                                         identifier:@"alerthere"];
    
    [manager stopMonitoringForRegion:region];
}

-(void) upDate
{
    NSLog(@"called update");
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"alert.plist"];
    NSFileManager *fileManager = [NSFileManager defaultManager];

    NSMutableDictionary *data;
    
    if ([fileManager fileExistsAtPath: path])
    {
        data = [[NSMutableDictionary alloc] initWithContentsOfFile: path];
    }
    else
    {
        // If the file doesn’t exist, create an empty dictionary
        data = [[NSMutableDictionary alloc] init];
    }
    
    if (title == NULL)
    {
        title = @"Drag to Move";
    }
    subtitle = [NSString	stringWithFormat:@"%f %f", coords.latitude, coords.longitude];
    
    //To insert the data into the plist
    [data setObject:title forKey:@"title"];
    [data setObject:subtitle forKey:@"subtitle"];
    [data setObject:[NSNumber numberWithDouble:coords.latitude] forKey:@"latitude"];
    [data setObject:[NSNumber numberWithDouble:coords.longitude] forKey:@"longitude"];
    [data writeToFile: path atomically:YES];
    
    NSLog(@"%@",data);
    [data release];
    
    [self monitorOff];
    [self monitorOn];

}

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    NSString* documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString* path = [documentsPath stringByAppendingPathComponent:@"alert.plist"];
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:path];
    
    if (fileExists==FALSE)
    {
        NSLog(@"no file");
        coords = first;
        //coords.latitude = 30;
        //coords.longitude = 30;
        title = @"Drag to Move Pin";
        subtitle = [NSString	stringWithFormat:@"%f %f", coords.latitude, coords.longitude];
        
        
        
        NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
        [data setObject:title forKey:@"title"];
        [data setObject:subtitle forKey:@"subtitle"];
        [data setObject:[NSNumber numberWithDouble:coords.latitude] forKey:@"latitude"];
        [data setObject:[NSNumber numberWithDouble:coords.longitude] forKey:@"longitude"];

        NSLog(@"data %@", data);
        [data writeToFile:path atomically:YES];
        [data release];
    }
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void) locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
    
    NSLog(@"didEnterRegion for %@",[region identifier]);
        
    UIApplicationState applicationState = [UIApplication sharedApplication].applicationState;
    if (applicationState == UIApplicationStateActive)
    {
        UIAlertView *alr=[[UIAlertView alloc] initWithTitle:@"in Alert Area"//[alertText text]
                                                    message:[region identifier]
                                                   delegate:nil
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"Ok",nil];
        
        [alr show];
        
        [alr release];
    }
    
    else
    {
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.fireDate = [NSDate date];
    NSTimeZone* timezone = [NSTimeZone defaultTimeZone];
    notification.timeZone = timezone;
    notification.alertBody = @"In Alert Area";
    notification.alertAction = @"Show";
    notification.soundName = UILocalNotificationDefaultSoundName;
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    [notification release]; // release if not using ARC
    }
    
    
    
    

}

- (void) locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
    NSLog(@"didLeaveRegion for %@",[region identifier]);
    
    UIApplicationState applicationState = [UIApplication sharedApplication].applicationState;
    if (applicationState == UIApplicationStateActive)
    {
        UIAlertView *alr=[[UIAlertView alloc] initWithTitle:@"Leaving Alert Area"//[alertText text]
                                                    message:[region identifier]
                                                   delegate:nil
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"Ok",nil];
        
        [alr show];
        
        [alr release];
    }
    
    else
    {
        UILocalNotification *notification = [[UILocalNotification alloc] init];
        notification.fireDate = [NSDate date];
        NSTimeZone* timezone = [NSTimeZone defaultTimeZone];
        notification.timeZone = timezone;
        notification.alertBody = @"Leaving Alert Area";
        notification.alertAction = @"Show";
        notification.soundName = UILocalNotificationDefaultSoundName;
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
        [notification release]; // release if not using ARC
    }
}

@end
