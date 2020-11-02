//
//  SectionIndexView.m
//  TableViewSectionIndexDemo
//
//  Created by 何强 on 2020/10/25.
//

#import "SectionIndexView.h"
#import "SectionIndexViewItemView.h"

NSString * const touchesOccurredNotificationName = @"SectionIndexViewTouchesOccurredNotification";
NSString * const touchesEndedNotificationName = @"SectionIndexViewTouchesEndedNotification";

@interface SectionIndexView ()

@property (nonatomic, strong) UIImpactFeedbackGenerator *generator;
@property (nonatomic, strong) NSMutableArray<SectionIndexViewItemView *> *items;

@end

@implementation SectionIndexView

- (instancetype)init {
    if (self = [self initWithFrame:CGRectZero]) {
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _itemIndicatorHorizontalOffset = -20;
        _generator = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleLight];
        _items = [NSMutableArray array];
    }
    return self;
}

- (void)setDataSource:(id<SectionIndexViewDataSource>)dataSource {
    _dataSource = dataSource;
    [self reloadData];
}

- (void)reloadData {
    for (SectionIndexViewItemView *item in self.items) {
        [item removeFromSuperview];
        if (item.indicator) {
            [item.indicator removeFromSuperview];
        }
    }
    
    [self.items removeAllObjects];
    [self loadView];
}

- (SectionIndexViewItemView *)itemAt:(NSInteger)section {
    if (section >= 0 && section < self.items.count) {
        return self.items[section];
    }
    return nil;
}

- (void)impact {
    [self.generator prepare];
    [self.generator impactOccurred];
}

- (void)selectItemAt:(NSInteger)section {
    SectionIndexViewItemView *v = [self itemAt:section];
    if (v) {
        v.isSelected = YES;
        self.selectedItem = v;
    }
}

- (void)deselectCurrentItem {
    if (self.selectedItem) {
        self.selectedItem.isSelected = NO;
    }
    self.selectedItem = nil;
}

- (void)showCurrentItemIndicator {
    if (self.selectedItem && self.selectedItem.indicator && !self.selectedItem.indicator.superview) {
        CGFloat x = -self.selectedItem.indicator.bounds.size.width * 0.5 + self.itemIndicatorHorizontalOffset;
        CGFloat y = self.isItemIndicatorAlwaysInCenterY ? (self.bounds.size.height - self.selectedItem.bounds.size.height) * 0.5 : self.selectedItem.center.y;
        self.selectedItem.indicator.center = CGPointMake(x, y);
        [self addSubview:self.selectedItem.indicator];
        return;
    }
    self.selectedItem.indicator.alpha = 1;
}

- (void)hideCurrentItemIndicator {
    if (self.selectedItem && self.selectedItem.indicator) {
        self.selectedItem.indicator.alpha = 0;
    }
}

#pragma mark - private

- (void)loadView {
    if (!self.dataSource) {
        return;
    }
    
    NSInteger numberOfItems = [self.dataSource numberOfScetions:self];
    NSMutableArray *list = [NSMutableArray array];
    for (NSInteger i = 0; i < numberOfItems; i ++) {
        SectionIndexViewItemView *v = [self.dataSource sectionIndexView:self itemAt:i];
        [list addObject:v];
    }
    self.items = list;
    
    [self setItemsLayoutConstrain];
}

- (void)setItemsLayoutConstrain {
    if (self.items && self.items.count) {
        
        
        CGFloat heightMultiplier = (CGFloat)1 / (CGFloat)self.items.count;
        
        for (NSInteger i = 0; i < self.items.count; i ++) {
            SectionIndexViewItemView *v = self.items[i];
            v.translatesAutoresizingMaskIntoConstraints = NO;
            [self addSubview:v];
            
            NSArray *constraints = @[
                [v.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
                [v.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
                [v.heightAnchor constraintEqualToAnchor:self.heightAnchor multiplier:heightMultiplier],
                [v.topAnchor constraintEqualToAnchor:i == 0 ? self.topAnchor : self.items[i - 1].bottomAnchor]
            ];
            [NSLayoutConstraint activateConstraints:constraints];
        }
    }
}

#pragma mark -
- (BOOL)point:(CGPoint)point isIn:(UIView *)view {
    return point.y <= (view.frame.origin.y + view.frame.size.height) && point.y >= view.frame.origin.y;
}

- (NSInteger)getSectionBy:(NSSet<UITouch *> *)touches  {
    if (touches.count) {
        UITouch *touch = [touches allObjects].firstObject;
        CGPoint p = [touch locationInView:self];
        __block NSInteger section = -1;
        [self.items enumerateObjectsUsingBlock:^(SectionIndexViewItemView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([self point:p isIn:obj]) {
                section = idx;
                *stop = YES;
            }
        }];
        return section;
    }
    
    return -1;
}

- (void)touchesOccurred:(NSSet<UITouch *> *)touches {
    self.isTouching = YES;
    NSInteger section = [self getSectionBy:touches];
    SectionIndexViewItemView *item = [self itemAt:section];
    if (item && ![self.selectedItem isEqual:item]) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(sectionIndexView:didSelect:)]) {
            [self.delegate sectionIndexView:self didSelect:section];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:touchesEndedNotificationName object:self userInfo:@{@"section" : @(section)}];
    }
    
}

- (void)touchesEnded {
    if (self.delegate && [self.delegate respondsToSelector:@selector(sectionIndexViewToucheEnded:)]) {
        [self.delegate sectionIndexViewToucheEnded:self];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:touchesEndedNotificationName object:self];
    self.isTouching = NO;
}

#pragma mark - override
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self touchesOccurred:touches];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self touchesOccurred:touches];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self touchesEnded];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self touchesEnded];
}


@end
