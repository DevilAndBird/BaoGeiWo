//
//  UIView+WQChangeResponseRange.m
//  WQProject
//
//  Created by wb on 2018/8/9.
//  Copyright © 2018年 qyqs. All rights reserved.
//

#import "UIView+WQChangeResponseRange.h"


@implementation UIView (WQChangeResponseRange)

static char *changeRangeKey;
static char *recommendRangeKey;

- (void)setChangeRange:(NSString *)changeRange {
    objc_setAssociatedObject(self, &changeRangeKey, changeRange, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)changeRange {
    return objc_getAssociatedObject(self, &changeRangeKey);
}

- (void)changeResponseRange:(UIEdgeInsets)changeInsets {
    self.changeRange = NSStringFromUIEdgeInsets(changeInsets);
}


- (void)setLeastRecommendRange:(NSNumber *)recommedRange {
    objc_setAssociatedObject(self, &recommendRangeKey, recommedRange, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSNumber *)leastRecommendRange {
    return objc_getAssociatedObject(self, &recommendRangeKey);
}

- (void)setupLeastRecommendRange:(BOOL)yesOrNo {
    self.leastRecommendRange = @(yesOrNo);
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    
    if (self.leastRecommendRange && self.leastRecommendRange.boolValue) {
        CGRect myBounds = self.bounds;
        CGFloat widthDiff = MAX(44.0 - myBounds.size.width, 0);
        CGFloat heightDiff = MAX(44.0 - myBounds.size.height, 0);
        myBounds = CGRectInset(myBounds, -0.5 * widthDiff, -0.5 * heightDiff);
        return CGRectContainsPoint(myBounds, point);
        
    } else {
        UIEdgeInsets changeInsets = UIEdgeInsetsFromString(self.changeRange);
        if (changeInsets.top != 0 || changeInsets.left != 0 || changeInsets.bottom != 0 || changeInsets.right != 0) {
            CGRect myBounds = self.bounds;
            myBounds.origin.x += changeInsets.left;
            myBounds.origin.y += changeInsets.top;
            myBounds.size.width = myBounds.size.width - changeInsets.left - changeInsets.right;
            myBounds.size.height = myBounds.size.height - changeInsets.top - changeInsets.bottom;
            return CGRectContainsPoint(myBounds, point);
        } else {
            return CGRectContainsPoint(self.bounds, point);
        }
    }
    
}


@end
