//
//  ViewController.m
//  iBeaconTransmitterDemo
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
@property(nonatomic,strong)CBPeripheralManager *peripheralManager;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupView];
}

-(void)setupView
{
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.frame = CGRectMake(0,0, self.view.frame.size.width, 60);
    titleLabel.backgroundColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:0.2];
    [titleLabel setText:@"Transmitter"];
    [self.view addSubview:titleLabel];

    
    self.startButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.view addSubview:self.startButton];
    self.startButton.frame = CGRectMake(10,70, 100, 40);
    [self.startButton setTitle:@"Start" forState:UIControlStateNormal];
    [self.startButton addTarget:self action:@selector(start) forControlEvents:UIControlEventTouchUpInside];
    [self.startButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:15]];
    
    
    
    self.stopButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.stopButton addTarget:self action:@selector(stop) forControlEvents:UIControlEventTouchUpInside];
    [self.stopButton setTitle:@"Stop" forState:UIControlStateNormal];
    self.stopButton.frame = CGRectMake(self.view.frame.size.width - 120,70, 100, 40);
    [self.stopButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:15]];
    
    [self.view addSubview:self.stopButton];
    
    
    self.UUIDTextField = [[UITextField alloc]init];
    self.UUIDTextField.frame = CGRectMake(10, 120, self.view.frame.size.width-20, 30);
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

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self configureBeaconTransmitter];
}


-(void)start
{
    NSDictionary *peripheralData = [self configureBeaconTransmitter];
    if(peripheralData)
    {
        [self.peripheralManager startAdvertising:peripheralData];
    }
}

-(NSDictionary*)configureBeaconTransmitter
{
    if (self.peripheralManager==nil) {
        self.peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    }
    
    NSString *uuid = kSampleUUID;
    if (self.UUIDTextField.text != nil && self.UUIDTextField.text.length == 36) {
        uuid = self.UUIDTextField.text;
    }
    
    self.beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:[[NSUUID alloc] initWithUUIDString:uuid] major:10 minor:12 identifier:@"BeaconTransmitter"];
    return [self.beaconRegion peripheralDataWithMeasuredPower:[NSNumber numberWithInt:-59]];

}


-(void)stop
{
    if (self.peripheralManager != nil) {
        [self.peripheralManager stopAdvertising];
    }
    
}


- (void)peripheralManagerDidStartAdvertising:(CBPeripheralManager *)peripheral error:(nullable NSError *)error
{
    
}

-(void)peripheralManagerDidUpdateState:(nonnull CBPeripheralManager *)peripheral
{
    if(peripheral.state < CBPeripheralManagerStatePoweredOn)
    {
        NSString *title = NSLocalizedString(@"Bluetooth must be enabled", @"");
        NSString *message = NSLocalizedString(@"To configure your device as a beacon", @"");
        NSString *cancelButtonTitle = NSLocalizedString(@"OK", @"Cancel button title in configuration Save Changes");
        UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil];
        [errorAlert show];
        [self stop];
    }
    else
    {
        [self start];
    }

    
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
    [self stop];
    [self start];
    return YES;
}


-(void)touchesBegan:(nonnull NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event
{
    [self.view endEditing:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
