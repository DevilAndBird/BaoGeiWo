//
//  DeviceMacro.h
//  BaoGeiWo
//
//  Created by wb on 2018/5/2.
//  Copyright © 2018年 qyqs. All rights reserved.
//

#ifndef DeviceMacro_h
#define DeviceMacro_h


// scale
#define DEVICE_SCALE WIDTH/375

#define DEVICE_WIDTH [UIScreen mainScreen].bounds.size.width

#define DEVICE_HEIGHT [UIScreen mainScreen].bounds.size.height


#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_MAX_LENGTH (MAX(DEVICE_WIDTH, DEVICE_HEIGHT))
#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH <= 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)
#define IS_IPHONE_X (IS_IPHONE && SCREEN_MAX_LENGTH == 812.0)


#define KStatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height
#define KNavBarHeight (44+KStatusBarHeight)
#define KTabbarBarHeight (IS_IPHONE_X?83:49)
#define KBottomSafeAreaHeight (IS_IPHONE_X?34:0)



#endif /* DeviceMacro_h */
