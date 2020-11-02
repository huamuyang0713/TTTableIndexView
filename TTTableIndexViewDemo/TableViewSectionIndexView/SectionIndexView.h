//
//  SectionIndexView.h
//  TableViewSectionIndexDemo
//
//  Created by 何强 on 2020/10/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class SectionIndexView;
@class SectionIndexViewItemView;

@protocol SectionIndexViewDataSource <NSObject>

- (NSInteger)numberOfScetions:(SectionIndexView *)sectionIndexView;
- (SectionIndexViewItemView *)sectionIndexView:(SectionIndexView *)sectionIndexView itemAt:(NSInteger)section;

@end

@protocol SectionIndexViewDelegate <NSObject>

- (void)sectionIndexView:(SectionIndexView *)sectionIndexView didSelect:(NSInteger)section;
- (void)sectionIndexViewToucheEnded:(SectionIndexView *)sectionIndexView;

@end


@interface SectionIndexView : UIView

@property (nonatomic, weak) id <SectionIndexViewDataSource> dataSource;
@property (nonatomic, weak) id <SectionIndexViewDelegate> delegate;

@property (nonatomic, assign) BOOL isItemIndicatorAlwaysInCenterY;
@property (nonatomic, assign) CGFloat itemIndicatorHorizontalOffset;

@property (nonatomic, assign) BOOL isTouching;
@property (nonatomic, strong, nullable) SectionIndexViewItemView *selectedItem;

- (void)reloadData;
- (SectionIndexViewItemView *)itemAt:(NSInteger)section;
- (void)impact;
- (void)selectItemAt:(NSInteger)section;
- (void)deselectCurrentItem;
- (void)showCurrentItemIndicator;
- (void)hideCurrentItemIndicator;

@end

NS_ASSUME_NONNULL_END
