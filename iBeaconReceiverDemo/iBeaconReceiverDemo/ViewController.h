//
//  ViewController.h
//  iBeaconReceiverDemo
//
//  Created by Saurav Satpathy on 06/07/15.
//  Copyright © 2015 Saurav Satpathy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <CoreLocation/CoreLocation.h>


#define kSampleUUID  @"74278BDA-B644-4520-8F0C-720EAF059935"
@interface ViewController : UIViewController <CLLocationManagerDelegate,UITextFieldDelegate,UITextViewDelegate>


@end

