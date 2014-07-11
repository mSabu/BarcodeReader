//
//  BRBarcodeScanViewController.h
//  BarcodeScanner
//
//  Created by Manjusha on 6/4/14.
//  Copyright (c) 2014 Manjusha. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "BRScannerDelegate.h"
@interface BRBarcodeScanViewController : UIViewController <AVCaptureMetadataOutputObjectsDelegate>

@property (strong) AVCaptureSession *bCaptureSession;

@property (strong) NSMutableString *bCode;

@property (nonatomic, weak) id<BRScannerDelegate> delegate;

@end
