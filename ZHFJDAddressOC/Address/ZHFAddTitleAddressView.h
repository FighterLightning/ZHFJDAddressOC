//
//  ZHFAddTitleAddressView.h
//  ZHFJDAddressOC
//
//  Created by 张海峰 on 2017/12/18.
//  Copyright © 2017年 张海峰. All rights reserved.
// 这是一个自定义仿京东地址选择器。OC版本，（保证集成成功，有不懂的地方可加QQ：991150443 进行讨论。）
// Swift版本地址：https://github.com/FighterLightning/ZHFJDAddress.git
/*该demo的使用须知:
 1.下载该demo。把Address文件拖进项目（里面有一个View（主要），四个model（一个网络，剩下省市区））
 2.pod 'AFNetworking'//网络请求
 pod 'YYModel' //字典转模型
 3.把以下代码添加进自己的控制器方可使用,注意顺序，网络请求看ZHFAddTitleAddressView.m头部注释根据需求进行修改
 4.如果感觉有帮助，不要吝啬你的星星哦！
 该demo地址：https://github.com/FighterLightning/ZHFJDAddressOC.git
 */

#import <UIKit/UIKit.h>
@protocol  ZHFAddTitleAddressViewDelegate <NSObject>
-(void)cancelBtnClick:(NSString *)titleAddress titleID:(NSString *)titleID;
@end
@interface ZHFAddTitleAddressView : UIView
@property(nonatomic,weak)id<ZHFAddTitleAddressViewDelegate>delegate1;
@property(nonatomic,assign)NSUInteger defaultHeight;
@property(nonatomic,assign)CGFloat titleScrollViewH;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,strong)NSMutableArray *titleIDMarr;
@property(nonatomic,strong)UIView *addAddressView;
@property(nonatomic,assign)BOOL isChangeAddress; //这个属性如果是新增地址的时候设置成false
-(UIView *)initAddressView;
-(void)addAnimate;
@end
