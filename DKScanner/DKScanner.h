//
//  DKScanner.h
//  DKScanner
//
//  Created by 庄槟豪 on 07/10/2017.
//  Copyright © 2017 cn.dankal. All rights reserved.
//

@import UIKit;

#import "DKScannerViewController.h"

@interface DKScanner : NSObject

/**
 以`modal`的方式弹出扫一扫控制器

 @param scanner 设置扫描控制器回调
 @param completion 扫描完成回调
 */
+ (void)modalScanner:(void(^)(DKScannerViewController *scannerVc))scanner completion:(void(^)(NSString *result))completion;

///**
// 以`push`的方式弹出扫一扫控制器，要求主窗口中存在导航栏控制器
//
// @param scanner 设置扫描控制器回调
// @param completion 扫描完成回调
// */
//+ (void)pushScanner:(void(^)(DKScannerViewController *scannerVc))scanner completion:(void(^)(NSString *result))completion;

@end
