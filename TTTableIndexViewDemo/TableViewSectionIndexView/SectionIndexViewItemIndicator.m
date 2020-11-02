//
//  SectionIndexViewItemIndicator.m
//  TableViewSectionIndexDemo
//
//  Created by 何强 on 2020/10/25.
//

#import "SectionIndexViewItemIndicator.h"
#import <math.h>

@interface SectionIndexViewItemIndicator ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) CAShapeLayer *shapeLayer;

@end

@implementation SectionIndexViewItemIndicator

- (instancetype)initWithTitle:(NSString *)title {
    CGSize size= CGSizeMake(50, 50);
    return [self initWithTitle:title andSize:size];
}

- (instancetype)initWithTitle:(NSString *)title andSize:(CGSize)size {
    self = [super initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    if (self) {
        _titleColor = UIColor.whiteColor;
        _titleFont = [UIFont boldSystemFontOfSize:35];
        _indicatorBackgroundColor = UIColor.grayColor;
        
        [self.layer addSublayer:self.shapeLayer];
        [self addSubview:self.titleLabel];
        self.titleLabel.text = title;
    }
    return self;
}

- (void)setTitleColor:(UIColor *)titleColor {
    _titleColor = titleColor;
    self.titleLabel.textColor = titleColor;
}

- (void)setTitleFont:(UIFont *)titleFont {
    _titleFont = titleFont;
    self.titleLabel.font = titleFont;
}

- (void)setIndicatorBackgroundColor:(UIColor *)indicatorBackgroundColor {
    _indicatorBackgroundColor = indicatorBackgroundColor;
    self.shapeLayer.fillColor = indicatorBackgroundColor.CGColor;
}

#pragma mark - lazy
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.frame = self.bounds;
        _titleLabel.textColor = self.titleColor;
        _titleLabel.backgroundColor = UIColor.clearColor;
        _titleLabel.font = [UIFont boldSystemFontOfSize:35];
        _titleLabel.adjustsFontSizeToFitWidth = YES;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (CAShapeLayer *)shapeLayer {
    if (!_shapeLayer) {
        CGFloat x = self.bounds.size.width * 0.5;
        CGFloat y = self.bounds.size.height * 0.5;
        CGFloat radius = self.bounds.size.width * 0.5;
        CGFloat startAngle = M_PI * 0.25; 
        CGFloat endAngle = M_PI * 1.75;
        
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(x, y) radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
        
        CGFloat lineX = x * 2 + self.bounds.size.width * 0.2;
        CGFloat lineY = y;
        [path addLineToPoint:CGPointMake(lineX, lineY)];
        [path closePath];
        
        _shapeLayer = [[CAShapeLayer alloc] init];
        _shapeLayer.frame = self.bounds;
        _shapeLayer.fillColor = self.indicatorBackgroundColor.CGColor;
        _shapeLayer.path = path.CGPath;
    }
    return _shapeLayer;
}

@end
