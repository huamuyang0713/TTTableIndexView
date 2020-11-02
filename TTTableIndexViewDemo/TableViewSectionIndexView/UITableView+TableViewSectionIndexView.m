//
//  UITableView+TableViewSectionIndexView.m
//  TableViewSectionIndexDemo
//
//  Created by 何强 on 2020/10/25.
//

#import "UITableView+TableViewSectionIndexView.h"
#import "SectionIndexViewItemIndicator.h"
#import <objc/runtime.h>

@implementation UITableView (TableViewSectionIndexView)

+ (void)load {
    static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            
            SEL originalSelector = @selector(reloadData);
            SEL swizzledSelector = @selector(swizzlingReloadData);
            
            Method originalMethod = class_getInstanceMethod(self.class, originalSelector);
            Method swizzledMethod = class_getInstanceMethod(self.class, swizzledSelector);
            
            BOOL didAddMethod =
            class_addMethod(self.class,
                            originalSelector,
                            method_getImplementation(swizzledMethod),
                            method_getTypeEncoding(swizzledMethod));
            
            if (didAddMethod) {
                class_replaceMethod(self.class,
                                    swizzledSelector,
                                    method_getImplementation(originalMethod),
                                    method_getTypeEncoding(originalMethod));
            } else {
                method_exchangeImplementations(originalMethod, swizzledMethod);
            }
        });
}

- (void)addSectionView {
    if (!self.superview) {
        return;
    }
    self.isAutomicManageItems = YES;
    NSInteger sectionCount = [self.dataSource numberOfSectionsInTableView:self];
    NSMutableArray *items = [NSMutableArray array];
    for (NSInteger i = 0; i < sectionCount; i ++) {
        NSString *key = [self.dataSource tableView:self titleForHeaderInSection:i];
        
        SectionIndexViewItemView *item = [[SectionIndexViewItemView alloc] init];
        item.title = key;
        item.indicator = [[SectionIndexViewItemIndicator alloc] initWithTitle:key];
        
        [items addObject:item];
    }
    
    SectionIndexViewConfiguration *config = [[SectionIndexViewConfiguration alloc] init];
    self.sectionIndexViewManager = [[SectionIndexViewManager alloc] initWith:self andItems:items configuration:config];
}

- (void)sectionIndexView:(NSArray<SectionIndexViewItemView *> *)items {
    self.isAutomicManageItems = NO;
    SectionIndexViewConfiguration *config = [[SectionIndexViewConfiguration alloc] init];
    [self sectionIndexView:items withConfiguration:config];
}

- (void)sectionIndexView:(NSArray<SectionIndexViewItemView *> *)items withConfiguration:(SectionIndexViewConfiguration *)config {
    NSAssert(self.superview != nil, @"先设置superView，再调用此方法");
    self.isAutomicManageItems = NO;
    self.sectionIndexViewManager = [[SectionIndexViewManager alloc] initWith:self andItems:items configuration:config];
}

#pragma mark - private
- (void)swizzlingReloadData {
    [self swizzlingReloadData];
    
    if (self.isAutomicManageItems) {
        self.sectionIndexViewManager = nil;
        [self addSectionView];
    }
}

#pragma mark - kvc
- (SectionIndexViewManager *)sectionIndexViewManager {
    return objc_getAssociatedObject(self, @selector(sectionIndexViewManager));
}

- (void)setSectionIndexViewManager:(SectionIndexViewManager * _Nullable)sectionIndexViewManager {
    objc_setAssociatedObject(self, @selector(sectionIndexViewManager), sectionIndexViewManager, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)isAutomicManageItems {
    return [objc_getAssociatedObject(self, @selector(isAutomicManageItems)) boolValue];
}

- (void)setIsAutomicManageItems:(BOOL)isAutomicManageItems {
    objc_setAssociatedObject(self, @selector(isAutomicManageItems), @(isAutomicManageItems), OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end
