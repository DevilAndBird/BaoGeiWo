//
//  NSArray+Safe.m
//  BaoGeiWo
//
//  Created by wb on 2018/6/6.
//  Copyright © 2018年 qyqs. All rights reserved.
//

#import "NSArray+Safe.h"

@implementation NSArray (Safe)

+ (void)load {
    Method objectAtIndex = class_getInstanceMethod(NSClassFromString(@"__NSArrayI"), @selector(objectAtIndex:));
    Method wq_objectAtIndex = class_getInstanceMethod(NSClassFromString(@"__NSArrayI"), @selector(wq_objectAtIndex:));
    method_exchangeImplementations(objectAtIndex, wq_objectAtIndex);
}

- (id)wq_objectAtIndex:(NSUInteger)index {
    if (index >= [self count]) {
        return nil;
    }
    return [self wq_objectAtIndex:index];
}

@end


@implementation NSMutableArray (Safe)

+ (void)load {
    Method addMethod = class_getInstanceMethod(NSClassFromString(@"__NSArrayM"), @selector(addObject:));
    Method wq_addMethod = class_getInstanceMethod(NSClassFromString(@"__NSArrayM"), @selector(wq_addObject:));
    method_exchangeImplementations(addMethod, wq_addMethod);
    
    Method objectAtIndex = class_getInstanceMethod(NSClassFromString(@"__NSArrayM"), @selector(objectAtIndex:));
    Method wq_objectAtIndex = class_getInstanceMethod(NSClassFromString(@"__NSArrayM"), @selector(wq_objectAtIndex:));
    method_exchangeImplementations(objectAtIndex, wq_objectAtIndex);
    
}

- (void)wq_addObject:(id)anObject {
    if (!anObject) {
        return;
    }
    [self wq_addObject:anObject];
}


- (id)wq_objectAtIndex:(NSUInteger)index {
    if (index >= [self count]) {
        return nil;
    }
    return [self wq_objectAtIndex:index];
}


@end



