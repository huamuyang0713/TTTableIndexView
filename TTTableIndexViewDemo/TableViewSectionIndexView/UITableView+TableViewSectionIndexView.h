//
//  UITableView+TableViewSectionIndexView.h
//  TableViewSectionIndexDemo
//
//  Created by 何强 on 2020/10/25.
//

#import <UIKit/UIKit.h>
#import "SectionIndexViewItemView.h"
#import "SectionIndexViewConfiguration.h"
#import "SectionIndexViewManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface UITableView (TableViewSectionIndexView)

/**
 * 默认样式
 * 自动从DataSource的titleForHeaderInSection方法中获取title，生成SectionIndexViewItemView
 */
- (void)addSectionView;

/**
 * 自定义SectionIndexViewItemView
 * 默认config
 */
- (void)sectionIndexView:(NSArray<SectionIndexViewItemView *> *)items;

/**
 * 自定义SectionIndexViewItemView
 * 自定义config
 */
- (void)sectionIndexView:(NSArray<SectionIndexViewItemView *> *)items withConfiguration:(SectionIndexViewConfiguration *)config;


@property (nonatomic, strong, readonly, nullable) SectionIndexViewManager *sectionIndexViewManager;
@property (nonatomic, assign, readonly) BOOL isAutomicManageItems;

@end

NS_ASSUME_NONNULL_END
