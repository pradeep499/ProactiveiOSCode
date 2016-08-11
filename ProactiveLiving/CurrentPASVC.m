//
//  CurrentPASVC.m
//  ProactiveLiving
//
//  Created by Mohd Asim on 19/04/16.
//  Copyright © 2016 appstudioz. All rights reserved.
//

#import "CurrentPASVC.h"
#import "PASLevelVC.h"
#import "PASRatingVC.h"
#import "AppHelper.h"
#import "Defines.h"

#define START_POINT 90
#define END_POINT 180

@interface CurrentPASVC ()
{
    CGRect oldframe;
}

@property (weak, nonatomic) IBOutlet UIImageView *needleImageView;
@property(nonatomic,assign) float speedometerCurrentValue;
@property(nonatomic,assign) float prevAngleFactor;
@property(nonatomic,assign) float angle;
@property(nonatomic,retain) NSTimer *speedometer_Timer;
@property(nonatomic,retain) IBOutlet UILabel *speedometerReading;
@property(nonatomic,retain) NSString *maxVal;
@property (weak, nonatomic) IBOutlet UIButton *btnLevel;
@property (weak, nonatomic) IBOutlet UIButton *btnRating;
@property (weak, nonatomic) IBOutlet UIButton *btnPASToDo;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)btnLevelClick:(id)sender;
- (IBAction)btnRatingClick:(id)sender;
- (IBAction)btnPASToDoClick:(id)sender;
- (IBAction)btnBackClick:(id)sender;
- (IBAction)btnInstClick:(id)sender;

@end

@implementation CurrentPASVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addMeterViewContents];
    [AppHelper addShadowOnView:self.btnLevel withOffset:CGSizeMake(0.0, 1.0) withColor:[UIColor blackColor]];
    [AppHelper addShadowOnView:self.btnRating withOffset:CGSizeMake(0.0, 1.0) withColor:[UIColor blackColor]];
    [AppHelper addShadowOnView:self.btnPASToDo withOffset:CGSizeMake(0.0, 1.0) withColor:[UIColor blackColor]];
    
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [AppHelper setBorderOnView:self.tableView];



}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

#pragma mark - preferredStatusBarStyle
-(UIStatusBarStyle)preferredStatusBarStyle {
    // to set the light color of status bar
    return UIStatusBarStyleLightContent;
}

#pragma mark Public Methods

-(void) addMeterViewContents
{
    //Needle
    oldframe=self.needleImageView.bounds;
    self.needleImageView.layer.anchorPoint = CGPointMake(self.needleImageView.layer.anchorPoint.x, self.needleImageView.layer.anchorPoint.y*2);
    //self.needleImageView.frame=oldframe;
    //[self setAnchorPoint:CGPointMake(0.0f, 1.0f) forView:self.needleImageView];
    self.needleImageView.backgroundColor = [UIColor clearColor];
    
    //Reading
    self.speedometerReading.text= @"0";
    
    // Set Max Value //
    self.maxVal = @"100";
    
    /// Set Needle pointer initialy at zero //
    [self rotateIt:-START_POINT];
    
    // Set previous angle //
    self.prevAngleFactor = -START_POINT;
    
    // Set Speedometer Value //
    [self setSpeedometerCurrentValue];
}

- (void) setAnchorPoint:(CGPoint)anchorPoint forView:(UIView *)view{
    CGPoint oldOrigin = view.frame.origin;
    view.layer.anchorPoint = anchorPoint;
    CGPoint newOrigin = view.frame.origin;
    
    CGPoint transition;
    transition.x = newOrigin.x - oldOrigin.x;
    transition.y = newOrigin.y - oldOrigin.y;
    
    view.center = CGPointMake (view.center.x - transition.x, view.center.y - transition.y);
}
/*
-(void)setAnchorPoint:(CGPoint)anchorPoint forView:(UIView *)view
{
    CGPoint newPoint = CGPointMake(view.bounds.size.width * anchorPoint.x,
                                   view.bounds.size.height * anchorPoint.y);
    CGPoint oldPoint = CGPointMake(view.bounds.size.width * view.layer.anchorPoint.x,
                                   view.bounds.size.height * view.layer.anchorPoint.y);
    
    newPoint = CGPointApplyAffineTransform(newPoint, view.transform);
    oldPoint = CGPointApplyAffineTransform(oldPoint, view.transform);
    
    CGPoint position = view.layer.position;
    
    position.x -= oldPoint.x;
    position.x += newPoint.x;
    
    position.y -= oldPoint.y;
    position.y += newPoint.y;
    
    view.layer.position = position;
    view.layer.anchorPoint = anchorPoint;
}
*/
#pragma mark -
#pragma mark calculateDeviationAngle Method

-(void) calculateDeviationAngle
{
    
    if([self.maxVal floatValue]>0)
    {
        self.angle = ((self.speedometerCurrentValue *237.4)/[self.maxVal floatValue])-START_POINT;  // 237.4 - Total angle between 0 - 100 //
    }
    else
    {
        self.angle = 0;
    }
    
    if(self.angle<=-START_POINT)
    {
        self.angle = -START_POINT;
    }
    if(self.angle>=119)
    {
        self.angle = 119;
    }
    
    
    // If Calculated angle is greater than 180 deg, to avoid the needle to rotate in reverse direction first rotate the needle 1/3 of the calculated angle and then 2/3. //
    if(abs(self.angle-self.prevAngleFactor) >180)
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5f];
        [self rotateIt:self.angle/3];
        [UIView commitAnimations];
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5f];
        [self rotateIt:(self.angle*2)/3];
        [UIView commitAnimations];
        
    }
    
    self.prevAngleFactor = self.angle;
    
    
    // Rotate Needle //
    [self rotateNeedle];
    
    
}


#pragma mark -
#pragma mark rotateNeedle Method
-(void) rotateNeedle
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5f];
    [self.needleImageView setTransform: CGAffineTransformMakeRotation((M_PI / 180) * self.angle)];
    [UIView commitAnimations];
    
}

#pragma mark -
#pragma mark setSpeedometerCurrentValue

-(void) setSpeedometerCurrentValue
{
    self.speedometerCurrentValue =  46.85; //Value between 0 to 75.8 //

    if(self.speedometer_Timer)
    {
        [self.speedometer_Timer invalidate];
        self.speedometer_Timer = nil;
    }
    self.speedometer_Timer = [NSTimer  scheduledTimerWithTimeInterval:2 target:self selector:@selector(setSpeedometerCurrentValue) userInfo:nil repeats:YES];
    
    self.speedometerReading.text = [NSString stringWithFormat:@"%d",(int)(self.speedometerCurrentValue*16.67)];
    
    // Calculate the Angle by which the needle should rotate //
    [self calculateDeviationAngle];
}
#pragma mark -
#pragma mark Speedometer needle Rotation View Methods

-(void) rotateIt:(float)angl
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.01f];
    
    [self.needleImageView setTransform: CGAffineTransformMakeRotation((M_PI / 180) *angl)];	
    
    [UIView commitAnimations];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnLevelClick:(id)sender {
    
    if (![[AppHelper userDefaultsForKey:uId] isKindOfClass:[NSNull class]] && [AppHelper userDefaultsForKey:uId])
    {
        PASLevelVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"PASLevelVC"];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (IBAction)btnRatingClick:(id)sender {
    
    if (![[AppHelper userDefaultsForKey:uId] isKindOfClass:[NSNull class]] && [AppHelper userDefaultsForKey:uId])
    {
        PASRatingVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"PASRatingVC"];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (IBAction)btnPASToDoClick:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];

}

- (IBAction)btnBackClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnInstClick:(id)sender {
}
@end
