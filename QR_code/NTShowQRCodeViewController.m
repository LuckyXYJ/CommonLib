//
//  NTShowQRCodeViewController.m
//  NodeTransfer
//
//  Created by xyj on 2020/8/20.
//  Copyright © 2020 NodeTransfer. All rights reserved.
//

#import "NTShowQRCodeViewController.h"

#import <Photos/Photos.h>

@interface NTShowQRCodeViewController ()

@property(nonatomic, strong)UILabel *salerNameLabel;

@property(nonatomic, strong)UIImageView *qrImageView;

@end

@implementation NTShowQRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setCustomNavigationBarHidden:YES];
    
    [self configViews];
}

- (void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Initialize
- (void)configViews {
    
    // gradient
    CAGradientLayer *gl = [CAGradientLayer layer];
    gl.frame = CGRectMake(0,0,ScreenWidth,ScreenHeight);
    gl.startPoint = CGPointMake(0.02, 0);
    gl.endPoint = CGPointMake(1, 1);
    gl.colors = @[(__bridge id)[UIColor colorWithRed:212/255.0 green:176/255.0 blue:112/255.0 alpha:1.0].CGColor, (__bridge id)[UIColor colorWithRed:190/255.0 green:145/255.0 blue:57/255.0 alpha:1.0].CGColor];
    gl.locations = @[@(0), @(1.0f)];
    [self.view.layer addSublayer:gl];
    
    UILabel *textLabel = createLabelWithText(@"国金收款码", 18, [UIColor whiteColor]);
    textLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:textLabel];
    textLabel.frame = CGRectMake(60, StatusBarHeight, ScreenWidth - 120, 44);
    
    UIButton *backAction = [[UIButton alloc] init];
    [backAction setImage:[UIImage imageNamed:@"popWhiteIcon"] forState:UIControlStateNormal];
    [backAction addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [backAction setEnlargeEdgeWithTop:10 right:0 bottom:10 left:10];
    [self.view addSubview:backAction];
    backAction.frame = CGRectMake(5, StatusBarHeight + 7, 30, 30);
    
    CGFloat cacle = (ScreenWidth - 30)/345.f;
    
    UIImageView *topView = [[UIImageView alloc]initWithFrame:CGRectMake(15, HeaderHeight + 25, ScreenWidth - 30, 403*cacle)];
    topView.image = [UIImage imageNamed:@"pay_qrcode_background"];
    topView.userInteractionEnabled = YES;
    [self.view addSubview:topView];
    
    _salerNameLabel = createLabelWithText(_salerName, 18, ColorHex(0x333333));
    _salerNameLabel.textAlignment = NSTextAlignmentCenter;
    [topView addSubview:_salerNameLabel];
    _salerNameLabel.frame = CGRectMake(0, 27*cacle, ScreenWidth - 30, 25*cacle);
    
    _qrImageView =  [[UIImageView alloc]initWithFrame:CGRectMake((ScreenWidth - 30 - 172*cacle)/2.f, 156*cacle, 172*cacle, 172*cacle)];
    _qrImageView.image = [self adjustQRImageSize:[self createQRCodeWithUrlString:_unique_code_url] QRSize:172*cacle];
    //[[UIView alloc]initWithFrame:CGRectMake(15, HeaderHeight + 25, ScreenWidth - 30, 403)];
    [topView addSubview:_qrImageView];


    UILabel *takeQrLeb = createLabelWithText(@"扫一扫即刻支付", 12, ColorHex(0x666666));
    takeQrLeb.textAlignment = NSTextAlignmentCenter;
    [topView addSubview:takeQrLeb];
    takeQrLeb.frame = CGRectMake(0, 120*cacle, ScreenWidth - 30, 16);


    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"保存收款码" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn setTitleColor:ColorHex(0xCFA145) forState:UIControlStateNormal];
    btn.frame = CGRectMake(0, 340*cacle, ScreenWidth - 30, 30);
    [btn addTarget:self action:@selector(saveAction) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:btn];
    
    
    UIView *botView = [[UIView alloc]initWithFrame:CGRectMake(15, topView.bottom + 10, ScreenWidth - 30, 50)];
    botView.backgroundColor = [UIColor whiteColor];
    botView.layer.masksToBounds = YES;
    botView.layer.cornerRadius = 10;
    [self.view addSubview:botView];
    
    UIImageView *leftIcon = [[UIImageView alloc]initWithFrame:CGRectMake(12.5, 15, 20, 20)];
    leftIcon.image = [UIImage imageNamed:@"pay_qrcode_shop"];
    [botView addSubview:leftIcon];
    
    UILabel *titleLeb = createLabelWithText(@"商家服务", 15, ColorHex(0x333333));
    [botView addSubview:titleLeb];
    titleLeb.frame = CGRectMake(40, 0, 80, 50);
    
    UILabel *setLeb = createLabelWithText(@"GNA比例设置  >", 14, ColorHex(0x999999));
    setLeb.textAlignment = NSTextAlignmentRight;
    [botView addSubview:setLeb];
    setLeb.frame = CGRectMake(ScreenWidth - 30 - 125, 0, 115, 50);
    
    UIButton *managerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    managerBtn.frame = CGRectMake(ScreenWidth - 30 - 125, 0, 115, 50);
    [managerBtn addTarget:self action:@selector(managerAction) forControlEvents:UIControlEventTouchUpInside];
    [botView addSubview:managerBtn];
}


- (void)saveAction {
    MJWeakSelf
    [self requestUsePhotoLibrary:^(BOOL isCanUse) {
        if (isCanUse) {
            [weakSelf takeScreenShot];
        }
    }];
}

- (void)managerAction {
    [GOSToast makeToast:@"敬请期待"];
}

- (void)takeScreenShot {
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    CAGradientLayer *gl = [CAGradientLayer layer];
    gl.frame = CGRectMake(0,0,ScreenWidth,ScreenHeight);
    gl.startPoint = CGPointMake(0.02, 0);
    gl.endPoint = CGPointMake(1, 1);
    gl.colors = @[(__bridge id)[UIColor colorWithRed:212/255.0 green:176/255.0 blue:112/255.0 alpha:1.0].CGColor, (__bridge id)[UIColor colorWithRed:190/255.0 green:145/255.0 blue:57/255.0 alpha:1.0].CGColor];
    gl.locations = @[@(0), @(1.0f)];
    [bgView.layer addSublayer:gl];
    
    CGFloat cacle = (ScreenWidth - 30)/345.f;
    
    UIImageView *topView = [[UIImageView alloc]initWithFrame:CGRectMake(15, HeaderHeight + 34, ScreenWidth - 30, 515*cacle)];
    topView.image = [UIImage imageNamed:@"pay_qrcode_background1"];
    //[[UIView alloc]initWithFrame:CGRectMake(15, HeaderHeight + 25, ScreenWidth - 30, 403)];
    [bgView addSubview:topView];
    
    UIImageView *iconView = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth/2.f - 45, HeaderHeight + 34 -45, 90, 90)];
    iconView.image = [UIImage imageNamed:@"pay_qrcode_guojin"];
    //[[UIView alloc]initWithFrame:CGRectMake(15, HeaderHeight + 25, ScreenWidth - 30, 403)];
    [bgView addSubview:iconView];
    
    UILabel *topLabel = createLabelWithText(@"国金收款码", 18, ColorHex(0xA37F3E));
    topLabel.textAlignment = NSTextAlignmentCenter;
    [topView addSubview:topLabel];
    topLabel.frame = CGRectMake(0, 57*cacle, ScreenWidth - 30, 25*cacle);
    
    UILabel *gosLabel = createLabelWithText(@"GosPay", 18, ColorHex(0xA37F3E));
    gosLabel.textAlignment = NSTextAlignmentCenter;
    [topView addSubview:gosLabel];
    gosLabel.frame = CGRectMake(0, 82*cacle, ScreenWidth - 30, 25*cacle);
    
    UILabel *salerNameLabel  = createLabelWithText(_salerName, 18, ColorHex(0x333333));
    salerNameLabel.textAlignment = NSTextAlignmentCenter;
    [topView addSubview:salerNameLabel];
    salerNameLabel.frame = CGRectMake(0, 151*cacle, ScreenWidth - 30, 25*cacle);
    
    UIImageView *qrImageView =  [[UIImageView alloc]initWithFrame:CGRectMake((ScreenWidth - 30 - 172*cacle)/2.f, 201*cacle, 172*cacle, 172*cacle)];
    qrImageView.image = [self adjustQRImageSize:[self createQRCodeWithUrlString:_unique_code_url] QRSize:172*cacle];
    //[[UIView alloc]initWithFrame:CGRectMake(15, HeaderHeight + 25, ScreenWidth - 30, 403)];
    [topView addSubview:qrImageView];
    
    
    UILabel *userNameLabel  = createLabelWithText(kNTUserModel.user_name, 13, ColorHex(0x666666));
    userNameLabel.textAlignment = NSTextAlignmentCenter;
    [topView addSubview:userNameLabel];
    userNameLabel.frame = CGRectMake(0, 388*cacle, ScreenWidth - 30, 19*cacle);
    
    
    UILabel *bot1Label  = createLabelWithText(@"国金收款码", 12, ColorHex(0x666666));
    bot1Label.textAlignment = NSTextAlignmentCenter;
    [topView addSubview:bot1Label];
    bot1Label.frame = CGRectMake(0, 447*cacle, ScreenWidth - 30, 17*cacle);
    
    UILabel *bot2Label  = createLabelWithText(@"打开APP [扫一扫]", 12, ColorHex(0xA37F3E));
    bot2Label.textAlignment = NSTextAlignmentCenter;
    [topView addSubview:bot2Label];
    bot2Label.frame = CGRectMake(0, 469*cacle, ScreenWidth - 30, 17*cacle);
    
    UIImage *screenShot = [self getImageFromView:bgView];
    
    [[PHPhotoLibrary sharedPhotoLibrary]performChanges:^{
        [PHAssetChangeRequest creationRequestForAssetFromImage:screenShot];
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!error) {
                [GOSToast makeToast:@"图片保存成功"];
            } else {
                [GOSToast makeToast:@"保存图片失败，请稍后重试" duration:2];
            }
        });
    }];
}

- (UIImage *)getImageFromView:(UIView *)orgView{

    CGSize s = orgView.bounds.size;

    UIGraphicsBeginImageContextWithOptions(s, NO, [UIScreen mainScreen].scale);

    [orgView.layer renderInContext:UIGraphicsGetCurrentContext()];

    UIImage*image = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    return image;

}

#pragma mark - Private Method
// 请求相机权限
- (void)requestUsePhotoLibrary:(void(^)(BOOL isCanUse))CompletionHandler
{
    __block NSString *tipTextWhenNoPhotosAuthorization; // 提示语
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    TLog(@"Photostatus:%zd", status);
    if (status == PHAuthorizationStatusRestricted || status == PHAuthorizationStatusDenied) {
        NSDictionary *mainInfoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSString *appName = [mainInfoDictionary objectForKey:@"CFBundleDisplayName"];
        tipTextWhenNoPhotosAuthorization = [NSString stringWithFormat:@"请在\"设置-隐私-照片\"选项中，允许\"%@\"访问您的手机相册", appName];
        
        ShowAlert(@"温馨提示", tipTextWhenNoPhotosAuthorization, @[@"取消", @"去设置"], ^(NSUInteger index) {
            if (index == 1) {
                [self openSystemSetting];
            }
        });
    } else if(status == AVAuthorizationStatusNotDetermined) {
        //第一次请求。
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            
            if (status == PHAuthorizationStatusAuthorized) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (CompletionHandler) {
                        CompletionHandler(YES);
                    }
                });
            } else {
                if (CompletionHandler) {
                    CompletionHandler(NO);
                }
            }
        }];
    } else {
        if (CompletionHandler) {
            CompletionHandler(YES);
        }
    }

}

- (void)openSystemSetting {
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]]) {
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }
}

#pragma mark 二维码生成
- (CIImage*)createQRCodeWithUrlString:(NSString*)url
{
    // 实例化二维码滤镜
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 恢复滤镜默认属性，因为滤镜有可能保存了上一次的属性
    [filter setDefaults];
    // 将字符串转换成NSData
    NSData *data = [url dataUsingEncoding:NSUTF8StringEncoding];
    // 设置滤镜,传入Data，
    [filter setValue:data forKey:@"inputMessage"];
    // 生成二维码
    CIImage *qrCode = [filter outputImage];
    return qrCode;
}

- (UIImage*)adjustQRImageSize:(CIImage*)ciImage QRSize:(CGFloat)qrSize {
    // 获取CIImage图片的的Frame
    CGRect ciImageRect = CGRectIntegral(ciImage.extent);
    CGFloat scale = MIN(qrSize / CGRectGetWidth(ciImageRect), qrSize / CGRectGetHeight(ciImageRect));
    
    // 创建bitmap
    size_t width = CGRectGetWidth(ciImageRect) * scale;
    size_t height = CGRectGetHeight(ciImageRect) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:@{kCIContextUseSoftwareRenderer : @(YES)}];
    CGImageRef bitmapImage = [context createCGImage:ciImage fromRect:ciImageRect];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, ciImageRect, bitmapImage);
    
    // 保存Bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    
    return [UIImage imageWithCGImage:scaledImage];
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
