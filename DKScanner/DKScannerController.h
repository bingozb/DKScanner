//
//  DKScannerController.h
//  DKScanner
//
//  Created by 庄槟豪 on 2017/1/12.
//  Copyright © 2017年 cn.dankal. All rights reserved.
//

#import <UIKit/UIKit.h>

/*!
 扫描控制器
 
 作用：
 
 * 提供一个导航控制器，扫描 `二维码 / 条形码`
 * 能够生成指定 `字符串`
 * 能够识别相册图片中的二维码(iOS64位设备)
 
 使用：
 
 @code
 
 // 实例化一个扫描控制器
 DKScannerController *scannerVc = [DKScannerController scannerWithCompletion:^(NSString *stringValue) {
    NSLog(@"%@", stringValue);
 }];
 // 设置标题、标题颜色和主题色
 [scannerVc setTitle:@"扫描二维码" titleColor:[UIColor whiteColor] tintColor:[UIColor redColor]];
 // modal
 [self presentViewController:scannerVc animated:YES completion:nil];
 
 @endcode
 */
@interface DKScannerController : UINavigationController

/**
 实例化扫描导航控制器

 @param completion 完成回调
 @return 扫描导航控制器
 */
+ (instancetype)scannerWithCompletion:(void (^)(NSString *stringValue))completion;

/**
 设置导航栏标题颜色和主题色
 
 @param titleColor 标题颜色
 @param tintColor 主题色
 */
- (void)setTitleColor:(UIColor *)titleColor tintColor:(UIColor *)tintColor;

/**
 设置导航栏标题、标题颜色和主题色

 @param title 导航栏标题
 @param titleColor 标题颜色
 @param tintColor 主题色
 */
- (void)setTitle:(NSString *)title titleColor:(UIColor *)titleColor tintColor:(UIColor *)tintColor;

@end
