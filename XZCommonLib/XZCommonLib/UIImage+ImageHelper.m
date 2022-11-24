//
//  UIImage+ImageHelper.m
//  XZCommonLib
//
//  Created by LuckyXYJ on 2023/3/12.
//

#import "UIImage+ImageHelper.h"
#import "Dimens.h"

@implementation UIImage (ImageHelper)

+ (UIImage *)imageSizeWithScreenImage:(UIImage *)image {
    CGFloat imageWidth = image.size.width;
    CGFloat imageHeight = image.size.height;
    
    if (imageWidth <= ScreenWidth && imageHeight <= ScreenHeight) {
        return image;
    }
    
    CGFloat max = MAX(imageWidth, imageHeight);
    CGFloat scale = max / (ScreenHeight * 2.0);
    
    CGSize size = CGSizeMake(imageWidth / scale, imageHeight / scale);
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

+ (UIImage *)imageWithBgColor:(UIColor *)color {
    
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

+ (NSData *)zipNSDataWithImage:(UIImage *)sourceImage {
    //进行图像尺寸的压缩
    CGSize imageSize = sourceImage.size;//取出要压缩的image尺寸
    CGFloat width = imageSize.width;    //图片宽度
    CGFloat height = imageSize.height;  //图片高度
//    //1.宽高大于1280(宽高比不按照2来算，按照1来算)
//    if (width>200||height>200) {
//        if (width>height) {
//            CGFloat scale = height/width;
//            width = 200;
//            height = width*scale;
//        }else{
//            CGFloat scale = width/height;
//            height = 200;
//            width = height*scale;
//        }
//    //2.宽大于1280高小于1280
//    }else if(width>200||height<200){
//        CGFloat scale = height/width;
//        width = 200;
//        height = width*scale;
//    //3.宽小于1280高大于1280
//    }else if(width<200||height>200){
//        CGFloat scale = width/height;
//        height = 200;
//        width = height*scale;
//    //4.宽高都小于1280
//    }else{
//    }
    
    CGFloat scale = width/height;
    height = 150;
    width = height*scale;
    
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    [sourceImage drawInRect:CGRectMake(0,0,width,height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //进行图像的画面质量压缩
    NSData *data=UIImageJPEGRepresentation(newImage, 1.0);
    if (data.length>100*1024) {
        if (data.length>1024*1024) {//1M以及以上
            data=UIImageJPEGRepresentation(newImage, 0.7);
        }else if (data.length>512*1024) {//0.5M-1M
            data=UIImageJPEGRepresentation(newImage, 0.8);
        }else if (data.length>200*1024) {
            //0.25M-0.5M
            data=UIImageJPEGRepresentation(newImage, 0.9);
        }
    }
    return data;
}

@end
