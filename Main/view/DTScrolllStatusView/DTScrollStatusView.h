//
//  DTScrollStatusView.h

//
//  Created by zhenyong on 16/4/30.
//  Copyright © 2016年 com.lnl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTStatusView.h"
@class PackageView;
typedef NS_ENUM(NSInteger , ScrollTapType)
{
    ScrollTapTypeWithNavigation,  //含有导航栏
    ScrollTapTypeWithNavigationAndTabbar, //含有tarbar
    ScrollTapTypeWithNothing,  //什么都不含有
};
@protocol DTScrollStatusDelegate<UIScrollViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@optional
-(void)refreshViewWithTag:(int)tag andIsHeader:(BOOL)isHeader;

@end
@interface DTScrollStatusView : UIView<UIScrollViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,DTStatusViewDelegate>
{
    BOOL isrefresh;
    UIColor *curSelectTabColor;
    UIColor *curNormalTabColor;
}
@property (strong , nonatomic) DTStatusView *statusView;
@property (strong , nonatomic) UIScrollView *mainScrollView;
@property (nonatomic,strong) PackageView *pView;
/**
 *  获取当前所选中的view

 */
@property (strong , nonatomic) UIView *curCollView;
/**
 *  含有的tableiview 数组  
 */
@property (strong , nonatomic) NSMutableArray *tableArr;
@property (strong , nonatomic) id<DTScrollStatusDelegate> scrollStatusDelegate;

/**
 *  初始化
 *
 *  @param frame    frame
 *  @param titleArr 标题
 *
 *  @return <#return value description#>
 */

-(instancetype)initWithFrame:(CGRect)frame;
-(void)setStatusViewWithTitle:(NSArray *)titleArr;

@end
