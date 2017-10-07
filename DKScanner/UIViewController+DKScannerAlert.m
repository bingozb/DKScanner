//
//  UIViewController+DKScannerAlert.m
//  DKScannerExample
//
//  Created by Bingo💤 on 06/10/2017.
//  Copyright © 2017 cn.dankal. All rights reserved.
//

#import "UIViewController+DKScannerAlert.h"

@implementation UIViewController (DKScannerAlert)

- (void)dk_alertWithTitle:(NSString *)title message:(NSString *)message completion:(void (^)())completion
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (completion) {
            completion();
        }
    }];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
