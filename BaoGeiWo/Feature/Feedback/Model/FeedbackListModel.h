//
//  FeedbackListModel.h
//  BaoGeiWo
//
//  Created by wb on 2018/12/12.
//  Copyright © 2018 qyqs. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FeedbackListModel : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *desc;

@property (nonatomic, copy) NSString *processStatus;
@property (nonatomic, copy) NSString *processName;
@property (nonatomic, copy) NSString *processMobile;
@property (nonatomic, copy) NSString *processTime;
@property (nonatomic, copy) NSString *processDesc;


@end

NS_ASSUME_NONNULL_END
