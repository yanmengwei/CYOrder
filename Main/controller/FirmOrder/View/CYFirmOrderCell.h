//
//  CYFirmOrderCell.h
//  CYOrder
//
//  Created by ymw on 17/4/24.
//  Copyright © 2017年 ymw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CYFirmOrderCell : UITableViewCell
@property (nonatomic,strong) CYOrderListModel *menuModel;
@property (nonatomic,strong) CYPackageModel *packageModel;
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
