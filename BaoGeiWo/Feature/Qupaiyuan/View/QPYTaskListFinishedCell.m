//
//  QPYTaskListFinishedCell.m
//  BaoGeiWo
//
//  Created by wb on 2018/5/14.
//  Copyright © 2018年 qyqs. All rights reserved.
//

#import "QPYTaskListFinishedCell.h"

@implementation QPYTaskListFinishedCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupFinishedUI];
    };
    return self;
}

- (void)setupFinishedUI {
    [self.bottomButtonView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@1);
    }];
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
