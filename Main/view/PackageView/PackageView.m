//
//  PackageView.m
//  CYOrder
//
//  Created by ymw on 17/6/1.
//  Copyright © 2017年 ymw. All rights reserved.
//

#import "PackageView.h"
#import "PackageHeaderView.h"
#import "CYMenuCollectionCell.h"
#define collection_left_gap 0
#define collection_right_gap 0
#define PACKAGE_COLLECTVIEW_TAG 410
static NSString *const reuseIdentifier  = @"packageCellReuseIdentifier";

@interface PackageView()<UICollectionViewDelegate,UICollectionViewDataSource,CYMenuCollectionCellDelegate,PackageHeaderViewDelegate>{
    UIImageView *_bgImageView;
    PackageHeaderView *_headerView;
    UIScrollView *_scrollView;
    CGFloat _iw;
    NSMutableArray *_collectionArr;
    UILabel *_hintLabel;
    UIButton *_addBtn;
    NSInteger _currentIndex;
}


@end
@implementation PackageView
#pragma mark DTStatusView的delegate
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        _collectionArr = [NSMutableArray array];
        
//        [self setupSubviews];
    }
    return self;
}
- (void)setupSubviews{
    if (!_bgImageView) {
        _bgImageView =  [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"menu_light"]];
        [self addSubview:_bgImageView];
        _bgImageView.userInteractionEnabled = YES;
        [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.equalTo(self);
        }];
    }

    if (!_headerView) {
        _headerView  = [[PackageHeaderView alloc]init];
        [self addSubview:_headerView];
        _headerView.delegate = self;
        [_headerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(15);
            make.left.offset(10);
            make.right.offset(-20);
            make.height.offset(35);
        }];
    }
    if (!_addBtn) {
        _addBtn = [[UIButton alloc]init];
        [_addBtn addTarget:self action:@selector(addPackageWithBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_addBtn setBackgroundImage:[UIImage imageNamed:@"btn_add_one_key"] forState:UIControlStateNormal];
        [self addSubview:_addBtn];
        [_addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.offset(110);
            make.height.offset(38);
            make.centerX.equalTo(self);
            make.bottom.offset(-16);
        }];
    }
    _headerView.titleArr = self.packageModelArr;
    

    if (!_hintLabel) {
        _hintLabel  = [[UILabel alloc]init];
        _hintLabel.textColor = [UIColor whiteColor];
        _hintLabel.font = [UIFont systemFontOfSize:16];
        CYPackageModel *model = [self.packageModelArr firstObject];
        _hintLabel.text = [NSString stringWithFormat:@"共%ld道菜,是否一键加入我的订单？", model.packageLists.count];
        [self addSubview:_hintLabel];
        [_hintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.bottom.equalTo(_addBtn.mas_top).offset(-16);
        }] ;
    }
    
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]init];
        [self addSubview:_scrollView];
        [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
            make.top.equalTo(_headerView.mas_bottom);
        }];
    }
    
     //如果是普通菜系
    for (int i = 0; i< self.packageModelArr.count; i++) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        UICollectionView *collectView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        collectView.delegate = self;
        collectView.dataSource = self;
        collectView.tag = i+ PACKAGE_COLLECTVIEW_TAG;
        [collectView registerClass:[CYMenuCollectionCell class] forCellWithReuseIdentifier:reuseIdentifier];
        [_scrollView addSubview:collectView];
        collectView.backgroundColor = [UIColor clearColor];
        
        [collectView mas_makeConstraints:^(MASConstraintMaker *make) {
            UICollectionView *collect =  [_collectionArr lastObject];
            if (collect) {
                make.left.equalTo(collect.mas_right);
            }else{
                make.left.equalTo(_scrollView);
            }
            make.top.offset(0);
            make.bottom.equalTo(_hintLabel.mas_top).offset(-20);
            make.width.equalTo(_scrollView.mas_width);
        }];
        [_collectionArr addObject:collectView];
    }
    
    [self bringSubviewToFront:_addBtn];
}
#pragma mark - 点击了一键加入
- (void)addPackageWithBtn:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectAddBtn:)]) {
        [self.delegate didSelectAddBtn:self.packageModelArr[_currentIndex]];
    }
}
#pragma mark -头部代理
-(void)headerViewSelectIndex:(NSInteger)index{
    _iw = CGRectGetWidth(self.frame);
    [_scrollView setContentOffset:CGPointMake(_iw*index, 0) animated:YES];
    CYPackageModel *model = self.packageModelArr[index];
    _hintLabel.text = [NSString stringWithFormat:@"共%ld道菜,是否一键加入我的订单？", model.packageLists.count];
    _currentIndex = index;

}
#pragma mark - 单元格代理
-(void)cell:(CYMenuCollectionCell *)cell didClickDetailBtnWithMenuModel:(CYMenuModel *)model{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSeleceCellWithModel:)]) {
        [self.delegate didSeleceCellWithModel:model];
    }
    
}
#pragma mark collectionview的delegate&datasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    CYPackageModel *packeageModel = self.packageModelArr[collectionView.tag - PACKAGE_COLLECTVIEW_TAG];
    
    return packeageModel.packageLists.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CYPackageModel *packModel = self.packageModelArr[collectionView.tag -PACKAGE_COLLECTVIEW_TAG];

    CYMenuCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    if (!cell) {
        cell = [[CYMenuCollectionCell alloc]init];
    }
    if (packModel.packageLists.count > indexPath.row) {
        cell.model = packModel.packageLists[indexPath.row];
    }
    cell.delegate =  self;
    return cell;
}
#pragma mark - flowlayoutDelegate
//设置每个item的尺寸
//分类中的单元格均在此设计
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat iw = (CGRectGetWidth(self.frame)- CollectionCellGap*4)/3;
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


- (void)setPackageModelArr:(NSArray *)packageModelArr{
    _packageModelArr = packageModelArr;
    [self setupSubviews];
}

@end

