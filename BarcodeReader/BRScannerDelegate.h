//
//  BRScannerDelegate.h
//  BarcodeScanner
//
//  Created by Manjusha on 6/4/14.
//  Copyright (c) 2014 Manjusha. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BRBarcodeScanViewController;

@protocol BRScannerDelegate <NSObject>

-(void) barcodeScannerViewController: (BRBarcodeScanViewController *)controller didFinishScaningItem: (NSString*) barcodeText;

@end
