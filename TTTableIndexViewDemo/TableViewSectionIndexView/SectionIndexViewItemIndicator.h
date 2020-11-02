//
//  SectionIndexViewItemIndicator.h
//  TableViewSectionIndexDemo
//
//  Created by 何强 on 2020/10/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SectionIndexViewItemIndicator : UIView

@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, strong) UIFont *titleFont;
@property (nonatomic, strong) UIColor *indicatorBackgroundColor;

- (instancetype)initWithTitle:(NSString *)title;
- (instancetype)initWithTitle:(NSString *)title andSize:(CGSize)size;


@end

NS_ASSUME_NONNULL_END
