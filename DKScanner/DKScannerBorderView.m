//
//  DKScannerBorderView.m
//  DKScanner
//
//  Created by 庄槟豪 on 2017/1/12.
//  Copyright © 2017年 cn.dankal. All rights reserved.
//

#import "DKScannerBorderView.h"
#import "DKScannerConst.h"
#import <Masonry/Masonry.h>
#import "NSBundle+DKScanner.h"

@interface DKScannerBorderView ()
@property (nonatomic, strong) UIImageView *scanLineImgView;
@end

@implementation DKScannerBorderView

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
    
    [self setupScanLine];
    [self setupCorners];
}

- (void)setupScanLine
{
    UIImageView *scanLineImgView = [[UIImageView alloc] initWithImage:[NSBundle dk_imageWithName:@"DKScanLine"]];
    self.scanLineImgView = scanLineImgView;
    [self addSubview:scanLineImgView];
    
    // Constraints
    [self.scanLineImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.width.centerX.equalTo(self);
        make.height.equalTo(self.scanLineImgView);
    }];
}

- (void)setupCorners
{
    for (NSInteger i = 1; i <= 4; i++) {
        NSString *cornerImgName = [NSString stringWithFormat:@"DKScanQR%zd", i];
        UIImageView *cornerImgView = [[UIImageView alloc] initWithImage:[NSBundle dk_imageWithName:cornerImgName]];
        [self addSubview:cornerImgView];
        
        // Constraints
        [cornerImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(cornerImgView);
            switch (i) {
                case 1:
                    make.left.top.equalTo(self);
                    break;
                case 2:
                    make.right.top.equalTo(self);
                    break;
                case 3:
                    make.left.bottom.equalTo(self);
                    break;
                case 4:
                    make.right.bottom.equalTo(self);
                    break;
                default:
                    break;
            }
        }];
    }
}

#pragma mark - public Method

- (void)startScannerAnimating
{
    [self stopScannerAnimating];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:DKScannerAnimateDuration delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [UIView setAnimationRepeatCount:MAXFLOAT];
            CGRect frame = self.scanLineImgView.frame;
            frame.origin.y += self.bounds.size.height;
            self.scanLineImgView.frame = frame;
        } completion:nil];
    });
}

- (void)stopScannerAnimating
{
    [self.scanLineImgView.layer removeAllAnimations];
}

@end
