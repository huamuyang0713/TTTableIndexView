//
//  SectionIndexViewManager.m
//  TableViewIndexDemo
//
//  Created by 何强 on 2020/10/28.
//  Copyright © 2020 LianRenHealth. All rights reserved.
//

#import "SectionIndexViewManager.h"

void * const contextKey = @"SectionIndexViewManagerKVOContext";
NSString * const contentOffsetKey = @"contentOffset";

@interface SectionIndexViewManager () <SectionIndexViewDelegate, SectionIndexViewDataSource>

@property (nonatomic, assign) BOOL isOperated;
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) SectionIndexView *indexView;
@property (nonatomic, strong) NSArray<SectionIndexViewItemView *> *items;
@property (nonatomic, strong) SectionIndexViewConfiguration *configuration;

@end

@implementation SectionIndexViewManager

- (instancetype)initWith:(UITableView *)tableView andItems:(NSArray<SectionIndexViewItemView *> *)items configuration:(SectionIndexViewConfiguration *)configuration {
    self = [super init];
    if (self) {
        self.tableView = tableView;
        self.indexView = [[SectionIndexView alloc] init];
        self.items = items;
        self.configuration = configuration;
        self.indexView.isItemIndicatorAlwaysInCenterY = configuration.isItemIndicatorAlwaysInCenterY;
        self.indexView.itemIndicatorHorizontalOffset = configuration.itemIndicatorHorizontalOffset;
        self.indexView.delegate = self;
        self.indexView.dataSource = self;
        [self setLayoutConstraint];
        [tableView addObserver:self forKeyPath:contentOffsetKey options:NSKeyValueObservingOptionNew context:contextKey];
    }
    return self;
}

- (void)dealloc {
    [self.indexView removeFromSuperview];
    [self.tableView removeObserver:self forKeyPath:contentOffsetKey];
}

- (void)setLayoutConstraint {
    if (!self.tableView || !self.tableView.superview) {
        return;
    }
    
    [self.tableView.superview addSubview:self.indexView];
    self.indexView.translatesAutoresizingMaskIntoConstraints = NO;
    CGSize size = CGSizeMake(self.configuration.itemSize.width, self.configuration.itemSize.height * self.items.count);
    CGFloat topOffset = self.configuration.sectionIndexViewOriginInset.bottom - self.configuration.sectionIndexViewOriginInset.top;
    CGFloat rightOffset = self.configuration.sectionIndexViewOriginInset.right - self.configuration.sectionIndexViewOriginInset.left;
    
    NSArray *constraints = @[
        [self.indexView.centerYAnchor constraintEqualToAnchor:self.tableView.centerYAnchor constant:topOffset],
        [self.indexView.widthAnchor constraintEqualToConstant:size.width],
        [self.indexView.heightAnchor constraintEqualToConstant:size.height],
        [self.indexView.trailingAnchor constraintEqualToAnchor:self.tableView.trailingAnchor constant:rightOffset]
    ];
    
    [NSLayoutConstraint activateConstraints:constraints];
}

- (void)tableViewContentOffsetChange {
    if (self.tableView && !self.indexView.isTouching && (self.isOperated || self.tableView.isTracking)) {
        NSArray *visible = self.tableView.indexPathsForVisibleRows;
        if (visible && visible.count) {
            NSIndexPath *startP = visible.firstObject;
            NSIndexPath *endP = visible.lastObject;
            NSInteger topSection = 0;
            for (NSInteger i = startP.section; i < endP.section + 1; i ++) {
                if ([self isSectionVisible:i inTableView:self.tableView]) {
                    topSection = i;
                    break;
                }
            }
            SectionIndexViewItemView *item = [self.indexView itemAt:topSection];
            if (item && ![self.indexView.selectedItem isEqual:item]) {
                self.isOperated = YES;
                [self.indexView deselectCurrentItem];
                [self.indexView selectItemAt:topSection];
            }
        }
    }
}

- (BOOL)isSectionVisible:(NSInteger)section inTableView:(UITableView *)tableView {
    CGRect rect = [tableView rectForSection:section];
    return tableView.contentOffset.y + self.configuration.adjustedContentInset < rect.origin.y + rect.size.height;
}


//MARK: - SectionIndexViewDelegate, SectionIndexViewDataSource

- (NSInteger)numberOfScetions:(SectionIndexView *)sectionIndexView {
    return self.items.count;
}

- (SectionIndexViewItemView *)sectionIndexView:(SectionIndexView *)sectionIndexView itemAt:(NSInteger)section {
    return self.items[section];
}

- (void)sectionIndexView:(SectionIndexView *)sectionIndexView didSelect:(NSInteger)section {
    if (self.tableView && [self.tableView numberOfSections] > section) {
        [sectionIndexView hideCurrentItemIndicator];
        [sectionIndexView deselectCurrentItem];
        [sectionIndexView selectItemAt:section];
        [sectionIndexView showCurrentItemIndicator];
        [sectionIndexView impact];
        self.isOperated = YES;
        self.tableView.panGestureRecognizer.enabled = NO;
        if (self.configuration.scrollToTopWhenSelectTheFirstItem && section == 0) {
            [self.tableView scrollRectToVisible:CGRectMake(0, 0, 100, 1) animated:NO];
        } else if ([self.tableView numberOfRowsInSection:section] > 0) {
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section] atScrollPosition:UITableViewScrollPositionTop animated:NO];
        } else {
            [self.tableView scrollRectToVisible:[self.tableView rectForSection:section] animated:NO];
        }
    }
}

- (void)sectionIndexViewToucheEnded:(SectionIndexView *)sectionIndexView {
    [UIView animateWithDuration:0.3 animations:^{
        [sectionIndexView hideCurrentItemIndicator];
    }];
    
    self.tableView.panGestureRecognizer.enabled = YES;
}

#pragma mark - kvo
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (context == contextKey && [keyPath isEqualToString:contentOffsetKey]) {
        [self tableViewContentOffsetChange];
    }
}

@end
