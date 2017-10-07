//
//  DKScanner.m
//  DKScanner
//
//  Created by 庄槟豪 on 2017/1/12.
//  Copyright © 2017年 cn.dankal. All rights reserved.
//

@import AVFoundation;
#import "DKScannerCapture.h"

#define kMaxDetectedCount 10

@interface DKScannerCapture() <AVCaptureMetadataOutputObjectsDelegate>
{
    NSInteger currentDetectedCount;
}
@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;
@property (nonatomic, strong) CALayer *drawLayer;
@property (nonatomic, weak) UIView *parentView;
@property (nonatomic, copy) DKScannerBlock completionCallBack;
@property (nonatomic) CGRect scanFrame;
@end

@implementation DKScannerCapture

#pragma mark - Scan Method

+ (instancetype)scanerWithView:(UIView *)view scanFrame:(CGRect)scanFrame completion:(DKScannerBlock)completion
{
    DKScannerCapture *scannerCapture = [[self alloc] init];
    scannerCapture.parentView = view;
    scannerCapture.scanFrame = scanFrame;
    scannerCapture.completionCallBack = completion;
    
    [scannerCapture setupSession];
    [scannerCapture setupLayers];
    
    return scannerCapture;
}

+ (void)scanWithImage:(UIImage *)image completion:(void (^)(NSArray *))completion
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{CIDetectorAccuracy: CIDetectorAccuracyHigh}];
        CIImage *ciImage = [[CIImage alloc] initWithImage:image];
        NSArray *features = [detector featuresInImage:ciImage];
        
        NSMutableArray *arrayM = [NSMutableArray arrayWithCapacity:features.count];
        for (CIQRCodeFeature *feature in features) {
            [arrayM addObject:feature.messageString];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(arrayM.copy);
        });
    });
}

- (void)setupSession
{
    self.session = [[AVCaptureSession alloc] init];
    
    NSError *error;
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput *videoInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    AVCaptureMetadataOutput *dataOutput = [[AVCaptureMetadataOutput alloc] init];
    
    if (!([self.session canAddInput:videoInput] && [self.session canAddOutput:dataOutput]) || error) {
        if (self.completionCallBack) {
            self.completionCallBack(nil, error);
        }
        self.session = nil;
        return;
    }
    
    [self.session addInput:videoInput];
    [self.session addOutput:dataOutput];
    
    dataOutput.metadataObjectTypes = dataOutput.availableMetadataObjectTypes;
    [dataOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
}

- (void)setupLayers
{
    self.drawLayer = [CALayer layer];
    self.drawLayer.frame = self.parentView.bounds;
    [self.parentView.layer insertSublayer:self.drawLayer atIndex:0];

    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    self.previewLayer.frame = self.parentView.bounds;
    [self.parentView.layer insertSublayer:self.previewLayer atIndex:0];
}

#pragma mark - Public Method

- (void)startScan
{
    if ([self.session isRunning]) return;
    
    currentDetectedCount = 0;
    [self.session startRunning];
}

- (void)stopScan
{
    if (![self.session isRunning]) return;
  
    [self.session stopRunning];
}

#pragma mark - Private Method

- (void)clearDrawLayer
{
    if (self.drawLayer.sublayers.count == 0) return;
    
    [self.drawLayer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
}

- (void)drawCornersShape:(AVMetadataMachineReadableCodeObject *)dataObject
{
    if (!dataObject.corners.count) return;
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.lineWidth = 2.5f;
    layer.strokeColor = [UIColor whiteColor].CGColor;
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.path = [self cornersPath:dataObject.corners];
    
    [self.drawLayer addSublayer:layer];
}

- (CGPathRef)cornersPath:(NSArray *)corners
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGPoint point = CGPointZero;
    NSInteger index = 0;
    CGPointMakeWithDictionaryRepresentation((CFDictionaryRef)corners[index++], &point);
    [path moveToPoint:point];
    while (index < corners.count) {
        CGPointMakeWithDictionaryRepresentation((CFDictionaryRef)corners[index++], &point);
        [path addLineToPoint:point];
    }
    [path closePath];
    
    return path.CGPath;
}

#pragma mark - <AVCaptureMetadataOutputObjectsDelegate>

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    [self clearDrawLayer];
    
    for (id obj in metadataObjects) {
        if (![obj isKindOfClass:[AVMetadataMachineReadableCodeObject class]]) return;

        AVMetadataMachineReadableCodeObject *dataObject = (AVMetadataMachineReadableCodeObject *)[self.previewLayer transformedMetadataObjectForMetadataObject:obj];
        if (!CGRectContainsRect(self.scanFrame, dataObject.bounds)) continue;
        
        if (currentDetectedCount++ < kMaxDetectedCount) {
            [self drawCornersShape:dataObject];
        } else {
            [self stopScan];

            if (self.completionCallBack) {
                self.completionCallBack(dataObject.stringValue, nil);
            }
        }
    }
}

@end
