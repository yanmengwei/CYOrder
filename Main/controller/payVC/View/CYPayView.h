//
//  CYPayView.h
//  CYOrder
//
//  Created by ymw on 17/4/27.
//  Copyright © 2017年 ymw. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CYPayMethodModel;
@protocol CYPayViewDelegate <NSObject>
- (void)payViewDidClickSureBtnWithModel:(CYPayMethodModel *)payModel;
@end
@interface CYPayView : UIView
@property (nonatomic,weak) id<CYPayViewDelegate>delegate;
@end
