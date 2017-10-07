//
//  DKScannerViewController.m
//  DKScanner
//
//  Created by 庄槟豪 on 2017/1/12.
//  Copyright © 2017年 cn.dankal. All rights reserved.
//

#import "DKScannerViewController.h"
#import "DKScannerCapture.h"
#import "UIViewController+DKScannerAlert.h"
#import <Masonry/Masonry.h>

#define KTipLabelMargin 32.0
#define KBorderViewMargin 40.0

@interface DKScannerViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (nonatomic, strong, readwrite) DKScannerBorderView *scannerBorderView;
@property (nonatomic, strong, readwrite) DKScannerMaskView *maskView;
@property (nonatomic, strong, readwrite) UILabel *tipsLabel;
@property (nonatomic, strong) DKScannerCapture *scannerCapture;
@property (nonatomic) CGRect scanTargetFrame;
@end

@implementation DKScannerViewController

- (CGRect)scanTargetFrame
{
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenH = [UIScreen mainScreen].bounds.size.height;
    CGFloat wh = screenW - KBorderViewMargin * 2;
    CGFloat x = screenW * 0.5 - wh * 0.5;
    CGFloat y = screenH * 0.5 - wh * 0.5;
    return CGRectMake(x, y, wh, wh);
}

- (DKScannerBorderView *)scannerBorderView
{
    if (!_scannerBorderView) {
        DKScannerBorderView *scannerBorderView = [[DKScannerBorderView alloc] init];
        scannerBorderView.tintColor = [UIColor whiteColor];
        _scannerBorderView = scannerBorderView;
    }
    return _scannerBorderView;
}

- (DKScannerMaskView *)maskView
{
    if (!_maskView) {
        _maskView = [DKScannerMaskView maskViewWithFrame:[UIScreen mainScreen].bounds cropRect:self.scanTargetFrame];
    }
    return _maskView;
}

- (UILabel *)tipsLabel
{
    if (!_tipsLabel) {
        UILabel *tipsLabel = [[UILabel alloc] init];
        tipsLabel.text = @"将二维码/条码放入框中，即可自动扫描";
        tipsLabel.font = [UIFont systemFontOfSize:13];
        tipsLabel.textColor = [UIColor whiteColor];
        tipsLabel.textAlignment = NSTextAlignmentCenter;
        [tipsLabel sizeToFit];
        _tipsLabel = tipsLabel;
    }
    return _tipsLabel;
}

#pragma mark - Life Cycle

- (instancetype)initWithCompletion:(DKScannerCompletion)completion
{
    if (self = [super init]) {
        self.completion = completion;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupUI];
    [self setupScanner];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self startScan];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self stopScan];
}

- (void)setupUI
{
    [self setupNavigationBar];
    [self setupScanerBorderView];
    [self setupMaskView];
    [self setupTipsLabel];
}

- (void)setupNavigationBar
{
    void(^setupNavigationBar)() = ^{
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        self.navigationController.navigationBar.translucent = YES;
        self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
        
        self.navigationItem.title = @"扫一扫";
        self.navigationItem.leftBarButtonItem = [self barButtonItemWithTitle:@"关闭" action:@selector(closeBtnClick)];
        self.navigationItem.rightBarButtonItem = [self barButtonItemWithTitle:@"相册" action:@selector(albumBtnClick)];
    };
    
    if (self.navigationController) {
        setupNavigationBar();
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.navigationController) {
                setupNavigationBar();
            }
        });
    }
}

- (void)setupScanerBorderView
{
    [self.view addSubview:self.scannerBorderView];
    
    [self.scannerBorderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.scanTargetFrame.size);
        make.center.equalTo(self.view);
    }];
}

- (void)setupMaskView
{
    [self.view insertSubview:self.maskView atIndex:0];
}

- (void)setupTipsLabel
{
    [self.view addSubview:self.tipsLabel];
    
    // Constraints
    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.scannerBorderView.mas_bottom).offset(KTipLabelMargin);
    }];
}

- (void)setupScanner
{
    self.scannerCapture = [DKScannerCapture scanerWithView:self.view scanFrame:self.scanTargetFrame completion:^(NSString *result, NSError *error) {
        if (self.completion) {
            self.completion(result, error);
        }
        [self closeBtnClick];
    }];
}

#pragma mark - Private Method

- (UIBarButtonItem *)barButtonItemWithTitle:(NSString *)title action:(SEL)selector
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn sizeToFit];
    [btn addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];

    return [[UIBarButtonItem alloc] initWithCustomView:btn];
}

#pragma mark - Events

- (void)startScan
{
    [self.scannerCapture startScan];
    [self.scannerBorderView startScannerAnimating];
}

- (void)stopScan
{
    [self.scannerCapture stopScan];
    [self.scannerBorderView stopScannerAnimating];
}

- (void)closeBtnClick
{
    if (self.navigationController.childViewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)albumBtnClick
{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        self.tipsLabel.text = @"无法访问相册";
        return;
    }

    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.view.backgroundColor = [UIColor whiteColor];
    picker.delegate = self;

    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark - <UIImagePickerControllerDelegate>

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];

    [DKScannerCapture scanWithImage:info[UIImagePickerControllerOriginalImage] completion:^(NSArray *values) {
        if (values.count) {
            [self dismissViewControllerAnimated:YES completion:^{
                self.completion(values.firstObject, nil);
            }];
        } else {
            NSString *errorStr = @"没有识别到二维码/条形码，请选择其他照片";
            self.tipsLabel.text = errorStr;
            [self.tipsLabel sizeToFit];
            self.tipsLabel.center = CGPointMake(self.scannerBorderView.center.x, CGRectGetMaxY(self.scannerBorderView.frame) + KTipLabelMargin);
            NSError *error = [NSError errorWithDomain:@"cn.dankal.scanner" code:0 userInfo:@{@"message":errorStr}];
            self.completion(nil, error);
        }
    }];
}

@end
