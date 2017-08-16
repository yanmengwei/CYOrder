//
//  orderCell.h
//  CYOrder
//
//  Created by ymw on 17/4/5.
//  Copyright © 2017年 ymw. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OrderCell;
@class CYMenuModel;
@protocol OrderCellDelegate<NSObject>
- (void)orderCell:(OrderCell *)cell didSelectDeleteBtnWithOrderModel:(CYOrderListModel *)menuModel;
@end

@interface OrderCell : UITableViewCell
@property (nonatomic,weak) id<OrderCellDelegate> delegate;
@property (nonatomic,strong) CYOrderListModel *orderModel;
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
