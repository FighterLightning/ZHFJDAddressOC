//
//  AddressVC.m
//  ZHFJDAddressOC
//
//  Created by 张海峰 on 2019/8/24.
//  Copyright © 2019年 张海峰. All rights reserved.
//

#import "AddressVC.h"
#import "ZHFAddTitleAddressView.h"
#define screen_width [UIScreen mainScreen].bounds.size.width
#define screen_height [UIScreen mainScreen].bounds.size.height
@interface AddressVC ()<ZHFAddTitleAddressViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *addressBtn;
@property(nonatomic,strong)ZHFAddTitleAddressView * addTitleAddressView;
@end

@implementation AddressVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.addTitleAddressView = [[ZHFAddTitleAddressView alloc]init];
    if (self.isEdit == true) {
        self.addTitleAddressView.titleIDMarr = [[NSMutableArray alloc] initWithObjects:@"44",@"4405",@"440513",@"440513100", nil];
        [self.addressBtn setTitle:@"广东省 汕头市 潮阳区 海门镇" forState:UIControlStateNormal];
        [self setUI];
    }else{
        [self.addressBtn setTitle:@"新增" forState:UIControlStateNormal];
        [self setUI];
    }
}
-(void)setUI{
    self.addTitleAddressView.title = @"选择地址";
    self.addTitleAddressView.delegate1 = self;
    self.addTitleAddressView.defaultHeight = 350;
    self.addTitleAddressView.titleScrollViewH = 37;
    if (self.addTitleAddressView.titleIDMarr.count > 0) {
        self.addTitleAddressView.isChangeAddress = true;
    }
    else{
        self.addTitleAddressView.isChangeAddress = false;
    }
   
    [self.view addSubview:[self.addTitleAddressView initAddressView]];
}

- (IBAction)addressBtnClick:(UIButton *)sender {
    [self.addTitleAddressView addAnimate];
}

-(void)cancelBtnClick:(NSString *)titleAddress titleID:(NSString *)titleID{
    [self.addressBtn setTitle:titleAddress forState:UIControlStateNormal];
    NSLog( @"%@", [NSString stringWithFormat:@"打印的对应省市县的id=%@",titleID]);
}
@end
