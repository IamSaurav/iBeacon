//
//  ViewController.m
//  iBeaconReceiverDemo
//
//  Created by Saurav Satpathy on 06/07/15.
//  Copyright © 2015 Saurav Satpathy. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property(nonatomic,strong)CLLocationManager *locationManager;
@property(nonatomic,strong)CLBeaconRegion *beaconRegion;
@property(nonatomic,strong)CBCentralManager *bluetoothManager;
@property(nonatomic,strong)UITextField *UUIDTextField;
@property(nonatomic,strong)UITextView *beaconInfoTxtView;
@property(nonatomic,strong)UIButton *startButton;
@property(nonatomic,strong)UIButton *stopButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupView];
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self configureBeacon];
    
}
-(void)setupView
{
    
    self.startButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.view addSubview:self.startButton];
    self.startButton.frame = CGRectMake(10,30, 100, 40);
    [self.startButton setTitle:@"Start" forState:UIControlStateNormal];
    [self.startButton addTarget:self action:@selector(start) forControlEvents:UIControlEventTouchUpInside];
    [self.startButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:15]];

    
    
    self.stopButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.stopButton addTarget:self action:@selector(stop) forControlEvents:UIControlEventTouchUpInside];
    [self.stopButton setTitle:@"Stop" forState:UIControlStateNormal];
    self.stopButton.frame = CGRectMake(self.view.frame.size.width - 120,30, 100, 40);
    [self.stopButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:15]];

    [self.view addSubview:self.stopButton];

    
    self.UUIDTextField = [[UITextField alloc]init];
    self.UUIDTextField.frame = CGRectMake(10, 100, self.view.frame.size.width-20, 30);
    self.UUIDTextField.delegate = self;
    [self.UUIDTextField setBorderStyle:UITextBorderStyleRoundedRect];
    self.UUIDTextField.textAlignment = NSTextAlignmentCenter;
    self.UUIDTextField.font = [UIFont fontWithName:@"Helvetica" size:14];
    self.UUIDTextField.text = kSampleUUID;
    [self.view addSubview:self.UUIDTextField];
    
    
    
    self.beaconInfoTxtView = [[UITextView alloc]init];
    CGFloat originY = self.UUIDTextField.frame.origin.y +  self.UUIDTextField.frame.size.height + 40;
    self.beaconInfoTxtView.frame = CGRectMake(10,originY, self.view.frame.size.width-20, self.view.frame.size.height - originY - 20);
    self.beaconInfoTxtView.textAlignment = NSTextAlignmentCenter;
    self.beaconInfoTxtView.font = [UIFont fontWithName:@"Helvetica" size:14];
    [self.view addSubview:self.beaconInfoTxtView];
    
    
}

-(void)start
{
    if (self.UUIDTextField.text != nil && self.UUIDTextField.text.length == 36) {
        [self configureBeacon];
        //Start Monitoring and ranging
        [self.locationManager startMonitoringForRegion:self.beaconRegion];
        [self.locationManager startRangingBeaconsInRegion:self.beaconRegion];
    }
    else
    {
        [self showAlertMessage:@"Invalid UUID"];
    }
    

}


-(void)stop
{
    //Start Monitoring and ranging
    [self.locationManager stopMonitoringForRegion:self.beaconRegion];
    [self.locationManager stopRangingBeaconsInRegion:self.beaconRegion];

}

-(void)touchesBegan:(nonnull NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event
{
    [self.view endEditing:YES];
}


-(void)configureBeacon
{
    self.locationManager = [[CLLocationManager alloc] init];
    
    // Authorization must asked and granted by user.
    // requestAlwaysAuthorization or requestWhenInUseAuthorization
    // can be used based on reuirement/
    if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        
        [self.locationManager requestAlwaysAuthorization];
    }
    //[self.locationManager requestAlwaysAuthorization];
    
    // Location Manager configuration
    [self.locationManager setDelegate:self];
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    [self.locationManager setDistanceFilter:kCLDistanceFilterNone];
    
    // Beacon Region Configuration
    NSString *UUIDStr = kSampleUUID;
    if (self.UUIDTextField.text != nil && self.UUIDTextField.text.length == 36) {
        UUIDStr = self.UUIDTextField.text;
    }
    
    self.beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:
                         [[NSUUID alloc] initWithUUIDString:UUIDStr]
                                    identifier:@"BeaconSameple"];
    self.beaconRegion.notifyOnExit=YES;
    self.beaconRegion.notifyOnEntry=YES;
    self.beaconRegion.notifyEntryStateOnDisplay = YES;
    
    //Start Monitoring and ranging
    [self.locationManager startMonitoringForRegion:self.beaconRegion];
    [self.locationManager startRangingBeaconsInRegion:self.beaconRegion];
    
}



-(void)locationManager:(nonnull CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(nonnull CLRegion *)region
{
    switch (state) {
        case CLRegionStateInside:
        {
            [self showAlertMessage:@"You entered region!"];
            
            break;
        }
        case CLRegionStateOutside:
        {
            [self showAlertMessage:@"You exited region!"];
            
            break;
        }
        case CLRegionStateUnknown:
        {
            [self showAlertMessage:@"You state is unknown!"];
            
            break;
        }
            
        default:
            break;
    }
}

-(void)locationManager:(nonnull CLLocationManager *)manager didRangeBeacons:(nonnull NSArray<CLBeacon *> *)beacons inRegion:(nonnull CLBeaconRegion *)region
{
    for (CLBeacon *beacon in beacons) {
        self.beaconInfoTxtView.text = [self.beaconInfoTxtView.text stringByAppendingFormat:@" \n Major : %d Minor : %d Distance : %f",beacon.major.intValue,beacon.minor.intValue,beacon.accuracy];
        
    }
    
}



-(void)showAlertMessage :(NSString*)message
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"iBeacon Receiver" message:message preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alertController animated:YES completion:nil];
    
    [alertController addAction: [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil]];
    
}

-(BOOL)textFieldShouldReturn:(nonnull UITextField *)textField
{
    [textField resignFirstResponder];
    return  YES;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [self start];
    return YES;
}

- (BOOL)textViewShouldEndEditing:(nonnull UITextView *)textView
{
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
