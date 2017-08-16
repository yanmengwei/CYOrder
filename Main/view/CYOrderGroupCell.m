//
//  CYOrderGroupCell.m
//  CYOrder
//
//  Created by ymw on 17/6/16.
//  Copyright © 2017年 ymw. All rights reserved.
//

#import "CYOrderGroupCell.h"
#import "OrderCell.h"
#import "OrderPackageCell.h"
#import "HadOrderCell.h"
@interface CYOrderGroupCell()<UITableViewDelegate,UITableViewDataSource,OrderCellDelegate,OrderPackageCellDelegate>{
}
@property (nonatomic,strong) UITableView * groupTb;
@end
@implementation CYOrderGroupCell
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"CYOrderGroupCell";
    CYOrderGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[CYOrderGroupCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self  = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUpSubviews];
    }
    return self;
}
- (void)setUpSubviews{
    [self.contentView addSubview:self.groupTb];
    [self.groupTb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.contentView);
    }];
}

#pragma mark delegate
- (void)orderCell:(OrderCell *)cell didSelectDeleteBtnWithOrderModel:(CYOrderListModel *)menuModel{
    for (CYOrderListModel *listModel in self.model.orderListModelArr) {
        if ([listModel.menu_id isEqualToString:menuModel.menu_id]) {
            if (listModel.count > 1) {
                listModel.count -- ;
                break;
            
            }else{
                [self.model.orderListModelArr removeObject:listModel];
                break;
            }
        }
    }
    [self didChangeModel];
}
- (void)orderPackageCell:(OrderPackageCell *)cell didSelectDeleteBtnWithPackageModel:(CYPackageModel *)packageModel{
    for (CYOrderListModel *listModel in self.model.packageArr) {
        if ([listModel.packageModel.package_id isEqualToString:packageModel.package_id]) {
            if (listModel.count > 1) {
                listModel.count -- ;
                break;
            }else{
                [self.model.packageArr removeObject:listModel];
                break;
            }
        }
    }

    [self didChangeModel];
}
- (void)didChangeModel{
    if (self.delegate && [self.delegate respondsToSelector:@selector(orderGroupCell:orderListArr:packageArr:)]) {
        [self.delegate orderGroupCell:self orderListArr:self.model.orderListModelArr packageArr:self.model.packageArr];
    }
    [self.groupTb reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return self.model.orderListModelArr.count;
    }else{
        return self.model.packageArr.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        CYOrderListModel *listModel = self.model.orderListModelArr[indexPath.row];
        if (!_isActive) {
            //不可操作
            HadOrderCell *cell = [HadOrderCell cellWithTableView:tableView];
            cell.orderListModel = listModel;
            
            return cell;
    
        }else{
            OrderCell *cell = [OrderCell cellWithTableView:tableView];
            cell.orderModel = listModel;
            cell.delegate = self;

            return cell;

        }
    }else{
        OrderPackageCell *cell = [OrderPackageCell cellWithTableView:tableView];
        CYOrderListModel *listModel = self.model.packageArr[indexPath.row];
        cell.packageModel = listModel.packageModel;
        cell.isActive = _isActive;
        cell.delegate = self;
        return cell;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 32;
    }else{
        CYOrderListModel *listModel = self.model.packageArr[indexPath.row];
        return listModel.packageModel.packageLists.count * 32;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"vdidSelectRowAtIndexPath----dd---");
}
- (void)setModel:(CYOrderModel *)model{
    _model = model;
    [self.groupTb reloadData];
}

- (UITableView *)groupTb{
    if (!_groupTb) {
        _groupTb = [[UITableView alloc]init];
        _groupTb.separatorStyle = UITableViewCellSeparatorStyleNone;
        _groupTb.allowsSelection = YES;
        _groupTb.delegate = self;
        _groupTb.dataSource = self;
        _groupTb.scrollEnabled = NO;
    }
    return _groupTb;
}
- (void)setIsActive:(BOOL)isActive{
    _isActive = isActive;
}
@end
