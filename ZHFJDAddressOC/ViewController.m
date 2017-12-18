//
//  ViewController.m
//  ZHFJDAddressOC
//
//  Created by 张海峰 on 2017/12/18.
//  Copyright © 2017年 张海峰. All rights reserved.
//写过Swift版本之后，有读者需要OC版本，现写下，希望能为你们提供帮助。
/*该demo的使用须知:
 1.把Address文件拖进项目
 2.pod 'AFNetworking'//网络请求
 pod 'YYModel' //字典转模型
 3.把以下代码添加进自己的控制器方可使用,注意顺序，网络请求看ZHFAddTitleAddressView.m头部注释根据需求进行修改
 4.如果感觉有帮助，不要吝啬你的星星哦！
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
    self.addTitleAddressView.userID = 7;
    self.addTitleAddressView.delegate1 = self;
    self.addTitleAddressView.defaultHeight = 350;
    self.addTitleAddressView.titleScrollViewH = 37;
    [self.view addSubview:[self.addTitleAddressView initAddressView]];
    UITableView * tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 200) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.tag = 0;
    self.addTitleAddressView.tableViewMarr = [[NSMutableArray alloc]init];
    self.addTitleAddressView.titleMarr = [[NSMutableArray alloc]init];
    [self.addTitleAddressView.tableViewMarr addObject:tableView];
    [self.addTitleAddressView.titleMarr addObject:@"请选择"];
    //1.添加标题滚动视图
    [self.addTitleAddressView setupTitleScrollView];
    //2.添加内容滚动视图
    [self.addTitleAddressView setupContentScrollView];
    [self.addTitleAddressView setupAllTitle:0];
    
}
- (IBAction)addressBtnClick:(id)sender {
    [self.addTitleAddressView addAnimate];
}
-(void)cancelBtnClick:(NSString *)titleAddress titleID:(NSString *)titleID{
    [self.addressBtn setTitle:titleAddress forState:UIControlStateNormal];
    NSLog( @"%@", [NSString stringWithFormat:@"打印的对应省市县的id=%@",titleID]);
}



@end