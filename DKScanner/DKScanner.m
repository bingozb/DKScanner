//
//  DKScanner.m
//  DKScannerExample
//
//  Created by Bingo💤 on 07/10/2017.
//  Copyright © 2017 cn.dankal. All rights reserved.
//

#import "DKScanner.h"

@implementation DKScanner

+ (void)modalScanner:(void (^)(DKScannerViewController *))scanner completion:(void (^)(NSString *))completion
{
    DKScannerViewController *scannerVc = [[DKScannerViewController alloc] initWithCompletion:^(NSString *result, NSError *error) {
        if (completion) {
            completion(result);
        }
    }];
    [scannerVc view];
    if (scanner) {
        dispatch_async(dispatch_get_main_queue(), ^{
            scanner(scannerVc);
        });
    }
    UINavigationController *navC = [[UINavigationController alloc] initWithRootViewController:scannerVc];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:navC animated:YES completion:nil];
}

+ (void)pushScanner:(void (^)(DKScannerViewController *))scanner completion:(void (^)(NSString *))completion
{
    DKScannerViewController *scannerVc = [[DKScannerViewController alloc] initWithCompletion:^(NSString *result, NSError *error) {
        if (completion) {
            completion(result);
        }
    }];
    if (scanner) {
        dispatch_async(dispatch_get_main_queue(), ^{
            scanner(scannerVc);
        });
    }
    
    id rootVc = [UIApplication sharedApplication].keyWindow.rootViewController;
    if ([rootVc isKindOfClass:[UITabBarController class]]) {
        id selectedViewController = ((UITabBarController *)rootVc).selectedViewController;
        if ([selectedViewController isKindOfClass:[UINavigationController class]]) {
            [(UINavigationController *)selectedViewController pushViewController:scannerVc animated:YES];
        }
    } else if ([rootVc isKindOfClass:[UINavigationController class]]) {
        [(UINavigationController *)rootVc pushViewController:scannerVc animated:YES];
    } else {
        @throw [NSException exceptionWithName:@"DKScanner" reason:@"There is no navigationController in keyWindow, please use `modalScanner:completion:` instead." userInfo:nil];
    }
}

@end
