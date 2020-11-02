//
//  SectionIndexViewConfiguration.m
//  TableViewSectionIndexDemo
//
//  Created by 何强 on 2020/10/25.
//

#import "SectionIndexViewConfiguration.h"

@implementation SectionIndexViewConfiguration

- (instancetype)init {
    if (self = [super init]) {
        _adjustedContentInset = 0;
        _itemSize = CGSizeMake(20, 15);
        _isItemIndicatorAlwaysInCenterY = NO;
        _itemIndicatorHorizontalOffset = -20;
        _sectionIndexViewOriginInset = UIEdgeInsetsZero;
    }
    return self;
}

@end
