//
//  CYPayView.m
//  CYOrder
//
//  Created by ymw on 17/4/27.
//  Copyright © 2017年 ymw. All rights reserved.
//

#import "CYPayView.h"
#import "CYPayMethodCell.h"
#import "CYPayMethodModel.h"
@interface CYPayView()<UITableViewDataSource,UITableViewDelegate>{
    UIImageView *_imageview;
    CYPayMethodModel *_payModel;
    NSArray *_payArr;
}
@property (nonatomic,strong) UITableView *payTable;
@property (nonatomic,strong) UIButton *payBtn;
@end
@implementation CYPayView

- (instancetype)init
{
    self = [super init];
    if (self) {
        _payArr = [CYPayMethodModel getMethods];
        [self setUp];
    }
    return self;
}
- (void)setUp{
    
    _imageview = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"pay_paytype_bg"]];
    [self addSubview:_imageview];
    _imageview.userInteractionEnabled = YES;
    __weak UIView *superview = _imageview;
    [_imageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self);
    }];
    
    [superview addSubview:self.payBtn];
    [superview addSubview:self.payTable];
    
    [self.payBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset(-40);
        make.height.offset(50);
        make.width.offset(150);
        make.centerX.equalTo(superview);
    }];
    
    [self.payTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(superview);
        make.bottom.equalTo(self.payBtn.mas_top);
    }];
}
- (void)didClickPayBtn:(UIButton *)sender{
    if (self.delegate &&[self.delegate respondsToSelector:@selector(payViewDidClickSureBtnWithModel:)]) {
        [self.delegate payViewDidClickSureBtnWithModel:_payModel];
    }
}
#pragma tableview delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 85;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]init];
    UILabel *hintLabel1 = [[UILabel alloc]init];
    hintLabel1.text = @"请在此选择以下自助支付方式";
    hintLabel1.textColor = CYTextColor;
    
    //设置反射。倾斜15度
    CGAffineTransform matrix =  CGAffineTransformMake(1, 0, tanf(15 * (CGFloat)M_PI / 180), 1, 0, 0);
    //取得系统字符并设置反射
    UIFontDescriptor *desc = [ UIFontDescriptor fontDescriptorWithName :[ UIFont systemFontOfSize :17 ]. fontName matrix :matrix];
    hintLabel1.font = [UIFont fontWithDescriptor :desc size :14];//设置字体为斜体
    
    UILabel *hintLabel2 = [[UILabel alloc]init];
    hintLabel2.text = @"也可呼叫服务员或者到柜台现金结账";
    hintLabel2.textColor = CYTextColor;
    hintLabel2.font = [UIFont fontWithDescriptor :desc size :14];//设置字体为斜体
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = CYBrownBorderColor;
    
    [view addSubview:hintLabel1];
    [view addSubview:hintLabel2];
    [view addSubview:line];
    
    [hintLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(25);
        make.centerX.equalTo(view);
    }];
    [hintLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(hintLabel1.mas_bottom).offset(10);
        make.centerX.equalTo(view);
    }];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(view);
        make.height.offset(1);
    }];
    view.backgroundColor = [UIColor clearColor];
    return view;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _payArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CYPayMethodCell *cell = [CYPayMethodCell cellWithTableView:tableView];
    cell.model = _payArr[indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _payModel = _payArr[indexPath.row];
}
-(UITableView *)payTable{
    if (!_payTable) {
        _payTable = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _payTable.separatorStyle =  UITableViewCellSeparatorStyleNone;
        _payTable.delegate = self;
        _payTable.dataSource = self;
        _payTable.backgroundColor = [UIColor clearColor];
    }
    return _payTable;
}
- (UIButton *)payBtn{
    if (!_payBtn) {
        _payBtn = [[UIButton alloc]init];
        [_payBtn setImage:[UIImage imageNamed:@"btn_sure_pay"] forState:UIControlStateNormal];
        [_payBtn addTarget:self action:@selector(didClickPayBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _payBtn;
}
@end
