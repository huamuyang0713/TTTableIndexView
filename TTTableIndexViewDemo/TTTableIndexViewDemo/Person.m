//
//  Person.m
//  TableViewIndexDemo
//
//  Created by 何强 on 2020/10/28.
//

#import "Person.h"

@implementation Person

- (instancetype)initWithDic:(NSDictionary *)dic {
    self = [super init];
    if (self) {
        self.fullName = dic[@"FirstNameLastName"] ?: @"Bryon Grady";
        self.firstCharacter = [NSString stringWithFormat:@"%c", [self.fullName characterAtIndex:0]];
    }
    return self;
}

@end
