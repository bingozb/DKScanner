//
//  DKScannerNavigationController.m
//  DKScanner
//
//  Created by 庄槟豪 on 08/10/2017.
//  Copyright © 2017 cn.dankal. All rights reserved.
//

#import "DKScannerNavigationController.h"

@implementation DKScannerNavigationController

- (BOOL)shouldAutorotate
{
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

@end
