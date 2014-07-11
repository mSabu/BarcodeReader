//
//  BRCodeViewController.m
//  BarcodeReader
//
//  Created by Manjusha on 3/20/14.
//

#import "BRCodeViewController.h"

@interface BRCodeViewController ()
{
    UIView *_highlightView;
}
@end

@implementation BRBarcodeScanViewController
@synthesize mCaptureSession, mCode;

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
    
    //added for testing if navigation works
    /*
     NSString *barCodeString = @"12132323";
     [self.delegate barcodeScannerViewController:self didFinishScaningItem:barCodeString ];
     */
    
    //view for displaying border for scanning
    _highlightView = [[UIView alloc] init];
    
    _highlightView.frame =  CGRectMake(20, 140, 280, 280);
    
    _highlightView.layer.borderColor = [UIColor greenColor].CGColor;
    _highlightView.layer.borderWidth = 3;
    
    [self.view addSubview:_highlightView];
    
    
    NSLog(@"_highlightView.frame %f, %f", _highlightView.frame.size.height, _highlightView.frame.size.width);
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"CANCEL" style:UIBarButtonItemStylePlain target:self action:@selector(cancelButtonPressed)];
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont
                                                                           fontWithName:@"EUPHEMIA UCAS" size:10], NSFontAttributeName,
                                [UIColor blackColor], NSForegroundColorAttributeName, nil];
    
    [self.navigationItem.leftBarButtonItem setTitleTextAttributes:attributes forState:UIControlStateNormal];
    
    mCaptureSession = [[AVCaptureSession alloc] init];
    
    // 2
    AVCaptureDevice *videoCaptureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error = nil;
    
    // 3
    AVCaptureDeviceInput *videoInput = [AVCaptureDeviceInput deviceInputWithDevice:videoCaptureDevice error:&error];
    
    if ([mCaptureSession canAddInput:videoInput]) {
        [mCaptureSession addInput:videoInput];
        NSLog(@"Added videoinput.");
        // 4
        AVCaptureMetadataOutput *metadataOutput = [[AVCaptureMetadataOutput alloc] init];
        
        metadataOutput.rectOfInterest = self.view.bounds;
        
        if ([mCaptureSession canAddOutput:metadataOutput]) {
            [mCaptureSession addOutput:metadataOutput];
            NSLog(@"Added metadata output.");
            
            // 5
            [metadataOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
            [metadataOutput setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode, AVMetadataObjectTypeEAN13Code,AVMetadataObjectTypeCode39Code,AVMetadataObjectTypeCode39Mod43Code]];
        } else {
            NSLog(@"Could not add metadata output.");
        }
        
        // 6
        AVCaptureVideoPreviewLayer *previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:mCaptureSession];
        previewLayer.frame = self.view.layer.bounds;
        [self.view.layer addSublayer:previewLayer];
        
        // 7
        [mCaptureSession startRunning];
        [self.view bringSubviewToFront:_highlightView];
        
    } else {
        NSLog(@"Could not add video input: %@", [error localizedDescription]);
        
        NSString *noOutput = @"no video output";
        
        [self.delegate barcodeScannerViewController:self didFinishScaningItem:noOutput ];
    }
    
    
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    
    NSLog(@"captureOutput ");
    if (mCode == nil) {
        mCode = [[NSMutableString alloc] initWithString:@""];
    }
    
    // 2
    [mCode setString:@""];
    
    // 3
    for (AVMetadataObject *metadataObject in metadataObjects) {
        
        AVMetadataMachineReadableCodeObject *readableObject = (AVMetadataMachineReadableCodeObject *)metadataObject;
        
        // 4
        if([metadataObject.type isEqualToString:AVMetadataObjectTypeQRCode]) {
            [mCode appendFormat:@"%@ (QR)", readableObject.stringValue];
            
            NSLog(@"mcode - %@",mCode);
        }
        else if([metadataObject.type isEqualToString:AVMetadataObjectTypeCode39Code]) {
            [mCode appendFormat:@"%@ ", readableObject.stringValue];
            
            NSLog(@"mcode AVMetadataObjectTypeCode39Code - %@",mCode);
        }
        
        else if ([metadataObject.type isEqualToString:AVMetadataObjectTypeCode39Mod43Code]) {
            [mCode appendFormat:@"%@ ", readableObject.stringValue];
            
            NSLog(@"mcode AVMetadataObjectTypeCode39Mod43Code - %@",mCode);
        }
        
        else if ([metadataObject.type isEqualToString:AVMetadataObjectTypeEAN13Code]) {
            [mCode appendFormat:@"%@", readableObject.stringValue];
            NSLog(@"mcode - %@",mCode);
            
        }
        else if ([metadataObject.type isEqualToString:AVMetadataObjectTypeUPCECode]) {
            [mCode appendFormat:@"%@ (UPC)", readableObject.stringValue];
            NSLog(@"mcode - %@",mCode);
            
        }
    }
    
    // 5
    if (![mCode isEqualToString:@""]) {
        
        //send the data to detailview controller using delegate
        //[self performSegueWithIdentifier:@"CodeViewSegue" sender:self];
        
        NSString *barCodeString = mCode;
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
    
    // [self.navigationController popToRootViewControllerAnimated:NO];
}

@end
