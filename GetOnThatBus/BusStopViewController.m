//
//  BusStopViewController.m
//  GetOnThatBus
//
//  Created by ETC ComputerLand on 8/5/14.
//  Copyright (c) 2014 cmeats. All rights reserved.
//

#import "BusStopViewController.h"
#import <MapKit/MapKit.h>

@interface BusStopViewController ()
@property (strong, nonatomic) IBOutlet UILabel *addressLabel;
@property (strong, nonatomic) IBOutlet UILabel *busRouteLabel;
@property (strong, nonatomic) IBOutlet UILabel *transferLabel;

@end

@implementation BusStopViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = self.busStopAnnotation.busStop[@"cta_stop_name"];

    NSString *address = [NSString stringWithFormat:@"%f, %f", self.busStopAnnotation.coordinate.latitude, self.busStopAnnotation.coordinate.longitude];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:address completionHandler:^(NSArray *placemarks, NSError *error) {
        for (CLPlacemark *place in placemarks) {
            self.addressLabel.text = place.addressDictionary[@"Street"];
        }
    }];

    self.busRouteLabel.text = self.busStopAnnotation.busStop[@"routes"];
    self.transferLabel.text = self.busStopAnnotation.busStop[@"inter_modal"];
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
