//
//  SectionIndexViewManager.h
//  TableViewIndexDemo
//
//  Created by 何强 on 2020/10/28.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SectionIndexViewItemView.h"
#import "SectionIndexViewConfiguration.h"
#import "SectionIndexView.h"

NS_ASSUME_NONNULL_BEGIN

@interface SectionIndexViewManager : NSObject

- (instancetype)initWith:(UITableView *)tableView andItems:(NSArray<SectionIndexViewItemView *> *)items configuration:(SectionIndexViewConfiguration *)configuration;

@end

NS_ASSUME_NONNULL_END
