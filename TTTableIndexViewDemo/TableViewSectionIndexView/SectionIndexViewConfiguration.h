//
//  SectionIndexViewConfiguration.h
//  TableViewSectionIndexDemo
//
//  Created by 何强 on 2020/10/25.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SectionIndexViewConfiguration : NSObject

@property (nonatomic, assign) CGFloat adjustedContentInset;
@property (nonatomic, assign) CGSize itemSize;
@property (nonatomic, assign) BOOL isItemIndicatorAlwaysInCenterY;
@property (nonatomic, assign) CGFloat itemIndicatorHorizontalOffset;
@property (nonatomic, assign) UIEdgeInsets sectionIndexViewOriginInset;
@property (nonatomic, assign) BOOL scrollToTopWhenSelectTheFirstItem;

@end

NS_ASSUME_NONNULL_END
