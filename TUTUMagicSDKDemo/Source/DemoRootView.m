//
//  DemoRootView.m
//  TuSDKDemo
//
//  Created by Clear Hu on 15/4/24.
//  Copyright (c) 2015年 tusdk.com. All rights reserved.
//

#import "DemoRootView.h"

#pragma mark - DemoRootView
/**
 *  RootView
 */
@interface DemoRootView()<UITableViewDelegate, UITableViewDataSource>
{
    // TableView List
    TuSDKICTableView *_tableView;
    // Cell Identifier
    NSString *_cellIdentifier;
}
@end

@implementation DemoRootView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self lsqInitView];
    }
    return self;
}
- (void)lsqInitView;
{
    // 缓存标记
    _cellIdentifier = [NSString stringWithFormat:@"%@", [self class]];
    
    // 表格视图
    _tableView = [TuSDKICTableView tableWithHeight:self.frame.size.height];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.rowHeight = 50;
    _tableView.sectionHeaderHeight = 30;
    [self addSubview:_tableView];
}

- (void)setGroup:(SampleGroup *)group;
{
    _group = group;
    
    if (_tableView) [_tableView reloadData];
}

/**
 *  Choose Sample
 *
 *  @param indexPath
 *
 *  @return Sample
 */
- (SampleBase *)sampleWithIndexPath:(NSIndexPath *)indexPath;
{
    if (!indexPath || !_group) return nil;
    
    GroupHeader *header = [_group headerWithIndex:indexPath.section];
    if (!header || !header.datas || header.datas.count <= indexPath.row) return nil;
    
    return [header.datas objectAtIndex:indexPath.row];
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if (!self.delegate) return;
        
    SampleBase *sample = [self sampleWithIndexPath:indexPath];
    if (!sample) return;
    
    [self.delegate demoRootView:self selectedSample:sample withAction:demoListItemActionSelected];
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    if (!_group) return 1;
    return _group.headers.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    if (!_group) return 0;
    GroupHeader *header = [_group headerWithIndex:section];
    if (!header || !header.datas) return 0;
    return header.datas.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section;
{
    GroupHeader *header = [_group headerWithIndex:section];
    if (!header) return nil;
    return header.title;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    TuSDKICTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:_cellIdentifier];
    if (!cell) {
        cell = [TuSDKICTableViewCell initWithReuseIdentifier:_cellIdentifier];
        cell.textLabel.font = lsqFontSize(15);
    }
    
    SampleBase *sample = [self sampleWithIndexPath:indexPath];
    if (!sample) return cell;
    cell.textLabel.text = [NSString stringWithFormat:@"    %@", sample.title];
    return cell;
}
@end
