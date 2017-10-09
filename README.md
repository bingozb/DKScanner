# DKScanner

A QRCode Scanner for iOS.
一个“扫一扫”扫描器，支持二维码和条码。

## 安装

通过 CocoaPods 安装

```objc
pod 'DKScanner'
```

## 使用

以 present (modal) 的方式，弹出扫描控制器：

```objc
[DKScanner modalScanner:^(DKScannerViewController *scannerVc) {
    // setup scannerViewController
    scannerVc.scannerBorderView.tintColor = [UIColor greenColor];
} completion:^(NSString *result) {
    // handle scan result
    NSLog(@"%@", result);
}];
```

## 注意

在 iOS 10上，使用摄像头和访问相册都需要添加请求访问权限描述，否则会 Crash。

请在 info.plist 文件中添加

```objc
<key>NSCameraUsageDescription</key>
<string>是否允许访问摄像头</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>是否允许访问相册</string>
```


