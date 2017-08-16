//
//  orderListView.m
//  CYOrder
//
//  Created by ymw on 17/4/5.
//  Copyright © 2017年 ymw. All rights reserved.
//

#import "OrderListView.h"
#import "CYOrderGroupCell.h"
@interface OrderListView()<UITableViewDataSource,UITableViewDelegate,CYOrderGroupCellDelegate>{
    
    NSMutableArray *_menuArr;
    NSMutableArray *_packageArr;
    OrderCell *_tagCell;
    
    CYOrderModel *_orderModel;
}

@property (nonatomic,strong) UILabel *titleLabel;
/**
 *  提交按钮
 */
@property (nonatomic,strong) UIButton *submitBtn;

@property (nonatomic,strong) UITableView *orderTableView;
/**
 *  桌号
 */
@property (nonatomic,strong) UILabel *disNumLabel;
/**
 *  总价
 */
@property (nonatomic,strong) UILabel *countLabel;

@property (nonatomic,strong) UIView *bottomView;

@property (nonatomic,strong) UIView *makingView;
@property (nonatomic,strong) UILabel *makingMenuLabel;


@property (nonatomic,strong) UIView *noMakingView;

@end
@implementation OrderListView
- (instancetype)init
{
    self = [super init];
    if (self) {
        _orderModel = [[CYOrderModel alloc]init];
        _orderModel.packageArr = [NSMutableArray array];
        _orderModel.orderListModelArr = [NSMutableArray array];
        [self setUpSubviews];
        
    }
    return self;
}
#pragma mark - privateMothod
- (void)setUpSubviews{
    __weak UIView *superview = self;
    [superview addSubview:self.submitBtn];
    [superview addSubview:self.orderTableView];
    [superview addSubview:self.bottomView];
    [self.submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(50);
        make.width.offset(120);
        make.bottom.equalTo(superview.mas_bottom).offset(-12);
        make.centerX.mas_equalTo(superview);
    }];
    
    [self.orderTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(superview);
        make.bottom.mas_equalTo(self.bottomView.mas_top);
    }];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(superview);
        make.bottom.mas_equalTo(self.submitBtn.mas_top).offset(-10);
        make.height.offset(40);
    }];

}
#pragma mark - 计算总价
- (CGFloat)calculatePrice{
    CGFloat price = 0.0;
    //目前暂定逻辑：计算所有订单的价格
    
    for (CYOrderModel *orderModel in self.orderArr) {
        price = price + [self calculateOrderPrice:orderModel];
    }
    price = price + [self calculateOrderPrice:_orderModel];

    self.countLabel.text = [NSString stringWithFormat:@"%.f",price];
    return price;
}
- (CGFloat)calculateOrderPrice:(CYOrderModel *)calOrderModel{
    CGFloat price = 0.0;

    for (CYOrderListModel *orderListModel in calOrderModel.packageArr) {
        price = price + orderListModel.packageModel.price * orderListModel.count;
    }
    for (CYOrderListModel *orderListModel in calOrderModel.orderListModelArr) {
        if (orderListModel.menuModel.is_special) {
            //如果是特价
            price = price + orderListModel.menuModel.discount_price * orderListModel.count;
        }else{
            //如果不是特价
            price = price + orderListModel.menuModel.price * orderListModel.count;
        }
    }
    return price;
}
- (void)addAFoodWithFoodModel:(CYMenuModel *)menuModel{
    [self.submitBtn setImage:[UIImage imageNamed:@"btn_commit_order"] forState:UIControlStateNormal];
    BOOL isExit = NO;
    for (CYOrderListModel *model in _orderModel.orderListModelArr) {
        if ([model.menu_id isEqualToString:menuModel.food_id]) {
            //如果存在
            isExit = YES;
            model.count ++;
        }
    }
    if (!isExit) {
        //如果不存在
        CYOrderListModel *orderListModel = [CYOrderListModel orderListModelWithMenuArr:menuModel];
        orderListModel.count = 1;
        [_orderModel.orderListModelArr addObject:orderListModel];
    }

    [self.orderTableView reloadData];
    [self scrollToBottom];
    [self calculatePrice];
}
- (void)addPackageWithPackage:(CYPackageModel *)packageModel{
    [self.submitBtn setImage:[UIImage imageNamed:@"btn_commit_order"] forState:UIControlStateNormal];

    BOOL isExit = NO;
    for (CYOrderListModel *pacModel in _orderModel.packageArr) {
        if ([pacModel.package_id isEqualToString:packageModel.package_id]) {
            //如果已经点过了一个套餐
            pacModel.count ++;
            isExit = YES;
        }
    }
    if (!isExit) {
        //如果不存在
        CYOrderListModel *orderListModel = [CYOrderListModel orderListModelWithPack:packageModel];
        orderListModel.count = 1;
        [_orderModel.packageArr addObject:orderListModel];
    }
    
    [self.orderTableView reloadData];
    [self scrollToBottom];
    [self calculatePrice];
}
#pragma mark - responseEvent
- (void)didClickSubmitBtn:(UIButton *)sender{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(orderListViewDidClickSubmitBtnWithOrderModel:)]) {
        [self.delegate orderListViewDidClickSubmitBtnWithOrderModel:_orderModel];
    }
}

- (void)scrollToBottom
{
    CGFloat yOffset = 0; //设置要滚动的位置 0最顶部 CGFLOAT_MAX最底部
    if (self.orderTableView.contentSize.height > self.orderTableView.bounds.size.height) {
        yOffset = self.orderTableView.contentSize.height - self.orderTableView.bounds.size.height;
    }
    [self.orderTableView setContentOffset:CGPointMake(0, yOffset) animated:NO];
}
- (CGFloat)calculateCellHeight:(CYOrderModel *)orderModel{
    CGFloat ih = orderModel.orderListModelArr.count *32;
    for (CYOrderListModel *listModel in orderModel.packageArr) {
        ih = ih + listModel.packageModel.packageLists.count *32;
    }
    return ih;
}
#pragma mark - delegate

- (void)orderGroupCell:(CYOrderGroupCell *)cell orderListArr:(NSMutableArray *)orderListArr packageArr:(NSMutableArray *)packageArr{
    _orderModel.orderListModelArr = orderListArr;
    _orderModel.packageArr = packageArr;
    if (_orderModel.orderListModelArr.count == 0 && _orderModel.packageArr.count == 0 && self.orderArr.count > 0) {
        [self.submitBtn setImage:[UIImage imageNamed:@"btn_pay"] forState:UIControlStateNormal];
    }
    [self.orderTableView reloadData];
}
//表尾
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"didOrderListView--------");
}
//表头
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section < self.orderArr.count ) {
        if (section == 0) {
            UIView *view = [[UIView alloc]init];
                [view addSubview:self.makingView];
                [self.makingView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.bottom.left.right.top.equalTo(view);
                }];
            return view;
        }

    }else{
        if (_orderModel.orderListModelArr.count >0 || _orderModel.packageArr.count > 0) {
            UIView *view = [[UIView alloc]init];
            view.backgroundColor = [UIColor colorWithRed:245/255.0 green:122/255.0 blue:102/255.0 alpha:1];
            UILabel *label = [[UILabel alloc]init];
            label.textColor = [UIColor whiteColor];
            label.font = [UIFont systemFontOfSize:12];
            label.text = @"您有新的订单未提交";
            [view addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.offset(10);
                make.centerY.equalTo(view);
            }];
            return view;
        }
        if (self.orderArr.count == 0) {
            return nil;
        }

    }
    return nil;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section < self.orderArr.count) {
        CYOrderModel *curOrderModel = self.orderArr[section];
        if (curOrderModel.orderListModelArr.count > 0 || curOrderModel.packageArr.count > 0) {
            return 1;
        }
    }else{
        if (_orderModel.orderListModelArr.count > 0 || _orderModel.packageArr.count > 0) {
            return 1;
        }
    }
    return 0.01;

}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.orderArr.count + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section < self.orderArr.count) {
        CGFloat ih =   [self calculateCellHeight:self.orderArr[indexPath.section]];
        return ih;
    }else{
        return [self calculateCellHeight:_orderModel];
    }
    return 32;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}



- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section<self.orderArr.count) {
        if (section == 0) {
            return 25;

        }
    }else{
        if (_orderModel.packageArr.count > 0 || (_orderModel.orderListModelArr.count > 0)) {
            if (self.orderArr.count == 0) {
                return 0;
            }
            return 25;
        }
   
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CYOrderGroupCell *cell = [CYOrderGroupCell cellWithTableView:tableView];
    if (indexPath.section < self.orderArr.count) {
        cell.model = self.orderArr[indexPath.section];
        cell.isActive = NO;
    }else{
        cell.model = _orderModel;
        cell.isActive = YES;
        cell.delegate = self;
    }
    
    return cell;
}

#pragma mark - init
- (void)setOrderArr:(NSArray *)orderArr{
    _orderArr = orderArr;
    _orderModel = [[CYOrderModel alloc]init];
    _orderModel.packageArr = [NSMutableArray array];
    _orderModel.orderListModelArr = [NSMutableArray array];
    [self.orderTableView reloadData];
    if (_orderArr.count > 0) {
        [self.submitBtn setImage:[UIImage imageNamed:@"btn_pay"] forState:UIControlStateNormal];
    }
    [self calculatePrice];

    
}
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.backgroundColor = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = @"我的订单";
        _titleLabel.font = CYDefaultTextFont(22.5);
        _titleLabel.textColor = CYTextColor;
    }
    return _titleLabel;
}
- (UIButton *)submitBtn{
    if (!_submitBtn) {
        _submitBtn = [[UIButton alloc]init];
//        [_submitBtn setBackgroundImage:[UIImage imageNamed:@"btn_bg"] forState:UIControlStateNormal];
        _submitBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_submitBtn addTarget:self action:@selector(didClickSubmitBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.submitBtn setImage:[UIImage imageNamed:@"btn_commit_order"] forState:UIControlStateNormal];
        [_submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _submitBtn.titleLabel.font = CYDefaultTextFont(15);
    }
    return _submitBtn;
}
- (UITableView *)orderTableView{
    if (!_orderTableView) {
        _orderTableView = [[[UITableView alloc]init]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _orderTableView.backgroundColor = [UIColor whiteColor];
        _orderTableView.delegate = self;
        _orderTableView.dataSource = self;
        _orderTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        _orderTableView.scro
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 45)];              _orderTableView.tableHeaderView = view;

        UIImageView *bottomView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"order_cell_split_line"]];
        [view addSubview:self.titleLabel];
        [view addSubview:bottomView];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.mas_equalTo(view);
            make.height.offset(40);
        }];
        
        [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.offset(30);
            make.centerY.equalTo(view.mas_bottom);
            make.width.equalTo(view.mas_width).multipliedBy(1.5);
            make.centerX.equalTo(view);
        }];
         
    }
    return _orderTableView;
}
- (UILabel *)disNumLabel{
    if (!_disNumLabel) {
        _disNumLabel = [[UILabel alloc]init];
        _disNumLabel.font = CYDefaultTextFont(15);
        _disNumLabel.text = @"No6";
    }
    return _disNumLabel;
}

- (UILabel *)countLabel{
    if (!_countLabel) {
        _countLabel = [[UILabel alloc]init];
        _countLabel.font = CYDefaultTextFont(15);
        _countLabel.text = @"0";
        
    }
    return _countLabel;
}
- (UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc]init];
        [_bottomView setBackgroundColor:[UIColor whiteColor]];
        UILabel *exNumL = [[UILabel alloc]init];
        exNumL.font = CYDefaultTextFont(15);
        exNumL.text = @"桌号 :";
        UILabel *exCountL = [[UILabel alloc]init];
        exCountL.text = @"总价 :";
        exCountL.font = CYDefaultTextFont(15);
        UILabel *label = [[UILabel alloc]init];
        label.font = CYDefaultTextFont(12);
        label.text = @"¥";
        [_bottomView addSubview:exNumL];
        [_bottomView addSubview:self.disNumLabel];
        [_bottomView addSubview:exCountL];
        [_bottomView addSubview:label];
        [_bottomView addSubview:self.countLabel];
        
        
        [exNumL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(15);
            make.centerY.equalTo(_bottomView);
        }];
        [self.disNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(exNumL.mas_right);
            make.centerY.equalTo(exNumL.mas_centerY);
        }];
        [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_bottomView).offset(-15);
            make.centerY.equalTo(exNumL.mas_centerY);
        }];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.countLabel.mas_left).offset(-3);
            make.centerY.equalTo(exNumL.mas_centerY);
        }];
        [exCountL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(label.mas_left);
            make.centerY.equalTo(exNumL.mas_centerY);
        }];
        
    }
    return _bottomView;
}
- (UIView *)makingView{
    if (!_makingView) {
        _makingView = [[UIView alloc]init];
        _makingView.backgroundColor = [UIColor colorWithRed:245/255.0 green:122/255.0 blue:102/255.0 alpha:1];
        [_makingView addSubview:self.makingMenuLabel];
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"making"]];
        [_makingView addSubview:imageView];
        UILabel *label = [[UILabel alloc]init];
        label.textColor = [UIColor whiteColor];
        label.font = CYDefaultTextFont(12);
        label.text = @"正在制作中...";
        [_makingView addSubview:label];
        
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(5);
            make.width.offset(25);
            make.height.offset(25);
            make.centerY.equalTo(_makingView);
        }];
        [self.makingMenuLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(imageView.mas_right).offset(5);
            make.centerY.equalTo(_makingView);

        }];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset(-5);
            make.centerY.equalTo(_makingView);

        }];
    }
    return _makingView;
}
- (UILabel *)makingMenuLabel{
    if (!_makingMenuLabel) {
        _makingMenuLabel = [[UILabel alloc]init];
        _makingMenuLabel.font = CYDefaultTextFont(15);
        _makingMenuLabel.textColor = [UIColor whiteColor];
        _makingMenuLabel.text = @"红烧狮子头";
    }
    return _makingMenuLabel;
}
- (UIView *)noMakingView{
    if (!_noMakingView) {
        _noMakingView = [[UIView alloc]init];
        _noMakingView.backgroundColor = [UIColor colorWithRed:245/255.0 green:122/255.0 blue:102/255.0 alpha:1];
        UILabel *label = [[UILabel alloc]init];
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:12];
        label.text = @"您的订单已被厨师接收";
        [_noMakingView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(10);
            make.centerY.equalTo(_noMakingView);
        }];
    }
    return _noMakingView;
}
@end
