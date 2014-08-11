//
//  ViewController.m
//  GetOnThatBus
//
//  Created by ETC ComputerLand on 8/5/14.
//  Copyright (c) 2014 cmeats. All rights reserved.
//

#import "ViewController.h"
#import <MapKit/MapKit.h>
#import "busStopAnnotation.h"
#import "BusStopViewController.h"

@interface ViewController () <MKMapViewDelegate>
@property (strong, nonatomic) IBOutlet MKMapView *busMapView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self zoomChicago];

    [self doApi];

}

-(void)doApi
{
    NSURL *url = [NSURL URLWithString:@"https://s3.amazonaws.com/mobile-makers-lib/bus.json"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        //        NSDictionary *fullJsonDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        self.busStops = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil][@"row"];

        [self addStopsToMap];

    }];
}

-(void)addStopsToMap
{
    for (NSDictionary *busStop in self.busStops) {
        CLLocationCoordinate2D coord;
        //            coord.latitude = [busStop[@"location"][@"latitude"] floatValue];
        //            coord.longitude = [busStop[@"location"][@"longitude"] floatValue];
        coord.latitude = [busStop[@"latitude"] floatValue];
        if ([busStop[@"longitude"] floatValue] > 0) {
            coord.longitude = -[busStop[@"longitude"] floatValue];
        } else {
            coord.longitude = [busStop[@"longitude"] floatValue];
        }
        busStopAnnotation *annotation = [[busStopAnnotation alloc] init];
        annotation.coordinate = coord;

        annotation.title = busStop[@"cta_stop_name"];
        annotation.subtitle = busStop[@"routes"];

        annotation.busStop = busStop;

        [self.busMapView addAnnotation:annotation];
    }
}

-(void)zoomChicago
{
    NSString *address = @"Chicago IL";
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:address completionHandler:^(NSArray *placemarks, NSError *error) {
        for (CLPlacemark *place in placemarks) {

            CLLocationCoordinate2D centerCoordinate = place.location.coordinate;
            MKCoordinateSpan coordinateSpan;
            coordinateSpan.latitudeDelta = 1.00;
            coordinateSpan.longitudeDelta = 1.00;
            MKCoordinateRegion region;
            region.center = centerCoordinate;
            region.span = coordinateSpan;

            [self.busMapView setRegion:region];
        }
    }];
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKPinAnnotationView *pin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:nil];
    pin.canShowCallout = YES;
    pin.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    return pin;
}

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    [self performSegueWithIdentifier:@"busStopDetail" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    BusStopViewController *vc = segue.destinationViewController;
    vc.busStopAnnotation = [self.busMapView selectedAnnotations][0];
}

@end
