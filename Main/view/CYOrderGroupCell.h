//
//  CYOrderGroupCell.h
//  CYOrder
//
//  Created by ymw on 17/6/16.
//  Copyright © 2017年 ymw. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CYOrderModel;
@class CYOrderGroupCell;
@protocol CYOrderGroupCellDelegate <NSObject>

- (void)orderGroupCell:(CYOrderGroupCell *)cell orderListArr:(NSMutableArray *)orderListArr packageArr:(NSMutableArray *)packageArr;

@end
@interface CYOrderGroupCell : UITableViewCell
@property (nonatomic,strong) CYOrderModel *model;
@property (nonatomic,assign) BOOL isActive;
@property (nonatomic,weak) id<CYOrderGroupCellDelegate>delegate;
+ (instancetype)cellWithTableView:(UITableView *)tableView;


@end
