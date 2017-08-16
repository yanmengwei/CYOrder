//
//  CYPayVC.m
//  CYOrder
//
//  Created by ymw on 17/4/27.
//  Copyright © 2017年 ymw. All rights reserved.
//

#import "CYPayVC.h"
#import "CountView.h"
#import "CYPayCell.h"
#import "CYPayView.h"
#import "CYHintView.h"
#import "CYEvaluateView.h"
@interface CYPayVC ()<UITableViewDataSource,UITableViewDelegate,CYPayViewDelegate,CYEvaluateViewDelegate>{
    NSArray *_orderListArr;
    CYPayCellType _cellType;
}
@property (nonatomic,strong) UIImageView *listImgView;

@property (nonatomic,strong) UIImageView *remarkBgImgView;
@property (nonatomic,strong) UIImageView *remarksImgView;
@property (nonatomic,strong) UILabel *naviTitleLabel;

@property (nonatomic,strong) UIImageView *orderBgView;

@property (nonatomic,strong) UIButton *sureBtn;
@property (nonatomic,strong) UITableView *orderTal;
@property (nonatomic,strong) CountView *countView;
@property (nonatomic,strong) CYPayView *payView;

@property (nonatomic,strong) CYEvaluateView *evaluateView;
@end

@implementation CYPayVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configSubviews];
    [self setUpSubviews];
}

- (void)setUpSubviews{
    __weak UIView *superview = self.view;
    [superview addSubview:self.naviTitleLabel];
    [superview addSubview:self.listImgView];
    [superview addSubview:self.remarkBgImgView];
    [superview addSubview:self.orderBgView];
    [self.remarkBgImgView addSubview:self.payView];

    //orderBgView作为显示页
    [self.orderBgView addSubview:self.sureBtn];
    [self.orderBgView addSubview:self.countView];
    [self.orderBgView addSubview:self.orderTal];
    
    
    
    
    [self.naviTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.topBgImgView.mas_bottom).offset(-10);
        make.centerX.equalTo(superview);
    }];
    [self.listImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topBgImgView.mas_bottom).offset(6);
        make.left.offset(30);
        make.right.equalTo(self.remarkBgImgView.mas_left).offset(-25);
        make.bottom.offset(-12);
    }];
    [self.remarkBgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.listImgView.mas_top);
        make.bottom.equalTo(self.listImgView.mas_bottom);
        make.right.offset(-30);
    }];
    
    
    [self.orderBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.listImgView.mas_top).offset(12);
        make.left.equalTo(self.listImgView.mas_left).offset(12);
        make.right.equalTo(self.listImgView.mas_right).offset(-12);
        make.bottom.equalTo(self.listImgView.mas_bottom).offset(-12);
    }];
    
    [self.orderTal mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(20);
        make.left.right.equalTo(self.orderBgView);
        make.bottom.equalTo(self.countView.mas_top).offset(-30);
    }];
    
    [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(150);
        make.height.offset(50);
        make.right.equalTo(self.countView.mas_right);
        make.top.equalTo(self.countView.mas_bottom).offset(20);
    }];
    
    [self.countView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset(-160);
        make.height.offset(65);
        make.width.offset(140);
        make.right.offset(-24);
    }];
    
    [self.payView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.remarkBgImgView).offset(12);
        make.bottom.right.equalTo(self.remarkBgImgView).offset(-12);
        
    }];
    
    //评价页面
    [superview addSubview:self.evaluateView];
    
    [self.evaluateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.orderBgView);
        make.bottom.equalTo(superview).offset(-20);
    }];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _cellType = CYPayCellTypeNone;
    _orderListArr = [_db getOrderList];

    
    
    self.countView.countLabel.text = [NSString stringWithFormat:@"%.1f",[CYTools countWithOrderArr:_orderListArr]];
    self.countView.vipCountLabel.text =[NSString stringWithFormat:@"%.1f",[CYTools countWithOrderArr:_orderListArr]*0.9];
    BOOL isStar = NO;
    for (CYOrderModel *model in _orderListArr) {
        isStar = model.is_star;
    }
    if (isStar) {
        _sureBtn.hidden = YES;
    }else{
        [_sureBtn setImage:[UIImage imageNamed:@"btn_comment_favourable"] forState:UIControlStateNormal];
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)didClickSureBtn:(UIButton *)sender{

    self.orderBgView.hidden = YES;
    self.evaluateView.hidden = NO;
    NSMutableArray *arr = [NSMutableArray array];
    for ( CYOrderModel *model in _orderListArr) {
        if (!model.is_star) {
            [arr addObject:model];
        }
    }
    self.evaluateView.orderModelArr = arr;
    if (_cellType == CYPayCellTypeNone) {
        [self.sureBtn setImage:[UIImage imageNamed:@"btn_commit_comment"] forState:UIControlStateNormal];
        [self.orderTal reloadData];
        return;
    }
    if (_cellType == CYPayCellTypeCommentComplete) {
//        for (CYOrderModel *orderModel in _orderListArr) {
//            
//        }
        if ([_db completeCommentWithOrder:_orderListArr[0]]) {
            _cellType = CYPayCellTypeCommentComplete;
            self.sureBtn.hidden = YES;
            [self.orderTal reloadData];
        }

    }
    
}
#pragma mark - 评价代理
- (void)didClickSubmitCommentBtnWithOrderModelArr:(NSArray *)orderModelArr andRestuarantModel:(CYRestuarantEvaluateModel *)resModel{
    if ([_db completeCommentWithOrder:orderModelArr] &&  [_db evaluateRestuarantWithResModel:resModel]) {
        //评论成功 刷新页面
        _orderListArr = [_db getOrderList];
        [self.orderTal reloadData];
        self.sureBtn.hidden = YES;
    }
    self.evaluateView.hidden = YES;
    self.orderBgView.hidden = NO;

}
#pragma mark - tableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _orderListArr.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    CYOrderModel *orderModel = _orderListArr[section];
    return orderModel.orderListModelArr.count + orderModel.packageArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CYPayCell  *cell = [CYPayCell cellWithTableView:tableView];
    CYOrderModel *orderModel = _orderListArr[indexPath.section];
    if (indexPath.row < orderModel.orderListModelArr.count) {
        cell.listModel = orderModel.orderListModelArr[indexPath.row];
    }else{
        cell.listModel  = orderModel.packageArr[indexPath.row - orderModel.orderListModelArr.count];
    }
    cell.cellType = _cellType;
    if (orderModel.is_star) {
        //评价过
        cell.cellType = CYPayCellTypeCommentComplete;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (void)payViewDidClickSureBtnWithModel:(CYPayMethodModel *)payModel{
    //确认按钮
    if ([_db pay]) {
        [ProgressHUD showSuccess:@"支付成功"];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"didCompletePay" object:nil];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}
- (UILabel *)naviTitleLabel{
    if (!_naviTitleLabel) {
        _naviTitleLabel = [[UILabel alloc]init];
        _naviTitleLabel.text = @"支付确认";
        _naviTitleLabel.font =  CYDefaultTextFont(18);
        _naviTitleLabel.textColor = [UIColor whiteColor];
    }
    return _naviTitleLabel;
}
- (UIImageView *)listImgView{
    if (!_listImgView) {
        _listImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"firm_order_bg"]];
        
        _listImgView.userInteractionEnabled = YES;
        UIImageView *topImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"firm_order_list_ray_top"]];
        UIImageView *leftImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"firm_order_list_ray_left"]];
        UIImageView *rightImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"firm_order_list_ray_right"]];
        
        [_listImgView addSubview:topImageView];
        [_listImgView addSubview:leftImageView];
        [_listImgView addSubview:rightImageView];
        
        [topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(_listImgView);
            make.height.offset(30);
            make.centerY.equalTo(_listImgView.mas_top).offset(3);
            
        }];
        [leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(_listImgView);
            make.width.offset(30);
            make.centerX.equalTo(_listImgView.mas_left);
        }];
        [rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(_listImgView);
            make.width.offset(30);
            make.centerX.equalTo(_listImgView.mas_right);
        }];
    }
    return _listImgView;
}
- (UIImageView *)remarkBgImgView{
    if (!_remarkBgImgView) {
        _remarkBgImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"firm_order_remark_bg"]];
        _remarkBgImgView.userInteractionEnabled = YES;
        UIImageView *topImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"firm_order_ray_top"]];
        UIImageView *leftImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"firm_order_ray_left"]];
        UIImageView *rightImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"firm_order_ray_right"]];
        
        [_remarkBgImgView addSubview:topImageView];
        [_remarkBgImgView addSubview:leftImageView];
        [_remarkBgImgView addSubview:rightImageView];
        
        [topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(_remarkBgImgView);
            make.height.offset(30);
            make.centerY.equalTo(_remarkBgImgView.mas_top).offset(3);
            
        }];
        [leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(_remarkBgImgView);
            make.width.offset(30);
            make.centerX.equalTo(_remarkBgImgView.mas_left);
        }];
        [rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(_remarkBgImgView);
            make.width.offset(30);
            make.centerX.equalTo(_remarkBgImgView.mas_right);
        }];
    }
    return _remarkBgImgView;
}
- (UITableView *)orderTal{
    if (!_orderTal) {
        _orderTal =  [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _orderTal.delegate = self;
        _orderTal.dataSource = self;
        _orderTal.separatorStyle = UITableViewCellSeparatorStyleNone;
        _orderTal.backgroundColor = [UIColor clearColor];
        
    }
    return _orderTal;
}
- (UIImageView *)orderBgView{
    if (!_orderBgView) {
        _orderBgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"pay_order_bg"]];
        _orderBgView.userInteractionEnabled = YES;
    }
    return _orderBgView;
}
- (UIButton *)sureBtn{
    if (!_sureBtn) {
        _sureBtn = [[UIButton alloc]init];
        [_sureBtn addTarget:self action:@selector(didClickSureBtn:) forControlEvents:UIControlEventTouchUpInside];

    }
    return _sureBtn;
}
- (CountView *)countView{
    if (!_countView) {
        _countView = [[CountView alloc]init];

        _countView.discountLabel.text = @"优惠价:";
    }
    return _countView;
}
- (CYPayView *)payView{
    if (!_payView) {
        _payView = [[CYPayView alloc]init];
        _payView.delegate = self;
    }
    return _payView;
}
- (CYEvaluateView *)evaluateView{
    if (!_evaluateView) {
        _evaluateView = [[CYEvaluateView alloc]init];
        _evaluateView.hidden = YES;
        _evaluateView.delegate = self;
    }
    return _evaluateView;
}
@end
