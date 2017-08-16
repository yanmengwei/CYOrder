//
//  BaseViewController.h
//  CYOrder
//
//  Created by ymw on 17/4/12.
//  Copyright © 2017年 ymw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeftDrawerView.h"

@interface BaseViewController : UIViewController<LeftDrawerViewDelegate>{
    //数据库管理工具
    DataBase *_db;
}
/**
 *  下部背景图
 */
@property (nonatomic,strong) UIImageView *bottomBgImgView;
/**
 *  左侧图
 */
@property (nonatomic,strong) LeftDrawerView *leftView;


/**
 *  顶部背景图
 */
@property (nonatomic,strong) UIImageView *topBgImgView;


@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,strong) UIImageView *logoView;


- (void)configSubviews;
/**
 *  如果需要显示左侧视图
 */
- (void)showLeftView;

/**
 *  关闭弹出视图
 */
- (void)closeViews;
@end
