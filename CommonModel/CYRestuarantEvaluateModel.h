//
//  CYRestuarantEvaluateModel.h
//  CYOrder
//
//  Created by ymw on 17/6/14.
//  Copyright © 2017年 ymw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CYRestuarantEvaluateModel : NSObject
@property (nonatomic,copy) NSString *Id;
@property (nonatomic,assign) NSInteger environment;
@property (nonatomic,assign) NSInteger flavor;
@property (nonatomic,assign) NSInteger attitude;
@property (nonatomic,copy) NSString *evaluation;

@end
