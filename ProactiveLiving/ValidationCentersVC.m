//
//  ValidationCentersVC.m
//  ProactiveLiving
//
//  Created by Mohd Asim on 27/01/16.
//  Copyright © 2016 appstudioz. All rights reserved.
//

#import "ValidationCentersVC.h"
#import "ValidationCenterCell.h"
#import "AppHelper.h"
#import "Defines.h"
#import "AppDelegate.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "Services.h"
#import "ZSAnnotation.h"
#import "ValidationCMoreVC.h"
#import "ValidationCProfileVC.h"
#import "ValidationFiltersVC.h"
#import "JCTagListView.h"
#import "UIImageView+AFNetworking.h"
#import "LocationManagerSingleton.h"

@interface ValidationCentersVC () <UISearchBarDelegate,UIGestureRecognizerDelegate,MKMapViewDelegate>
{
    BOOL flag;
}
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;
@property (weak, nonatomic) IBOutlet UILabel *screenTitle;
@property (nonatomic, weak) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet JCTagListView *tagView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)btnBackClick:(id)sender;
- (IBAction)btnSearchClick:(id)sender;
- (IBAction)btnFilterClick:(id)sender;
@property (strong, nonatomic) NSArray *dataArray;
@property (strong, nonatomic) NSArray *arrLatLong;
@property (strong, nonatomic) NSArray *arrCenters;
@property (weak, nonatomic) IBOutlet UIButton *btnSwitch;

@end

@implementation ValidationCentersVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.screenTitle.text=self.orgType;
    
    _searchBar.showsCancelButton = YES;
    _searchBar.delegate = self;
     _searchBar.alpha = 0.0;
    
    [self.tableView setSeparatorColor:[UIColor clearColor]];
    [AppHelper setBorderOnView:self.topView];
    
    [self.btnSwitch setImage:[UIImage imageNamed:@"ic_mapview_listviewfloating"] forState:UIControlStateSelected];
    [self.btnSwitch setImage:[UIImage imageNamed:@"ic_validation_mapviewfloating"] forState:UIControlStateNormal];
    
    //long press recognizer on floating switch button
    UILongPressGestureRecognizer *btn_LongPress_gesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleBtnLongPressgesture:)];
    [self.btnSwitch addGestureRecognizer:btn_LongPress_gesture];
    
    // pan recognizer on annotation view to show/hide
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panRecognized:)];
    [panRecognizer setDelegate:self];
    [self.topView addGestureRecognizer:panRecognizer]; // add to the view you want to detect swipe on

    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateLocation:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(filterDataWithInfo:) name:NOTIFICATION_VALIDATION_CENTER_FLTER object:nil];
    
    //initiate Location and draw Map with API consumed data
    [self locationManagerSetup];
    [self prepareDataForValidationCenters:nil];
    [self mapSetup];


}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:YES animated:NO];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(buttonCalloutClicked:) name:NOTIFICATION_ANNOTATION_CLICKED object:nil];

}

#pragma mark - preferredStatusBarStyle
-(UIStatusBarStyle)preferredStatusBarStyle {
    // to set the color of status bar
    return UIStatusBarStyleLightContent;
}


-(void)panRecognized:(UIPanGestureRecognizer *)sender
{
    CGPoint distance = [sender translationInView:self.topView]; // get distance of pan/swipe in the view in which the gesture recognizer was added
    CGPoint velocity = [sender velocityInView:self.topView]; // get velocity of pan/swipe in the view in which the gesture recognizer was added
    //float usersSwipeSpeed = fabs(velocity.x); // use this if you need to move an object at a speed that matches the users swipe speed
    ////NSLog(@"swipe speed:%f", usersSwipeSpeed);
    
    if (sender.state == UIGestureRecognizerStateEnded) {
        [sender cancelsTouchesInView]; // you may or may not need this - check documentation if unsure
        if (distance.x > 0 && fabs(distance.x)>fabs(distance.y)) { // right
            //NSLog(@"user swiped right");
        } else if (distance.x < 0 && fabs(distance.x)>fabs(distance.y)) { //left
            //NSLog(@"user swiped left");
        }
        if (distance.y > 0 && fabs(distance.y)>fabs(distance.x)) { // down
            //NSLog(@"user swiped down");
            [UIView animateWithDuration:.15 animations:^{
                self.topView.frame =CGRectMake(0, (SCREEN_HEIGHT-148), SCREEN_WIDTH, self.topView.frame.size.height);
                self.imgArrow.transform = CGAffineTransformIdentity;
            }];
            
        } else if (distance.y < 0 && fabs(distance.y)>fabs(distance.x)) { //up
            //NSLog(@"user swiped up");
            [UIView animateWithDuration:.15 animations:^{
                self.topView.frame =CGRectMake(0, (SCREEN_HEIGHT-106)-self.topView.frame.size.height, SCREEN_WIDTH, self.topView.frame.size.height);
                self.imgArrow.transform = CGAffineTransformMakeRotation(-M_PI);

            }];
        }
        
    }
}


- (void)handleBtnLongPressgesture:(UILongPressGestureRecognizer *)recognizer{
    
    //as you hold the button this would fire
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        flag=TRUE;
    }
    
    //as you release the button this would fire
    
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        flag=FALSE;
    }
}


-(void)locationManagerSetup
{
    self.locationManagerSingleton = [LocationManagerSingleton sharedSingleton];
    
#ifdef __IPHONE_8_0
    if(IS_IOS8_OR_LATER) {
        // Use one from below, not both. Depending on requirement and what you put in info.plist
        [self.locationManagerSingleton.locationManager requestWhenInUseAuthorization];// NSLocationWhenInUseUsageDescription key add in info.plist
        //[self.locationManager requestAlwaysAuthorization]; // NSLocationAlwaysUsageDescription key add in info.plist
    }
#endif
    
    [self.locationManagerSingleton.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    [self.locationManagerSingleton.locationManager setDistanceFilter:kCLDistanceFilterNone];
    [self.locationManagerSingleton.locationManager setHeadingFilter:kCLHeadingFilterNone];

    [self.locationManagerSingleton.locationManager startUpdatingLocation];

}

-(void)mapSetup
{
    self.mapView.delegate = self;
    
    if([CLLocationManager locationServicesEnabled]){
        
        if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusDenied){
            //NSLog(@"Location Services Enabled but Denied");
        }
    }
    
    
    [self.mapView setMapType:MKMapTypeStandard];
    [self.mapView setZoomEnabled:YES];
    [self.mapView setScrollEnabled:YES];
    
    
    self.mapView.showsUserLocation = NO;
    MKCoordinateRegion region = self.mapView.region;
    region.center = CLLocationCoordinate2DMake(31.057550, -98.175117); //Or
    //region.center.latitude = self.locationManager.location.coordinate.latitude;
    //region.center.longitude = self.locationManager.location.coordinate.longitude;
    region.span.longitudeDelta = 0.015f; // Lesser the value, closer the map view
    region.span.latitudeDelta = 0.015f;
    //[self.mapView setRegion:region animated:YES];
}

-(void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:YES];
    
    if([CLLocationManager locationServicesEnabled] && [[AppHelper userDefaultsForKey:GPSStatus] boolValue]){
                
        if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusDenied){
            
            [AppHelper saveToUserDefaults:@"0" withKey:GPSStatus];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Location Access Denied"
                                                            message:@"Please go to Settings and allow location access for this app."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
       
        //NSLog(@"%@", [self deviceLocation]);
    }
    else if([[AppHelper userDefaultsForKey:GPSStatus] boolValue])
    {
        [AppHelper saveToUserDefaults:@"0" withKey:GPSStatus];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Location Service Disabled"
                                                        message:@"To re-enable, please go to Settings and turn on location service."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];

    }

    
}

#pragma mark- Plot Annotations on Map
-(void)plotValidationCentersOnMap
{
    [self.mapView removeAnnotations:self.mapView.annotations];

    for ( int i=0; i<[self.dataArray count]; i++)
    {
        double latitude=[[[[self.dataArray objectAtIndex:i]valueForKey:@"location"]objectAtIndex:1]floatValue];
        double longitude=[[[[self.dataArray objectAtIndex:i]valueForKey:@"location"]objectAtIndex:0]floatValue];
        NSString *titleStr =[self.dataArray objectAtIndex:i][@"name"] ;
        
        //NSArray *arrWithIDs=[self.arrCenters valueForKey:@"ID"];
        //find color index in original colors array
        //NSUInteger index = [arrWithIDs indexOfObject:[self.dataArray objectAtIndex:i][@"type"]];
        //NSString *colorStr =[self.arrCenters objectAtIndex:index][@"mapicon"] ;
        
        NSString *colorStr=[[[self.dataArray objectAtIndex:i] objectForKey:@"color"] valueForKey:@"color"];
        
        
        CLLocationCoordinate2D coordinate;
        coordinate.latitude=latitude;
        coordinate.longitude=longitude;

        ZSAnnotation *annotation = nil;
        annotation = [[ZSAnnotation alloc] init];
        annotation.dicInfo=[self.dataArray objectAtIndex:i];
        annotation.coordinate = coordinate;
        annotation.colorStr = colorStr;
        annotation.title = titleStr;
        [self.mapView addAnnotation:annotation];
        
        
    }
    
    // Show region with all Annotations
    MKMapRect zoomRect = MKMapRectNull;
    for (id <MKAnnotation> annotation in self.mapView.annotations)
    {
        MKMapPoint annotationPoint = MKMapPointForCoordinate(annotation.coordinate);
        MKMapRect pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0.1, 0.1);
        zoomRect = MKMapRectUnion(zoomRect, pointRect);
    }
    
    [self.mapView setVisibleMapRect:zoomRect edgePadding:UIEdgeInsetsMake(40.0f, 40.0f, 40.0f, 40.0f) animated:YES];
    
    //Bottom annotation view
    self.tagView.canSeletedTags = NO;
    self.tagView.tagColor = [UIColor clearColor];
    self.tagView.tagCornerRadius = 0.0f;
    [self.tagView.tags removeAllObjects];
    [self.tagView.tagColors removeAllObjects];
    
    NSOrderedSet *orderedSet = [NSOrderedSet orderedSetWithArray:[self.dataArray valueForKey:@"color"]];
    NSArray *arrayWithNoDuplicates = [orderedSet array];
    
    [self.tagView.tags addObjectsFromArray:[arrayWithNoDuplicates valueForKey:@"name"]];
    [self.tagView.tagColors addObjectsFromArray:[arrayWithNoDuplicates valueForKey:@"color"]];
    [self.tagView.collectionView reloadData];
    
    [self.tagView setCompletionBlockWithSeleted:^(NSInteger index) {
        //NSLog(@"______%ld______", (long)index);
    }];
}

-(void)filterDataWithInfo:(NSNotification *)notifInfo
{
    [self prepareDataForValidationCenters:[notifInfo userInfo]];
}

-(void)prepareDataForValidationCenters:(NSDictionary *)dataDict
{
    //NSLog(@"location::::::>  %@",[LocationManagerSingleton sharedSingleton].locationManager.location);
   
    //check internet before hitting web service
    if ([AppDelegate checkInternetConnection]) {
        
        //create dictionary for parameters of web service
        NSMutableDictionary *parameters=[[NSMutableDictionary alloc]init];
        [parameters setValue:AppKey forKey:@"AppKey"];
        [parameters setValue:[AppHelper userDefaultsForKey:uId] forKey:@"UserID"];
        
        if([[AppHelper userDefaultsForKey:GPSStatus] boolValue] && [CLLocationManager authorizationStatus]!=kCLAuthorizationStatusDenied)
        {
            NSString *latitude=[NSString stringWithFormat:@"%f",[LocationManagerSingleton sharedSingleton].locationManager.location.coordinate.latitude];
            NSString *longitude=[NSString stringWithFormat:@"%f",[LocationManagerSingleton sharedSingleton].locationManager.location.coordinate.longitude];

            [parameters setObject:[AppHelper userDefaultsForKey:GPSStatus] forKey:@"isGpsOn"];
            [parameters setObject:latitude forKey:@"latitude"];
            [parameters setObject:longitude forKey:@"longitude"];
        }
        
        if(self.orgType)
        {
            [parameters setValue:self.orgType forKey:@"validationType"];
           
            if([self.orgType isEqualToString:@"Personal Trainers"]|| [self.orgType isEqualToString:@"Dietitians"] || [self.orgType isEqualToString:@"Health Wellness Coaches"] || [self.orgType isEqualToString:@"Health Education Specialists"] || [self.orgType isEqualToString:@"Nutritionists"] || [self.orgType isEqualToString:@"Professional Organizers"] || [self.orgType isEqualToString:@"Psychologists"] || [self.orgType isEqualToString:@"Corp Wellness Specialists"])
                self.servicePath=ServicePersonalTrainers;
            else
                self.servicePath=ServiceValidationCenters;

        }

        if(dataDict)
        {
            NSArray *arrServiceIDs=[[dataDict objectForKey:@"arrServices"] valueForKey:@"_id"];
            if(arrServiceIDs.count>0)
                [parameters setValue:[arrServiceIDs componentsJoinedByString:@","] forKey:@"serviceIdArr"];
            
            NSString *timeStamp=[dataDict objectForKey:@"strTimeStamp"];
            if(timeStamp)
                [parameters setValue:timeStamp forKey:@"availabilityAt"];
            
            //NSArray *arrLocationIDs=[[dataDict objectForKey:@"arrLocations"] valueForKey:@"_id"];
            //if(arrLocationIDs.count>0)
                //[parameters setValue:[arrLocationIDs componentsJoinedByString:@","] forKey:@"organizationIds"];
            
            NSArray *arrLocationIDs=[[dataDict objectForKey:@"arrLocations"] valueForKey:@"location"];
            if(arrLocationIDs.count>0)
                [parameters setValue:[arrLocationIDs componentsJoinedByString:@","] forKey:@"location"];

            NSArray *arrTypeIDs=[[dataDict objectForKey:@"arrTypes"] valueForKey:@"_id"];
            if(arrTypeIDs.count>0)
                [parameters setValue:[arrTypeIDs componentsJoinedByString:@","] forKey:@"typesIdArr"];
            
            //In case of search
            if([dataDict valueForKey:@"search"])
            [parameters setValuesForKeysWithDictionary:dataDict];

        }
        
        //show indicator on screen
        [AppDelegate showProgressHUDWithStatus:@""];
        
        //call global web service class
        [Services serviceCallWithPath:self.servicePath withParam:parameters success:^(NSDictionary *responseDict)
        {
            [AppDelegate dismissProgressHUD];
            
            
            if (![[responseDict objectForKey:@"error"] isKindOfClass:[NSNull class]] && [responseDict objectForKey:@"error"])
            {
                if ([[responseDict objectForKey:@"error"] intValue] == 0) {
                    // success
                    self.dataArray = [responseDict valueForKey:@"result"];//set dictionary
                    self.arrLatLong=[responseDict objectForKey:@"userLatLong"];//for latlong
                    [self.tableView reloadData];
 
                    
                }
                else
                    [AppHelper showAlertWithTitle:@"" message:serviceError tag:0 delegate:nil cancelButton:ok otherButton:nil];
            }
            else
                [AppHelper showAlertWithTitle:@"" message:serviceError tag:0 delegate:nil cancelButton:ok otherButton:nil];
            
        } failure:^(NSError *error)
        {
            [AppDelegate dismissProgressHUD];
            //NSLog(@"%@",error);
            [AppHelper showAlertWithTitle:@"" message:serviceError tag:0 delegate:nil cancelButton:ok otherButton:nil];
        }];
        
    }
    else
        [AppHelper showAlertWithTitle:netError message:netErrorMessage tag:0 delegate:nil cancelButton:ok otherButton:nil];
}

#pragma mark - uitableview
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //set height of cell
    if ([self.orgType isEqualToString:@"Physicians"]) {
        return 132;
    }
    return 120;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //number of rows in tableview
    return [self.dataArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"ValidationCenterCell";
    ValidationCenterCell *cell = (ValidationCenterCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.imageView.image = nil;
    cell.lblOrgType.text=@"";
    
    if([self.orgType isEqualToString:@"Physicians"])
    {
        cell.lblOrgType.text=[[self.dataArray objectAtIndex:indexPath.row][@"Physician_Services"] valueForKey:@"name"];
        cell.lblAddressTOP.constant=14;
        cell.imgLocationTOP.constant=62;
    }
    
    //NSArray *arrWithIDs=[self.arrCenters valueForKey:@"ID"];
    //find color index in original colors array
    //NSUInteger index = [arrWithIDs indexOfObject:[self.dataArray objectAtIndex:indexPath.row][@"type"]];

    cell.viewSideStrip.backgroundColor=[UIColor clearColor];
    cell.viewSideStrip.backgroundColor=[AppHelper colorFromHexString:[[[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"color"] valueForKey:@"color"] alpha:1.0];
    //cell.imgBGStrip.backgroundColor=[AppHelper colorFromHexString:[self.arrCenters objectAtIndex:index][@"mapicon"] alpha:0.5];
    [AppHelper setBorderOnView:cell.imgBGStrip];
    
    cell.lblCenterName.text=[self.dataArray objectAtIndex:indexPath.row][@"name"];
    cell.lblAddress.text=[self.dataArray objectAtIndex:indexPath.row][@"address1"];
    cell.viewRatings.canEdit=NO;
    cell.viewRatings.rating=[[self.dataArray objectAtIndex:indexPath.row][@"rating"]floatValue];
    
    if([self.orgType isEqualToString:@"Personal Trainers"])
    {
        NSArray *arrServices=[[[self.dataArray objectAtIndex:indexPath.row] valueForKey:@"categoryId"]valueForKey:@"name"];
        cell.lblServices.text=[NSString stringWithFormat:@"%@",[arrServices componentsJoinedByString:@", "]];
    }
    else
        cell.lblServices.text=[[[self.dataArray objectAtIndex:indexPath.row] valueForKey:@"Validation_Center"]valueForKey:@"name"];

    cell.lblServices.lineBreakMode = NSLineBreakByWordWrapping;
    cell.lblServices.numberOfLines=0;
    [cell.lblServices sizeToFit];

    cell.lblCity.text=[NSString stringWithFormat:@"%@, %@",[self.dataArray objectAtIndex:indexPath.row][@"city"],[self.dataArray objectAtIndex:indexPath.row][@"state"]];
    cell.lblPIN.text=[NSString stringWithFormat:@"%@",[self.dataArray objectAtIndex:indexPath.row][@"postalCode"]];
    //cell.lblReviews.text=[NSString stringWithFormat:@"%@ Reviews",[self.dataArray objectAtIndex:indexPath.row][@"reviewcount"]];
    
    //CLLocation * LocationActual = [[CLLocation alloc]initWithLatitude:[[[[self.dataArray objectAtIndex:indexPath.row]objectForKey:@"location"]objectAtIndex:1]floatValue] longitude:[[[[self.dataArray objectAtIndex:indexPath.row]objectForKey:@"location"]objectAtIndex:0]floatValue]];
    ////NSLog(@"Dist----%@",[NSString stringWithFormat:@"%d miles",[self distanceFromCurrentLocationToLocation:LocationActual]]);

    cell.lblDistance.text=[NSString stringWithFormat:@"%.02f miles",(([[[self.dataArray objectAtIndex:indexPath.row]valueForKey:@"dist"] floatValue])/1609.344)];
    
    NSURL *url = [NSURL URLWithString:[self.dataArray objectAtIndex:indexPath.row][@"image"]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    UIImage *placeholderImage = [UIImage imageNamed:@"your_placeholder"];
    
    __weak ValidationCenterCell *weakCell = cell;
    
    [cell.imgBuilding setImageWithURLRequest:request
                          placeholderImage:placeholderImage
                                   success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                       
                                       weakCell.imgBuilding.image = image;
                                       [weakCell setNeedsLayout];
                                       
                                   } failure:nil];
    
    [AppHelper setBorderOnView:cell.btnMore];
    cell.btnMore.tag=indexPath.row;
    [cell.btnMore addTarget:self action:@selector(btnMoreClick:) forControlEvents:UIControlEventTouchUpInside];
   
    [AppHelper setBorderOnView:cell.btnBook];
    cell.btnBook.tag=indexPath.row;
    [cell.btnBook addTarget:self action:@selector(btnBookClick:) forControlEvents:UIControlEventTouchUpInside];

    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

-(int)distanceFromCurrentLocationToLocation:(CLLocation*)location
{
    
    CLLocationDistance distance;
    if(![[AppHelper userDefaultsForKey:GPSStatus] boolValue] && [self.arrLatLong count]==2)
        distance= [location distanceFromLocation:[[CLLocation alloc]initWithLatitude:[[self.arrLatLong objectAtIndex:1]floatValue] longitude:[[self.arrLatLong objectAtIndex:0]floatValue]]];
    else
        distance=[location distanceFromLocation:self.locationManagerSingleton.locationManager.location];
    
    return distance/1609.344; //meter to mile
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - buttons
- (void)btnMoreClick:(id)sender {
    
    if (![[AppHelper userDefaultsForKey:uId] isKindOfClass:[NSNull class]] && [AppHelper userDefaultsForKey:uId]) {
        [self performSegueWithIdentifier:@"ValidationCMoreVC" sender:sender];
    }

}

- (void)btnBookClick:(id)sender {
    if (![[AppHelper userDefaultsForKey:uId] isKindOfClass:[NSNull class]] && [AppHelper userDefaultsForKey:uId]) {
        [self performSegueWithIdentifier:@"ValidationCProfileVC" sender:sender];
    }
    
}

- (IBAction)handleDrag:(UIButton *)sender forEvent:(UIEvent *)event
{
    flag=TRUE;
    CGPoint point = [[[event allTouches] anyObject] locationInView:self.view];
    
    if(point.y>=84 && point.y<=(SCREEN_HEIGHT-68))
    {
    point.x = sender.center.x; //Always stick to the same x value
    sender.center = point;
    }
}


#pragma mark Back Button Clicked
- (IBAction)btnBackClick:(id)sender {
    //back to previous view controller
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark Search Button Clicked
- (IBAction)btnSearchClick:(id)sender {
    
    [UIView animateWithDuration:0.1 animations:^{
        //_searchButton.alpha = 0.0f;
        
    } completion:^(BOOL finished) {
        
        // remove the search button
        _searchBar.alpha = 0.0;
        
        [UIView animateWithDuration:0.1
                         animations:^{
                             _searchBar.alpha = 1.0;
                         } completion:^(BOOL finished) {
                             [_searchBar becomeFirstResponder];
                         }];
        
    }];
}

#pragma mark UISearchBarDelegate methods
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    
    //[UIView animateWithDuration:0.1 animations:^{
        
        _searchBar.alpha = 0.0;
        [_searchBar resignFirstResponder];
        //[self.view endEditing:YES];
        [self prepareDataForValidationCenters:nil];

  //  } completion:^(BOOL finished) {
        //_searchButton.alpha = 0.0;  // set this *after* adding it back
        //[UIView animateWithDuration:0.1 animations:^ {
            //_searchButton.alpha = 1.0;
      //  }];
   // }];
    
}// called when cancel button pressed


-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
   
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [_searchBar resignFirstResponder];
    NSMutableDictionary *dataDict=[[NSMutableDictionary alloc]init];
    [dataDict setObject:searchBar.text forKey:@"search"];
    [self prepareDataForValidationCenters:dataDict];
    //NSLog(@"%@",searchBar.text);
    
}

- (IBAction)btnFilterClick:(id)sender {
    
    if (![[AppHelper userDefaultsForKey:uId] isKindOfClass:[NSNull class]] && [AppHelper userDefaultsForKey:uId]) {
        [self performSegueWithIdentifier:@"ValidationFiltersVC" sender:sender];
    }

}

- (IBAction)btnShowMapClick:(id)sender {
    
    if(flag==FALSE) {
    if (![sender isSelected]) {
        [sender setSelected: YES];
        [UIView transitionWithView:self.tableView
                          duration:0.1
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            /* any other animation you want */
                        } completion:^(BOOL finished) {

                            /* hide/show the required view*/
                            [self plotValidationCentersOnMap];
                            [self.mapContainerView setHidden:NO];
                            [self.tableView setHidden:YES];
                            //[self zoomToFitMapAnnotations:self.mapView];
                            
                        }];

    } else {
        [sender setSelected: NO];
        [UIView transitionWithView:self.mapContainerView
                          duration:0.1
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            /* any other animation you want */
                        } completion:^(BOOL finished) {
                            /* hide/show the required view*/
                            [self.mapContainerView setHidden:YES];
                            [self.tableView setHidden:NO];
                        }];

    }
    }
    else
        flag=FALSE;

}

- (void)zoomToFitMapAnnotations:(MKMapView *)mapView {
    if ([mapView.annotations count] == 0) return;
    
    CLLocationCoordinate2D topLeftCoord;
    topLeftCoord.latitude = -90;
    topLeftCoord.longitude = 180;
    
    CLLocationCoordinate2D bottomRightCoord;
    bottomRightCoord.latitude = 90;
    bottomRightCoord.longitude = -180;
    
    for(id<MKAnnotation> annotation in mapView.annotations) {
        topLeftCoord.longitude = fmin(topLeftCoord.longitude, annotation.coordinate.longitude);
        topLeftCoord.latitude = fmax(topLeftCoord.latitude, annotation.coordinate.latitude);
        bottomRightCoord.longitude = fmax(bottomRightCoord.longitude, annotation.coordinate.longitude);
        bottomRightCoord.latitude = fmin(bottomRightCoord.latitude, annotation.coordinate.latitude);
    }
    
    MKCoordinateRegion region;
    region.center.latitude = topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) * 0.5;
    region.center.longitude = topLeftCoord.longitude + (bottomRightCoord.longitude - topLeftCoord.longitude) * 0.5;
    
    // Add a little extra space on the sides
    region.span.latitudeDelta = fabs(topLeftCoord.latitude - bottomRightCoord.latitude) * 1.1;
    region.span.longitudeDelta = fabs(bottomRightCoord.longitude - topLeftCoord.longitude) * 1.1;
    
    region = [mapView regionThatFits:region];
    [mapView setRegion:region animated:YES];
}

#pragma mark- Map delegates

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 800, 800);
    //[self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
    //NSLog(@"CurrentLocation: %f: %f",region.center.latitude,region.center.longitude);
}

- (void) updateLocation:(NSNotification *) info {
    [self.locationManagerSingleton.locationManager startUpdatingLocation]; //Will update location immediately
    [self.tableView reloadData];
}

- (NSString *)deviceLocation {
    
    return [NSString stringWithFormat:@"latitude: %f longitude: %f", [AppDelegate getAppDelegate].currentLocation.coordinate.latitude, [AppDelegate getAppDelegate].currentLocation.coordinate.longitude];
}

-(MKAnnotationView *)mapView:(MKMapView *)mV viewForAnnotation:(id <MKAnnotation>)annotation
{
    // Don't mess with user location
    if(![annotation isKindOfClass:[ZSAnnotation class]])
        return nil;
    
    ZSAnnotation *a = (ZSAnnotation *)annotation;
    static NSString *defaultPinID = @"com.proactive.custompin";
    
    // Create the ZSPinAnnotation object and reuse it
    ZSPinAnnotation *pinView = (ZSPinAnnotation *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
    if (pinView == nil){
        pinView = [[ZSPinAnnotation alloc] initWithAnnotation:annotation reuseIdentifier:defaultPinID];
    }
    
    // Set the type of pin to draw and the color
    pinView.annotationType = ZSPinAnnotationTypeTag;
    pinView.annotationColor =[AppHelper colorFromHexString:a.colorStr alpha:1.0];
   
    pinView.canShowCallout = NO;
    pinView.dicInfo=a.dicInfo;
    return pinView;
    
    /*
    if( annotation == self.mapView.userLocation ) return nil;
    
    MKPinAnnotationView *pinView = nil;
    if(annotation != self.mapView.userLocation)
    {
        static NSString *defaultPinID = @"com.proactive.pin";
        pinView = (MKPinAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
        if ( pinView == nil )
            pinView = [[MKPinAnnotationView alloc]
                       initWithAnnotation:annotation reuseIdentifier:defaultPinID];
        
        CenterAnnotation *myAnn = (CenterAnnotation *)annotation;
        [pinView addSubview:[[UIImageView alloc]initWithImage:[AppHelper imageFromColor:[AppHelper colorFromHexString:myAnn.color alpha:1.0]]]]; //image from color
        pinView.canShowCallout = YES;
        //pinView.animatesDrop = YES;
        pinView.pinColor=[AppHelper colorFromHexString:myAnn.color alpha:1.0];

        pinView.annotation = annotation;
        //pinView.image = [AppHelper imageFromColor:[AppHelper colorFromHexString:myAnn.color alpha:1.0]]; //image from color
        //pinView.image = [UIImage imageNamed:@"ic_validation_location_2"];
        pinView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];

    }
    return pinView;
     */
    
}
-(void)buttonCalloutClicked:(NSNotification *)notification
{
    NSDictionary *dicInfo = notification.userInfo;
    
    //NSLog(@"%@",dicInfo);
    
    if (![[AppHelper userDefaultsForKey:uId] isKindOfClass:[NSNull class]] && [AppHelper userDefaultsForKey:uId]) {
        [self performSegueWithIdentifier:@"ValidationCMoreVC" sender:dicInfo];
    }


}

- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView
{
    //NSLog(@"Map fully loaded");
}

//if annotation pressed
-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
    
    if (![(ZSAnnotation *)view.annotation isKindOfClass:[MKUserLocation class]])
    {
        ZSAnnotation *myAnn = (ZSAnnotation *)view.annotation;
        //detailButton.tag = myAnn.pinIndex;
        //NSLog (@"Pin color %@", myAnn.colorStr);
        
    }
}
-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    
    if (![(ZSAnnotation *)view.annotation isKindOfClass:[MKUserLocation class]])
    {
        ZSAnnotation *myAnn = (ZSAnnotation *)view.annotation;
        //detailButton.tag = myAnn.pinIndex;
        //NSLog (@"Pin color %@", myAnn.colorStr);
    }
    
    
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"ValidationCMoreVC"]) {
       
        if ([[sender class] isSubclassOfClass: [UIButton class]]) {
        //id selectedObject = [self.dataArray objectAtIndex: [self.tableView indexPathForCell: sender].row];
        UIButton *button=(UIButton*)sender;
        ValidationCMoreVC *VC = [segue destinationViewController];
        VC.dataDict=[self.dataArray objectAtIndex: button.tag];
            
        //ValidationCenterCell *clickedCell = (ValidationCenterCell *)[[sender superview] superview];
        CLLocation * LocationActual = [[CLLocation alloc]initWithLatitude:[[[[self.dataArray objectAtIndex:button.tag]valueForKey:@"location"]objectAtIndex:1]floatValue] longitude:[[[[self.dataArray objectAtIndex:button.tag]valueForKey:@"location"]objectAtIndex:0]floatValue]];
        VC.milesAway=[self distanceFromCurrentLocationToLocation:LocationActual];
            
        }
        else if([[sender class] isSubclassOfClass: [NSDictionary class]])
        {
            NSDictionary *dict=(NSDictionary*)sender;
            ValidationCMoreVC *VC = [segue destinationViewController];
            VC.dataDict=dict;
            //ValidationCenterCell *clickedCell = (ValidationCenterCell *)[[sender superview] superview];
            CLLocation * LocationActual = [[CLLocation alloc]initWithLatitude:[[[dict valueForKey:@"location"]objectAtIndex:1]floatValue] longitude:[[[dict valueForKey:@"location"]objectAtIndex:0]floatValue]];
            VC.milesAway=[self distanceFromCurrentLocationToLocation:LocationActual];
        }
    
    }
    
    if ([segue.identifier isEqualToString:@"ValidationCProfileVC"]) {
        
        if ([[sender class] isSubclassOfClass: [UIButton class]]) {
            //id selectedObject = [self.dataArray objectAtIndex: [self.tableView indexPathForCell: sender].row];
            UIButton *button=(UIButton*)sender;
            ValidationCProfileVC *VC = [segue destinationViewController];
            VC.allData=[self.dataArray objectAtIndex:button.tag];
            
        }
        
    }
    
    if ([segue.identifier isEqualToString:@"ValidationFiltersVC"]) {
        ValidationFiltersVC *VF = [segue destinationViewController];
        VF.screenTitle=self.orgType;
    }
    
    
    if ([segue.identifier isEqualToString:@"showPinDetails"]) {
        
        // SetCardController *scc = [segue destinationViewController];
    }
    
}

#pragma -mark Tab Bar items click methods
- (void)btnHomeClick {
    
    if (![[AppHelper userDefaultsForKey:uId] isKindOfClass:[NSNull class]] && [AppHelper userDefaultsForKey:uId]) {
        [self performSegueWithIdentifier:@"HomeVCScreen" sender:nil];
    }
    
}

- (void) viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_ANNOTATION_CLICKED object:nil];
}



@end
