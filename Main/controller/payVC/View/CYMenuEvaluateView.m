//
//  CYMenuEvaluateView.m
//  CYOrder
//
//  Created by ymw on 17/6/14.
//  Copyright © 2017年 ymw. All rights reserved.
//

#import "CYMenuEvaluateView.h"
#import "CYMenuEvaluateCell.h"
@interface CYMenuEvaluateView()<UITableViewDelegate,UITableViewDataSource,CYMenuEvaluateCellDelegate>
@property (nonatomic,strong) UITableView *menuEvaluateTableView;
@end

@implementation CYMenuEvaluateView
- (instancetype)init{
    if (self = [super init]) {
        [self setUpSubviews];
    }
    return self;
}
- (void)setUpSubviews{
    [self addSubview:self.menuEvaluateTableView];
    [self.menuEvaluateTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self);
    }];
}
#pragma mark - cellDelegate
- (void)cellDidChangeEvaStatus:(CYOrderListModel *)model{
    for (CYOrderListModel *listModel in self.orderListArr) {
        if ([listModel.menu_id isEqualToString:model.menu_id] && [listModel.order_id isEqualToString:model.order_id]) {
            [self.orderListArr replaceObjectAtIndex:[self.orderListArr indexOfObject:listModel] withObject:model];
            return;
        }
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(didChangeMenuEvaStatusWithOrderListArr:)]) {
        [self.delegate didChangeMenuEvaStatusWithOrderListArr:self.orderListArr];
    }
}
#pragma mark - delegate 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.orderListArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 45;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]init];
    UIImageView *image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"pay_order_bg"]];
    [view addSubview:image];
    [image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(view);
    }];
    UILabel *title = [[UILabel alloc]init];
    title.font  = CYDefaultTextFont(16);
    title.textColor = CYTextColor;
    title.text = @"菜品评价";
    [view addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(15);
        make.left.offset(30);
    }];
    
    return view;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CYMenuEvaluateCell *cell = [CYMenuEvaluateCell cellWithTableView:tableView];
    cell.model = self.orderListArr[indexPath.row];
    cell.delegate = self;
    return cell;
}
- (void)setOrderListArr:(NSArray *)orderListArr{
    _orderListArr = orderListArr;
    [self.menuEvaluateTableView reloadData];
}
- (UITableView *)menuEvaluateTableView{
    if (!_menuEvaluateTableView) {
        _menuEvaluateTableView = [[UITableView alloc]init];
        _menuEvaluateTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _menuEvaluateTableView.dataSource = self;
        _menuEvaluateTableView.delegate = self;
        [_menuEvaluateTableView setBackgroundView:[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"pay_order_bg"]]];
    }
    return _menuEvaluateTableView;
}
@end
