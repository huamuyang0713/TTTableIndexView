//
//  Person.h
//  TableViewIndexDemo
//
//  Created by 何强 on 2020/10/28.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Person : NSObject

@property (nonatomic, strong) NSString *fullName;
@property (nonatomic, strong) NSString *firstCharacter;

- (instancetype)initWithDic:(NSDictionary *)dic;

@end

NS_ASSUME_NONNULL_END
