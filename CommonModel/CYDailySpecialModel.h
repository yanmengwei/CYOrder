//
//  CYDailySpecialModel.h
//  CYOrder
//
//  Created by ymw on 17/6/9.
//  Copyright © 2017年 ymw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CYDailySpecialModel : NSObject
@property (nonatomic,copy) NSString * Id;
@property (nonatomic,copy) NSString *menu_id;
@property (nonatomic,assign) CGFloat special_price;
@property (nonatomic,strong) CYMenuModel *menuModel;
@end
