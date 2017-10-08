//
//  NSBundle+DKScanner.m
//  DKScanner
//
//  Created by 庄槟豪 on 08/10/2017.
//  Copyright © 2017 cn.dankal. All rights reserved.
//

#import "NSBundle+DKScanner.h"
#import "DKScanner.h"

@implementation NSBundle (DKScanner)

+ (instancetype)dk_scannerBundle
{
    static NSBundle *scannerBundle = nil;
    if (scannerBundle == nil) {
        scannerBundle = [NSBundle bundleWithPath:[[NSBundle bundleForClass:[DKScanner class]] pathForResource:@"DKScanner" ofType:@"bundle"]];
    }
    return scannerBundle;
}

+ (UIImage *)dk_imageWithName:(NSString *)name
{
    return [[UIImage imageWithContentsOfFile:[[self dk_scannerBundle] pathForResource:name ofType:@"png"]] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
}

+ (NSString *)dk_localizedStringForKey:(NSString *)key
{
    return [self dk_localizedStringForKey:key value:nil];
}

+ (NSString *)dk_localizedStringForKey:(NSString *)key value:(NSString *)value
{
    static NSBundle *bundle = nil;
    if (bundle == nil) {
        NSString *language = [NSLocale preferredLanguages].firstObject;
        if ([language hasPrefix:@"en"]) {
            language = @"en";
        } else if ([language hasPrefix:@"zh"]) {
            if ([language rangeOfString:@"Hans"].location != NSNotFound) {
                language = @"zh-Hans"; // 简体中文
//            } else { // zh-Hant\zh-HK\zh-TW
//                language = @"zh-Hant"; // 繁體中文
            }
        } else {
            language = @"en";
        }
        
        bundle = [NSBundle bundleWithPath:[[NSBundle dk_scannerBundle] pathForResource:language ofType:@"lproj"]];
    }
    value = [bundle localizedStringForKey:key value:value table:@"DKScanner"];
    return [[NSBundle mainBundle] localizedStringForKey:key value:value table:nil];
}

@end
