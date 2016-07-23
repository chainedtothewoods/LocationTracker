//
//  AppDelegate.m
//  LocationTracker
//
//  Created by Michael Lapuebla on 7/11/16.
//  Copyright © 2016 Michael Lapuebla. All rights reserved.
//

#import "AppDelegate.h"


@interface AppDelegate ()

@property (nonatomic) NSMutableArray* locationList;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [self setupLocationManager];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

// *******************************************************
// MARK: - CLLocationManager
// *******************************************************

- (void)setupLocationManager {
    
    _locationManager = [[CLLocationManager alloc] init];        // Create Location Manager Instance
    _locationManager.delegate = self;                           // Set Delegate
    _locationManager.distanceFilter = 10.0;                     // 10 meters
    
    
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    
    if(status == kCLAuthorizationStatusNotDetermined) {
        NSLog(@"Authorization Not Determined");
        [_locationManager requestAlwaysAuthorization];
        [_locationManager requestWhenInUseAuthorization];
    }
    
    [_locationManager startUpdatingLocation];                   // Start updating locations
}

// *******************************************************
// MARK: - CLLocationManagerDelegate
// *******************************************************

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    NSLog(@"Authorization Status Changed to %d", status);
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    // TODO: Update to a method.
    if(_locationList != nil) {
        CLLocation *latestLocation = [locations lastObject];
        if(![self isLastKnownLocationSameAs:latestLocation]) {
            [_locationList addObject:latestLocation];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"kLocationHasBeenAdded" object:latestLocation];
        }
    } else {
        _locationList = [[NSMutableArray alloc] init];
    }
    
    NSLog(@"Locations: *** %@ *** \n\n", [_locationList description]);
}

// *******************************************************
// MARK: - CLLocation Helpers
// *******************************************************

- (BOOL)isLastKnownLocationSameAs:(CLLocation *)location {
    CLLocation *lastKnownLocation = [_locationList lastObject];
    return (lastKnownLocation.coordinate.latitude == location.coordinate.latitude &&
            lastKnownLocation.coordinate.longitude == location.coordinate.longitude);
}

@end
