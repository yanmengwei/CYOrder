//
//  HadOrderCell.h
//  CYOrder
//
//  Created by ymw on 17/4/26.
//  Copyright © 2017年 ymw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CYOrderListModel.h"
@interface HadOrderCell : UITableViewCell
@property (nonatomic,assign) BOOL showLine;
//动画效果
@property (nonatomic,assign) BOOL showAnti;
@property (nonatomic,strong) UIColor *textColor;
@property (nonatomic,strong) CYOrderListModel *orderListModel;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
