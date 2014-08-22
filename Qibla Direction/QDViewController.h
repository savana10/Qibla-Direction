//
//  QDViewController.h
//  Qibla Direction
//
//  Created by Savana on 22/08/2014.
//  Copyright (c) 2014 Savana. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

#define MECCA_LATITUDE 21.4225
#define MECCA_LONGITUDE 39.8264
#define cot(x) (1 / tan(x))

@interface QDViewController : UIViewController<CLLocationManagerDelegate>

@property (retain, nonatomic) CLLocationManager *qiblaLocationManager;
@property (strong, nonatomic) IBOutlet UIImageView *qiblaPointer;
@property (strong, nonatomic) IBOutlet UIImageView *qiblaBackground;
@property (weak, nonatomic) IBOutlet UILabel *currentLat;
@property (weak, nonatomic) IBOutlet UILabel *currentLon;
@property (weak, nonatomic) IBOutlet UILabel *currentAngle;


@end
