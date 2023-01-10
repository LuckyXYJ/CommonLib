//
//  NTTakeQRCodeViewController.m
//  NodeTransfer
//
//  Created by xyj on 2020/8/20.
//  Copyright © 2020 NodeTransfer. All rights reserved.
//

#import "NTTakeQRCodeViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface NTTakeQRCodeViewController ()<AVCaptureMetadataOutputObjectsDelegate,UIAlertViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property(nonatomic,strong)AVCaptureDevice *device;//创建相机
@property(nonatomic,strong)AVCaptureDeviceInput *input;//创建输入设备
@property(nonatomic,strong)AVCaptureMetadataOutput *output;//创建输出设备
@property(nonatomic,strong)AVCaptureSession *session;//创建捕捉类
@property(strong,nonatomic)AVCaptureVideoPreviewLayer *preview;//视觉输出预览层

@end

@implementation NTTakeQRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setCustomNavigationBarHidden:YES];
    
    [self configView];
    [self capture];
    
}

- (void)dealloc
{
    self.device = nil;
    [self.session stopRunning];
    self.session = nil;
    self.input = nil;
    self.output = nil;
    self.preview = nil;
}

- (void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 初始化UI
- (void)configView
{

    //扫描区域
    CGRect scanFrame = CGRectMake((ScreenWidth - 225)/2, 180, 225, 225);
    
    [self setCropRect:scanFrame];
    
    UILabel *textLabel = createLabelWithText(@"扫一扫", 18, [UIColor whiteColor]);
    textLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:textLabel];
    textLabel.frame = CGRectMake(60, StatusBarHeight, ScreenWidth - 120, 44);
    
    UIButton *backAction = [[UIButton alloc] init];
    [backAction setImage:[UIImage imageNamed:@"popWhiteIcon"] forState:UIControlStateNormal];
    [backAction addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [backAction setEnlargeEdgeWithTop:10 right:0 bottom:10 left:10];
    [self.view addSubview:backAction];
    backAction.frame = CGRectMake(5, StatusBarHeight + 7, 30, 30);
    
    //提示文字
    UILabel *label = [UILabel new];
    label.text = @"将二维码置于框内进行扫描";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = ColorHex(0xCDCDCD);
    label.frame = CGRectMake(0, CGRectGetMaxY(scanFrame)+15, ScreenWidth, 20);
    [self.view addSubview:label];
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"打开相册" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn setTitleColor:ColorHex(0xF4F4F4) forState:UIControlStateNormal];
    btn.frame = CGRectMake(ScreenWidth/2 - 50, ScreenHeight - BottomCornerHeight - 100, 100, 50);
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)setCropRect:(CGRect)cropRect{
    CAShapeLayer *cropLayer = [[CAShapeLayer alloc] init];
    CGMutablePathRef path = CGPathCreateMutable();
//    CGPathAddRect(path, nil, cropRect);
    CGPathAddRoundedRect(path, nil, cropRect, 15, 15);
    CGPathAddRect(path, nil, self.view.bounds);
    
    [cropLayer setFillRule:kCAFillRuleEvenOdd];
    [cropLayer setPath:path];
    [cropLayer setFillColor:[UIColor blackColor].CGColor];
    [cropLayer setOpacity:0.6];
    [cropLayer setNeedsDisplay];
    
    [self.view.layer addSublayer:cropLayer];
}

- (void)btnClick:(UIButton *)sender
{

    UIImagePickerController *imagrPicker = [[UIImagePickerController alloc]init];
    imagrPicker.delegate = self;
    imagrPicker.allowsEditing = YES;
    //将来源设置为相册
    imagrPicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    
    [self presentViewController:imagrPicker animated:YES completion:nil];

}

#pragma mark - 从相册选择识别二维码
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    //获取选中的照片
    UIImage *image = info[UIImagePickerControllerEditedImage];
    
    if (!image) {
        image = info[UIImagePickerControllerOriginalImage];
    }
    //初始化  将类型设置为二维码
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:nil];
    
    [picker dismissViewControllerAnimated:YES completion:^{
        //设置数组，放置识别完之后的数据
        NSArray *features = [detector featuresInImage:[CIImage imageWithData:UIImagePNGRepresentation(image)]];
        //判断是否有数据（即是否是二维码）
        if (features.count >= 1) {
            //取第一个元素就是二维码所存放的文本信息
            CIQRCodeFeature *feature = features[0];
            NSString *scannedResult = feature.messageString;
            
            [self toGOSPayView:scannedResult];

        }else{
            [GOSToast makeToast:@"扫描失败，请重试"];
        }
    }];
    
}

#pragma mark - 初始化扫描设备
- (void)capture
{
    //如果是模拟器返回（模拟器获取不到摄像头）
    if (TARGET_IPHONE_SIMULATOR) {
        return;
    }
    
    // 下面的是比较重要的,也是最容易出现崩溃的原因,就是我们的输出流的类型
    // 1.这里可以设置多种输出类型,这里必须要保证session层包括输出流
    // 2.必须要当前项目访问相机权限必须通过,所以最好在程序进入当前页面的时候进行一次权限访问的判断
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if(authStatus ==AVAuthorizationStatusRestricted|| authStatus ==AVAuthorizationStatusDenied){
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请在iPhone的“设置”-“隐私”-“相机”功能中，打开相机访问权限" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    //初始化基础"引擎"Device
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //初始化输入流 Input,并添加Device
    self.input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    //初始化输出流Output
    self.output = [[AVCaptureMetadataOutput alloc] init];
    
    //设置输出流的相关属性
    // 确定输出流的代理和所在的线程,这里代理遵循的就是上面我们在准备工作中提到的第一个代理,至于线程的选择,建议选在主线程,这样方便当前页面对数据的捕获.
    [self.output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    //设置扫描区域的大小 rectOfInterest  默认值是CGRectMake(0, 0, 1, 1) 按比例设置
//    self.output.rectOfInterest = CGRectMake((ScreenWidth - 225)/2, 180, 225, 225);
    self.output.rectOfInterest = CGRectMake(180/ScreenHeight,((ScreenWidth-225)/2)/ScreenWidth,225/ScreenHeight,225/ScreenWidth);
    /*
     // AVCaptureSession 预设适用于高分辨率照片质量的输出
     AVF_EXPORT NSString *const AVCaptureSessionPresetPhoto NS_AVAILABLE(10_7, 4_0) __TVOS_PROHIBITED;
     // AVCaptureSession 预设适用于高分辨率照片质量的输出
     AVF_EXPORT NSString *const AVCaptureSessionPresetHigh NS_AVAILABLE(10_7, 4_0) __TVOS_PROHIBITED;
     // AVCaptureSession 预设适用于中等质量的输出。 实现的输出适合于在无线网络共享的视频和音频比特率。
     AVF_EXPORT NSString *const AVCaptureSessionPresetMedium NS_AVAILABLE(10_7, 4_0) __TVOS_PROHIBITED;
     // AVCaptureSession 预设适用于低质量的输出。为了实现的输出视频和音频比特率适合共享 3G。
     AVF_EXPORT NSString *const AVCaptureSessionPresetLow NS_AVAILABLE(10_7, 4_0) __TVOS_PROHIBITED;
     */
    
    // 初始化session
    self.session = [[AVCaptureSession alloc]init];
    // 设置session类型,AVCaptureSessionPresetHigh 是 sessionPreset 的默认值。
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    
    //将输入流和输出流添加到session中
    // 添加输入流
    if ([_session canAddInput:self.input]) {
        [_session addInput:self.input];
    }
    // 添加输出流
    if ([_session canAddOutput:self.output]) {
        [_session addOutput:self.output];
        
        //扫描格式
        NSMutableArray *metadataObjectTypes = [NSMutableArray array];
        [metadataObjectTypes addObjectsFromArray:@[
                                                   AVMetadataObjectTypeQRCode,
                                                   AVMetadataObjectTypeEAN13Code,
                                                   AVMetadataObjectTypeEAN8Code,
                                                   AVMetadataObjectTypeCode128Code,
                                                   AVMetadataObjectTypeCode39Code,
                                                   AVMetadataObjectTypeCode93Code,
                                                   AVMetadataObjectTypeCode39Mod43Code,
                                                   AVMetadataObjectTypePDF417Code,
                                                   AVMetadataObjectTypeAztecCode,
                                                   AVMetadataObjectTypeUPCECode,
                                                   ]];
        
        // >= ios 8
        if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_7_1) {
            [metadataObjectTypes addObjectsFromArray:@[AVMetadataObjectTypeInterleaved2of5Code,
                                                       AVMetadataObjectTypeITF14Code,
                                                       AVMetadataObjectTypeDataMatrixCode]];
        }
        //设置扫描格式
        self.output.metadataObjectTypes= metadataObjectTypes;
    }
    
    
    //设置输出展示平台AVCaptureVideoPreviewLayer
    // 初始化
    self.preview =[AVCaptureVideoPreviewLayer layerWithSession:_session];
    // 设置Video Gravity,顾名思义就是视频播放时的拉伸方式,默认是AVLayerVideoGravityResizeAspect
    // AVLayerVideoGravityResizeAspect 保持视频的宽高比并使播放内容自动适应播放窗口的大小。
    // AVLayerVideoGravityResizeAspectFill 和前者类似，但它是以播放内容填充而不是适应播放窗口的大小。最后一个值会拉伸播放内容以适应播放窗口.
    // 因为考虑到全屏显示以及设备自适应,这里我们采用fill填充
    self.preview.videoGravity =AVLayerVideoGravityResizeAspectFill;
    // 设置展示平台的frame
    self.preview.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    // 因为 AVCaptureVideoPreviewLayer是继承CALayer,所以添加到当前view的layer层
    [self.view.layer insertSublayer:self.preview atIndex:0];
    
    //开始
    [self.session startRunning];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.session stopRunning];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.session startRunning];
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate
#pragma mark - 扫描结果处理
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    
    // 判断扫描结果的数据是否存在
    if ([metadataObjects count] >0){
        // 如果存在数据,停止扫描
        [self.session stopRunning];

        // AVMetadataMachineReadableCodeObject是AVMetadataObject的具体子类定义的特性检测一维或二维条形码。
        // AVMetadataMachineReadableCodeObject代表一个单一的照片中发现机器可读的代码。这是一个不可变对象描述条码的特性和载荷。
        // 在支持的平台上,AVCaptureMetadataOutput输出检测机器可读的代码对象的数组
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        // 获取扫描到的信息
        NSString *stringValue = metadataObject.stringValue;
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"扫描结果"
//                                                        message:stringValue
//                                                       delegate:self
//                                              cancelButtonTitle:nil
//                                              otherButtonTitles:@"确定", nil];
//        [self.view addSubview:alert];
//        [alert show];
        
        [self toGOSPayView:stringValue];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)toGOSPayView:(NSString *)payUrl {
    
    [GOSWebManager openUrl:payUrl];
//    // 获取当前控制器数组
//    NSMutableArray *vcArray = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
//    // 获取当前控制器在数组的位置
//    int index = (int)[vcArray indexOfObject:self];
//    // 移除当前控制器器
//    [vcArray removeObjectAtIndex:index];
//    self.navigationController.viewControllers = vcArray;
//    [self removeController:self];
}

- (void)removeController:(id)target {
    
    NSMutableArray *vcArray = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    // 获取当前控制器在数组的位置
    int index = (int)[vcArray indexOfObject:target];
    // 移除当前控制器器
    [vcArray removeObjectAtIndex:index];
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.35 * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//        [self.shotStack removeObjectAtIndex:index];
        self.navigationController.viewControllers = vcArray;
    });
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
