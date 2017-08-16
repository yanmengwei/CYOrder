//
//  CYMenuEvaluateCell.m
//  CYOrder
//
//  Created by ymw on 17/6/14.
//  Copyright © 2017年 ymw. All rights reserved.
//

#import "CYMenuEvaluateCell.h"
#import "CYCommentView.h"
@interface CYMenuEvaluateCell()<CYCommentViewDelegate>
@property (nonatomic,strong)UILabel *nameLabel;
@property (nonatomic,strong) CYCommentView *commentView;
@property (nonatomic, nonnull,strong) UIView *line;


@end

@implementation CYMenuEvaluateCell
+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"CYMenuEvaluateCell";
    CYMenuEvaluateCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[CYMenuEvaluateCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self  = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self setUpSubviews];
    }
    return self;
}

- (void)setUpSubviews{
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.commentView];
    [self.contentView addSubview:self.line];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(50);
        make.centerY.equalTo(self.contentView);
    }];
    [self.commentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(110);
        make.right.offset(-35);
        make.centerY.equalTo(self.contentView);
        make.height.offset(30);
    }];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(50);
        make.right.offset(-35);
        make.bottom.equalTo(self.contentView);
        make.height.offset(0.5);
    }];
    
}
- (void)didChangeCommentStatus:(EvaluateStatus)commentType{
    self.model.evaluate = commentType;
    if (self.delegate && [self.delegate respondsToSelector:@selector(cellDidChangeEvaStatus:)]){
        [self.delegate cellDidChangeEvaStatus:self.model];
    }
}
- (void)setModel:(CYOrderListModel *)model{
    _model = model;
    self.model.evaluate =  EvaluateStatusZan;
    if (model.package_id) {
        self.nameLabel.text = _model.packageModel.name;
    }else{
        self.nameLabel.text = _model.menuModel.name;
    }
}
- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.font = [UIFont systemFontOfSize:16];
        _nameLabel.textColor = CYTextColor;
    }
    return _nameLabel;
}
- (CYCommentView *)commentView{
    if (!_commentView) {
        _commentView = [[CYCommentView alloc]init];
        _commentView.defaultType = EvaluateStatusZan;
        _commentView.delegate = self;
    }
    return _commentView;
}
- (UIView *)line{
    if (!_line) {
        _line = [[UIView alloc]init];
        _line.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1];
    }
    return _line;
}
@end
