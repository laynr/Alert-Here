//
//  AppDelegate.h
//  Alert Here
//
//  Created by theChamps on 8/10/12.
//  Copyright (c) 2012 scoutic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, CLLocationManagerDelegate> {
    CLLocationManager *manager;
	CLLocationCoordinate2D coords;
    CLLocationCoordinate2D first;
    NSString *title;
	NSString *subtitle;
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, readwrite, assign) CLLocationCoordinate2D coords;
@property (nonatomic, readwrite, assign) CLLocationCoordinate2D first;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *subtitle;
@property (nonatomic, retain) CLLocationManager *manager;

-(void) upDate;
-(void) monitorOff;
-(void) monitorOn;


@end
