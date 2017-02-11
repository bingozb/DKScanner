//
//  DKScannerController.m
//  DKScanner
//
//  Created by 庄槟豪 on 2017/1/12.
//  Copyright © 2017年 cn.dankal. All rights reserved.
//

#import "DKScannerController.h"
#import "DKScannerViewController.h"
#import "DKScanner.h"

@interface DKScannerController ()
@property (nonatomic, strong) DKScannerViewController *scannerVc;
@end

@implementation DKScannerController

+ (instancetype)scannerWithCompletion:(void (^)(NSString *, NSError *))completion
{
    NSAssert(completion, @"必须传入完成回调");
    
    return [[self alloc] initWithAutoShowErrorAlert:NO completion:completion];
}

+ (instancetype)scannerWithAutoShowErrorAlert:(BOOL)autoShowErrorAlert completion:(void (^)(NSString *, NSError *))completion
{
    NSAssert(completion, @"必须传入完成回调");
    
    return [[self alloc] initWithAutoShowErrorAlert:autoShowErrorAlert completion:completion];
}

- (instancetype)initWithAutoShowErrorAlert:(BOOL)autoShowErrorAlert completion:(void (^)(NSString *, NSError *))completion
{
    if (self = [super init]) {
        DKScannerViewController *scannerVc = [[DKScannerViewController alloc] initWithCompletion:completion];
        scannerVc.autoShowErrorAlert = autoShowErrorAlert;
        self.scannerVc = scannerVc;
        [self setTitle:@"扫一扫" titleColor:[UIColor whiteColor] tintColor:[UIColor redColor]]; // 默认设置
        [self pushViewController:scannerVc animated:NO];
    }
    return self;
}

- (void)setTitleColor:(UIColor *)titleColor tintColor:(UIColor *)tintColor
{
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: titleColor}];
    self.scannerVc.foregroundColor = titleColor;
    self.navigationBar.tintColor = tintColor;
}

- (void)setTitle:(NSString *)title titleColor:(UIColor *)titleColor tintColor:(UIColor *)tintColor
{
    [self setTitleColor:titleColor tintColor:tintColor];
    self.scannerVc.titleString = title;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait; // 强制竖屏
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
