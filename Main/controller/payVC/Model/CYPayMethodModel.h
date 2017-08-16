//
//  CYPayMethodModel.h
//  CYOrder
//
//  Created by ymw on 17/4/27.
//  Copyright © 2017年 ymw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CYPayMethodModel : NSObject
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *imageName;

+(NSArray *)getMethods;
@end
