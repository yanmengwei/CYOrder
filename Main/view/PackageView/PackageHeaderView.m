//
//  PackageHeaderView.m
//  CYOrder
//
//  Created by ymw on 17/6/1.
//  Copyright © 2017年 ymw. All rights reserved.
//

#import "PackageHeaderView.h"
#define BTN_TAG  370
#define BTN_WIDTH 140
@interface PackageHeaderView(){
    NSMutableArray *_btnArr;
    UIButton *_tagBtn;
    CYPackageModel *_currentModel;

}
@property (nonatomic,strong) UIScrollView *scrollView;
@end
@implementation PackageHeaderView
-(instancetype)init{
    self = [super init];
    if (self) {
        _btnArr = [NSMutableArray array];
    }
    return self;
}
- (void)setupSubviews{
    
    [self addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.height.equalTo(self);
    }];
    

    for (UIView *view in _btnArr) {
        [view removeFromSuperview];
    }
    for (int i = 0; i < self.titleArr.count; i++) {
        CYPackageModel *packageModel = self.titleArr[i];
        UIButton *btn = [[UIButton alloc]init];
        [btn setTitle:packageModel.name forState:UIControlStateNormal];
        btn.tag = BTN_TAG + i;
        [_btnArr addObject:btn];
        [self.scrollView addSubview:btn];
        if (i == 0) {
            btn.titleLabel.font = CYDefaultTextFont(18);
            NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:btn.currentTitle];
            //斜体字体
            [attrStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica-BoldOblique" size:18] range:NSMakeRange(0,attrStr.length)];
        
            [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:126/255.0 green:252/255.0 blue:184/255.0 alpha:1] range:NSMakeRange(0,attrStr.length)];
            [btn.titleLabel setAttributedText:attrStr];
            _tagBtn = btn;
        }else{
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:16];
        }
        [btn addTarget:self action:@selector(didSelectBtn:) forControlEvents:UIControlEventTouchUpInside];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(i * BTN_WIDTH);
            make.height.top.equalTo(self.scrollView);
            make.width.offset(BTN_WIDTH);
        }];
        if (i < self.titleArr.count - 1) {
            //添加白线
            UIView *lineView = [[UIView alloc]init];
            lineView.backgroundColor = [UIColor whiteColor];
            [self.scrollView addSubview:lineView];
            [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.offset(22);
                make.width.offset(2);
                make.centerY.equalTo(btn.mas_centerY);
                make.left.equalTo(btn.mas_right).offset(-1);
            }];
        }
    }
    self.scrollView.contentSize = CGSizeMake(self.titleArr.count * BTN_WIDTH, 0);
    self.scrollView.userInteractionEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator =  NO;
}
- (void)didSelectBtn:(UIButton *)btn{
    if ([btn isEqual:_tagBtn]) {
        //如果现在点中的是前一个点中的
        btn.titleLabel.font = CYDefaultTextFont(18);
        btn.titleLabel.textColor = [UIColor colorWithRed:126/255.0 green:252/255.0 blue:184/255.0 alpha:1];
        _tagBtn = btn;
    }else{
        btn.titleLabel.font = CYDefaultTextFont(18);
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:btn.currentTitle];
        //斜体字体
        [attrStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica-BoldOblique" size:18] range:NSMakeRange(0,attrStr.length)];
        [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:126/255.0 green:252/255.0 blue:184/255.0 alpha:1] range:NSMakeRange(0,attrStr.length)];
        [btn.titleLabel setAttributedText:attrStr];
        
        _tagBtn.titleLabel.font = CYDefaultTextFont(16);
        _tagBtn.titleLabel.textColor = [UIColor whiteColor];
        _tagBtn = btn;
    }
    if (self.delegate &&  [self.delegate respondsToSelector:@selector(headerViewSelectIndex:)]) {
        [self.delegate headerViewSelectIndex:btn.tag - BTN_TAG];
    }
}

- (void)setTitleArr:(NSArray *)titleArr{
    _titleArr = titleArr;
    [self setupSubviews];
}
- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]init];
        _scrollView.userInteractionEnabled = YES;
    }
    return _scrollView;
}

@end
