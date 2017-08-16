//
//  DataBase.m
//  CYOrder
//
//  Created by ymw on 17/3/31.
//  Copyright © 2017年 ymw. All rights reserved.
//


#import "DataBase.h"
#import "CYDataRequest.h"
#import "CYOrderListModel.h"
#import "CYOrderModel.h"
#import "FMDB.h"
#import "CYDailySpecialModel.h"
#import "CYRestuarantEvaluateModel.h"
#define firstKey @"firstSqlKey"
//菜单表
#define MenuTableName  @"menu"

//分类表
#define CategoryTableName @"category"

//套餐表
#define PackageTableName  @"package"

//套餐详情表
#define PackageListTableName @"package_list"

#define DBName @"restaurantdb.sqlite2"
#define  DailySpecialTableName @"daily_special"
//订单表
#define OrderTableName @"order"
//大厨主推
#define ChefAdvocate @"chef_advocate"
static DataBase *_DBCtl = nil;
@interface DataBase()<NSCopying,NSMutableCopying>{
    FMDatabase *_db;
    CYDataRequest *_request;
    dispatch_queue_t _dbQueue;
    
}
@end

@implementation DataBase
+(instancetype)shareDataBase{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _DBCtl = [[DataBase alloc] init];

    });
    return _DBCtl;
}


/**
 *  获取所有的菜系
 *
 *  @return 菜系数组
 */
#pragma mark  - 获取所有的菜系 这里是修改过后的 标签栏中不只包括菜系 还包括如大厨主推等

- (NSMutableArray *)getAllCategory{
    [_db open];
    NSMutableArray *categoryArr = [NSMutableArray array];
    NSArray *arr = [NSArray arrayWithObjects:@"所有菜系",@"菜系点评",@"今日特价",@"大厨主推", @"组合套餐",nil];
    for (NSString *str  in arr) {
        CYCategoryModel *category = [[CYCategoryModel alloc]init];
        category.name = str;
        category.category_id = str;
        [categoryArr addObject:category];
    }
    FMResultSet *res = [_db executeQuery:[NSString stringWithFormat:@"SELECT * FROM %@",CategoryTableName]];
    while ([res next]) {
        CYCategoryModel *category = [[CYCategoryModel alloc]init];
        category.category_id = [res stringForColumn:@"id"];
        category.name = [res stringForColumn:@"name"];
        [categoryArr addObject:category];
    }
    return categoryArr;
}

/**
 *  根据菜系id获取菜单表
 *
 *  @param categoryId 菜系id
 *
 *  @return 菜单数组
 */
#pragma mark  根据菜系id获取菜单表 在这里同样能够取得组合套餐中的信息
- (NSMutableArray *)getMenusWithCategryId:(NSString *)categoryId{
    [_db open];
    NSMutableArray *menuArr = [NSMutableArray array];
    //查询语句
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE category_id='%@'",MenuTableName,categoryId];
    if ([categoryId isEqualToString:@"所有菜系"]) {
        sql = [NSString stringWithFormat:@"SELECT * FROM %@",MenuTableName];
    }
    if ([categoryId isEqualToString:@"菜系评价"]) {

    }
    if ([categoryId isEqualToString:@"组合套餐"]) {
        menuArr = [self getAllPackage];
        return menuArr;
    }
    if ([categoryId isEqualToString:@"今日特价"]) {
        return  [self getDailySpecialList];
    }
    if ([categoryId isEqualToString:@"大厨主推"]) {
        return  [self getChefAdvocate];
    }
    FMResultSet *res = [_db executeQuery:sql];
    while ([res next]) {
        CYMenuModel *model = [[CYMenuModel alloc]init];
        model.food_id = [res stringForColumn:@"id"];
        model.name = [res stringForColumn:@"name"];
        model.category_id = [res stringForColumn:@"category_id"];
        model.price = [[res stringForColumn:@"price"]floatValue];
        model.brief = [res stringForColumn:@"brief"];
        model.discount_price = [[res stringForColumn:@"discount_price"]floatValue];
        model.is_enable = [[res stringForColumn:@"is_enable"]boolValue];
        model.img_address = [res stringForColumn:@"img_address"];
        model.is_special = [[res stringForColumn:@"is_special"]boolValue];

        [menuArr addObject:model];
    }

    
    return menuArr;
}
#pragma mark - 获取套餐列表
#pragma mark 根据套餐id获取套餐详情
- (CYPackageModel *)getPackageWithPackageId:(NSString *)packageId{
    
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE id = '%@'",PackageTableName,packageId];
    FMResultSet *res = [_db executeQuery:sql];
    CYPackageModel *model;
    while ([res next]) {
        model = [[CYPackageModel alloc]init];
        model.package_id = [res stringForColumn:@"id"];
        model.name = [res stringForColumn:@"name"];
        model.suggest_persons = [[res stringForColumn:@"suggest_persons"]integerValue];
        model.price = [[res stringForColumn:@"price"]floatValue];
        model.packageLists = [self getPackageListWithPackageId:model.package_id];
    }
    return model;
}
#pragma mark 获取套餐，列表
- (NSMutableArray *)getAllPackage{
    NSMutableArray *arr = [NSMutableArray array];
    [_db open];
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@",PackageTableName];
    FMResultSet *res = [_db executeQuery:sql];
    while ([res next]) {
        CYPackageModel *model = [[CYPackageModel alloc]init];
        model.package_id = [res stringForColumn:@"id"];
        model.name = [res stringForColumn:@"name"];
        model.suggest_persons = [[res stringForColumn:@"suggest_persons"]integerValue];
        model.price = [[res stringForColumn:@"price"]floatValue];
        model.packageLists = [self getPackageListWithPackageId:model.package_id];
        [arr addObject:model];
    }
    return arr;
}
#pragma mark  根据套餐id获取套餐详情
- (NSMutableArray *)getPackageListWithPackageId:(NSString *)packageId{
    NSMutableArray *arr = [NSMutableArray array];
    [_db open];
    //查询所有的套餐中的菜品
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE package_id='%@'",PackageListTableName,packageId];
    FMResultSet *packageRes = [_db executeQuery:sql];
    while ([packageRes next]) {
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE id='%@'",MenuTableName,[packageRes stringForColumn:@"menu_id"]];
        FMResultSet *res = [_db executeQuery:sql];
        while ([res next]) {
            CYMenuModel *model = [[CYMenuModel alloc]init];
            model.food_id = [res stringForColumn:@"id"];
            model.name = [res stringForColumn:@"name"];
            model.category_id = [res stringForColumn:@"category_id"];
            model.price = [[res stringForColumn:@"price"]floatValue];
            model.brief = [res stringForColumn:@"brief"];
            model.is_enable = [[res stringForColumn:@"is_enable"]boolValue];
            model.img_address = [res stringForColumn:@"img_address"];
            model.is_special = [[res stringForColumn:@"is_special"]boolValue];
            [arr addObject:model];
        }
     }
    return arr;
}
#pragma mark - 获取今日特价列表
- (NSMutableArray *)getDailySpecialList{
    [_db open];
    NSMutableArray *arr = [NSMutableArray array];
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@",DailySpecialTableName];
    FMResultSet *dailySpecialRes = [_db executeQuery:sql];
    while ([dailySpecialRes next]) {
        CYDailySpecialModel *dailyModel = [[CYDailySpecialModel alloc]init];
        dailyModel.Id = [dailySpecialRes stringForColumn:@"id"];
        dailyModel.menu_id = [dailySpecialRes stringForColumn:@"menu_id"];
        dailyModel.special_price = [[dailySpecialRes stringForColumn:@"special_price"]floatValue];
        dailyModel.menuModel = [self getMenuWithMenuId:[dailySpecialRes stringForColumn:@"menu_id"]];
        dailyModel.menuModel.discount_price = [[dailySpecialRes stringForColumn:@"special_price"]floatValue];
        
        [arr addObject:dailyModel];
        
    }
    return arr;
}
- (NSMutableArray *)getChefAdvocate{
    [_db open];
    NSMutableArray *arr = [NSMutableArray array];
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@",ChefAdvocate];
    FMResultSet *dailySpecialRes = [_db executeQuery:sql];
    while ([dailySpecialRes next]) {
        CYDailySpecialModel *dailyModel = [[CYDailySpecialModel alloc]init];
        dailyModel.Id = [dailySpecialRes stringForColumn:@"id"];
        dailyModel.menu_id = [dailySpecialRes stringForColumn:@"menu_id"];
        dailyModel.menuModel = [self getMenuWithMenuId:[dailySpecialRes stringForColumn:@"menu_id"]];
        [arr addObject:dailyModel];
        
    }
    return arr;
}
#pragma mark - 订单

/**
 *  添加订单
 *
 *  @param orderModel 订单模型
 *  @param listArr    订单详情模型数组
 */
- (BOOL)insertOrder:(CYOrderModel *)orderModel{
    [_db open];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    //用[NSDate date]可以获取系统当前时间
    NSString *timeString = [dateFormatter stringFromDate:[NSDate date]];
    NSString *insetOrderSql = [NSString stringWithFormat:@"INSERT INTO order_t(number,total,remarks,pay_status,id)VALUES('123','%.1f','%@','0','%@')",orderModel.total,orderModel.remarks,timeString];
    BOOL insetOrderSuccess = [_db executeUpdate:insetOrderSql];
    BOOL insetListSuccess = NO;
    for (CYOrderListModel *listModel in orderModel.orderListModelArr) {
        NSString *insertListSql = [NSString stringWithFormat:@"INSERT INTO order_t_list(order_id,menu_id,count)VALUES('%@',%@,%d)",timeString,listModel.menu_id,(int)listModel.count];
       insetListSuccess = [_db executeUpdate:insertListSql];
    }
    for (CYOrderListModel *listModel in orderModel.packageArr) {
        NSString *sql = [NSString stringWithFormat:@"INSERT INTO order_t_list(order_id,package_id,count)VALUES('%@',%@,%d)",timeString,listModel.package_id,(int)listModel.count];
        insetListSuccess = [_db executeUpdate:sql];

    }
    [_db close];
    
    return insetListSuccess&&insetOrderSuccess;
}
#pragma mark  - 获取订单列表
/**
 *  订单列表
 *
 *  @return <#return value description#>
 */
- (NSArray *)getOrderList{
    [_db open];
    NSString *sql = @"SELECT * FROM order_t";
    //数据库中未付款的订单 取出---
    

    FMResultSet *orderRes = [_db executeQuery:sql];
    NSMutableArray *arr = [NSMutableArray array];
    while ([orderRes next]) {
        CYOrderModel *orderModel = [[CYOrderModel alloc]init];
        orderModel.Id = [orderRes stringForColumn:@"id"];
        orderModel.create_time = [orderRes stringForColumn:@"create_time"];
        orderModel.total = [[orderRes stringForColumn:@"total"]floatValue];
        orderModel.number = [orderRes stringForColumn:@"number"];
        orderModel.is_star = [[orderRes stringForColumn:@"is_star"]boolValue];
        
        //取出订单中的所有菜
        NSString *order = [NSString stringWithFormat:@"SELECT * FROM order_t_list WHERE order_id = '%@'",[orderRes stringForColumn:@"id"]];
        FMResultSet *menuRes = [_db executeQuery:order];
        NSMutableArray *orderArr = [NSMutableArray  array];
        NSMutableArray *packageArr = [NSMutableArray array];
        while ([menuRes next]) {
            CYOrderListModel *listModel = [[CYOrderListModel alloc]init];
            listModel.Id = [menuRes stringForColumn:@"id"];
            listModel.order_id = [menuRes stringForColumn:@"order_id"];
            listModel.count = [[menuRes stringForColumn:@"count"]intValue];
            listModel.status = [[menuRes stringForColumn:@"status"]integerValue];
            listModel.start_process_time = [menuRes stringForColumn:@"start_process_time"];
            listModel.ready_time = [menuRes stringForColumn:@"ready_time"];
            listModel.serve_time = [menuRes stringForColumn:@"serve_time"];
            listModel.is_evaluation = [[menuRes stringForColumn:@"is_evaluation"]boolValue];
            listModel.evaluate = [[menuRes stringForColumn:@"evaluate"]integerValue];
            if ([menuRes stringForColumn:@"menu_id"].length > 0) {
                //如果是menu_id有值
                listModel.menu_id = [menuRes stringForColumn:@"menu_id"];
                listModel.menuModel = [self getMenuWithMenuId:[menuRes stringForColumn:@"menu_id"]];
                [orderArr addObject:listModel];
            }
            if ([menuRes stringForColumn:@"package_id"].length > 0) {
                //如果套餐id有值
                listModel.package_id = [menuRes stringForColumn:@"package_id"];
                listModel.packageModel = [self getPackageWithPackageId:[menuRes stringForColumn:@"package_id"]];
                [packageArr addObject:listModel];
            }
       
        }
        //取出订单中的所有套餐
        orderModel.orderListModelArr = orderArr;
        orderModel.packageArr = packageArr;

        
        [arr addObject:orderModel];
        
    }
    return arr;
}
#pragma mark - 根据菜id获取菜详情
/**
 *  根据菜id获取详情
 *
 *  @param menu_id
 *
 *  @return
 */
- (CYMenuModel *)getMenuWithMenuId:(NSString *)menu_id{
    NSString *menu = [NSString stringWithFormat:@"SELECT * FROM menu WHERE id = '%@'",menu_id];
    FMResultSet *res = [_db executeQuery:menu];
    while ([res next]) {
        CYMenuModel *model = [[CYMenuModel alloc]init];
        model.food_id = [res stringForColumn:@"id"];
        model.name = [res stringForColumn:@"name"];
        model.category_id = [res stringForColumn:@"category_id"];
        model.price = [[res stringForColumn:@"price"]floatValue];
        model.brief = [res stringForColumn:@"brief"];
        model.is_enable = [[res stringForColumn:@"is_enable"]boolValue];
        model.img_address = [res stringForColumn:@"img_address"];
        model.is_special = [[res stringForColumn:@"is_special"]boolValue];
        return model;
    }
    return nil;
    

}
#pragma mark  评价
/**
 *  完成评价
 *
 *  @param orderArr 订单数组
 *
 *  @return YES/NO
 */
- (BOOL)completeCommentWithOrder:(NSArray *)orderListArr{

    BOOL isComplete = YES;
    [_db open];


    for (CYOrderListModel *listModel in orderListArr) {
        NSString  *str = [NSString stringWithFormat:@"UPDATE order_t_list SET is_evaluation = '1' ,evaluate = '%ld' WHERE id = '%@'",listModel.evaluate,listModel.Id];
        isComplete = [_db executeUpdate:str];
        NSString *orderModelSql = [NSString stringWithFormat:@"UPDATE order_t SET is_star = '1' WHERE id = '%@'",listModel.order_id];
        isComplete = [_db executeUpdate:orderModelSql];
    }

    [_db close];
    return isComplete;
}
/**
 评价餐厅
 
 @param resModel 餐厅model
 @return <#return value description#>
 */
- (BOOL)evaluateRestuarantWithResModel:(CYRestuarantEvaluateModel *)resModel{
    BOOL isSuccess = YES;
    [_db open];
    NSString *str = [NSString stringWithFormat:@"INSERT INTO evaluate_restaurant(environment,flavor,attitude,evaluation)VALUES('%ld','%ld','%ld','%@')",resModel.environment,resModel.flavor,resModel.attitude,resModel.evaluation];
    isSuccess = [_db executeUpdate:str];
    [_db close];
    return isSuccess;
}
- (BOOL)pay{
    BOOL isSuccess = YES;
    [_db open];
    
    NSString *deleteSql = @"Delete from evaluate_restaurant where 1=1";
    
    [_db executeUpdate:deleteSql];
    deleteSql = @"Delete from evaluate where 1=1";
    [_db executeUpdate:deleteSql];
    
    deleteSql = @"Delete from order_t where 1=1";
    [_db executeUpdate:deleteSql];
    
    deleteSql = @"Delete from order_t_list where 1=1";
    [_db executeUpdate:deleteSql];

    [_db close];

    return isSuccess;
}
#pragma mark - init初始化
-(id)mutableCopy{
    return self;
}

+(instancetype)allocWithZone:(struct _NSZone *)zone{
    if (_DBCtl == nil) {
        _DBCtl = [super allocWithZone:zone];
        [_DBCtl initDataBase];
    }
    return _DBCtl;
}

-(id)copy{
    return self;
}

-(id)copyWithZone:(NSZone *)zone{
    return self;
}

-(id)mutableCopyWithZone:(NSZone *)zone{
    return self;
}

- (void)initDataBase{
    //初始化_request
    _request = [CYDataRequest shareDataRequst];
    
    
    _dbQueue = dispatch_queue_create("DBQueue", NULL);
    
    
    //获得doucument目录
    NSString *doucumentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    //数据库路径
    NSString *filePath = [doucumentsPath stringByAppendingString:[NSString stringWithFormat:@"/%@",DBName]];

    //实例化FMDataBased对象
    _db = [FMDatabase databaseWithPath:filePath];

    //如果数据库不存在 创建数据库
    [_db open];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"data" ofType:@"txt"];
    //创建数据库表
    NSString *st = [[NSString alloc]initWithData:[NSData dataWithContentsOfFile:path] encoding:NSUTF8StringEncoding];
    NSArray *arr = [st  componentsSeparatedByString:@";"];
    for (NSString *str  in arr) {
        [_db executeUpdate:str];
    }
    [_db close];
//    [self updateDataBase];

    if (![[NSUserDefaults standardUserDefaults]boolForKey:firstKey]) {
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:firstKey];
        [self updateDataBase];
    }
    //需要阻塞主线程
}
- (void)updateDataBase{
    NSLog(@"开始阻塞");
    [_db open];
    NSString *deleteMenuSql = @"Delete from menu where 1=1";
    [_db executeUpdate:deleteMenuSql];
    
    NSString *deleteCataSql = @"Delete from category where 1=1";

    [_db executeUpdate:deleteCataSql];
    NSString *deletepackageSql = @"Delete from package where 1=1";
    [_db executeUpdate:deletepackageSql];
    
    NSString *deletepackageListSql = @"Delete from package_list where 1=1";
    [_db executeUpdate:deletepackageListSql];
    
    NSString *deleteSpecialSql = @"Delete from daily_special where 1=1";
    [_db executeUpdate:deleteSpecialSql];

    
    NSString *delete = @"Delete from chef_advocate where 1=1";
    [_db executeUpdate:delete];

    [_db close];
    
    __block  BOOL can = NO;
    
    dispatch_async(_dbQueue, ^{
       [self updateCategoryCommpelete:^(BOOL result) {
           NSLog(@"dispatch-queue--------1");
       }];
    });
    dispatch_async(_dbQueue, ^{
        [self updataAllFood:nil];
    });
    dispatch_async(_dbQueue, ^{
//        self 
    });
    [self updateCategoryCommpelete:^(BOOL result) {
        NSLog(@"------1------");
        [self updataAllFood:^(BOOL result) {
            NSLog(@"------2------");
            [self updataPackage:^(BOOL result) {
                NSLog(@"------3------");
                [self updateSpecialToday:^(BOOL result) {
                    NSLog(@"------4------");

                    [self updateChefAdvocate:^(BOOL result) {
                        NSLog(@"------5------");
                        can = YES;
                    }];
                }];
              
            }];
        }];
    }];

 
    while (!can) {
        if (can) {
            break;
        }
    }
  
}
- (void)applicationWillTerminate{
    [_request closeConnect];
}
/**
 *  更新菜系 同时更新菜单
 */
#pragma mark - socket请求分类
- (void)updateCategoryCommpelete:(void(^)(BOOL result))complete{
    

    //更新菜谱
    [_request updateAllCategorySuccess:^(NSData *receiveData) {
        NSArray *arr = [NSJSONSerialization JSONObjectWithData:receiveData options:NSJSONReadingAllowFragments error:nil];
        NSArray *categoryArr = [CYCategoryModel mj_objectArrayWithKeyValuesArray:arr];
        for (CYCategoryModel *category in categoryArr) {
            [_db open];
            NSString *sql = [NSString stringWithFormat:@"INSERT INTO category(id,name)VALUES('%@','%@')",category.category_id,category.name];
            [_db executeUpdate:sql];
            [_db close];
        }
        if (complete) {
            if (receiveData != nil) {
                complete(YES);
            }else{
                complete(NO);
            }
        }
    }];
}
/**
 *  更新菜单
 */
#pragma mark  socket所有菜
- (void)updataAllFood:(void(^)(BOOL result))complete{
  
   
    [_request updateMenuSuccess:^(NSData *receiveData) {

        NSArray *arr = [NSJSONSerialization JSONObjectWithData:receiveData options:NSJSONReadingAllowFragments error:nil];
        NSArray *menuArr = [CYMenuModel mj_objectArrayWithKeyValuesArray:arr];
        for (CYMenuModel *menu in menuArr) {
            BOOL open =  [_db open];
            while (!open) {
                [_db open];
            }
            NSString *sql = [NSString stringWithFormat:@"INSERT INTO menu(id,name,price,category_id,brief,is_enable,img_address,discount_price)VALUES('%@','%@',%.2f,'%@','%@',%d,'%@','%.2f')",menu.food_id,menu.name,menu.price,menu.category_id,menu.brief,menu.is_enable,menu.img_address,menu.discount_price];
            [_db executeUpdate:sql];
            [_db close];

        }
        if (complete) {
            if (receiveData != nil) {
                complete(YES);
            }else{
                complete(NO);
            }
        }
    
    }];
    
}
#pragma mark  socket请求所有套餐
- (void)updataPackage:(void(^)(BOOL result))complete{
    
    [_request updatePackageSuccess:^(NSData *receiveData) {

        NSArray *arr = [NSJSONSerialization JSONObjectWithData:receiveData options:NSJSONReadingAllowFragments error:nil];
        NSArray *packageArr = [CYPackageModel mj_objectArrayWithKeyValuesArray:arr];
        for (CYPackageModel *packageModel in packageArr) {
            BOOL open =  [_db open];
            while (!open) {
                [_db open];
            }
            NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@(id,name,suggest_persons,price)VALUES('%@','%@','%ld','%.2f')",PackageTableName,packageModel.package_id,packageModel.name,packageModel.suggest_persons,packageModel.price];
            [_db executeUpdate:sql];
            [_db close];

            for (CYPackageListModel *listModel in packageModel.packageLists) {
                BOOL open =  [_db open];
                while (!open) {
                    [_db open];
                }
                NSString *listSql = [NSString stringWithFormat:@"INSERT INTO %@(count,id,menu_id,package_id)VALUES('%ld','%@','%@','%@')",PackageListTableName,listModel.count,listModel.package_list_id,listModel.menu_id,listModel.package_id];
                [_db executeUpdate:listSql];
                [_db close];

            }
            
        }
        if (complete) {
            if (receiveData != nil) {
                complete(YES);
            }else{
                complete(NO);
            }
        }

    }];
}
#pragma mark  socket请求所有今日特价
- (void)updateSpecialToday:(void(^)(BOOL result))complete{
    [_request updateTodaySpecialSuccess:^(NSData *receiveData) {
        NSArray *arr = [NSJSONSerialization JSONObjectWithData:receiveData options:NSJSONReadingAllowFragments error:nil];
        NSArray *specialArr = [CYDailySpecialModel mj_objectArrayWithKeyValuesArray:arr];
        //今日特价写入本地
        for (CYDailySpecialModel *dailyModel in specialArr) {
            BOOL open =  [_db open];
            while (!open) {
                [_db open];
            }
            NSString *sql = [NSString stringWithFormat:@"INSERT INTO daily_special(id,menu_id,special_price)VALUES('%@','%@','%f')",dailyModel.Id,dailyModel.menu_id,dailyModel.special_price];
            [_db executeUpdate:sql];
            [_db close];
            open =  [_db open];
            while (!open) {
                [_db open];
            }
            //更新菜单表
            NSString *update = [NSString stringWithFormat:@"UPDATE %@ SET is_special = '1' WHERE id = '%@'",MenuTableName,dailyModel.menu_id];
            NSString *updateDis = [NSString stringWithFormat:@"UPDATE %@ SET discount_price = '%f' WHERE id = '%@'",MenuTableName,dailyModel.special_price,dailyModel.menu_id];
            [_db executeUpdate:update];
            [_db executeUpdate:updateDis];
            [_db close];
            
            
        }
        if (complete) {
            if (receiveData != nil) {
                complete(YES);
            }else{
                complete(NO);
            }
        }
    }];
}
#pragma mark socket请求大厨主推
- (void)updateChefAdvocate:(void(^)(BOOL result))complete{
    [_request updateChefAdvocateSuccess:^(NSData *receiveData) {
        NSArray *arr = [NSJSONSerialization JSONObjectWithData:receiveData options:NSJSONReadingAllowFragments error:nil];
        NSArray *chefArr = [CYDailySpecialModel mj_objectArrayWithKeyValuesArray:arr];
        //今日特价写入本地
        for (CYDailySpecialModel *dailyModel in chefArr) {
            BOOL open =  [_db open];
            while (!open) {
                [_db open];
            }
            NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@(id,menu_id)VALUES('%@','%@')",ChefAdvocate,dailyModel.Id,dailyModel.menu_id];
            [_db executeUpdate:sql];
            [_db close];
        }
        if (complete) {
            if (receiveData != nil) {
                complete(YES);
            }else{
                complete(NO);
            }
        }
    }];
}
@end
