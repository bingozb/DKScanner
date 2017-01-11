//
//  DKScannerViewController.h
//  DKScanner
//
//  Created by 庄槟豪 on 2017/1/12.
//  Copyright © 2017年 cn.dankal. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 扫描控制器
 */
@interface DKScannerViewController : UIViewController

/**
 前景色 (字体颜色)
 */
@property (nonatomic, strong) UIColor *foregroundColor;

/**
 标题文本
 */
@property (nonatomic, copy) NSString *titleString;

/**
 实例化扫描控制器

 @param completion 完成回调
 @return 扫描控制器
 */
- (instancetype)initWithCompletion:(void (^)(NSString *stringValue))completion;

@end
