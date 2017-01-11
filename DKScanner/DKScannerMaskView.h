//
//  DKScannerMaskView.h
//  DKScanner
//
//  Created by 庄槟豪 on 2017/1/12.
//  Copyright © 2017年 cn.dankal. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 扫描遮罩视图
 */
@interface DKScannerMaskView : UIView

/**
 使用裁切区域实例化遮罩视图

 @param frame 视图区域
 @param cropRect 裁切区域
 @return 遮罩视图
 */
+ (instancetype)maskViewWithFrame:(CGRect)frame cropRect:(CGRect)cropRect;

/**
 裁切区域
 */
@property (nonatomic, assign) CGRect cropRect;

@end
