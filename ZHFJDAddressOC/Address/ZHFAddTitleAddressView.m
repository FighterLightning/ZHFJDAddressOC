//
//  ZHFAddTitleAddressView.m
//  ZHFJDAddressOC
//
//  Created by 张海峰 on 2017/12/18.
//  Copyright © 2017年 张海峰. All rights reserved.
//
/*
 这个视图你需要修改的地方为：(网络请求部分)
 -(void)getAddressMessageDataAddressID:(NSInteger)addressID  provinceIdOrCityId: (NSString *)provinceIdOrCityId
 该方法里的代码，已写清楚
 一个是模拟数据。
 二是网络请求数据。
 （因本人网络请求是局域网，所以网络请求的思路已在方法里写明，三个url，
 三个字典，修改成自己的即可使用。）
 */
#import "ZHFAddTitleAddressView.h"
#import "ProvinceModel.h"
#import "CityModel.h"
#import "CountyModel.h"
#import <YYModel/YYModel.h>
#import "HttpRequest.h"
//设备物理尺寸
#define screen_width [UIScreen mainScreen].bounds.size.width
#define screen_height [UIScreen mainScreen].bounds.size.height
@interface ZHFAddTitleAddressView ()<UIScrollViewDelegate,UIGestureRecognizerDelegate,UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UIScrollView *titleScrollView;
@property(nonatomic,strong)UIScrollView *contentScrollView;
@property(nonatomic,strong)UIButton *radioBtn;
@property(nonatomic,strong)NSMutableArray *titleBtns;
@property(nonatomic,strong)UILabel *lineLabel;
@property(nonatomic,strong)NSMutableArray *titleIDMarr;
@property(nonatomic,assign)BOOL isInitalize;
@property(nonatomic,assign)BOOL isclick; //判断是滚动还是点击
@property(nonatomic,strong)NSMutableArray *provinceMarr;
@property(nonatomic,strong)NSMutableArray *cityMarr;
@property(nonatomic,strong)NSMutableArray *countyMarr;
@end
@implementation ZHFAddTitleAddressView
-(NSMutableArray *)titleBtns
{
    if (_titleBtns == nil) {
        _titleBtns = [[NSMutableArray alloc]init];
    }
    return _titleBtns;
}
-(NSMutableArray *)titleIDMarr
{
    if (_titleIDMarr == nil) {
        _titleIDMarr = [[NSMutableArray alloc]init];
    }
    return _titleIDMarr;
}
-(NSMutableArray *)provinceMarr
{
    if (_provinceMarr == nil) {
        _provinceMarr = [[NSMutableArray alloc]init];
    }
    return _provinceMarr;
}
-(NSMutableArray *)cityMarr
{
    if (_cityMarr == nil) {
        _cityMarr = [[NSMutableArray alloc]init];
    }
    return _cityMarr;
}
-(NSMutableArray *)countyMarr
{
    if (_countyMarr == nil) {
        _countyMarr = [[NSMutableArray alloc]init];
    }
    return _countyMarr;
}

-(UIView *)initAddressView{
    self.frame = CGRectMake(0, 0, screen_width, screen_height);
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    self.hidden = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapBtnAndcancelBtnClick)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
    //设置添加地址的View
    self.addAddressView = [[UIView alloc]init];
    self.addAddressView.frame = CGRectMake(0, screen_height, screen_width, _defaultHeight);
    self.addAddressView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.addAddressView];
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 10, screen_width - 80, 30)];
    titleLabel.text = _title;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor grayColor];
    titleLabel.font = [UIFont systemFontOfSize:17];
    [self.addAddressView addSubview:titleLabel];
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    cancelBtn.frame =CGRectMake(CGRectGetMaxX(self.addAddressView.frame) - 40, 10, 30, 30);
    cancelBtn.tag = 1;
    [cancelBtn setImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(tapBtnAndcancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.addAddressView addSubview:cancelBtn];
    return self;
}
-(void)addAnimate{
    self.hidden = NO;
    [UIView animateWithDuration:0.2 animations:^{
        self.addAddressView.frame = CGRectMake(0, screen_height - self.defaultHeight, screen_width, self.defaultHeight);
    }];
}
-(void)tapBtnAndcancelBtnClick{
    self.hidden = NO;
    [UIView animateWithDuration:0.2 animations:^{
         self.addAddressView.frame = CGRectMake(0, screen_height, screen_width, 200);
    } completion:^(BOOL finished) {
        self.hidden = YES;
        NSMutableString * titleAddress = [[NSMutableString alloc]init];
        NSMutableString * titleID = [[NSMutableString alloc]init];
        NSInteger  count = 0;
        NSString * str = self.titleMarr[self.titleMarr.count - 1];
        if ([str isEqualToString:@"请选择"]) {
            count = self.titleMarr.count - 1;
        }
        else{
            count = self.titleMarr.count;
        }
        for (int i = 0; i< count ; i++) {
            [titleAddress appendString:[[NSString alloc]initWithFormat:@" %@",self.titleMarr[i]]];
            if (i == count - 1) {
                [titleID appendString:[[NSString alloc]initWithFormat:@" %@",self.titleIDMarr[i]]];
            }
            else{
                [titleID appendString:[[NSString alloc]initWithFormat:@"%@ =",self.titleIDMarr[i]]];
            }
        }
        [self.delegate1 cancelBtnClick:titleAddress titleID:titleID];
    }];
}
-(void)setupTitleScrollView{
    //TitleScrollView和分割线
    self.titleScrollView = [[UIScrollView alloc]init];
    self.titleScrollView.frame = CGRectMake(0, 50, screen_width, _titleScrollViewH);
    [self.addAddressView addSubview:self.titleScrollView];
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.titleScrollView.frame), screen_width, 0.5)];
    lineView.backgroundColor = [UIColor grayColor];
    [self.addAddressView addSubview:(lineView)];
}
-(void)setupContentScrollView{
    //ContentScrollView
    CGFloat y  =  CGRectGetMaxY(self.titleScrollView.frame) + 1;
     self.contentScrollView = [[UIScrollView alloc]init];
    self.contentScrollView.frame = CGRectMake(0, y, screen_width, self.defaultHeight - y);
    [self.addAddressView addSubview:self.contentScrollView];
    self.contentScrollView.delegate = self;
    self.contentScrollView.pagingEnabled = YES;
    self.contentScrollView.bounces = NO;
}
-(void)setupAllTitle:(NSInteger)selectId{
    for ( UIView * view in [self.titleScrollView subviews]) {
         [view removeFromSuperview];
    }
    [self.titleBtns removeAllObjects];
    CGFloat btnH = self.titleScrollViewH;
    _lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 1, 1)];
    _lineLabel.backgroundColor = [UIColor redColor];
    [self.titleScrollView addSubview:(_lineLabel)];
    CGFloat x = 10;
    for (int i = 0; i < self.titleMarr.count ; i++) {
        NSString   *title = self.titleMarr[i];
        CGFloat titlelenth = title.length * 15;
        UIButton *titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [titleBtn setTitle:title forState:UIControlStateNormal];
        titleBtn.tag = i;
        [titleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
         [titleBtn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        titleBtn.selected = NO;
        titleBtn.frame = CGRectMake(x, 0, titlelenth, btnH);
        x  = titlelenth + 10 + x;
        [titleBtn.titleLabel setFont:[UIFont systemFontOfSize:13.0]];
        [titleBtn addTarget:self action:@selector(titleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.titleBtns addObject:titleBtn];
        if (i == selectId) {
            [self titleBtnClick:titleBtn];
        }
        [self.titleScrollView addSubview:(titleBtn)];
        self.titleScrollView.contentSize =CGSizeMake(x, 0);
        self.titleScrollView.showsHorizontalScrollIndicator = NO;
        self.contentScrollView.contentSize = CGSizeMake(self.titleMarr.count * screen_width, 0);
        self.contentScrollView.showsHorizontalScrollIndicator = NO;
    }
}
-(void)titleBtnClick:(UIButton *)titleBtn{
    self.radioBtn.selected = NO;
    titleBtn.selected = YES;
    [self setupOneTableView:titleBtn.tag];
    CGFloat x  = titleBtn.tag * screen_width;
    self.contentScrollView.contentOffset = CGPointMake(x, 0);
    self.lineLabel.frame = CGRectMake(CGRectGetMinX(titleBtn.frame), self.titleScrollViewH - 3,titleBtn.frame.size.width, 3);
    self.radioBtn = titleBtn;
    self.isclick = YES;
    }
-(void)setupOneTableView:(NSInteger)btnTag{
    UITableView  * contentView= self.tableViewMarr[btnTag];
    if  (btnTag == 0) {
        [self getAddressMessageDataAddressID:1 provinceIdOrCityId:0];
    }
    if (contentView.superview != nil) {
        return;
    }
    CGFloat  x= btnTag * screen_width;
    contentView.frame = CGRectMake(x, 0, screen_width, self.contentScrollView.bounds.size.height);
    contentView.delegate = self;
    contentView.dataSource = self;
    [self.contentScrollView addSubview:(contentView)];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSInteger leftI  = scrollView.contentOffset.x / screen_width;
    if (scrollView.contentOffset.x / screen_width != leftI){
        self.isclick = NO;
    }
    if (self.isclick == NO) {
        if (scrollView.contentOffset.x / screen_width == leftI){
            UIButton * titleBtn  = self.titleBtns[leftI];
            [self titleBtnClick:titleBtn];
        }
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag == 0) {
        return self.provinceMarr.count;
    }
    else if (tableView.tag == 1) {
        return self.cityMarr.count;
    }
    else if (tableView.tag == 2){
        return self.countyMarr.count;
    }
    else{
        return 0;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * AddressAdministerCellIdentifier = @"AddressAdministerCellIdentifier";
    UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:AddressAdministerCellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AddressAdministerCellIdentifier];
    }
    if (tableView.tag == 0) {
        ProvinceModel * provinceModel = self.provinceMarr[indexPath.row];
        cell.textLabel.text = provinceModel.province_name;
    }
    else if (tableView.tag == 1) {
        CityModel *cityModel = self.cityMarr[indexPath.row];
        cell.textLabel.text= cityModel.city_name;
    }
    else if (tableView.tag == 2){
        CountyModel * countyModel  = self.countyMarr[indexPath.row];
        cell.textLabel.text = countyModel.county_name;
    }
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    cell.textLabel.textColor = [UIColor grayColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 0 || tableView.tag == 1){
        if (tableView.tag == 0){
            ProvinceModel *provinceModel = self.provinceMarr[indexPath.row];
             NSString * provinceID = [NSString stringWithFormat:@"%ld",provinceModel.id];
            //1. 修改选中ID
            if (self.titleIDMarr.count > 0){
                [self.titleIDMarr replaceObjectAtIndex:tableView.tag withObject:provinceID];
            }
            else{
                [self.titleIDMarr addObject:provinceID];
            }
            //2.修改标题
              [self.titleMarr replaceObjectAtIndex:tableView.tag withObject:provinceModel.province_name];
            //请求网络 添加市区
            [self getAddressMessageDataAddressID:2 provinceIdOrCityId:provinceID];
        }
        else if (tableView.tag == 1){
            CityModel * cityModel = self.cityMarr[indexPath.row];
             NSString * cityID = [NSString stringWithFormat:@"%ld",cityModel.id];
             [self.titleMarr replaceObjectAtIndex:tableView.tag withObject:cityModel.city_name];
            //1. 修改选中ID
            if (self.titleIDMarr.count > 1){
                [self.titleIDMarr replaceObjectAtIndex:tableView.tag withObject:cityID];
            }
            else{
                 [self.titleIDMarr addObject:cityID];
            }
            //网络请求，添加县城
            [self getAddressMessageDataAddressID:3 provinceIdOrCityId:cityID];
        }
    }
    else if (tableView.tag == 2) {
        CountyModel * countyModel = self.countyMarr[indexPath.row];
        NSString * countyID = [NSString stringWithFormat:@"%ld",countyModel.id];
        [self.titleMarr replaceObjectAtIndex:tableView.tag withObject:countyModel.county_name];
        //1. 修改选中ID
        if (self.titleIDMarr.count > 2){
             [self.titleIDMarr replaceObjectAtIndex:tableView.tag withObject:countyID];
        }
        else{
             [self.titleIDMarr addObject:countyID];
        }
        [self setupAllTitle:tableView.tag];
        [self tapBtnAndcancelBtnClick];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  40;
}
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([NSStringFromClass(touch.view.classForCoder) isEqualToString: @"UITableViewCellContentView"] || touch.view == self.addAddressView || touch.view == self.titleScrollView) {
        return NO;
    }
    return YES;
}
//本地数据
-(void)getAddressMessageDataAddressID:(NSInteger)addressID  provinceIdOrCityId: (NSString *)provinceIdOrCityId{
    if (addressID == 1) {
        [self.provinceMarr removeAllObjects];
        for (int i = 0; i<64; i++) {
            NSString * ids = [[NSString alloc]initWithFormat:@"%d",i];
            NSString * province_name = [[NSString alloc]initWithFormat:@"第%d省",i];
            NSDictionary * dic1 = @{
                                    @"id":ids,
                                    @"province_name":province_name
                                    };
            ProvinceModel *provinceModel = [ProvinceModel yy_modelWithDictionary:dic1];
            [self.provinceMarr addObject:provinceModel];
        }
    }
    else if(addressID == 2){
        [self.cityMarr removeAllObjects];
        for (int i = 0; i<30; i++){
            NSString * ids = [[NSString alloc]initWithFormat:@"%d",i];
            NSString * city_name = [[NSString alloc]initWithFormat:@"第%d市",i];
            NSDictionary * dic1 = @{
                                    @"id":ids,
                                    @"city_name":city_name
                                    };
            CityModel *cityModel =  [CityModel yy_modelWithDictionary:dic1];
            [self.cityMarr addObject:cityModel];
        }
        if (self.tableViewMarr.count >= 2){
            [self.titleMarr replaceObjectAtIndex:1 withObject:@"请选择"];
            if (self.tableViewMarr.count > 2){
                [self.titleMarr removeLastObject];
                [self.tableViewMarr removeLastObject];
            }
        }
        else{
            UITableView * tableView2 = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 200) style:UITableViewStylePlain];
            tableView2.separatorStyle = UITableViewCellSeparatorStyleNone;
            tableView2.tag = 1;
            [self.tableViewMarr addObject:tableView2];
            [self.titleMarr addObject:@"请选择"];
            
        }
         [self setupAllTitle:1];
    }
    else if(addressID == 3){
        [self.countyMarr removeAllObjects];
        for (int i = 0; i<10; i++){
            NSString * ids = [[NSString alloc]initWithFormat:@"%d",i];
            NSString * county_name = [[NSString alloc]initWithFormat:@"%d县",i];
            NSDictionary * dic1 = @{
                                    @"id":ids,
                                    @"county_name":county_name
                                    };
            CountyModel *countyModel =  [CountyModel yy_modelWithDictionary:dic1];
            [self.countyMarr addObject:countyModel];
        }
        if (self.tableViewMarr.count > 2){
            [self.titleMarr replaceObjectAtIndex:2 withObject:@"请选择"];
        }
        else{
            UITableView * tableView2 = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 200) style:UITableViewStylePlain];
            tableView2.separatorStyle = UITableViewCellSeparatorStyleNone;
            tableView2.tag = 2;
            [self.tableViewMarr addObject:tableView2];
            [self.titleMarr addObject:@"请选择"];
        }
        [self setupAllTitle:2];
    }
    if (self.tableViewMarr.count >= addressID){
        UITableView* tableView1   = self.tableViewMarr[addressID - 1];
        [tableView1 reloadData];
    }
    
}
//(以下注释部分是网络请求)
//-(void)getAddressMessageDataAddressID:(NSInteger)addressID  provinceIdOrCityId: (NSString *)provinceIdOrCityId{
//    NSString * addressUrl = [[NSString alloc]init];
//    NSDictionary *parameters = [[NSDictionary alloc]init];
//    NSString * UserID = [[NSString alloc]initWithFormat:@"%ld",self.userID];
//    if (addressID == 1) {
//        //获取省份的URL
//        addressUrl = @"getProvinceAddressUrl";
//        //请求省份需要传递的参数
//        parameters = @{@"user_id" : UserID};
//    } else if(addressID == 2){
//        //获取市区的URL
//        addressUrl = @"getCityAddressUrl";
//        //请求市区需要传递的参数
//        parameters = @{@"province_id" : provinceIdOrCityId,
//                       @"user_id" : UserID};
//    }
//    else if(addressID == 3){
//        //获取县的URL
//        addressUrl = @"getCountyAddressUrl";
//        //请求县需要传递的参数
//        parameters = @{@"city_id" : provinceIdOrCityId,
//                       @"user_id" : UserID};
//    }
//    //网络请求
//    [HttpRequest requestWithURLString:addressUrl parameters:parameters type:HttpRequestTypePost success:^(id responseObject) {
//        if (responseObject != nil)
//        {
//            NSDictionary * dic = responseObject;
//            //成功
//            if([dic[@"statues"] isEqualToString:@"1"]){
//                NSArray *arr = [[NSArray alloc]init];
//                switch (addressID) {
//                case 1:
//                    //拿到省列表
//                        arr =  dic[@"data"];
//                        [self caseProvinceArr:arr];
//                case 2:
//                    //拿到市列表
//                    arr = dic[@"data"];
//                        [self caseCityArr:arr];
//                case 3:
//                    //拿到县列表
//                    arr = dic[@"data"];
//                        [self caseCountyArr:arr];
//
//                default:
//                    break;
//                }
//                if (self.tableViewMarr.count >= addressID){
//                    UITableView * tableView1  = self.tableViewMarr[addressID - 1];
//                    [tableView1 reloadData];
//                }
//            }
//            else{
//                NSLog(@"请求数据失败");
//            }
//        }
//        else{
//            NSLog(@"请求数据失败");
//        }
//    } failure:^(NSError *error) {
//          NSLog(@"网络请求失败");
//    }];
//}
//-(void)caseProvinceArr:(NSArray *)provinceArr{
//    if (provinceArr.count > 0){
//        [self.provinceMarr removeAllObjects];
//        for (int i = 0; i < provinceArr.count; i++) {
//            NSDictionary *dic1 = provinceArr[i];
//            ProvinceModel *provinceModel =  [ProvinceModel yy_modelWithDictionary:dic1];
//            [self.provinceMarr addObject:provinceModel];
//        }
//    }
//    else{
//        [self tapBtnAndcancelBtnClick];
//    }
//}
//-(void)caseCityArr:(NSArray *)cityArr{
//    if (cityArr.count > 0){
//        [self.cityMarr removeAllObjects];
//        for (int i = 0; i < cityArr.count; i++) {
//            NSDictionary *dic1 = cityArr[i];
//            CityModel *cityModel = [CityModel yy_modelWithDictionary:dic1];
//            [self.cityMarr addObject:cityModel];
//        }
//        if (self.tableViewMarr.count >= 2){
//            [self.titleMarr replaceObjectAtIndex:1 withObject:@"请选择"];
//            if (self.tableViewMarr.count > 2){
//                [self.titleMarr removeLastObject];
//                [self.tableViewMarr removeLastObject];
//            }
//        }
//        else{
//            UITableView * tableView2 = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 200) style:UITableViewStylePlain];
//            tableView2.separatorStyle = UITableViewCellSeparatorStyleNone;
//            tableView2.tag = 1;
//            [self.tableViewMarr addObject:tableView2];
//            [self.titleMarr addObject:@"请选择"];
//        }
//        [self setupAllTitle:1];
//    }
//    else{
//        //没有对应的市
//        if (self.tableViewMarr.count > 2){
//            [self.titleMarr removeLastObject];
//            [self.tableViewMarr removeLastObject];
//        }
//        if (self.tableViewMarr.count == 2){
//            [self.titleMarr removeLastObject];
//            [self.tableViewMarr removeLastObject];
//        }
//        [self setupAllTitle:0];
//        [self tapBtnAndcancelBtnClick];
//    }
//}
//-(void)caseCountyArr:(NSArray *)countyArr{
//    if (countyArr.count > 0){
//        [self.countyMarr removeAllObjects];
//        for (int i = 0; i < countyArr.count; i++) {
//            NSDictionary *dic1 = countyArr[i];
//            CountyModel *countyModel =  [CountyModel yy_modelWithDictionary:dic1];
//            [self.cityMarr addObject:countyModel];
//        }
//        if (self.tableViewMarr.count > 2){
//            [self.titleMarr replaceObjectAtIndex:2 withObject:@"请选择"];
//        }
//        else{
//            UITableView * tableView2 = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 200) style:UITableViewStylePlain];
//            tableView2.separatorStyle = UITableViewCellSeparatorStyleNone;
//            tableView2.tag = 2;
//            [self.tableViewMarr addObject:tableView2];
//            [self.titleMarr addObject:@"请选择"];
//        }
//        [self setupAllTitle:2];
//    }
//    else{
//        //没有对应的县
//        if (self.tableViewMarr.count > 2){
//            [self.titleMarr removeLastObject];
//            [self.tableViewMarr removeLastObject];
//        }
//        [self setupAllTitle:1];
//        [self tapBtnAndcancelBtnClick];
//    }
//}


@end

