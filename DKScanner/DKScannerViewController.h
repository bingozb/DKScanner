//
//  DKScannerViewController.h
//  DKScanner
//
//  Created by 庄槟豪 on 2017/1/12.
//  Copyright © 2017年 cn.dankal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DKScannerBorderView.h"
#import "DKScannerMaskView.h"

typedef void (^DKScannerCompletion)(NSString *result, NSError *error);

@interface DKScannerViewController : UIViewController

/** 扫描框 */
@property (nonatomic, strong, readonly) DKScannerBorderView *scannerBorderView;
/** 背景遮罩层 */
@property (nonatomic, strong, readonly) DKScannerMaskView *maskView;
/** 提示文本栏 */
@property (nonatomic, strong, readonly) UILabel *tipsLabel;

/** 扫描完成回调 */
@property (nonatomic, copy) DKScannerCompletion completion;

/**
 实例化扫描控制器

 @param completion 完成回调
 @return 扫描控制器
 */
- (instancetype)initWithCompletion:(DKScannerCompletion)completion;

@end
