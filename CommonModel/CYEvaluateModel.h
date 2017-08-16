//
//  CYEvaluateModel.h
//  CYOrder
//
//  Created by ymw on 17/6/14.
//  Copyright © 2017年 ymw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CYEvaluateModel : NSObject

@property (nonatomic,copy) NSString *Id;
@property (nonatomic,copy) NSString *order_id;
@property (nonatomic,copy) NSString *menu_id;
@property (nonatomic,copy) NSString *package_id;
@property (nonatomic,assign) NSInteger evaluation;

@end
