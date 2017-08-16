//
//  CYMenuEvaluateCell.h
//  CYOrder
//
//  Created by ymw on 17/6/14.
//  Copyright © 2017年 ymw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CYOrderListModel.h"
@protocol CYMenuEvaluateCellDelegate <NSObject>
- (void)cellDidChangeEvaStatus:(CYOrderListModel *)model;
@end
@interface CYMenuEvaluateCell : UITableViewCell
@property (nonatomic,strong) CYOrderListModel *model;
@property (nonatomic,weak)id<CYMenuEvaluateCellDelegate>delegate;
+ (instancetype)cellWithTableView:(UITableView *)tableView;


@end
