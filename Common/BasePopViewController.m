//
//  BasePopViewController.m
//  CYOrder
//
//  Created by ymw on 17/4/19.
//  Copyright © 2017年 ymw. All rights reserved.
//

#import "BasePopViewController.h"

@interface BasePopViewController ()
@property (nonatomic,strong) UIButton *btn;
@end

@implementation BasePopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configSubviews];
    // Do any additional setup after loading the view.
}
- (void)configSubviews{
    [super configSubviews];
    [self.view addSubview:self.btn];
    [self.btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.logoView.mas_bottom).offset(8);
        make.left.offset(30);
        make.width.offset(25);
        make.height.offset(41);
    }];
}
- (void)didClickReturnBtn:(UIButton *)sender{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (UIButton *)btn
{
    if (!_btn) {
        _btn = [[UIButton alloc]init];
        [_btn setImage:[UIImage imageNamed:@"return"] forState:UIControlStateNormal];
        [_btn addTarget:self action:@selector(didClickReturnBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btn;
}
@end
