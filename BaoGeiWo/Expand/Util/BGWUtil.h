//
//  BGWUtil.h
//  BaoGeiWo
//
//  Created by wb on 2018/7/6.
//  Copyright © 2018年 qyqs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BGWUtil : NSObject

+ (void)cameraAuth:(void(^)(void))authorized fail:(void(^)(void))fail;

@end
