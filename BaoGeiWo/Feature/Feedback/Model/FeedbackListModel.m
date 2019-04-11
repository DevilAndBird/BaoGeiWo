//
//  FeedbackListModel.m
//  BaoGeiWo
//
//  Created by wb on 2018/12/12.
//  Copyright © 2018 qyqs. All rights reserved.
//

#import "FeedbackListModel.h"

@implementation FeedbackListModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{@"name" : @"feedbackusername",
             @"mobile" : @"feedbackusermobile",
             @"time" : @"feedtimeformat",
             @"desc" : @"feedbackdesc",
             @"processName" : @"processname",
             @"processMobile" : @"processmobile",
             @"processTime" : @"processtimeformat",
             @"processDesc" : @"processdesc",
             @"processStatus" : @"processstatus",
             };
    
}

@end
