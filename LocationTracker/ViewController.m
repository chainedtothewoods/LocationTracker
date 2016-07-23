//
//  ViewController.m
//  LocationTracker
//
//  Created by Michael Lapuebla on 7/11/16.
//  Copyright © 2016 Michael Lapuebla. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>

#define kPLRFillColor       [[UIColor redColor] colorWithAlphaComponent:0.2]
#define kPLRStrokeColor     [[UIColor redColor] colorWithAlphaComponent:0.7]
#define kPLRLineWidth       2.0


@interface ViewController ()

@property (nonatomic) NSMutableArray *locationList;
@property (nonatomic, weak) MKPolyline *polyLinePath;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(locationAdded:)
                                                 name:@"kLocationHasBeenAdded"
                                               object:nil];
    
    _locationList = [[NSMutableArray alloc] init];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// *******************************************************
// MARK: - MKMapView
// *******************************************************

- (void)locationAdded:(NSNotification *) notification {
    CLLocation *newLocation = [notification object];
    if(newLocation != nil) {
        [_locationList addObject:newLocation];
        
        NSInteger pointsCount = _locationList.count;
        CLLocationCoordinate2D *coordinateArray = malloc(sizeof(CLLocationCoordinate2D) * pointsCount);
        
        int caIndex = 0;
        for (CLLocation *loc in _locationList) {
            coordinateArray[caIndex] = loc.coordinate;
            caIndex++;
        }

        MKPolyline *myPolyline = [MKPolyline polylineWithCoordinates:coordinateArray count:pointsCount];
        [self.mapView addOverlay:myPolyline];
        
        // Set starting
        if([_locationList count] == 1) {
            MKPointAnnotation *newAnnotation = [[MKPointAnnotation alloc] init];
            newAnnotation.coordinate = CLLocationCoordinate2DMake(newLocation.coordinate.latitude, newLocation.coordinate.longitude);
            
            [_mapView addAnnotation:newAnnotation];
        }
    }
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    if([overlay isKindOfClass:[MKPolyline class]]) {
        MKPolylineRenderer *polylineRenderer = [[MKPolylineRenderer alloc] initWithPolyline:overlay];
        polylineRenderer.fillColor = kPLRFillColor;
        polylineRenderer.strokeColor = kPLRStrokeColor;
        polylineRenderer.lineWidth = kPLRLineWidth;
        return polylineRenderer;
    }
    else {
        return  nil;
    }
}

@end
