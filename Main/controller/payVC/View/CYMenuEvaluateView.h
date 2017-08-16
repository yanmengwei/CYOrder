//
//  CYMenuEvaluateView.h
//  CYOrder
//
//  Created by ymw on 17/6/14.
//  Copyright © 2017年 ymw. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CYMenuEvaluateViewDelegate<NSObject>
-(void)didChangeMenuEvaStatusWithOrderListArr:(NSArray *)arr;
@end
@interface CYMenuEvaluateView : UIView
@property (nonatomic,strong) NSMutableArray *orderListArr;
@property (nonatomic,weak) id<CYMenuEvaluateViewDelegate>delegate;
@end
