//
//  UIViewController+DKScannerAlert.h
//  DKScanner
//
//  Created by 庄槟豪 on 06/10/2017.
//  Copyright © 2017 cn.dankal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (DKScannerAlert)

- (void)dk_alertWithTitle:(NSString *)title message:(NSString *)message completion:(void(^)())completion;

@end
