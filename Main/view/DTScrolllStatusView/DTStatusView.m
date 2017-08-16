//
//  BSOrderStatusView.m
//  BuyAndSend
//
//  Created by  on 16/3/24.
//  Copyright © 2016年 mjia. All rights reserved.
//


#import "DTStatusView.h"
#import "CYCategoryModel.h"
#define BTN_TAG 340
CGFloat width ;
NSInteger cloum = 6;
@interface DTStatusView()
@property (nonatomic,strong) UIScrollView *scrollView;

@end
@implementation DTStatusView

//界面搭建
- (void)setUpStatusButtonWithTitlt:(NSArray *)titleArray NormalColor:(UIColor *)normalColor SelectedColor:(UIColor *)selectedColor LineColor:(UIColor *)lineColor type:(DTStatusViewType)type{
    
    _scrollView = [[UIScrollView alloc]init];
    [self addSubview:_scrollView];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.height.equalTo(self);
    }];
    _scrollView.userInteractionEnabled = YES;
    //按钮创建
    width =(Main_Screen_Width - 250)/cloum;
    for (int i = 0; i < titleArray.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        if (type == DTStatusViewTypeTop) {
            CYCategoryModel *categoryModel = titleArray[i];
            button.titleLabel.font = CYDefaultTextFont(18);
            [button setTitle:categoryModel.name forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            [button setBackgroundImage:[UIImage imageNamed:@"main_top_select"] forState:UIControlStateSelected];
        }else{
            
        }
        button.tag = i+340;
        [button addTarget:self action:@selector(buttonTouchEvent:) forControlEvents:UIControlEventTouchUpInside];
       
        [_scrollView addSubview:button];
        [self.buttonArray addObject:button];
        
        if (i == 0) {
            button.selected = YES;
        }
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(width*i);
            make.top.equalTo(_scrollView.mas_top);
            make.width.offset(width);
            make.height.equalTo(_scrollView.mas_height);
        }];
    }
    _scrollView.contentSize = CGSizeMake(titleArray.count * width, 0);
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    self.currentIndex = 0;
    //线条
    if (lineColor) {
        
        self.lineView.frame = CGRectMake(0, self.frame.size.height-2, width, 2);
        self.lineView.backgroundColor = lineColor;
    }
    

    
}

//状态切换
- (void)buttonTouchEvent:(UIButton *)button{
    
    
    if (button.tag-BTN_TAG == self.currentIndex) {
        return;
    }
    //代理方法
    if (self.delegate && [self.delegate respondsToSelector:@selector(statusViewSelectIndex:)]) {
        
        [self.delegate statusViewSelectIndex:button.tag-BTN_TAG];
    }
    if (_isScroll) {
        [self changeTag:button.tag-BTN_TAG];
    }
    }

#pragma 懒加载
- (NSMutableArray *)buttonArray{
    
    if (!_buttonArray) {
        _buttonArray = [NSMutableArray array];
    }
    
    return _buttonArray;
}
-(void)changeTag:(NSInteger)tag
{
    //打开状态
    UIButton *button = self.buttonArray[tag];
    self.currentIndex = tag;
    button.selected = YES;

    
    //关闭上一个选择状态
    for (int i = 0; i < self.buttonArray.count; i++) {
        if (i != self.currentIndex) {
            UIButton *button = self.buttonArray[i];
            button.selected = NO;
        }
    }

    CGFloat iw = CGRectGetWidth(_scrollView.frame);
    NSInteger pageIndex = tag/cloum;
    [_scrollView setContentOffset:CGPointMake(iw * pageIndex, 0)];


}
//下面滑动的横线
- (UIView *)lineView{

    if (!_lineView) {
        
        _lineView = [[UIView alloc] init];
//        [self addSubview:self.lineView];
    }
    return _lineView;
}


@end
