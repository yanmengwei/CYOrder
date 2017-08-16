//
//  CYDataRequest.h
//  CYOrder
//
//  Created by ymw on 17/5/11.
//  Copyright © 2017年 ymw. All rights reserved.
//

#import <Foundation/Foundation.h>
@class GCDAsyncSocket;
typedef void (^DataRequestResult)(NSData * receiveData);

@interface CYDataRequest : NSObject
@property (nonatomic,strong)     GCDAsyncSocket *asyncSocket;

@property (nonatomic,copy) DataRequestResult successRes;

+(instancetype)shareDataRequst;

//@property (nonatomic,copy) void(^)(NSError *)error;
- (void)closeConnect;
/*
 *   更新分类
 */
- (void)updateAllCategorySuccess:(DataRequestResult)success;

/*
 *   更新菜单
 */
- (void)updateMenuSuccess:(DataRequestResult)success;
/**
 *   更新套餐
 **/
- (void)updatePackageSuccess:(DataRequestResult)success;

- (void)updateTodaySpecialSuccess:(DataRequestResult)success;
- (void)updateChefAdvocateSuccess:(DataRequestResult)success;

@end

