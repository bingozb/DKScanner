//
//  DKScannerBorder.m
//  DKScanner
//
//  Created by 庄槟豪 on 2017/1/12.
//  Copyright © 2017年 cn.dankal. All rights reserved.
//

#import "DKScannerBorder.h"

@implementation DKScannerBorder
{
    UIImageView *scannerLine; // 扫描线
}

#pragma mark - Life Cycle

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    self.clipsToBounds = YES;
    
    NSBundle *scannerBundle = [NSBundle bundleWithURL:[[NSBundle bundleForClass:[self class]] URLForResource:@"DKScanner" withExtension:@"bundle"]];
    
    scannerLine = [[UIImageView alloc] initWithImage:[self imageWithName:@"DKScanLine" bundle:scannerBundle]];
    scannerLine.frame = CGRectMake(0, 0, self.bounds.size.width, scannerLine.bounds.size.height);
    scannerLine.center = CGPointMake(self.bounds.size.width * 0.5, 0);
    [self addSubview:scannerLine];
    
    // 加载边框图像 四个角
    for (NSInteger i = 1; i <= 4; i++) {
        NSString *imgName = [NSString stringWithFormat:@"DKScanQR%zd", i];
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[self imageWithName:imgName bundle:scannerBundle]];
        [self addSubview:imgView];
        
        CGFloat offsetX = self.bounds.size.width - imgView.bounds.size.width;
        CGFloat offsetY = self.bounds.size.height - imgView.bounds.size.height;
        switch (i) {
            case 2:
                imgView.frame = CGRectOffset(imgView.frame, offsetX, 0);
                break;
            case 3:
                imgView.frame = CGRectOffset(imgView.frame, 0, offsetY);
                break;
            case 4:
                imgView.frame = CGRectOffset(imgView.frame, offsetX, offsetY);
                break;
            default:
                break;
        }
    }
}

- (UIImage *)imageWithName:(NSString *)imageName bundle:(NSBundle *)scannerBundle
{
    NSString *fileName = [NSString stringWithFormat:@"%@@2x", imageName];
    NSString *path = [scannerBundle pathForResource:fileName ofType:@"png"];
    
    return [[UIImage imageWithContentsOfFile:path] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
}

#pragma mark - public Method

/**
 开始扫描动画
 */
- (void)startScannerAnimating
{
    [self stopScannerAnimating];
    
    [UIView animateWithDuration:3.0 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [UIView setAnimationRepeatCount:MAXFLOAT];
        scannerLine.center = CGPointMake(self.bounds.size.width * 0.5, self.bounds.size.height);
    } completion:nil];
}

/**
 停止扫描动画
 */
- (void)stopScannerAnimating
{
    [scannerLine.layer removeAllAnimations];

    scannerLine.center = CGPointMake(self.bounds.size.width * 0.5, 0);
}

@end
