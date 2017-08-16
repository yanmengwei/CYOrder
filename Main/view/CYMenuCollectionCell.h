//
//  menuCollectionCell.h
//  CYOrder
//
//  Created by ymw on 17/4/5.
//  Copyright © 2017年 ymw. All rights reserved.
//

#import <UIKit/UIKit.h>
@class  CYMenuModel;
@class  CYMenuCollectionCell;
@class CYDailySpecialModel;
@protocol CYMenuCollectionCellDelegate<NSObject>
- (void)cell:(CYMenuCollectionCell *)cell didClickDetailBtnWithMenuModel:(CYMenuModel *)model;
@end
@interface CYMenuCollectionCell : UICollectionViewCell
@property (nonatomic,weak) id<CYMenuCollectionCellDelegate>delegate;
@property (nonatomic,strong) CYMenuModel *model;
@property (nonatomic,strong) CYDailySpecialModel *dailyModel;
@end
