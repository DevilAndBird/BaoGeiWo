//
//  MessageModel.h
//  BaoGeiWo
//
//  Created by wb on 2018/5/25.
//  Copyright © 2018年 qyqs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageModel : NSObject

/*
 addtime = "2018-05-24 19:45:25.0";
 id = 832;
 isread = N;
 pushcontent = "";
 userid = 113;
 */
@property (nonatomic, copy) NSString *msgId;
@property (nonatomic, copy) NSString *msgTheme;
@property (nonatomic, copy) NSString *msgContent;
@property (nonatomic, copy) NSString *msgTime;
@property (nonatomic, copy) NSString *msgType;

@property (nonatomic, copy) NSString *isRead;


@end
