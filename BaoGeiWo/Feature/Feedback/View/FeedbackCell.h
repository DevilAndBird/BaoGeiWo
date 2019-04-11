//
//  FeedbackCell.h
//  BaoGeiWo
//
//  Created by wb on 2018/12/10.
//  Copyright © 2018 qyqs. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FeedbackListModel;
NS_ASSUME_NONNULL_BEGIN

@interface FeedbackCell : UITableViewCell

- (void)setContentWithModel:(FeedbackListModel *)model;

@end


@interface FeedbackProcessCell : UITableViewCell

- (void)setContentWithProcessedModel:(FeedbackListModel *)model;

@end


NS_ASSUME_NONNULL_END
