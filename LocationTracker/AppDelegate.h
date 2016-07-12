//
//  AppDelegate.h
//  LocationTracker
//
//  Created by Mike Limestro on 7/11/16.
//  Copyright © 2016 Mike Lapuebla. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) CLLocationManager *locationManager;

@end

