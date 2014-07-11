//
//  BRViewController.h
//  BarcodeScanner
//
//  Created by Manjusha on 6/4/14.
//  Copyright (c) 2014 Manjusha. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BRScannerDelegate.h"

@interface BRViewController : UIViewController <BRScannerDelegate>

@property (strong, nonatomic) NSString *barCode;

@end
