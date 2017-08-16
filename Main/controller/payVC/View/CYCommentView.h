//
//  CYCommentView.h
//  CYOrder
//
//  Created by ymw on 17/6/12.
//  Copyright © 2017年 ymw. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol CYCommentViewDelegate <NSObject>

- (void)didChangeCommentStatus:(EvaluateStatus)commentType;

@end
@interface CYCommentView : UIView
@property (nonatomic,weak)id<CYCommentViewDelegate>delegate;
//默认值
@property (nonatomic,assign) EvaluateStatus defaultType;
@end
