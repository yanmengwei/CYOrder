//
//  RestaurantCell.h
//  CYOrder
//
//  Created by ymw on 17/6/14.
//  Copyright © 2017年 ymw. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RestaurantCell;
typedef NS_ENUM(NSInteger,RestaurantCellStatus){
    RestaurantCellStatusUnSta = 0,//不满意
    RestaurantCellStatusSta, //满意
    RestaurantCellStatusVerySta //非常满意
};
@protocol  RestaurantCellDelegate<NSObject>

- (void)restaurantCell:(RestaurantCell *)restaurantCell statusDidChange:(RestaurantCellStatus)status;

@end
@interface RestaurantCell : UIView
@property (nonatomic,strong) id<RestaurantCellDelegate>delegate;
- (instancetype)initWithTitle:(NSString *)title defaultStatus:(RestaurantCellStatus)defafultStatus;
@end
