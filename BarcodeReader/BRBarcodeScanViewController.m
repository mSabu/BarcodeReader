//
//  BRBarcodeScanViewController.m
//  BarcodeScanner
//
//  Created by Manjusha on 6/4/14.
//  Copyright (c) 2014 Manjusha. All rights reserved.
//

#import "BRBarcodeScanViewController.h"

@interface BRBarcodeScanViewController ()
{
    UIView *highlightView;
}
@end

@implementation BRBarcodeScanViewController

#define VIEW_BOUNDS_X 20
#define VIEW_BOUNDS_Y 140
#define VIEW_SIZE 280
#define BORDER_WIDTH 2

@synthesize bCaptureSession, bCode;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
    
    //view for displaying border for scanning
    highlightView = [[UIView alloc] init];
    
    highlightView.frame =  CGRectMake(VIEW_BOUNDS_X, VIEW_BOUNDS_Y, VIEW_SIZE, VIEW_SIZE);
    
    highlightView.layer.borderColor = [UIColor greenColor].CGColor;
    highlightView.layer.borderWidth = BORDER_WIDTH;
    
    [self.view addSubview:highlightView];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"CANCEL" style:UIBarButtonItemStylePlain target:self action:@selector(cancelButtonPressed)];
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont
                                                                           fontWithName:@"EUPHEMIA UCAS" size:10], NSFontAttributeName,
                                [UIColor blackColor], NSForegroundColorAttributeName, nil];
    
    [self.navigationItem.leftBarButtonItem setTitleTextAttributes:attributes forState:UIControlStateNormal];
    
    bCaptureSession = [[AVCaptureSession alloc] init];
    
    AVCaptureDevice *videoCaptureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error = nil;
    
    AVCaptureDeviceInput *videoInput = [AVCaptureDeviceInput deviceInputWithDevice:videoCaptureDevice error:&error];
    
    if ([bCaptureSession canAddInput:videoInput]) {
        [bCaptureSession addInput:videoInput];

        AVCaptureMetadataOutput *metadataOutput = [[AVCaptureMetadataOutput alloc] init];
        
        metadataOutput.rectOfInterest = self.view.bounds;
        
        if ([bCaptureSession canAddOutput:metadataOutput]) {
            [bCaptureSession addOutput:metadataOutput];
            NSLog(@"Added metadata output.");
            
            [metadataOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
            [metadataOutput setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode, AVMetadataObjectTypeEAN13Code,AVMetadataObjectTypeCode39Code,AVMetadataObjectTypeCode39Mod43Code]];
        } else {
            NSLog(@"Could not add metadata output.");
        }
        
        AVCaptureVideoPreviewLayer *previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:bCaptureSession];
        previewLayer.frame = self.view.layer.bounds;
        [self.view.layer addSublayer:previewLayer];
        
        [bCaptureSession startRunning];
        [self.view bringSubviewToFront:highlightView];
        
    } else {
        NSLog(@"Could not add video input: %@", [error localizedDescription]);
        NSString *noOutput = @"no video input";
        [self.delegate barcodeScannerViewController:self didFinishScaningItem:noOutput ];
    }
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    
    NSLog(@"captureOutput ");
 
    if (bCode == nil) {
        bCode = [[NSMutableString alloc] initWithString:@""];
    }
    
    [bCode setString:@""];
    
    for (AVMetadataObject *metadataObject in metadataObjects) {
        
        AVMetadataMachineReadableCodeObject *readableObject = (AVMetadataMachineReadableCodeObject *)metadataObject;
        
        if([metadataObject.type isEqualToString:AVMetadataObjectTypeQRCode]) {
            [bCode appendFormat:@"%@ (QR)", readableObject.stringValue];
            
        }
        else if([metadataObject.type isEqualToString:AVMetadataObjectTypeCode39Code]) {
            [bCode appendFormat:@"%@ (Code39) ", readableObject.stringValue];
            
        }
        
        else if ([metadataObject.type isEqualToString:AVMetadataObjectTypeEAN13Code]) {
            [bCode appendFormat:@"%@ EAN13", readableObject.stringValue];
            
        }
        else if ([metadataObject.type isEqualToString:AVMetadataObjectTypeUPCECode]) {
            [bCode appendFormat:@"%@ (UPC)", readableObject.stringValue];
        }
    }
    
    if (![bCode isEqualToString:@""]) {
        
        NSString *barCodeString = bCode;
        NSLog(@"barCodeString - %@",barCodeString);
        
        [self.delegate barcodeScannerViewController:self didFinishScaningItem:barCodeString ];
    }
}

- (BOOL) isCameraAvailable;
{
    NSArray *videoDevices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    return [videoDevices count] > 0;
}

-(void)cancelButtonPressed{
    NSLog(@"cancel button pressed");
    [self dismissViewControllerAnimated:NO completion:nil];
    
}

@end
