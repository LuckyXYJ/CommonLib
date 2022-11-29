//
//  BaseColor.h
//  XZCommonLib
//
//  Created by LuckyXYJ on 2023/3/12.
//

#ifndef BaseColor_h
#define BaseColor_h
/*
 * 公共color
 */
#define Color(r, g, b) [UIColor colorWithRed:r / 255.0 green:g / 255.0 blue:b / 255.0 alpha:1]
#define ColorWithAlpha(r, g, b, a) [UIColor colorWithRed:r / 255.0 green:g / 255.0 blue:b / 255.0 alpha:a]
#define ColorHex(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) / 255.0 green:((float)((rgbValue & 0xFF00) >> 8)) / 255.0 blue:((float)(rgbValue & 0xFF)) / 255.0 alpha:1]

#define RGBToColor(R,G,B)  [UIColor colorWithRed:(R * 1.0) / 255.0 green:(G * 1.0) / 255.0 blue:(B * 1.0) / 255.0 alpha:1.0]
#define rgba(R,G,B,A)  [UIColor colorWithRed:(R * 1.0) / 255.0 green:(G * 1.0) / 255.0 blue:(B * 1.0) / 255.0 alpha:A]

#endif /* BaseColor_h */
