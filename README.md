# DKScanner
A QRCode Scanner for iOS.
<br>一个“扫一扫”扫描器，支持二维码和条码。
****

## 安装

- 通过cocoapods安装

```objc

pod 'DKScanner'

```

- 或者直接clone，将`DKScanner`文件夹整个拖到你的项目中

## 使用

**引用头文件**

```objc

#import "DKScannerController.h" 

```

**调用**

```objc

DKScannerController *scannerVc = [DKScannerController scannerWithCompletion:^(NSString *result) {
        NSLog(@"扫描结果: %@", result);
}];
// 设置导航栏标题、标题颜色和主题色
[scannerVc setTitle:@"扫描二维码" titleColor:[UIColor whiteColor] tintColor:[UIColor redColor]];
// modal
[self presentViewController:scannerVc animated:YES completion:nil];

```

**如果不允许 APP 访问相机，反馈无权限信息**

调用 scannerWithAutoShowErrorAlert:completion: ，autoShowErrorAlert 赋值 为 YES 时会自动弹出对话框。
```objc
DKScannerController *scannerVc = [DKScannerController scannerWithAutoShowErrorAlert:YES completion:^(NSString *result, NSError *error) {
        NSLog(@"扫描结果: %@", result);
        // ...
    }];
[self presentViewController:scannerVc animated:YES completion:nil];
```

如果对默认弹出的内容或样式不满意，可以将 autoShowErrorAlert 赋值为NO，然后在回调中判断 error 是否为空，error 有值则为无权限，然后就可以做相应的处理。

```objc
DKScannerController *scannerVc = [DKScannerController scannerWithAutoShowErrorAlert:NO completion:^(NSString *result, NSError *error) {
        NSLog(@"扫描结果: %@", result);
        if (error) {
            NSLog(@"拒绝访问，请到系统设置 - 隐私 - 相机 中，允许APP【XXX】访问相机");
            // showError ...
        }
    }];
[self presentViewController:scannerVc animated:YES completion:nil];
```

## 注意

在iOS10上，使用摄像头和访问相册都需要添加请求访问权限描述，否则会Crash。

* 在info.plist文件中添加

  ```objc
  <key>NSCameraUsageDescription</key>
  <string>是否允许访问摄像头</string>
  <key>NSPhotoLibraryUsageDescription</key>
  <string>是否允许访问相册</string>
  ```
