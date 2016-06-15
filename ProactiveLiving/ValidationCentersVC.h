//
//  ValidationCentersVC.h
//  ProactiveLiving
//
//  Created by Mohd Asim on 27/01/16.
//  Copyright © 2016 appstudioz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>


@interface ValidationCentersVC : UIViewController<MKMapViewDelegate,CLLocationManagerDelegate>
@property(nonatomic, retain) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet UIView *mapContainerView;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIImageView *imgArrow;
@property (nonatomic, copy) NSString *orgType;
@property (nonatomic, copy) NSString *servicePath;

@end
