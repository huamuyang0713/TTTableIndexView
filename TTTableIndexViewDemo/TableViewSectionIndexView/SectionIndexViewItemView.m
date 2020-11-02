//
//  SectionIndexViewItemView.m
//  TableViewSectionIndexDemo
//
//  Created by 何强 on 2020/10/25.
//

#import "SectionIndexViewItemView.h"

@interface SectionIndexViewItemView ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *selectedView;

@end

@implementation SectionIndexViewItemView

- (instancetype)init {
    self = [self initWithFrame:CGRectZero];
    if (self) {
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.selectedView];
        [self addSubview:self.imageView];
        [self addSubview:self.titleLabel];
        
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [NSLayoutConstraint activateConstraints:@[
            [[self.titleLabel centerXAnchor] constraintEqualToAnchor:self.centerXAnchor],
            [[self.titleLabel centerYAnchor] constraintEqualToAnchor:self.centerYAnchor],
            [self.titleLabel.widthAnchor constraintEqualToAnchor:self.widthAnchor],
            [[self.titleLabel heightAnchor] constraintEqualToAnchor:self.titleLabel.widthAnchor]
        ]];
        
        self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
        [NSLayoutConstraint activateConstraints:@[
            [[self.imageView leadingAnchor] constraintEqualToAnchor:self.leadingAnchor],
            [[self.imageView trailingAnchor] constraintEqualToAnchor:self.trailingAnchor],
            [[self.imageView topAnchor] constraintEqualToAnchor:self.topAnchor],
            [[self.imageView bottomAnchor] constraintEqualToAnchor:self.bottomAnchor],
        ]];
        
        self.selectedView.translatesAutoresizingMaskIntoConstraints = NO;
        [NSLayoutConstraint activateConstraints:@[
            [[self.selectedView leadingAnchor] constraintEqualToAnchor:self.titleLabel.leadingAnchor],
            [[self.selectedView trailingAnchor] constraintEqualToAnchor:self.titleLabel.trailingAnchor],
            [[self.selectedView topAnchor] constraintEqualToAnchor:self.titleLabel.topAnchor],
            [[self.selectedView bottomAnchor] constraintEqualToAnchor:self.titleLabel.bottomAnchor],
        ]];
    }
    return self;
}

- (void)setIsSelected:(BOOL)isSelected {
    _isSelected = isSelected;
    [self selectItem:isSelected];
}

- (void)setImage:(UIImage *)image {
    _image = image;
    self.imageView.image = image;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = title;
}

- (void)setSelectedImage:(UIImage *)selectedImage {
    _selectedImage = selectedImage;
    self.imageView.highlightedImage = selectedImage;
}

- (void)setTitleFont:(UIFont *)titleFont {
    _titleFont = titleFont;
    self.titleLabel.font = titleFont;
}

- (void)setTitleColor:(UIColor *)titleColor {
    _titleColor = titleColor;
    self.titleLabel.textColor = titleColor;
}

- (void)setTitleSelectedColor:(UIColor *)titleSelectedColor {
    _titleSelectedColor = titleSelectedColor;
    self.titleLabel.highlightedTextColor = titleSelectedColor;
}

- (void)setSelectedColor:(UIColor *)selectedColor {
    _selectedColor = selectedColor;
    self.selectedView.backgroundColor = selectedColor;
}

#pragma mark - private
- (void)selectItem:(BOOL)select {
    if (self.selectedView.layer.cornerRadius == 0 && self.selectedView.bounds.size.width > 0) {
        self.selectedView.layer.cornerRadius = self.selectedView.bounds.size.width * 0.5;
    }
    self.titleLabel.highlighted = select;
    self.imageView.highlighted = select;
    self.selectedView.hidden = !select;
}

#pragma mark - lazy
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.adjustsFontSizeToFitWidth = YES;
        _titleLabel.numberOfLines = 0;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.backgroundColor = UIColor.clearColor;
        _titleLabel.textColor = [[UIColor alloc] initWithRed:0.3005631345 green:0.3005631345 blue:0.3005631345 alpha:1];
        _titleLabel.highlightedTextColor = [[UIColor alloc] initWithRed:0 green:0.5291740298 blue:1 alpha:1];
        _titleLabel.font = [UIFont boldSystemFontOfSize:10];
    }
    return _titleLabel;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeCenter;
    }
    return _imageView;
}

- (UIView *)selectedView {
    if (!_selectedView) {
        _selectedView = [[UIView alloc] init];
        _selectedView.backgroundColor = UIColor.clearColor;
        _selectedView.hidden = YES;
    }
    return _selectedView;
}



@end
