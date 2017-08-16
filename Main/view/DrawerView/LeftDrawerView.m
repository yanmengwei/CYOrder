//
//  LeftDrawerView.m
//  CYOrder
//
//  Created by ymw on 17/4/14.
//  Copyright © 2017年 ymw. All rights reserved.
//

#import "LeftDrawerView.h"
@interface LeftDrawerView(){
    NSArray *_titles;
    BOOL _isOpen;
}
@property (nonatomic,strong) UITableView *leftTableView;
@property (nonatomic,strong) UIButton *lockBtn;
@end
@implementation LeftDrawerView

-(instancetype)initLeftViewWithTitles:(NSArray *)titles{
    self = [super init];
    if (self) {
        _isOpen = NO;
        _titles = [NSArray arrayWithArray:titles];
        [self setUpSubviews];
        [self.leftTableView reloadData];
    }
    return self;

}
- (void)setUpSubviews{
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"left_bg"]];
    [self addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self);
    }];
    
    [self addSubview:self.leftTableView];

    [self.leftTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.height.offset(44*_titles.count);
        make.centerY.equalTo(self);
    }];
    
}
#pragma mark - event
#pragma mark - delegate&datesource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _titles.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"LeftDrawerViewIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.font = CYDefaultTextFont(15);
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIImageView *imageView  = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"server_split_line"]];
        [cell addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.offset(30);
            make.centerY.equalTo(cell.mas_bottom);
            make.width.equalTo(cell.mas_width).multipliedBy(1.2);
            make.left.equalTo(cell).offset(3);
        }];
    }
    if (_titles.count > indexPath.row) {
        cell.textLabel.text = _titles[indexPath.row];

    }
   

    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.delegate && [self.delegate respondsToSelector:@selector(leftDrawerView:didSelectAtIndex:)]) {
        [self.delegate leftDrawerView:self didSelectAtIndex:indexPath.row];
    }
}
#pragma mark - init
- (UITableView *)leftTableView{
    if (!_leftTableView) {
        _leftTableView = [[UITableView alloc]init];
        _leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"left_bg"]];
//
//        [_leftTableView setBackgroundView:imageView];
        _leftTableView.backgroundColor = [UIColor clearColor];
        _leftTableView.delegate = self;
        _leftTableView.dataSource = self;
    }
    return _leftTableView;
}
@end
