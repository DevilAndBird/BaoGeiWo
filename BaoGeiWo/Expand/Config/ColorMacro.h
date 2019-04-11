//
//  ColorMacro.h
//  BaoGeiWo
//
//  Created by wb on 2018/5/2.
//  Copyright © 2018年 qyqs. All rights reserved.
//

#ifndef ColorMacro_h
#define ColorMacro_h


// 取色值相关的方法
#define RGB(r,g,b)          [UIColor colorWithRed:(r)/255.f \
                                            green:(g)/255.f \
                                            blue:(b)/255.f \
                                            alpha:1.f]

#define RGBA(r,g,b,a)       [UIColor colorWithRed:(r)/255.f \
                                            green:(g)/255.f \
                                            blue:(b)/255.f \
                                            alpha:(a)]

#define RGBOF(rgbValue)     [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
                                            green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
                                            blue:((float)(rgbValue & 0xFF))/255.0 \
                                            alpha:1.0]

#define RGBA_OF(rgbValue)   [UIColor colorWithRed:((float)(((rgbValue) & 0xFF000000) >> 24))/255.0 \
                                            green:((float)(((rgbValue) & 0x00FF0000) >> 16))/255.0 \
                                            blue:((float)(rgbValue & 0x0000FF00) >> 8)/255.0 \
                                            alpha:((float)(rgbValue & 0x000000FF))/255.0]

#define RGBAOF(v, a)        [UIColor colorWithRed:((float)(((v) & 0xFF0000) >> 16))/255.0 \
                                            green:((float)(((v) & 0x00FF00) >> 8))/255.0 \
                                            blue:((float)(v & 0x0000FF))/255.0 \
                                            alpha:a]


// 定义通用颜色
#define kBlackColor         [UIColor blackColor]
#define kDarkGrayColor      [UIColor darkGrayColor]
#define kLightGrayColor     [UIColor lightGrayColor]
#define kWhiteColor         [UIColor whiteColor]
#define kGrayColor          [UIColor grayColor]
#define kRedColor           [UIColor redColor]
#define kGreenColor         [UIColor greenColor]
#define kBlueColor          [UIColor blueColor]
#define kCyanColor          [UIColor cyanColor]
#define kYellowColor        [UIColor yellowColor]
#define kMagentaColor       [UIColor magentaColor]
#define kOrangeColor        [UIColor orangeColor]
#define kPurpleColor        [UIColor purpleColor]
#define kClearColor         [UIColor clearColor]


//#define kMGrayColor             RGB(153, 153, 153)
//#define kMBlackColor            RGB(51, 51, 51)
//#define kMBgColor               RGB(243, 243, 243)
//#define kMGreenColor            RGB(85, 163, 42)
//#define kMBgGreenColor          RGB(97, 186, 49)
//#define kMTextGreenColor        RGB(85, 163, 42)

#define kMThemeColor         RGB(251, 196, 0) //fbc400
#define kMBgColor            RGB(240, 240, 247)
#define kMBlackColor         RGB(51, 51, 51)
#define kMGrayColor          RGB(102, 102, 102)
#define kMPromptColor        RGB(153, 153, 153)
#define kMSeparateColor      RGB(230, 230, 230)
#define kMWarningColor      RGB(253, 3, 3) //fd0303


#define kRandomColor [UIColor colorWithRed:(arc4random_uniform(255))/255.0 green:(arc4random_uniform(255))/255.0 blue:(arc4random_uniform(255))/255.0 alpha:(arc4random_uniform(255))/255.0]


#endif /* ColorMacro_h */
