//
//  RemarkSection.m
//  CYOrder
//
//  Created by ymw on 17/4/25.
//  Copyright © 2017年 ymw. All rights reserved.
//

#import "RemarkSection.h"
#define rows 3.0
#define gap  30
@interface RemarkSection(){
    UIButton *_perBtn;
    NSMutableArray *_btnArr;

}

@end
@implementation RemarkSection
- (instancetype)init
{
    self = [super init];
    if (self) {
        _btnArr = [NSMutableArray array];
    }
    return self;
}
- (void)setUpSubviews{
    for (int i = 0; i< _titles.count; i++) {
        int y = i/3;
        int x = i%3;
        UIButton *btn = [[UIButton alloc]init];
        [btn setTitle:_titles[i] forState:UIControlStateNormal];
        [btn setBackgroundColor:[UIColor whiteColor]];
        [btn setTitleColor:CYTextColor forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        btn.titleLabel.font = CYDefaultTextFont(15);
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = 5.0;
        [self addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(y*65);
            make.width.offset(80);
            make.height.offset(40);
            make.left.offset(x*115);
            if (i == _titles.count - 1) {
                make.bottom.equalTo(self.mas_bottom);
            }
        }];
        [btn addTarget:self action:@selector(didClickBtn:) forControlEvents:UIControlEventTouchUpInside];

        
    }
}
- (void)didClickBtn:(UIButton *)btn{
    btn.selected = !btn.selected;
    NSLog(@"%@",btn.titleLabel.text);
    if (btn.selected) {
        //选中
        [btn setBackgroundColor:[UIColor colorWithRed:255/255.0 green:128/255.0 blue:0 alpha:1]];
        [_btnArr addObject:btn.currentTitle];
    }else{
        //不选中
        [btn setBackgroundColor:[UIColor whiteColor]];
        if ([_btnArr containsObject:btn.currentTitle]) {
            [_btnArr removeObject:btn.currentTitle];
        }
    }
    
    if (self.isSingle) {
        //如果是单选
        [_btnArr removeAllObjects];
        if (![_perBtn isEqual:btn]) {
            _perBtn.selected = NO;
            _perBtn.backgroundColor = [UIColor whiteColor];
            [_btnArr addObject:btn.currentTitle];
            _perBtn = btn;
        }else{
            _perBtn = nil;
        }
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(remarkSection:didSelectBtnWithArr:)]) {
        [self.delegate remarkSection:self didSelectBtnWithArr:_btnArr];
    }
    
}
- (void)setTitles:(NSArray *)titles{
    _titles = titles;
    [self setUpSubviews];
}
@end
