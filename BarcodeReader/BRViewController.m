//
//  BRViewController.m
//  BarcodeScanner
//
//  Created by Manjusha on 6/4/14.
//  Copyright (c) 2014 Manjusha. All rights reserved.
//

#import "BRViewController.h"
#import "BRBarcodeScanViewController.h"

@interface BRViewController ()
@property (weak, nonatomic) IBOutlet UILabel *barCodeLabel;

@end

@implementation BRViewController
@synthesize barCode, barCodeLabel;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor blackColor];
    
    
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"scanBarcodeSegue"]) {
        // 1
        UINavigationController *navigationController = segue.destinationViewController;
        // 2
        BRBarcodeScanViewController *controller = (BRBarcodeScanViewController *)
        navigationController.topViewController;
        controller.delegate = self;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


-(void)barcodeScannerViewController:(BRBarcodeScanViewController *)controller didFinishScaningItem:(NSString *)barcodeText{
    UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:@"" message:@"Could not read barcode. No Video input available" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    
    if ([barcodeText isEqualToString:@"no video input"] ) {
        
        [self dismissViewControllerAnimated:NO completion:^{[errorAlert show];}];
        
    }
    
    else {
        barCodeLabel.text = barcodeText;
        
        NSLog(@"barcodeText in delegate %@", barcodeText);
        
        [self dismissViewControllerAnimated:NO completion:nil];
        
    }
}
@end
