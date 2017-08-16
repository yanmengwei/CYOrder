//
//  CYRemarksView.m
//  CYOrder
//
//  Created by ymw on 17/4/25.
//  Copyright © 2017年 ymw. All rights reserved.
//

#import "CYRemarksView.h"
#import "RemarkSection.h"
@interface CYRemarksView()<UITextViewDelegate,RemarkSectionDelegate>
{
    NSArray *_titles;
    UIImageView *_imageview;
    NSArray *_tasteSelectArr;
    NSArray *_spicySelectArr;
    NSArray *_specialSelectArr;
    NSMutableArray *_selectArr;
}

/**
 *  口味
 */
@property (nonatomic,strong) RemarkSection *tasteSection;
/**
 *  辣度
 */
@property (nonatomic,strong) RemarkSection *spicySection;
/**
 *  其他
 */
@property (nonatomic,strong) RemarkSection *specialSection;

/**
 *  自定义备注
 */
@property (nonatomic,strong) UITextView *remarkTf;

@property (nonatomic,strong) UILabel *placeholderLabel;
@end


@implementation CYRemarksView
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setUp];
        _selectArr = [NSMutableArray array];
    }
    return self;
}
- (void)setUp{
    
    _imageview = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"firm_order_remark_bottom"]];
    [self addSubview:_imageview];
    _imageview.userInteractionEnabled = YES;
    __weak UIView *superview = _imageview;

    [superview addSubview:self.tasteSection];
    [superview addSubview:self.spicySection];
    [superview addSubview:self.specialSection];
    [superview addSubview:self.remarkTf];
    [superview addSubview:self.placeholderLabel];
    [_imageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self);
    }];
    [self.tasteSection mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(75);
        make.left.offset(22);
        make.right.offset(-22);
    }];
    
    [self.spicySection mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tasteSection.mas_bottom).offset(24);
        make.left.offset(22);
        make.right.offset(-22);
    }];
    [self.specialSection mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.spicySection.mas_bottom).offset(24);
        make.left.offset(22);
        make.right.offset(-22);
    }];
    [self.remarkTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(22);
        make.right.offset(-22);
        make.bottom.offset(-30);
        make.top.equalTo(self.specialSection.mas_bottom).offset(30);
    }];
    
    [self.placeholderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.remarkTf).offset(15);
    }];
    
    UILabel *hintLabel = [[UILabel alloc]init];
    hintLabel.text = @"可以向厨师备注您的要求哦";
    hintLabel.textColor = CYTextColor;
    
    //设置反射。倾斜15度
    CGAffineTransform matrix =  CGAffineTransformMake(1, 0, tanf(15 * (CGFloat)M_PI / 180), 1, 0, 0);
    //取得系统字符并设置反射
    UIFontDescriptor *desc = [ UIFontDescriptor fontDescriptorWithName :[ UIFont systemFontOfSize :17 ]. fontName matrix :matrix];
    hintLabel.font = [UIFont fontWithDescriptor :desc size :14];//设置字体为斜体
    [superview addSubview:hintLabel];
    
    [hintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(30);
        make.centerX.equalTo(superview);
    }];


}
#pragma mark - textviewdeleagte

-(void)textViewDidEndEditing:(UITextView *)textView{
    if (textView.text.length == 0) {
        self.placeholderLabel.hidden = NO;

    }
    [UIView animateWithDuration:0.3 delay:0.2 options:UIViewAnimationOptionLayoutSubviews animations:^{
        [self.remarkTf mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(22);
            make.right.offset(-22);
            make.bottom.offset(-30);
            make.top.equalTo(self.specialSection.mas_bottom).offset(30);
        }];
        [self.placeholderLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(self.remarkTf).offset(15);
        }];
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];

}
-(void)textViewDidBeginEditing:(UITextView *)textView{
    self.placeholderLabel.hidden = YES;
    [UIView animateWithDuration:0.3 delay:0.2 options:UIViewAnimationOptionLayoutSubviews animations:^{
        [self.remarkTf mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(22);
            make.right.offset(-22);
            make.height.offset(400);
            make.top.offset(22);
        }];
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];
    [_selectArr removeAllObjects];
    [_selectArr addObjectsFromArray:_tasteSelectArr];
    [_selectArr addObjectsFromArray:_specialSelectArr];
    [_selectArr addObjectsFromArray:_spicySelectArr];
    [_selectArr addObject:self.remarkTf.text];
    if (self.delegate && [self.delegate respondsToSelector:@selector(didChangeRemark:)]) {
        [self.delegate didChangeRemark:_selectArr];
    }
}
- (void)remarkSection:(RemarkSection *)section didSelectBtnWithArr:(NSArray *)arr{
    [_selectArr removeAllObjects];
    if ([section isEqual:self.tasteSection]) {
        _tasteSelectArr = [NSArray arrayWithArray:arr];
    }
    if ([section isEqual:self.specialSection]) {
        _specialSelectArr = [NSArray arrayWithArray:arr];
    }
    else if([section isEqual:self.spicySection]){
        _spicySelectArr = [NSArray arrayWithArray:arr];
    }
    [_selectArr addObjectsFromArray:_tasteSelectArr];
    [_selectArr addObjectsFromArray:_specialSelectArr];
    [_selectArr addObjectsFromArray:_spicySelectArr];
    [_selectArr addObject:self.remarkTf.text];
    if (self.delegate && [self.delegate respondsToSelector:@selector(didChangeRemark:)]) {
        [self.delegate didChangeRemark:_selectArr];
    }
}
- (RemarkSection *)tasteSection{
    if (!_tasteSection) {
        _tasteSection = [[RemarkSection alloc]init];
        _tasteSection.titles = @[@"口味淡",@"口味重"];
        _tasteSection.isSingle = YES;
        _tasteSection.delegate = self;
    }
    return _tasteSection;
}
-(RemarkSection *)specialSection{
    if (!_specialSection) {
        _specialSection = [[RemarkSection alloc]init];
        
        _specialSection.titles = @[@"不要味精",@"不要葱",@"不要蒜",@"打包"];
        _specialSection.delegate = self;
    }
    return _specialSection;
}
- (RemarkSection *)spicySection{
    if (!_spicySection) {
        _spicySection = [[RemarkSection alloc]init];
        _spicySection.titles = @[@"不要辣椒",@"微辣",@"中辣",@"重辣"];
        _spicySection.isSingle = YES;
        _spicySection.delegate = self;

    }
    return _spicySection;
}
- (UITextView *)remarkTf{
    if (!_remarkTf) {
        _remarkTf = [[UITextView alloc]init];
        _remarkTf.layer.masksToBounds = YES;
        _remarkTf.layer.cornerRadius = 5;
        _remarkTf.backgroundColor = [UIColor whiteColor];
        _remarkTf.font = [UIFont systemFontOfSize:12];
        _remarkTf.contentInset = UIEdgeInsetsMake(15, 15, 15, 15);
        _remarkTf.delegate = self;
    }
    return _remarkTf;
}
- (UILabel *)placeholderLabel{
    if (!_placeholderLabel) {
        _placeholderLabel = [[UILabel alloc]init];
        _placeholderLabel.font = [UIFont systemFontOfSize:12];
        _placeholderLabel.textColor = [UIColor colorWithRed:221/255.0 green:221/255.0 blue:221/255.0 alpha:1];
        _placeholderLabel.text = @"在此可以输入您的自定义备注";
    }
    return _placeholderLabel;
}
@end
