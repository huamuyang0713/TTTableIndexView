//
//  ViewController.m
//  TTTableIndexViewDemo
//
//  Created by 何强 on 2020/11/2.
//

#import "ViewController.h"
#import "Person.h"
#import "SectionIndexViewItemIndicator.h"
#import "SectionIndexViewItemView.h"
#import "SectionIndexViewConfiguration.h"
#import "UITableView+TableViewSectionIndexView.h"

NSString * const identifier = @"cell";

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableDictionary *dataSource;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    [self loadData];
    [self addSection];
    
//    [self.tableView addSectionView];
}

-(void)addSection {
    NSArray *items = [self items];
    SectionIndexViewConfiguration *config = [[SectionIndexViewConfiguration alloc] init];
    config.adjustedContentInset = 100;
    
    [self.tableView sectionIndexView:items withConfiguration:config];
}

- (void)loadData {
    _dataSource = [NSMutableDictionary dictionary];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"data.json" ofType:nil];
    if (path) {
        NSData *data;
        @try {
            data = [[NSData alloc] initWithContentsOfFile:path];
        } @catch (NSException *exception) {
            NSLog(@"decode data err");
        } @finally {
            
        }
        
        NSArray *arr;
        NSError *err;
        if (data) {
            @try {
                arr = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&err];
            } @catch (NSException *exception) {
                NSLog(@"decode json err");
            } @finally {
                
            }
        }
        
        if (arr) {
            for (NSInteger i = 0; i < arr.count; i ++) {
                NSDictionary *dicItem = arr[i];
                Person *p = [[Person alloc] initWithDic:dicItem];
                NSMutableArray *list = [self.dataSource[p.firstCharacter] mutableCopy];
                
                if (!list) {
                    list = [NSMutableArray array];
                }
                
                [list addObject:p];
                [self.dataSource setObject:list forKey:p.firstCharacter];
            }
        }
        
    }
}

- (NSArray <SectionIndexViewItemView *> *)items {
    NSMutableArray *items = [NSMutableArray array];
    
    NSInteger index = 0;
    for (NSString *key in self.dataSource.allKeys) {
        SectionIndexViewItemView *item = [[SectionIndexViewItemView alloc] init];
        if (index == 0) {
            item.image = [UIImage imageNamed:@"recent"];
            item.selectedImage = [UIImage imageNamed:@"recent_sel"];
            UIImageView *indicator = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
            indicator.image = [UIImage imageNamed:@"recent_ind"];
            item.indicator = indicator;
        } else {
            item.title = key;
            item.indicator = [[SectionIndexViewItemIndicator alloc] initWithTitle:key];
        }
        [items addObject:item];
        index ++;
    }
    
    return items;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString *key = self.dataSource.allKeys[section];
    return [self.dataSource[key] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *key = self.dataSource.allKeys[section];
    return key;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    NSString *key = self.dataSource.allKeys[indexPath.section];
    Person *p = [self.dataSource[key] objectAtIndex:indexPath.row];
    cell.textLabel.text = p.fullName;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *keys = self.dataSource.allKeys;
    [self.dataSource removeObjectForKey:keys.lastObject];
    [self addSection];
    [tableView reloadData];
}


- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:UITableViewCell.class forCellReuseIdentifier:identifier];
    }
    return _tableView;
}

@end
