//
//  FeedbackView.h
//  BaoGeiWo
//
//  Created by wb on 2018/12/10.
//  Copyright © 2018 qyqs. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FeedbackView : UIView

- (instancetype)initWithTextViewEndEditing:(void(^)(UITextView *textView))endEditing submitPressed:(void(^)(void))submitPressed;

@end

NS_ASSUME_NONNULL_END
