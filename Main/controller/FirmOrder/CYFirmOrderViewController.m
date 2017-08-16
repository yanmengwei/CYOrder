//
//  CYFirmOrderViewController.m
//  CYOrder
//
//  Created by ymw on 17/4/19.
//  Copyright © 2017年 ymw. All rights reserved.
//

#import "CYFirmOrderViewController.h"
#import "CYFirmOrderCell.h"
#import "CountView.h"
#import "CYRemarksView.h"
#import "CYOrderModel.h"
#import "CYOrderListModel.h"
#import "CYHintView.h"
@interface CYFirmOrderViewController ()<UITableViewDataSource,UITableViewDelegate,CYRemarksViewDelegate,UIAlertViewDelegate,CYHintViewDelegate>{
    NSString *_reStr;
}
@property (nonatomic,strong) UIImageView *listImgView;

@property (nonatomic,strong) UIImageView *remarkBgImgView;
@property (nonatomic,strong) UIImageView *remarksImgView;
@property (nonatomic,strong) UILabel *naviTitleLabel;

@property (nonatomic,strong) UITableView *orderTal;
@property (nonatomic,strong) UIImageView *orderBgView;
@property (nonatomic,strong) UIButton *sureBtn;
@property (nonatomic,strong) CountView *countView;

@property (nonatomic,strong) CYRemarksView *remarksView;

@end

@implementation CYFirmOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _reStr = [NSString string];
    [self configSubviews];
    [self setUpSubviews];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)setUpSubviews{
    __weak UIView *superview = self.view;
    [superview addSubview:self.naviTitleLabel];
    [superview addSubview:self.listImgView];
    [superview addSubview:self.remarkBgImgView];
    [superview addSubview:self.orderBgView];
    [self.orderBgView addSubview:self.sureBtn];
    [self.orderBgView addSubview:self.countView];
    [self.orderBgView addSubview:self.orderTal];
    [self.remarkBgImgView addSubview:self.remarksView];

    
    
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
        make.width.offset(120);
        make.height.offset(50);
        make.centerX.equalTo(self.orderBgView);
        make.bottom.offset(-50);
    }];
    
    [self.countView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.sureBtn.mas_top).offset(-40);
        make.height.offset(65);
        make.width.offset(140);
        make.right.offset(-24);
    }];
    
    [self.remarksView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.remarkBgImgView).offset(12);
        make.bottom.right.equalTo(self.remarkBgImgView).offset(-12);

    }];
    
    
    
}

- (void)didClickSureBtn:(UIButton *)sender{
    CYOrderModel *orderModel = [[CYOrderModel alloc]init];
    orderModel.total = [CYTools countWithArr:self.orderArr];
    orderModel.remarks = _reStr;
    orderModel.packageArr = [NSMutableArray arrayWithArray:self.packageArr];
    
    orderModel.orderListModelArr = [NSMutableArray arrayWithArray:self.orderArr];
    BOOL isSuccess =    [_db insertOrder:orderModel];
    if (isSuccess) {
        CYHintView *hintView = [[CYHintView alloc]initWithTitles:@"您的订单已经提交成功" buttonArr:@[@"确定"] ];
        hintView.delegate = self;
        hintView.tag = 420;
        [hintView show];

    }
    
    
}
- (void)didClickReturnBtn:(UIButton *)sender{

    CYHintView *hintView = [[CYHintView alloc]initWithTitles:@"返回将不会保存当前的订单备注，您确定要返回吗？" buttonArr:@[@"确定",@"取消"]];
    hintView.delegate = self;
    [hintView show];
}
#pragma mark - delegate
- (void)hintView:(CYHintView *)hintview didSelcetBtnAtIndex:(NSInteger)index{
    if (index == 0) {
        if (hintview.tag == 420) {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"didOrderNoti" object:nil];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didChangeRemark:(NSArray *)arr{
    NSLog(@"%@",arr);
    _reStr = [arr componentsJoinedByString:@";"];
    NSLog(@"-----    %@",_reStr);
}
#pragma mark - tableview delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.orderArr.count + self.packageArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CYFirmOrderCell *cell = [CYFirmOrderCell cellWithTableView:tableView];

    if (indexPath.row < self.orderArr.count) {
        CYOrderListModel *orderListModel  = self.orderArr[indexPath.row];

        cell.menuModel = orderListModel;
    }else{
        CYOrderListModel *orderListModel  = self.packageArr[indexPath.row-self.orderArr.count];

        cell.packageModel = orderListModel.packageModel;

    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)setOrderArr:(NSArray *)orderArr
{
    _orderArr = orderArr;
    [self.orderTal reloadData];
}
- (void)setOrderModel:(CYOrderModel *)orderModel{
    _orderModel = orderModel;
    self.countView.countLabel.text = [NSString stringWithFormat:@"%.1f",[CYTools countWithOrderModel:self.orderModel]];
    self.countView.vipCountLabel.text =[NSString stringWithFormat:@"%.1f",[CYTools countWithOrderModel:self.orderModel]*0.9];
}
- (UILabel *)naviTitleLabel{
    if (!_naviTitleLabel) {
        _naviTitleLabel = [[UILabel alloc]init];
        _naviTitleLabel.text = @"点单确认";
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
        _orderBgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"firm_order_list_bg"]];
        _orderBgView.userInteractionEnabled = YES;
    }
    return _orderBgView;
}
- (UIButton *)sureBtn{
    if (!_sureBtn) {
        _sureBtn = [[UIButton alloc]init];
        [_sureBtn addTarget:self action:@selector(didClickSureBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_sureBtn setImage:[UIImage imageNamed:@"btn_sure_order"] forState:UIControlStateNormal];
    }
    return _sureBtn;
}
- (CountView *)countView{
    if (!_countView) {
        _countView = [[CountView alloc]init];
        
        _countView.countLabel.text = [NSString stringWithFormat:@"%.1f",[CYTools countWithOrderModel:self.orderModel]];
        _countView.vipCountLabel.text =[NSString stringWithFormat:@"%.1f",[CYTools countWithOrderModel:self.orderModel]*0.9];
    }
    return _countView;
}
- (CYRemarksView *)remarksView{
    if (!_remarksView) {
        _remarksView = [[CYRemarksView alloc]init];
        _remarksView.delegate = self;
        
        
    }
    return _remarksView;
}
@end
