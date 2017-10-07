//
//  DKScannerCapture.h
//  DKScanner
//
//  Created by 庄槟豪 on 2017/1/12.
//  Copyright © 2017年 cn.dankal. All rights reserved.
//

@import UIKit;

typedef void(^DKScannerBlock)(NSString *result, NSError *error);

/**
 二维码/条码扫描器
 */
@interface DKScannerCapture : NSObject

/**
 使用视图实例化扫描器，扫描预览窗口会添加到指定视图中

 @param view 指定的视图
 @param scanFrame 扫描范围
 @param completion 完成回调
 @return 扫描器
 */
+ (instancetype)scanerWithView:(UIView *)view scanFrame:(CGRect)scanFrame completion:(DKScannerBlock)completion;

/**
 扫描图像

 @param image 包含二维码的图像
 @param completion 完成回调
 @remark 目前只支持64位的iOS设备
 */
+ (void)scanWithImage:(UIImage *)image completion:(void (^)(NSArray *values))completion;

/**
 开始扫描
 */
- (void)startScan;

/**
 停止扫描
 */
- (void)stopScan;

@end
