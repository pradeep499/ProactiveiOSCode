//
//  MapVC.h
//  ProactiveLiving
//
//  Created by Affle on 02/12/16.
//  Copyright © 2016 appstudioz. All rights reserved.
//

#import <UIKit/UIKit.h>


#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
 
#import <CoreLocation/CoreLocation.h>

@interface MapVC : UIViewController
@property (weak, nonatomic) IBOutlet MKMapView *map_view;

@property(atomic, strong)NSString *address;

- (IBAction)onClickBackBtn:(id)sender;

@end
