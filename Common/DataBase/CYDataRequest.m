//
//  CYDataRequest.m
//  CYOrder
//
//  Created by ymw on 17/5/11.
//  Copyright © 2017年 ymw. All rights reserved.
//

#import "CYDataRequest.h"
#import "GCDAsyncSocket.h"
typedef NS_ENUM(NSInteger , CYCommandType)
{
    CYCommandTypeAdd = 0,  //增加
    CYCommandTypeDelete,  //删除
    CYCommandTypeUpdate,  //修改
    CYCommandTypeSearch  //查询
};

#define HOST @"192.168.68.173"
#define PORT 3001
static CYDataRequest *_requstCtl = nil;

@interface CYDataRequest()<GCDAsyncSocketDelegate>{
    NSInteger count;
    NSMutableData *mutableData;
    dispatch_queue_t _queue;
    BOOL  _canRequest;

}

@end
@implementation CYDataRequest
+(instancetype)shareDataRequst{
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        _requstCtl = [[CYDataRequest alloc] init];
    
        NSError *err = nil;
        
       _requstCtl.asyncSocket = [[GCDAsyncSocket alloc]initWithDelegate:_requstCtl delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
        [_requstCtl.asyncSocket connectToHost:HOST onPort:PORT withTimeout:-1 error:&err];
        [_requstCtl.asyncSocket readDataWithTimeout:-1 tag:400];
    });
    return _requstCtl;
}
- (void)closeConnect{
    if (_asyncSocket.isConnected) {
        [_asyncSocket disconnect];
    }
}
-(id)mutableCopy{
    return self;
}

+(instancetype)allocWithZone:(struct _NSZone *)zone{
    if (_requstCtl == nil) {
        _requstCtl = [super allocWithZone:zone];
        [_requstCtl initDataRequest];
        
    }
    return _requstCtl;
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

- (void)initDataRequest{
 
    NSLog(@"%@",_asyncSocket.localHost);

    mutableData = [NSMutableData data];
    _canRequest = YES;
    _queue = dispatch_queue_create("requet_queue", DISPATCH_QUEUE_SERIAL);

    
}
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    static int len;

    if (mutableData.length == 0) {
        //如果数据为空 即是第一节返回数据 需要截取数据头
        if(data.length > 3){
            NSData *countData = [data subdataWithRange:NSMakeRange(0,3)];
            data = [data subdataWithRange:NSMakeRange(3, data.length - 3)];
            len = [self readDataLengthWithData:countData];
        }

    }
    [mutableData appendData:data];
    if (mutableData.length >= len) {
        //数据接收完毕
    
        len = 0;
        
        //        NSLog(@"----------数据请求成功--------\n%@",str);
        if (self.successRes) {
            self.successRes(mutableData);
            mutableData = [NSMutableData data];
        }
        _canRequest = YES;
    }
    

    [_asyncSocket readDataWithTimeout:-1 tag:400];
}
- (int)readDataLengthWithData:(NSData *)data{
    data = [data subdataWithRange:NSMakeRange(1, 2)];
    Byte *bytes = (Byte *)[data bytes];
    int value;
    value = (int) ((bytes[1] & 0xFF)
                   | ((bytes[0] & 0xFF)<<8));

    return value;
}
- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag{
    NSLog(@"didW riteDataWithTag");
//    _asyncSocket cl
    [_asyncSocket readDataWithTimeout:-1 tag:400];
    
}
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(nonnull NSString *)host port:(uint16_t)port{
    [_asyncSocket readDataWithTimeout:-1 tag:400];


    NSLog(@"did connect");
}
- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err{
    NSLog(@"socketDidDisconnect");
}

#pragma mark - 接口
/**
 *  根据菜系id获取菜单表g
 *
 *  @param command 0-增加 1-删除 2-修改 3查询 4-呼叫服务员
 *  @param flag1
 *  @param flag2
 *  @param tableName
 *
 *  @return 菜单数组
 */
- (NSData *)portWithCommand:(CYCommandType)command
                          flag1:(NSString *)flag1
                          flag2:(NSString *)flag2
                     tableName:(NSString *)tableName{
    
    //数据
    NSMutableDictionary *dataDic = [NSMutableDictionary dictionary];
    if (command) {
        dataDic[@"command"] = [NSString stringWithFormat:@"%ld",command];
    }
    if (flag1) {
        dataDic[@"flag1"] = flag1;
    }
    if (flag2) {
        dataDic[@"flag2"] = flag2;

    }
    if (tableName) {
        dataDic[@"table"] = tableName;
    }
  
    return [self lengthTypeDataWithData:dataDic];
}
- (NSData *)lengthTypeDataWithData:(NSDictionary *)dic{
    
    //长度
    NSInteger len = (NSInteger)[NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil].length;
    //移位
    Byte b1=len & 0xff;
    Byte b2=(len>>8) & 0xff;
    Byte byte[] = {b2,b1};
    NSData *lenData = [NSData dataWithBytes:byte length:sizeof(byte)];
    
    NSInteger type = 0;
    Byte b = type & 0xff;
    Byte dbyte[] = {b};
    
    //    NSString *length =  [NSString stringWithFormat:@"%ld",len];
    NSData *dicData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    //拼接长度
    NSMutableData *data= [NSMutableData dataWithData:[NSData dataWithBytes:dbyte length:sizeof(dbyte)]];
    //拼接类型
    [data appendData:lenData];
    //拼接数据
    [data appendData:dicData];
    
    
    return data;
}
- (void)socketConnect{
    if (!_asyncSocket.isConnected) {
            _asyncSocket = [[GCDAsyncSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
            [_asyncSocket connectToHost:HOST onPort:PORT withTimeout:-1 error:nil];
    }
}
#pragma mark - 接口
/*
 *   更新数据
 */
- (void)updateMenuSuccess:(DataRequestResult)success{
    dispatch_async(_queue, ^{
        while (!_canRequest) {
            
        }
        self.successRes = success;
        NSData *data = [self portWithCommand:CYCommandTypeSearch flag1:@"0" flag2:nil tableName:@"menu"];
        [_asyncSocket writeData:data withTimeout:-1 tag:1];
        _canRequest = NO;
    });



    
}
- (void)updateAllCategorySuccess:(DataRequestResult)success{
    dispatch_async(_queue, ^{
        while (!_canRequest) {
            
        }
        self.successRes = success;
        NSData *data = [self portWithCommand:CYCommandTypeSearch flag1:@"0" flag2:nil tableName:@"category"];
        [_asyncSocket writeData:data withTimeout:-1 tag:2];
        _canRequest = NO;
    });
    


}
/**
  **/
- (void)updatePackageSuccess:(DataRequestResult)success{
    dispatch_async(_queue, ^{
        while (!_canRequest) {
            
        }
        self.successRes = success;
        NSData *data = [self portWithCommand:CYCommandTypeSearch flag1:@"2" flag2:@"0" tableName:@"package"];
        [_asyncSocket writeData:data withTimeout:-1 tag:3];
        _canRequest = NO;
    });

}
- (void)updateTodaySpecialSuccess:(DataRequestResult)success{
    dispatch_async(_queue, ^{
        while (!_canRequest) {
        }
            self.successRes = success;
            NSData *data = [self portWithCommand:CYCommandTypeSearch flag1:@"0" flag2:nil tableName:@"daily_special"];
            [_asyncSocket writeData:data withTimeout:-1 tag:3];
            _canRequest = NO;
        

     });
}
- (void)updateChefAdvocateSuccess:(DataRequestResult)success{
    dispatch_async(_queue, ^{
        while (!_canRequest) {
        }
        self.successRes = success;
        NSData *data = [self portWithCommand:CYCommandTypeSearch flag1:@"0" flag2:nil tableName:@"chef_advocate"];
        [_asyncSocket writeData:data withTimeout:-1 tag:3];
        _canRequest = NO;
        
    });
}


@end
