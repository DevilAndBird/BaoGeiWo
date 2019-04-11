//
//  NSDictionary+Safe.m
//  BaoGeiWo
//
//  Created by wb on 2018/6/6.
//  Copyright © 2018年 qyqs. All rights reserved.
//

#import "NSDictionary+Safe.h"

@implementation NSDictionary (Safe)

+ (void)load {
    
}



@end





@implementation NSMutableDictionary (Safe)

+ (void)load {
    Method setObj = class_getInstanceMethod(NSClassFromString(@"__NSDictionaryM"), @selector(setObject:forKey:));
    Method wq_setObj = class_getInstanceMethod(NSClassFromString(@"__NSDictionaryM"), @selector(wq_setObject:forKey:));
    method_exchangeImplementations(setObj, wq_setObj);
}

- (void)wq_setObject:(id)anObject forKey:(id <NSCopying>)aKey
{
    if (!anObject) {
        return;
    }
    if (!aKey) {
        return;
    }
    [self wq_setObject:anObject forKey:aKey];
}

@end



