//
//  OrderPackageCell.m
//  CYOrder
//
//  Created by ymw on 17/6/5.
//  Copyright © 2017年 ymw. All rights reserved.
//

#import "OrderPackageCell.h"
#import "HadOrderCell.h"
@interface OrderPackageCell()<UITableViewDelegate,UITableViewDataSource>
{
    UITapGestureRecognizer *_tap;
}
@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) UILabel *packageNameLabel;
@property (nonatomic,strong) UIImageView *bottomLine;
@property (nonatomic,strong) UIButton *deleteBtn;
@property (nonatomic,strong) UIImageView *bgImageView;


@end
@implementation OrderPackageCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"OrderPackageCell";
    OrderPackageCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[OrderPackageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self  = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUpSubviews];
    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        self.deleteBtn.hidden = NO;
        self.bgImageView.hidden = NO;
    }else{
        self.deleteBtn.hidden = YES;
        self.bgImageView.hidden = YES;
    }
    [self.tableView reloadData];
}
- (void)didClickTableviewWithGes:(UITapGestureRecognizer *)ges{
    
    
    static BOOL select = NO;
    select  = YES;
    [self setSelected:select];
    NSLog(@"------tap-----");

}
- (void)setUpSubviews{
    __weak UIView *superview = self.contentView;
    [superview addSubview:self.bgImageView];
    [superview addSubview:self.tableView];
    [superview addSubview:self.bottomLine];

    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(superview);
        make.bottom.equalTo(superview).offset(-1);
        
    }];
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.tableView);
    }];
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(30);
        make.centerY.equalTo(superview.mas_bottom);
        make.width.equalTo(superview.mas_width).multipliedBy(1.5);
        make.centerX.equalTo(superview);
    }];
    
}
- (void)didClickDeleteBtn:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(orderPackageCell:didSelectDeleteBtnWithPackageModel:)]) {
        [self.delegate orderPackageCell:self didSelectDeleteBtnWithPackageModel:self.packageModel];
    }
    
}
#pragma mark - tableview delegate & datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.packageModel.packageLists.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HadOrderCell *cell = [HadOrderCell cellWithTableView:tableView];
    NSArray *listArr = [CYOrderListModel orderListArrWithMenuArr:self.packageModel.packageLists];
    cell.orderListModel = listArr[indexPath.row];
    cell.showLine = YES;
    cell.showAnti = YES;
    if (self.selected) {
        cell.textColor = [UIColor whiteColor];
    }else{
        cell.textColor = CYTextColor;
    }
    if (!_isActive) {
        cell.textColor = [UIColor colorWithRed:114/255.0 green:114/255.0 blue:114/255.0 alpha:1];
    }
    cell.backgroundColor = [UIColor clearColor];

    cell.userInteractionEnabled =  NO;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
        return 32;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 32;
}
//- (uivi)
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:self.packageModel.name];
    //斜体字体
    [attrStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica-BoldOblique" size:18] range:NSMakeRange(0,attrStr.length)];
    if (!self.selected) {
        self.packageNameLabel.textColor = CYTextColor;
    }else{
        self.packageNameLabel.textColor = [UIColor whiteColor];
    }
    if (!self.isActive) {
        self.packageNameLabel.textColor = [UIColor colorWithRed:114/255.0 green:114/255.0 blue:114/255.0 alpha:1];
    }
    //[UIColor colorWithRed:126/255.0 green:252/255.0 blue:184/255.0 alpha:1];
    [self.packageNameLabel setAttributedText:attrStr];
    
    UIView *headerView = [[UIView alloc]init];
    [headerView addSubview:self.packageNameLabel];
    [headerView addSubview:self.deleteBtn];

    [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(6);
        make.height.width.offset(18);
        make.centerY.mas_equalTo(headerView);
    }];

    [self.packageNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.deleteBtn.mas_right).offset(5);
        make.centerY.mas_equalTo(headerView);
    }];
    [headerView bringSubviewToFront:self.deleteBtn];

    return headerView;
    
}
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]init];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.scrollEnabled = NO;
        _tableView.allowsSelection  = NO;
        _tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didClickTableviewWithGes:)];
        _tableView.userInteractionEnabled = YES;
        [_tableView addGestureRecognizer:_tap];
        
    }
    return _tableView;
}
- (UILabel *)packageNameLabel{
    if (!_packageNameLabel ) {
        _packageNameLabel = [[UILabel alloc]init];
        _packageNameLabel.textColor = [UIColor whiteColor];
    }
    return _packageNameLabel;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (UIButton *)deleteBtn{
    if (_deleteBtn == nil) {
        _deleteBtn = [[UIButton alloc]init];
        [_deleteBtn setBackgroundImage:[UIImage imageNamed:@"ordercell_delete"] forState:UIControlStateNormal];
        [_deleteBtn addTarget:self action:@selector(didClickDeleteBtn:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _deleteBtn;
}
- (UIImageView *)bottomLine{
    if (!_bottomLine) {
        _bottomLine = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"order_cell_split_line"]];
        
    }
    return _bottomLine;
}

- (UIImageView *)bgImageView{
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ordercell_select"]];
        _bgImageView.userInteractionEnabled = YES;
        _bgImageView.contentMode = UIViewContentModeScaleToFill;
    }
    return _bgImageView;
}

- (void)setPackageModel:(CYPackageModel *)packageModel{
    _packageModel = packageModel;
    [self.tableView reloadData];
}
- (void)setIsActive:(BOOL)isActive{
    _isActive = isActive;
    if (!_isActive) {
        [self.tableView removeGestureRecognizer:_tap];
    }else{
        [self.tableView addGestureRecognizer:_tap];
    }
}
@end
