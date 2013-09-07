//
//  ViewController.m
//  Alert Here
//
//  Created by theChamps on 8/10/12.
//  Copyright (c) 2012 scoutic. All rights reserved.
//

#import "ViewController.h"
#import "DDAnnotation.h"
#import "DDAnnotationView.h"
#import "AppDelegate.h"

@interface ViewController ()

- (void)coordinateChanged_:(NSNotification *)notification;

@end

@implementation ViewController



- (void)viewDidLoad {
    [super viewDidLoad];
	    
    //To reterive the data from the plist
    NSString* documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString* path = [documentsPath stringByAppendingPathComponent:@"alert.plist"];
    
    NSMutableDictionary *data;
    data = [[NSMutableDictionary alloc] initWithContentsOfFile: path];

    CLLocationCoordinate2D theCoordinate;
    theCoordinate.latitude  = [[data objectForKey:@"latitude"]doubleValue];
    theCoordinate.longitude = [[data objectForKey:@"longitude"]doubleValue];
    
    
    DDAnnotation *annotation = [[[DDAnnotation alloc] initWithCoordinate:theCoordinate addressDictionary:nil] autorelease];

	annotation.title = [data objectForKey:@"title"];
	annotation.subtitle = [data objectForKey:@"subtitle"];
    [data release];
	
	[self.mapView addAnnotation:annotation];
}

- (void)viewWillAppear:(BOOL)animated {
	
	[super viewWillAppear:animated];
    [[NSUserDefaults standardUserDefaults] registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],@"firstLaunch",nil]];
	
	// NOTE: This is optional, DDAnnotationCoordinateDidChangeNotification only fired in iPhone OS 3, not in iOS 4.
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(coordinateChanged_:) name:@"DDAnnotationCoordinateDidChangeNotification" object:nil];
}

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    
//    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]) {
//        
//        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.location.coordinate, 5000*METERS_PER_MILE, 5000*METERS_PER_MILE);
//        [self.mapView setRegion:region animated:YES];
//            
//        
//        AppDelegate     *theDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//        theDelegate.first = userLocation.location.coordinate;
//    }

    
}

- (void)viewWillDisappear:(BOOL)animated {
	
	[super viewWillDisappear:animated];
    
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"firstLaunch"];
	
	// NOTE: This is optional, DDAnnotationCoordinateDidChangeNotification only fired in iPhone OS 3, not in iOS 4.
	[[NSNotificationCenter defaultCenter] removeObserver:self name:@"DDAnnotationCoordinateDidChangeNotification" object:nil];
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	
	self.mapView.delegate = nil;
	self.mapView = nil;
}

- (void)dealloc {
	mapView.delegate = nil;
	[mapView release];
    [super dealloc];
}

#pragma mark -
#pragma mark DDAnnotationCoordinateDidChangeNotification

// NOTE: DDAnnotationCoordinateDidChangeNotification won't fire in iOS 4, use -mapView:annotationView:didChangeDragState:fromOldState: instead.
- (void)coordinateChanged_:(NSNotification *)notification {
	
	DDAnnotation *annotation = notification.object;
	annotation.subtitle = [NSString	stringWithFormat:@"%f %f", annotation.coordinate.latitude, annotation.coordinate.longitude];
}

#pragma mark -
#pragma mark MKMapViewDelegate

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)annotationView didChangeDragState:(MKAnnotationViewDragState)newState fromOldState:(MKAnnotationViewDragState)oldState {
	
	if (oldState == MKAnnotationViewDragStateDragging) {
		DDAnnotation *annotation = (DDAnnotation *)annotationView.annotation;
		annotation.subtitle = [NSString	stringWithFormat:@"%f %f", annotation.coordinate.latitude, annotation.coordinate.longitude];
	}
    if (newState == MKAnnotationViewDragStateEnding) {
        AppDelegate     *theDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        DDAnnotation *annotation = (DDAnnotation *)annotationView.annotation;
        
        
        
        theDelegate.coords = annotation.coordinate;
        NSLog(@"B");
        [theDelegate upDate];
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
	
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
	}
	
	static NSString * const kPinAnnotationIdentifier = @"PinIdentifier";
	MKAnnotationView *draggablePinView = [self.mapView dequeueReusableAnnotationViewWithIdentifier:kPinAnnotationIdentifier];
	
	if (draggablePinView) {
		draggablePinView.annotation = annotation;
	} else {
		// Use class method to create DDAnnotationView (on iOS 3) or built-in draggble MKPinAnnotationView (on iOS 4).
		draggablePinView = [DDAnnotationView annotationViewWithAnnotation:annotation reuseIdentifier:kPinAnnotationIdentifier mapView:self.mapView];
        
		if ([draggablePinView isKindOfClass:[DDAnnotationView class]]) {
			// draggablePinView is DDAnnotationView on iOS 3.
		} else {
			// draggablePinView instance will be built-in draggable MKPinAnnotationView when running on iOS 4.
		}
	}
	
	return draggablePinView;
}

@end
