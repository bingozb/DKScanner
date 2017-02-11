//
//  ViewController.m
//  DKScannerExample
//
//  Created by 庄槟豪 on 2017/1/12.
//  Copyright © 2017年 cn.dankal. All rights reserved.
//

#import "ViewController.h"
#import "DKScannerController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (IBAction)scan:(UIButton *)sender
{
    DKScannerController *scannerVc = [DKScannerController scannerWithAutoShowErrorAlert:YES completion:^(NSString *result, NSError *error) {
        NSLog(@"扫描结果: %@", result);
        [sender setTitle:result forState:UIControlStateNormal];
    }];
    [scannerVc setTitle:@"扫描二维码" titleColor:[UIColor whiteColor] tintColor:[UIColor redColor]];
    [self presentViewController:scannerVc animated:YES completion:nil];
}

@end
