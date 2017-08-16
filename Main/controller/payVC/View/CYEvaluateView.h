//
//  CYEvaluateView.h
//  CYOrder
//
//  Created by ymw on 17/6/14.
//  Copyright © 2017年 ymw. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CYRestuarantEvaluateModel;
@protocol CYEvaluateViewDelegate <NSObject>

- (void)didClickSubmitCommentBtnWithOrderModelArr:(NSArray *)orderModelArr andRestuarantModel:(CYRestuarantEvaluateModel *)resModel;
@end
@interface CYEvaluateView : UIView
@property (nonatomic,strong) NSArray *orderModelArr;
@property (nonatomic,weak) id<CYEvaluateViewDelegate> delegate;
@end
