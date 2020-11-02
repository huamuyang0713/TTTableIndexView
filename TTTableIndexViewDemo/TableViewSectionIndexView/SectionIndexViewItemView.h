//
//  SectionIndexViewItemView.h
//  TableViewSectionIndexDemo
//
//  Created by 何强 on 2020/10/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

//@protocol SectionIndexViewItem <NSObject>
//
//@property (nonatomic, assign) BOOL isSelected;
//@property (nonatomic, strong) UIView *indicator;
////- (BOOL)isSelected;
////- (UIView *)indicator;
//
//@end

@interface SectionIndexViewItemView : UIView

@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, strong) UIView *indicator;

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIImage *selectedImage;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) UIFont *titleFont;
@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, strong) UIColor *titleSelectedColor;
@property (nonatomic, strong) UIColor *selectedColor;

@end

NS_ASSUME_NONNULL_END
