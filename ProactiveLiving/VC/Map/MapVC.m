//
//  MapVC.m
//  ProactiveLiving
//
//  Created by Affle on 02/12/16.
//  Copyright © 2016 appstudioz. All rights reserved.
//

#import "MapVC.h"


@interface MapVC ()

@end

@implementation MapVC
@synthesize address;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
   // NSString *address = [NSString stringWithFormat:@"hatiara, kolkata west bengal, 700157" ];
    
    
      NSString *mapAddress = [@"http://maps.apple.com/?q=" stringByAppendingString:[address stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    [self showAddressOnMap];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)onClickBackBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)showAddressOnMap{
    
     
   NSString *location = [NSString stringWithFormat:@"%@", self.address];

    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:location
                 completionHandler:^(NSArray* placemarks, NSError* error){
                     
                     if (placemarks && placemarks.count > 0) {
                         CLPlacemark *topResult = [placemarks objectAtIndex:0];
                         MKPlacemark *placemark = [[MKPlacemark alloc] initWithPlacemark:topResult];
                         
                         CLLocationCoordinate2D coordinate;
                         coordinate.latitude = topResult.location.coordinate.latitude;
                         coordinate.longitude = topResult.location.coordinate.longitude;
                         
                         MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
                         point.coordinate = placemark.coordinate;
                     //    point.title = title;
                         point.subtitle = location;
                         
                         //NSLog(@"Lat: %f, Long: %f", coordinate.latitude, coordinate.longitude);
                         MKCoordinateRegion region;
                         region.center = [(CLCircularRegion *)placemark.region center];
                         MKCoordinateSpan span;
                         span.latitudeDelta=.005;
                         span.longitudeDelta=.005;
                         region.span = span;
                         [self.map_view setRegion:region animated:YES];
                         
                         
                         [self.map_view addAnnotation:point];
                     }
                     
                 }
     ];
}


@end
