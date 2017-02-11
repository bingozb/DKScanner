//
//  DKScannerViewController.h
//  DKScanner
//
//  Created by 庄槟豪 on 2017/1/12.
//  Copyright © 2017年 cn.dankal. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^DKScannerCompletionCallBack)(NSString *result, NSError *error);

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
 错误时是否自动弹出对话框
 */
@property (nonatomic, assign, getter=isAutoShowErrorAlert) BOOL autoShowErrorAlert;

/**
 实例化扫描控制器

 @param completion 完成回调
 @return 扫描控制器
 */
- (instancetype)initWithCompletion:(DKScannerCompletionCallBack)completion;

@end
