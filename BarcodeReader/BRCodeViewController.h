//
//  BRCodeViewController.h
//  BarcodeReader
//
//  Created by Manjusha on 3/20/14.
//  Copyright (c) 2014 Thapovan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "BRBarcodeScannerDelegate.h"

@interface BRCodeViewController : UIViewController <AVCaptureMetadataOutputObjectsDelegate>

@property (strong) AVCaptureSession *mCaptureSession;

@property (strong) NSMutableString *mCode;

@property (nonatomic, weak) id<BRBarcodeScannerDelegate> delegate;

@end
