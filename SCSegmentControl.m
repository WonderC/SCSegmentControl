//
//  SCSegmentControl.m
//  SCSegment
//
//  Created by wonderC on 2017/3/8.
//  Copyright © 2017年 wonderC. All rights reserved.
//


#import "SCSegmentControl.h"

#define WIDTH self.frame.size.width
#define HEIGHT self.frame.size.height

@interface SCSegmentControl ()<CAAnimationDelegate>

@property (nonatomic,strong) CAShapeLayer *lineShapeLayer;
@property (nonatomic,strong) CAShapeLayer *BGLineShapeLayer;
@property (nonatomic,assign) NSInteger count;
@property (nonatomic,assign) NSInteger selectIndex;

@end

@implementation SCSegmentControl

- (instancetype)initWithFrame:(CGRect)frame titleArr:(NSArray *)titleArr {
    
    if (self = [super initWithFrame:frame]) {
    
        self.backgroundColor = [UIColor whiteColor];
        _count = titleArr.count;
        _selectIndex = 0;
        [self initElementWithTitleArr:titleArr];
    }
    return self;
}

- (void)initElementWithTitleArr:(NSArray *)titleArr {
    
    for (int i = 0; i < titleArr.count; i++) {
        UIButton *btn = [[UIButton alloc] init];
        btn.tag = 10000 + i;
        [btn setTitle:titleArr[i] forState:UIControlStateNormal];
        
        if (i == 0)[btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        else [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        
        btn.titleLabel.font = [UIFont systemFontOfSize:16];
        btn.frame = CGRectMake(((WIDTH - _count + 1) / _count + 1) * i, 0, (WIDTH - _count + 1) / _count, self.frame.size.height);
        [btn addTarget:self action:@selector(segmentClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }
    
    NSInteger sum = _count;
    while (sum > 0) {
        CAShapeLayer *layer  = [CAShapeLayer layer];
        layer.fillColor = layer.strokeColor = [UIColor lightGrayColor].CGColor;
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(WIDTH * sum / _count , 5)];
        [path addLineToPoint:CGPointMake(WIDTH * sum/ _count, self.frame.size.height - 5)];
        
        layer.path = path.CGPath;
        [self.layer addSublayer:layer];
        sum--;
    }
    
    [self.layer addSublayer:self.BGLineShapeLayer];
    [self.layer addSublayer:self.lineShapeLayer];
    [self setPathStartPosition];

    
}

- (void)segmentClick:(UIButton *)btn {
    
    NSInteger clickTag = btn.tag - 10000;
    
    if (clickTag == _selectIndex) {return;}
    
    for (UIButton *button in self.subviews) {
        if ([button isEqual:btn]) [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        else [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }
    
    [self animationWithIndex:(clickTag-_selectIndex)];
    
    _selectIndex = clickTag;
    
    if (_delegate && [_delegate respondsToSelector:@selector(segmentControlDidSelected:)]) {
        [_delegate segmentControlDidSelected:btn];
    }
}

#pragma mark - set start

- (void)setPathStartPosition{
    
    UIBezierPath *bgPath = [[UIBezierPath alloc] init];
    [bgPath moveToPoint:CGPointMake(0, HEIGHT)];
    [bgPath addLineToPoint:CGPointMake(WIDTH,HEIGHT)];
    self.BGLineShapeLayer.path = bgPath.CGPath;
    
    UIBezierPath *path = [[UIBezierPath alloc] init];
    [path moveToPoint:CGPointMake(0, HEIGHT)];
    [path addLineToPoint:CGPointMake(WIDTH/_count,HEIGHT)];
    self.lineShapeLayer.path = path.CGPath;
}

#pragma mark - annimation

- (void)animationWithIndex:(NSInteger)index{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position.x"];
    animation.fromValue = @(WIDTH/_count*(_selectIndex));
    animation.toValue = @(WIDTH/_count*(_selectIndex+index));
    animation.duration = .5f;
    animation.fillMode=kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    [_lineShapeLayer addAnimation:animation forKey:nil];
}

#pragma mark - lazy

- (CAShapeLayer *)lineShapeLayer{
    if (!_lineShapeLayer) {
        _lineShapeLayer = [CAShapeLayer layer];
        _lineShapeLayer.fillColor = [UIColor blueColor].CGColor;
        _lineShapeLayer.strokeColor = [UIColor blueColor].CGColor;
        _lineShapeLayer.lineWidth = 2.f;
    }
    return _lineShapeLayer;
}

- (CAShapeLayer *)BGLineShapeLayer{
    if (!_BGLineShapeLayer) {
        _BGLineShapeLayer = [CAShapeLayer layer];
        _BGLineShapeLayer.fillColor = [UIColor lightGrayColor].CGColor;
        _BGLineShapeLayer.strokeColor = [UIColor lightGrayColor].CGColor;
        _BGLineShapeLayer.lineWidth = 1.f;
    }
    return _BGLineShapeLayer;
}

@end
