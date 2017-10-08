//
//  UIViewController+DKScannerAlert.m
//  DKScanner
//
//  Created by 庄槟豪 on 06/10/2017.
//  Copyright © 2017 cn.dankal. All rights reserved.
//

#import "UIViewController+DKScannerAlert.h"
#import "NSBundle+DKScanner.h"
#import "DKScannerConst.h"

@implementation UIViewController (DKScannerAlert)

- (void)dk_alertWithTitle:(NSString *)title message:(NSString *)message completion:(void (^)())completion
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:[NSBundle dk_localizedStringForKey:DKScannerOKText] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (completion) {
            completion();
        }
    }];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
