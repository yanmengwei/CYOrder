//
//  DTScrollStatusView.m

//
//  Created by zhenyong on 16/4/30.
//  Copyright © 2016年 com.lnl. All rights reserved.
//

#import "DTScrollStatusView.h"
#import "CYMenuCollectionCell.h"
#import "PackageView.h"
#define collection_left_gap 18
#define collection_right_gap 35

CGFloat _iw;
@implementation DTScrollStatusView

#pragma mark - 初始化方法
-(instancetype)initWithFrame:(CGRect)frame;
{
    self = [super initWithFrame:frame];
//    [self setStatusViewWithTitle:titleArr];
    return self;
}
-(void)setStatusViewWithTitle:(NSArray *)titleArr
{
    self.statusView = [[DTStatusView alloc]init];
    self.statusView.delegate = self;
    self.statusView.isScroll = YES;
    [self addSubview:self.statusView];

    if (curNormalTabColor && curSelectTabColor) {
        [self.statusView setUpStatusButtonWithTitlt:titleArr NormalColor:curNormalTabColor SelectedColor:curSelectTabColor LineColor:DTColor(10, 193, 147, 1) type:DTStatusViewTypeTop];
    }
    else
    {
        [self.statusView setUpStatusButtonWithTitlt:titleArr NormalColor:DTColor(154, 156, 156, 1) SelectedColor:DTColor(10, 193, 147, 1) LineColor:DTColor(10, 193, 147, 1) type:DTStatusViewTypeTop];
    }
 
    
    _iw = CGRectGetWidth(self.frame);

    [self addSubview:self.mainScrollView];
    _tableArr = [NSMutableArray array];
    
    
    [self.statusView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.height.offset(45);
    }];
    [_mainScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(self.statusView.mas_bottom).offset(10);
        make.width.equalTo(self);
        make.bottom.equalTo(self);
    }];
    
    for ( int i = 0; i < titleArr.count; i++) {
        if (i == 4) {
            //如果是组合套餐
           _pView = [[PackageView alloc]init];
            [_mainScrollView addSubview:_pView];
            [_pView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.offset(0);
                make.left.offset(_iw*i+collection_left_gap);
                make.height.equalTo(_mainScrollView.mas_height).offset(0);
                make.width.equalTo(_mainScrollView.mas_width).offset(-collection_left_gap-collection_right_gap);
            }];
            if (_scrollStatusDelegate) {
                [self.scrollStatusDelegate refreshViewWithTag:i+1 andIsHeader:YES];
            }
            _pView.tag = i + 1;
            [self collectionViewLightEffect:_pView];
            [_tableArr addObject:_pView];
        }else{
            //如果是普通菜系
            UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
            UICollectionView *collectView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
            collectView.delegate = self;
            collectView.dataSource = self;
            collectView.tag = i+1;
            [collectView registerClass:[CYMenuCollectionCell class] forCellWithReuseIdentifier:@"menucellIdentifier"];
            if (_scrollStatusDelegate) {
                [self.scrollStatusDelegate refreshViewWithTag:i+1 andIsHeader:YES];
            }
            [_tableArr addObject:collectView];
            [_mainScrollView addSubview:collectView];
            [collectView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.offset(0);
                make.left.offset(_iw*i+collection_left_gap);
                make.height.equalTo(_mainScrollView.mas_height).offset(0);
                make.width.equalTo(_mainScrollView.mas_width).offset(-collection_left_gap-collection_right_gap);
            }];
            UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"menu_light"]];
            [collectView setBackgroundView:imageView];
            //添加光效
            [self collectionViewLightEffect:collectView];
        }
    }
    _mainScrollView.contentSize = CGSizeMake(_iw*titleArr.count, 0);
    //获取当前tableview
    if (_tableArr.count > 0) {
        _curCollView = _tableArr[0];
    }
}
- (void)collectionViewLightEffect:(UIView *)collectionView{
    UIImageView *topImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"menu_light_top"]];
    UIImageView *leftImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"menu_light_left"]];
    UIImageView *rightImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"menu_light_right"]];
    
    [_mainScrollView addSubview:topImageView];
    [_mainScrollView addSubview:leftImageView];
    [_mainScrollView addSubview:rightImageView];
    
    [topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(collectionView);
        make.height.offset(30);
        make.centerY.equalTo(collectionView.mas_top).offset(3);
        
    }];
    [leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(collectionView);
        make.width.offset(30);
        make.centerX.equalTo(collectionView.mas_left);
    }];
    [rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(collectionView);
        make.width.offset(30);
        make.centerX.equalTo(collectionView.mas_right);
    }];


}
#pragma mark--delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (_scrollStatusDelegate && [_scrollStatusDelegate respondsToSelector:@selector(collectionView:numberOfItemsInSection:)]) {
        return [_scrollStatusDelegate collectionView:collectionView numberOfItemsInSection:section];
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (_scrollStatusDelegate && [_scrollStatusDelegate respondsToSelector:@selector(collectionView:cellForItemAtIndexPath:)]) {
       return [_scrollStatusDelegate collectionView:collectionView cellForItemAtIndexPath:indexPath];
    }
    
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(nonnull NSIndexPath *)indexPath{
    if (_scrollStatusDelegate && [_scrollStatusDelegate respondsToSelector:@selector(collectionView:didSelectItemAtIndexPath:)]) {
        [_scrollStatusDelegate collectionView:collectionView didSelectItemAtIndexPath:indexPath];
    }
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_scrollStatusDelegate) {
        if ([_scrollStatusDelegate respondsToSelector:@selector(collectionView:layout:sizeForItemAtIndexPath:)]) {
          return  [_scrollStatusDelegate collectionView:collectionView layout:collectionViewLayout sizeForItemAtIndexPath:indexPath];
        }
    }
    return CGSizeMake(0, 0);
    
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    
    if (_scrollStatusDelegate) {
        if ([_scrollStatusDelegate respondsToSelector:@selector(collectionView:layout:minimumInteritemSpacingForSectionAtIndex:)]) {
         return [_scrollStatusDelegate collectionView:collectionView layout:collectionViewLayout minimumInteritemSpacingForSectionAtIndex:section];
        }
    }
    return 0;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (_scrollStatusDelegate && [_scrollStatusDelegate respondsToSelector:@selector(collectionView:layout:insetForSectionAtIndex:)]) {
       return  [_scrollStatusDelegate collectionView:collectionView layout:collectionViewLayout insetForSectionAtIndex:section];
    }
    return UIEdgeInsetsMake(10, 10, 0, 10);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if(![scrollView isKindOfClass:[UICollectionView class]])
    {
        if (isrefresh == NO) {
            int scrollIndex = scrollView.contentOffset.x/_iw;
            [_statusView changeTag:scrollIndex];
            _curCollView = _tableArr[scrollIndex];

        }
    }
}

- (void)statusViewSelectIndex:(NSInteger)index;
{
   [_mainScrollView setContentOffset:CGPointMake(_iw*index, 0) animated:YES];
    _curCollView = _tableArr[index];
}
#pragma mark - init
- (UIScrollView *)mainScrollView{
    if (!_mainScrollView) {
        _mainScrollView = [[UIScrollView alloc]init];

        _mainScrollView.delegate = self;
        _mainScrollView.bounces = NO;
        _mainScrollView.pagingEnabled = YES;
        _mainScrollView.scrollEnabled = YES;
        _mainScrollView.showsVerticalScrollIndicator = NO;
        _mainScrollView.showsHorizontalScrollIndicator = NO;
        _mainScrollView.userInteractionEnabled = YES;
    }
    return _mainScrollView;
}
@end
