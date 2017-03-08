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
        [btn addTarget:self action:@selector(segmentClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }
    
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

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    CGFloat w = (self.frame.size.width - _count + 1) / _count;
    CGFloat h = self.frame.size.height;
    CGFloat x = 0;
    CGFloat y = 0;
    for (int i = 0; i < _count; i++) {
        UIButton *btn = self.subviews[i];
        if (i == 0) { x = w * i;}
        else { x = (w  + 1)* i;}
        btn.frame = CGRectMake(x, y, w, h);
    }
}

- (void)drawRect:(CGRect)rect {
    
    NSInteger sum = _count;
    while (sum > 0) {
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        CGContextSetLineWidth(ctx, 1);
        CGContextSetStrokeColorWithColor(ctx, [UIColor grayColor].CGColor);
        CGContextBeginPath(ctx);
        CGContextMoveToPoint(ctx, rect.size.width * sum / _count , 5);
        CGContextAddLineToPoint(ctx, rect.size.width * sum/ _count, rect.size.height - 5);
        CGContextStrokePath(ctx);
        sum--;
    }
    
    [self.layer addSublayer:self.BGLineShapeLayer];
    [self.layer addSublayer:self.lineShapeLayer];
    [self setPathStartPosition];
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
