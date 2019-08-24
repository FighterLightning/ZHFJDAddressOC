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


#import "ViewController.h"
#import "AddressVC.h"
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *addressBtn; //新增
@property (weak, nonatomic) IBOutlet UIButton *editAdressBtn; //编辑地址


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (IBAction)addressBtnClick:(UIButton *)sender {
    if (sender.tag == 1){
        //新建
        AddressVC *addressVC = [[AddressVC alloc]init];
        addressVC.isEdit = false;
        [self.navigationController pushViewController:addressVC animated:true];
    }
    if (sender.tag == 2){
        //编辑
        AddressVC *addressVC = [[AddressVC alloc]init];
        addressVC.isEdit = true;
        [self.navigationController pushViewController:addressVC animated:true];

    }
}




@end
