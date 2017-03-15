//
//  LocationManagerSingleton.h
//  ProactiveLiving
//
//  Created by Mohd Asim on 14/04/16.
//  Copyright © 2016 appstudioz. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <MapKit/MapKit.h>

//custom delegate
@protocol LocationUpdateProtocol <NSObject>

@required
//required methods
-(void)locationDidUpdateToLocation:(CLLocation *)location;
@optional
//optional methods

@end
//----

@interface LocationManagerSingleton : NSObject <CLLocationManagerDelegate>
{
    
}

@property (nonatomic, strong) CLLocationManager* locationManager;
@property (nonatomic, weak) id <LocationUpdateProtocol> delegate;

+ (LocationManagerSingleton*)sharedSingleton;

@end
