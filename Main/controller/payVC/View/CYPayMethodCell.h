//
//  CYPayMethodCell.h
//  CYOrder
//
//  Created by ymw on 17/4/27.
//  Copyright © 2017年 ymw. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CYPayMethodModel;
@interface CYPayMethodCell : UITableViewCell
@property (nonatomic,strong) UIImageView *selectImage;
@property (nonatomic,strong) CYPayMethodModel *model;
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
