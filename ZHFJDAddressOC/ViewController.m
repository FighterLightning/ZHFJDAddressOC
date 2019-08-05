//
//  ViewController.m
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
 简书链接：https://www.jianshu.com/p/0269071219af
 */

#define screen_width [UIScreen mainScreen].bounds.size.width
#define screen_height [UIScreen mainScreen].bounds.size.height
#import "ViewController.h"
#import "ZHFAddTitleAddressView.h"
@interface ViewController ()<ZHFAddTitleAddressViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *addressBtn;
@property(nonatomic,strong)ZHFAddTitleAddressView * addTitleAddressView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}
-(void)setUI{
    self.addTitleAddressView = [[ZHFAddTitleAddressView alloc]init];
    self.addTitleAddressView.title = @"选择地址";
    self.addTitleAddressView.delegate1 = self;
    self.addTitleAddressView.defaultHeight = 350;
    self.addTitleAddressView.titleScrollViewH = 37;
    [self.view addSubview:[self.addTitleAddressView initAddressView]];
}
- (IBAction)addressBtnClick:(id)sender {
    [self.addTitleAddressView addAnimate];
}
-(void)cancelBtnClick:(NSString *)titleAddress titleID:(NSString *)titleID{
    [self.addressBtn setTitle:titleAddress forState:UIControlStateNormal];
    NSLog( @"%@", [NSString stringWithFormat:@"打印的对应省市县的id=%@",titleID]);
}



@end
