//
//  OrderPackageCell.h
//  CYOrder
//
//  Created by ymw on 17/6/5.
//  Copyright © 2017年 ymw. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OrderPackageCell;
@protocol OrderPackageCellDelegate<NSObject>
- (void)orderPackageCell:(OrderPackageCell *)cell didSelectDeleteBtnWithPackageModel:(CYPackageModel *)packageModel;
@end
@interface OrderPackageCell : UITableViewCell
@property (nonatomic,assign)BOOL isActive;
@property (nonatomic,strong) id<OrderPackageCellDelegate>delegate;
@property (nonatomic,strong) CYPackageModel *packageModel;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
