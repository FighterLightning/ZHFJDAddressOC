//
//  ZHFAddTitleAddressView.h
//  ZHFJDAddressOC
//
//  Created by 张海峰 on 2017/12/18.
//  Copyright © 2017年 张海峰. All rights reserved.


#import <UIKit/UIKit.h>
@protocol  ZHFAddTitleAddressViewDelegate <NSObject>
-(void)cancelBtnClick:(NSString *)titleAddress titleID:(NSString *)titleID;
@end
@interface ZHFAddTitleAddressView : UIView
@property(nonatomic,assign)id<ZHFAddTitleAddressViewDelegate>delegate1;
@property(nonatomic,assign)NSInteger userID;
@property(nonatomic,assign)NSUInteger defaultHeight;
@property(nonatomic,assign)CGFloat titleScrollViewH;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,strong)UIView *addAddressView;
@property(nonatomic,strong)NSMutableArray *titleMarr;
@property(nonatomic,strong)NSMutableArray *tableViewMarr;
-(UIView *)initAddressView;
-(void)setupTitleScrollView;
-(void)setupContentScrollView;
-(void)setupAllTitle:(NSInteger)selectId;
-(void)addAnimate;
@end
