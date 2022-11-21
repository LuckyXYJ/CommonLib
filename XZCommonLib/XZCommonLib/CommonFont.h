//
//  CommonFont.h
//  XZCommonLib
//
//  Created by LuckyXYJ on 2023/3/12.
//

#ifndef CommonFont_h
#define CommonFont_h

//公共Font
#define Font(fontSize) [UIFont systemFontOfSize:fontSize]
#define BoldFont(fontSize) [UIFont boldSystemFontOfSize:fontSize]
#define DINFont(fontSize) [UIFont fontWithName:@"DIN" size:fontSize]

#define FontLevel1 Font(18.f)
#define FontLevel2 Font(15.f)
#define FontLevel3 Font(13.f)
#define FontLevel4 Font(12.f)
#define FontLevel5 Font(11.f)

#endif /* CommonFont_h */
