//
//  ViewController.h
//  Alert Here
//
//  Created by theChamps on 8/10/12.
//  Copyright (c) 2012 scoutic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#define METERS_PER_MILE 1609.344

@interface ViewController : UIViewController <MKMapViewDelegate> {
	MKMapView *mapView;
    
}

@property (nonatomic, retain) IBOutlet MKMapView *mapView;


@end
