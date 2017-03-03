//
//  DKScannerViewController.m
//  DKScanner
//
//  Created by 庄槟豪 on 2017/1/12.
//  Copyright © 2017年 cn.dankal. All rights reserved.
//

#import "DKScannerViewController.h"
#import "DKScannerBorder.h"
#import "DKScannerMaskView.h"
#import "DKScanner.h"

#define kControlMargin 32.0

@interface DKScannerViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
/** 完成回调 */
@property (nonatomic, copy) DKScannerCompletionCallBack completionCallBack;
@end

@implementation DKScannerViewController
{
    DKScannerBorder *scannerBorder; // 扫描框
    DKScanner *scanner; // 扫描器
    UILabel *tipLabel;  // 提示标签
}

#pragma mark - Life Cycle

- (instancetype)initWithCompletion:(DKScannerCompletionCallBack)completion
{
    if (self = [super init]) {
        self.completionCallBack = completion;
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
    
    [scannerBorder startScannerAnimating];
    [scanner startScan];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [scannerBorder stopScannerAnimating];
    [scanner stopScan];
}

/** 创建扫描器 */
- (void)setupScanner
{
    __weak typeof(self) weakSelf = self;
    scanner = [DKScanner scanerWithView:self.view scanFrame:scannerBorder.frame completion:^(NSString *result, NSError *error) {
        // 完成回调
        weakSelf.completionCallBack(result, error);
        
        if (error) { // 有错误就提示
            if (weakSelf.isAutoShowErrorAlert) { // 判断是否自动弹出对话框
                NSString *appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
                if (!appName.length)
                    appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"];
                
                [weakSelf alertWithOKButtonWithTitle:@"拒绝访问" message:[NSString stringWithFormat:@"请在系统设置 - 隐私 - 相机 中，允许【%@】访问相机",appName]];
            }
        } else {
            // 关闭
            [weakSelf closeBtnClick];
        }
    }];
}

- (void)setupUI
{
    [self setupNavigationBar];
    [self setupScanerBorder];
    [self setupTipLabel];
}

/** 提示标签 */
- (void)setupTipLabel
{
    tipLabel = [[UILabel alloc] init];
    tipLabel.text = @"将二维码/条码放入框中，即可自动扫描";
    tipLabel.font = [UIFont systemFontOfSize:12];
    tipLabel.textColor = self.foregroundColor;
    tipLabel.textAlignment = NSTextAlignmentCenter;
    [tipLabel sizeToFit];
    tipLabel.center = CGPointMake(scannerBorder.center.x, CGRectGetMaxY(scannerBorder.frame) + kControlMargin);
    
    [self.view addSubview:tipLabel];
}

/** 扫描框 */
- (void)setupScanerBorder
{
    CGFloat width = self.view.bounds.size.width - 80;
    scannerBorder = [[DKScannerBorder alloc] initWithFrame:CGRectMake(0, 0, width, width)];
    scannerBorder.center = self.view.center;
    scannerBorder.tintColor = self.navigationController.navigationBar.tintColor;
    [self.view addSubview:scannerBorder];
    
    DKScannerMaskView *maskView = [DKScannerMaskView maskViewWithFrame:self.view.bounds cropRect:scannerBorder.frame];
    [self.view insertSubview:maskView atIndex:0];
}

/** 导航栏 */
- (void)setupNavigationBar
{
    // 背景颜色
    [self.navigationController.navigationBar setBarTintColor:self.navigationController.navigationBar.tintColor];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    
    // 标题
    self.navigationItem.title = self.titleString;
    
    // 关闭、相册
    self.navigationItem.leftBarButtonItem = [self barButtonItemWithTitle:@"关闭" action:@selector(closeBtnClick)];
    self.navigationItem.rightBarButtonItem = [self barButtonItemWithTitle:@"相册" action:@selector(albumBtnClick)];
}

#pragma mark - Private Method

- (UIBarButtonItem *)barButtonItemWithTitle:(NSString *)title action:(SEL)selector
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:self.foregroundColor forState:UIControlStateNormal];
    [btn sizeToFit];
    [btn addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    
    return [[UIBarButtonItem alloc] initWithCustomView:btn];
}

- (void)alertWithOKButtonWithTitle:(NSString *)title message:(NSString *)message
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    __weak typeof(self) weakSelf = self;
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf closeBtnClick];
    }];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - Events

- (void)closeBtnClick
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)albumBtnClick
{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        tipLabel.text = @"无法访问相册";
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
    
    // 扫描图像
    [DKScanner scanWithImage:info[UIImagePickerControllerOriginalImage] completion:^(NSArray *values) {
        if (values.count) {
            [self dismissViewControllerAnimated:YES completion:^{
                self.completionCallBack(values.firstObject, nil);
            }];
        } else {
            NSString *errorStr = @"没有识别到二维码/条形码，请选择其他照片";
            tipLabel.text = errorStr;
            [tipLabel sizeToFit];
            tipLabel.center = CGPointMake(scannerBorder.center.x, CGRectGetMaxY(scannerBorder.frame) + kControlMargin);
            NSError *error = [NSError errorWithDomain:@"cn.dankal.scanner" code:0 userInfo:@{@"message":errorStr}];
            self.completionCallBack(nil, error);
        }
    }];
}

@end
