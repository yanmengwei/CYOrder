
//
//  menuViewController.m
//  CYOrder
//
//  Created by ymw on 17/4/1.
//  Copyright © 2017年 ymw. All rights reserved.
//

#import "CYMenuViewController.h"
#import "CYMenuCollectionCell.h"
#import "OrderListView.h"
#import "CYCategoryModel.h"
#import "DTScrollStatusView.h"
#import "CYDetailViewController.h"
#import "CYFirmOrderViewController.h"
#import "CYPayVC.h"
#import "CYOrderModel.h"
#import "PackageView.h"
#import "CYDailySpecialModel.h"
@interface CYMenuViewController ()<DTScrollStatusDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,OrderListViewDelegate,CYMenuCollectionCellDelegate,UITextFieldDelegate,PackageViewDelegate>{
    //菜系数组
    NSArray *_categoryArr;
    //菜谱数组
    NSArray *_menuArr;
    
    NSArray *_packageArr;
    
    NSArray *_orderedArr;
    
    //正在点的订单
    CYOrderModel *_orderModel;
    
    //已经点过的订单
    NSArray *_orderedModelArr;
    NSInteger _tag;

}

@property (nonatomic,strong) DTScrollStatusView *scrollTapView;
@property (nonatomic,strong) UIView *orderListView;
@property (nonatomic,strong) OrderListView *listView;
@property (nonatomic,strong) UIImageView  *adView;
@property (nonatomic,strong) UITextField *searchTextField;
//@property (nonatomic,strong)
@end

@implementation CYMenuViewController
static NSString *const menucellIdentifier = @"menucellIdentifier";
- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"success");
    _categoryArr = [_db getAllCategory];
    [self configSubviews];
    [self setUpSubviews];
    [self showLeftView];
//    [self showRihtView];
    [self didSureOrderWithNoti:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didSureOrderWithNoti:) name:@"didOrderNoti" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didCompletePayWithNoti:) name:@"didCompletePay" object:nil];
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"didOrderNoti" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"didCompletePay" object:nil];

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

}


- (void)didSureOrderWithNoti:(NSNotification *)noti{
    _orderedModelArr = [_db getOrderList];
    CYCategoryModel *category = _categoryArr[_tag-1];
    _menuArr = [_db getMenusWithCategryId:category.category_id];
    if (_tag == 5) {
        self.scrollTapView.pView.packageModelArr = _menuArr;
    }
    self.listView.orderArr = _orderedModelArr;
}
- (void)didCompletePayWithNoti:(NSNotification *)noti{
    _orderedModelArr = [_db getOrderList];
    self.listView.orderArr = _orderedModelArr;
    
}
- (void)setUpSubviews{
    __weak UIView *superview = self.view;

    [superview addSubview:self.orderListView];
    [superview addSubview:self.scrollTapView];
    [superview addSubview:self.searchTextField];
    [self.orderListView addSubview:self.listView];
    [self.orderListView addSubview:self.adView];
    
    /**1
     订单光线
     */
    UIImageView *leftImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"order_list_left"]];
    UIImageView *rightImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"order_list_left"]];
    UIImageView *light = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"order_light"]];
    [superview addSubview:light];
    [superview addSubview:leftImageView];
    [superview addSubview:rightImageView];
    
    [leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(30);
        make.height.equalTo(self.orderListView.mas_height).offset(1.5);
        make.centerY.equalTo(self.orderListView);
        make.centerX.equalTo(_orderListView.mas_left);
    }];
    [rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(30);
        make.height.equalTo(self.orderListView.mas_height).offset(1.5);
        make.centerY.equalTo(self.orderListView);
        make.centerX.equalTo(_orderListView.mas_right);
    }];
    
    [light mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.orderListView);
        make.height.offset(30);
        make.centerY.equalTo(self.orderListView.mas_top).offset(3);
    }];
    
    


    //搜索栏
    [self.searchTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(40);
        make.top.mas_equalTo(self.logoView.mas_bottom).offset(8);
        make.height.offset(30);
        make.right.mas_equalTo(self.scrollTapView.mas_left).offset(-48);
    }];
    //左侧订单列
    [self.orderListView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(superview).offset(30);
        make.width.offset(220);
        make.bottom.equalTo(superview).offset(-12);
        make.top.mas_equalTo(self.searchTextField.mas_bottom).offset(12);
    }];
    //广告图
    [self.adView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(15);
        make.right.offset(-12);
        make.left.offset(12);
        make.height.mas_equalTo(self.adView.mas_width);
    }];
    //我的订单
    [self.listView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.orderListView.mas_bottom);
        make.left.offset(12);
        make.right.offset(-12);
        make.top.mas_equalTo(self.adView.mas_bottom).offset(12);
        /**
         *
         */
    }];
    //选项卡
    [self.scrollTapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.logoView.mas_bottom);
        make.left.mas_equalTo(self.orderListView.mas_right);
        make.right.mas_equalTo(superview);
        make.bottom.offset(-12);
    }];
    
    
    self.searchTextField.hidden = YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    
}

#pragma mark - delegate
#pragma mark - delegate
- (void)leftDrawerView:(LeftDrawerView *)leftView didSelectAtIndex:(NSInteger)index{
    if ([leftView isEqual:self.leftView]) {
        NSLog(@"点击了服务");
    }
}
#pragma mark orderListDelegate 点击了提交订单按钮
- (void)orderListViewDidClickSubmitBtnWithOrderModel:(CYOrderModel *)orderModel{
    _orderModel = orderModel;
    if (orderModel.orderListModelArr.count > 0  || orderModel.packageArr.count > 0 ||[_db getOrderList].count == 0) {
        CYFirmOrderViewController *firmOrderVC = [[CYFirmOrderViewController alloc]init];
        firmOrderVC.orderArr = orderModel.orderListModelArr;
        firmOrderVC.packageArr = orderModel.packageArr;
        firmOrderVC.orderModel = orderModel;
        [self.navigationController pushViewController:firmOrderVC animated:YES];
    }else{
        CYPayVC *payVC = [[CYPayVC alloc]init];
        [self.navigationController pushViewController:payVC animated:YES];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    [self closeViews];
}
#pragma mark - 套餐代理
//点击了单元格
- (void)didSeleceCellWithModel:(CYMenuModel *)model{
    CYDetailViewController *detailVC = [[CYDetailViewController alloc]init];
    detailVC.menuModel = model;
    [self.navigationController pushViewController:detailVC animated:YES];
}
#pragma mark - 一键加入
- (void)didSelectAddBtn:(CYPackageModel *)packageModel{
    [self.listView addPackageWithPackage:packageModel];
}
#pragma mark - cellDelegate 点击详情 跳转页面
- (void)cell:(CYMenuCollectionCell *)cell didClickDetailBtnWithMenuModel:(CYMenuModel *)model{
//    [self closeViews];
    NSLog(@"点击详情 %@",model);
    CYDetailViewController *detailVC = [[CYDetailViewController alloc]init];
    detailVC.menuModel = model;
    [self.navigationController pushViewController:detailVC animated:YES];
    
}
#pragma mark - textfieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@"\n"]) {
        [textField resignFirstResponder];
    }
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
//    [self closeViews];
}
#pragma mark - 搜索
- (void)textFieldDidEndEditing:(UITextField *)textField{
    NSLog(@"要搜索与%@有关的食物",textField.text);
}
#pragma mark DTStatusView的delegate
-(void)refreshViewWithTag:(int)tag andIsHeader:(BOOL)isHeader{
    //分类页面刷新数据
    
    CYCategoryModel *category = _categoryArr[tag-1];
    _menuArr = [_db getMenusWithCategryId:category.category_id];
    if (tag == 5) {
        self.scrollTapView.pView.packageModelArr = _menuArr;
    }
    _tag = tag;
}
#pragma mark collectionview的delegate&datasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    CYCategoryModel *categoryModel = _categoryArr[collectionView.tag -1];
    _menuArr = [_db getMenusWithCategryId:categoryModel.category_id];
    return _menuArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CYCategoryModel *categoryModel = _categoryArr[collectionView.tag -1];
    _menuArr = [_db getMenusWithCategryId:categoryModel.category_id];
    CYMenuCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:menucellIdentifier forIndexPath:indexPath];
    if (!cell) {
        cell = [[CYMenuCollectionCell alloc]init];
    }
    if (_menuArr.count > indexPath.row) {
        if ([_menuArr[indexPath.row] isKindOfClass:[CYMenuModel class]])  {
            cell.model = _menuArr[indexPath.row];
        }else{
            if ([_menuArr[indexPath.row] isKindOfClass:[CYDailySpecialModel class]]) {
                cell.dailyModel = _menuArr[indexPath.row];
            }
        }
    }
    cell.delegate =  self;
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(nonnull NSIndexPath *)indexPath{
    [self closeViews];
    CYMenuCollectionCell *cell = (CYMenuCollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [self.listView addAFoodWithFoodModel:cell.model];
}
#pragma mark - flowlayoutDelegate
//设置每个item的尺寸
//分类中的单元格均在此设计
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat iw = (CGRectGetWidth(self.scrollTapView.curCollView.frame)- CollectionCellGap*4)/3;
    return CGSizeMake(iw ,iw);
    
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 20;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 20;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(12, 20, 20, 20);
}



#pragma mark - init

- (UIView *)orderListView{
    if (!_orderListView) {
        _orderListView = [[UIView alloc]init];
        _orderListView.layer.masksToBounds = YES;
        UIImageView *bg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"order_bg"]];
        [_orderListView addSubview:bg];
        [bg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.height.equalTo(_orderListView);
        }];
    }
    return _orderListView;   
}
- (OrderListView *)listView{
    if (!_listView) {
        _listView = [[OrderListView alloc]init];
        _listView.delegate = self;
        
    }
    return _listView;
}
- (UIImageView *)adView{
    if (!_adView) {
        _adView = [[UIImageView alloc]init];
        _adView.backgroundColor = [UIColor whiteColor];
        [_adView setImage:[UIImage imageNamed:@"default_pic"]];
    }
    return _adView;
}
- (DTScrollStatusView *)scrollTapView{
    if (!_scrollTapView) {
        _scrollTapView = [[DTScrollStatusView alloc]initWithFrame:CGRectMake(300, 20, Main_Screen_Width-250, Main_Screen_Height-56)];
        _scrollTapView.scrollStatusDelegate = self;
        [_scrollTapView setStatusViewWithTitle:_categoryArr];
        _scrollTapView.pView.delegate = self;
    }
    return _scrollTapView;
}

- (UITextField *)searchTextField{
    if (!_searchTextField) {
        _searchTextField = [[UITextField alloc]init];
//        _searchTextField.searchBarStyle = UISearchBarStyleMinimal;
        _searchTextField.backgroundColor = [UIColor whiteColor];
        _searchTextField.layer.masksToBounds = YES;
        _searchTextField.layer.cornerRadius = 15;
        _searchTextField.font = [UIFont systemFontOfSize:15];
        UIView *leftview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        _searchTextField.leftViewMode = UITextFieldViewModeAlways;
        _searchTextField.leftView = leftview;
        
        UIImageView *rightview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 50, 20)];
        rightview.contentMode = UIViewContentModeScaleAspectFit;
        [rightview setImage:[UIImage imageNamed:@"search"]];

        _searchTextField.rightViewMode = UITextFieldViewModeAlways;
        _searchTextField.rightView = rightview;
        _searchTextField.placeholder = @"搜索";
        _searchTextField.delegate = self;
    }
   return _searchTextField;
}

@end
