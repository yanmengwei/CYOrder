//
//  CYPayCell.h
//  CYOrder
//
//  Created by ymw on 17/4/27.
//  Copyright © 2017年 ymw. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,CYPayCellType) {
    CYPayCellTypeNone = 0, //没有状态
    CYPayCellTypeCommentComplete//评价完成
};
@class CYOrderListModel;
@interface CYPayCell : UITableViewCell
@property (nonatomic,strong) CYOrderListModel *listModel;
@property (nonatomic,assign) CYPayCellType cellType;
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
