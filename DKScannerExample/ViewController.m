//
//  ViewController.m
//  DKScannerExample
//
//  Created by 庄槟豪 on 2017/1/12.
//  Copyright © 2017年 cn.dankal. All rights reserved.
//

#import "ViewController.h"
#import "DKScanner.h"

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (IBAction)scan:(UIButton *)sender
{
    [self modalTest];
    
//    [self pushTest];
}

- (void)modalTest
{
    [DKScanner modalScanner:^(DKScannerViewController *scannerVc) {
        scannerVc.scannerBorderView.tintColor = [UIColor greenColor];
    } completion:^(NSString *result) {
        NSLog(@"%@", result);
    }];
}

- (void)pushTest
{
    [DKScanner pushScanner:^(DKScannerViewController *scannerVc) {
        scannerVc.scannerBorderView.tintColor = [UIColor redColor];
    } completion:^(NSString *result) {
        NSLog(@"%@", result);
    }];
}

@end
