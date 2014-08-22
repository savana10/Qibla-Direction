//
//  QDViewController.m
//  Qibla Direction
//
//  Created by Savana on 22/08/2014.
//  Copyright (c) 2014 Savana. All rights reserved.
//

#import "QDViewController.h"

@interface QDViewController ()

@end

@implementation QDViewController
@synthesize qiblaLocationManager;


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self startLocationManager];
}

#pragma mark- update location

-(void) startLocationManager
{
    qiblaLocationManager=[[CLLocationManager alloc] init];
    [qiblaLocationManager setDelegate:self];
    [qiblaLocationManager startUpdatingLocation];
    [qiblaLocationManager startUpdatingHeading];
    
}

#pragma mark - location manager delegate

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading
{
    
    float oldRad =  -manager.heading.trueHeading * M_PI / 180.0f;
	float newRad =  -newHeading.trueHeading * M_PI / 180.0f;
    double qiblaRad=-newHeading.trueHeading * M_PI / 180.0f+[self angleToMecca:manager.location];
    // to display angle in values
    [self changeLabelValues:manager.location AndAngle:qiblaRad];
    
    // if images are present
    [self rotateImagesFrom:oldRad To:newRad with:qiblaRad];

    
    
}
#pragma mark - calucalate angle
- (double)angleToMecca:(CLLocation *)currentLocation {
    float latk = 21.4225*M_PI /180.0;
	float longk = 39.8264*M_PI/180.0;
	float phi = currentLocation.coordinate.latitude*M_PI/180.0;
	float lambda = currentLocation.coordinate.longitude*M_PI/180.0;
	float qiblad = 180.0/M_PI*atan2(sin(longk-lambda),cos(phi)*tan(latk)-sin(phi)*cos(longk-lambda));
    
    float lon2=currentLocation.coordinate.longitude;
    float lon1=MECCA_LONGITUDE;
    float lat1=MECCA_LATITUDE;
    float lat2=currentLocation.coordinate.latitude;
    
    float lonDelta = (lon2 - lon1);
    float y = sin(lonDelta);
    float x = cos(lat1) * sin(lat2) - sin(lat1) *cos(lat2) * cos(lonDelta);
    float z= cos(lat2)*tan(lat1)-sin(lat1)*cos(lonDelta);
    float brng = atan2(y, x);
    brng=atan(y/z);
    
    
    return qiblad*M_PI /180;
    
}


-(void) rotateImagesFrom:(float) oldRad To:(float) newRad with:(double) qiblaRad
{
   	CABasicAnimation *theAnimation;
	theAnimation=[CABasicAnimation animationWithKeyPath:@"transform.rotation"];
	theAnimation.fromValue = [NSNumber numberWithFloat:oldRad];
	theAnimation.toValue=[NSNumber numberWithFloat:newRad];
	theAnimation.duration = 0.5f;
	[self.qiblaBackground.layer addAnimation:theAnimation forKey:@"animateMyRotation"];
    
    
	self.qiblaBackground.transform = CGAffineTransformMakeRotation(newRad);
    
    CABasicAnimation *theAnimation1;
	theAnimation1=[CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    theAnimation1.fromValue = [NSNumber numberWithFloat:qiblaRad];
	theAnimation1.toValue=[NSNumber numberWithFloat:qiblaRad];
	theAnimation1.duration = 0.5f;
    [self.qiblaPointer.layer addAnimation:theAnimation1 forKey:@"animateMyRotation1"];
    self.qiblaPointer.transform = CGAffineTransformMakeRotation(qiblaRad);
    
}
-(void) changeLabelValues:(CLLocation *) currentLocation AndAngle:(double ) angle
{
    [self.currentLat setText:[NSString stringWithFormat:@"%0.2f",currentLocation.coordinate.latitude]];
    [self.currentLon setText:[NSString stringWithFormat:@"%0.2f",currentLocation.coordinate.longitude]];
    [self.currentAngle setText:[NSString stringWithFormat:@"%0.2f",angle]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
