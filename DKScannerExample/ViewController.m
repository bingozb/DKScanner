//
//  ViewController.m
//  DKScannerExample
//
//  Created by 庄槟豪 on 2017/1/12.
//  Copyright © 2017年 cn.dankal. All rights reserved.
//

#import "ViewController.h"
#import "DKScanner.h"
#import "UIViewController+DKScannerAlert.h"

@implementation ViewController

- (IBAction)scan:(UIButton *)sender
{
    [DKScanner modalScanner:^(DKScannerViewController *scannerVc) {
        scannerVc.scannerBorderView.tintColor = [UIColor greenColor];
    } completion:^(NSString *result) {
        NSLog(@"%@", result);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self dk_alertWithTitle:@"DKScanner" message:result completion:nil];
        });
    }];
}

@end
