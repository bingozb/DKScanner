//
//  NSBundle+DKScanner.h
//  DKScanner
//
//  Created by 庄槟豪 on 08/10/2017.
//  Copyright © 2017 cn.dankal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSBundle (DKScanner)

+ (instancetype)dk_scannerBundle;

+ (UIImage *)dk_imageWithName:(NSString *)name;

+ (NSString *)dk_localizedStringForKey:(NSString *)key;

@end
