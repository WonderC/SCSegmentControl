//
//  SCSegmentControl.h
//  SCSegment
//
//  Created by wonderC on 2017/3/8.
//  Copyright © 2017年 wonderC. All rights reserved.
//


#import <UIKit/UIKit.h>

@class SCSegmentControl;

@protocol SCSegmentControlDelegate <NSObject>

@required
- (void)segmentControlDidSelected:(UIButton *)btn;

@end

@interface SCSegmentControl : UIView

@property (nonatomic, weak) id<SCSegmentControlDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame titleArr:(NSArray *)titleArr;

@end
