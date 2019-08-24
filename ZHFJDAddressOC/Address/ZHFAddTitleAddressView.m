//
//  ZHFAddTitleAddressView.m
//  ZHFJDAddressOC
//
//  Created by 张海峰 on 2017/12/18.
//  Copyright © 2017年 张海峰. All rights reserved.
//
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
#import "TownModel.h"
#import "AddressCell.h"
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
@property(nonatomic,strong)NSMutableArray *titleMarr;
@property(nonatomic,strong)NSMutableArray *tableViewMarr;
@property(nonatomic,strong)UILabel *lineLabel;
@property(nonatomic,assign)BOOL isInitalize;
@property(nonatomic,assign)BOOL isclick; //判断是滚动还是点击
@property(nonatomic,strong)NSMutableArray *provinceMarr;//省
@property(nonatomic,strong)NSMutableArray *cityMarr;//市
@property(nonatomic,strong)NSMutableArray *countyMarr;//县
@property(nonatomic,strong)NSMutableArray *townMarr;//乡
@property(nonatomic,strong)NSArray *resultArr;//本地数组
@property(nonatomic,assign)NSInteger PCCTID;
@property(nonatomic,assign)NSInteger scroolToRow; //确定在更改地址的时候能滚到对应的位置请求到下一级
@end
@implementation ZHFAddTitleAddressView
-(NSMutableArray *)titleBtns
{
    if (_titleBtns == nil) {
        _titleBtns = [[NSMutableArray alloc]init];
    }
    return _titleBtns;
}
-(NSMutableArray *)titleMarr
{
    if (_titleMarr == nil) {
        _titleMarr = [[NSMutableArray alloc]init];
    }
    return _titleMarr;
}
-(NSMutableArray *)tableViewMarr
{
    if (_tableViewMarr == nil) {
        _tableViewMarr = [[NSMutableArray alloc]init];
    }
    return _tableViewMarr;
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
-(NSMutableArray *)townMarr
{
    if (_townMarr == nil) {
        _townMarr = [[NSMutableArray alloc]init];
    }
    return _townMarr;
}
-(UIView *)initAddressView{
    //初始化本地数据（如果是网络请求请注释掉-----
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"location" ofType:@"txt"];
    NSString *string = [[NSString alloc] initWithContentsOfFile:imagePath encoding:NSUTF8StringEncoding error:nil];
    NSData * resData = [[NSData alloc]initWithData:[string dataUsingEncoding:NSUTF8StringEncoding]];
    _resultArr = [NSJSONSerialization JSONObjectWithData:resData options:NSJSONReadingMutableLeaves error:nil];
    //------到这里
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
    
    [self addTableViewAndTitle:0];
    //1.添加标题滚动视图
    [self setupTitleScrollView];
    //2.添加内容滚动视图
    [self setupContentScrollView];
    [self setupAllTitle:0];
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
    self.lineLabel.frame = CGRectMake(CGRectGetMinX(titleBtn.frame), self.titleScrollViewH - 3,titleBtn.frame.size.width, 3);
    [UIView animateWithDuration:0.25 animations:^{
         self.contentScrollView.contentOffset = CGPointMake(x, 0);
    }];
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
    else if (tableView.tag == 3){
        return self.townMarr.count;
    }
    else{
        return 0;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * AddressAdministerCellIdentifier = @"AddressAdministerCellIdentifier";
     AddressCell *cell = [tableView dequeueReusableCellWithIdentifier:AddressAdministerCellIdentifier];
    if (cell == nil) {
        cell = [[AddressCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AddressAdministerCellIdentifier];
    }
    if (tableView.tag == 0) {
        ProvinceModel * provinceModel = self.provinceMarr[indexPath.row];
        cell.nameLabel.text = provinceModel.province_name;
        self.PCCTID = provinceModel.id;
    }
    else if (tableView.tag == 1) {
        CityModel *cityModel = self.cityMarr[indexPath.row];
        cell.nameLabel.text= cityModel.city_name;
        self.PCCTID = cityModel.id;
    }
    else if (tableView.tag == 2){
        CountyModel * countyModel  = self.countyMarr[indexPath.row];
        cell.nameLabel.text = countyModel.county_name;
        self.PCCTID = countyModel.id;
    }
    else if (tableView.tag == 3){
        TownModel * townModel  = self.townMarr[indexPath.row];
        cell.nameLabel.text = townModel.town_name;
        self.PCCTID = townModel.id;
    }
    if (self.titleIDMarr.count > tableView.tag){
        NSInteger  pcctId  =  [self.titleIDMarr[tableView.tag] integerValue];
        if (self.PCCTID == pcctId){
            [cell.nameLabel setTextColor:UIColor.redColor];
            [cell.imageIcon setHidden:false];
            if (self.isChangeAddress == true){
                [self tableView:tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0]];
            }
        }
        else{
            [cell.nameLabel setTextColor:UIColor.grayColor];
            [cell.imageIcon setHidden:true];
        }
    }
    CGSize sizeNew = [cell.nameLabel.text sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:13]}];
    // 重新设置frame
    cell.nameLabel.frame = CGRectMake(20, 0, sizeNew.width, 40);
    cell.imageIcon.frame = CGRectMake(20 + sizeNew.width + 5, 25/2, 15, 15);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.isChangeAddress == false) {
        //先刷新当前选中的tableView
        UITableView * tableView1   = self.tableViewMarr[tableView.tag];
        [tableView1 reloadData];
    }
    if (tableView.tag == 0 || tableView.tag == 1 || tableView.tag == 2){
        if (tableView.tag == 0){
            ProvinceModel *provinceModel = self.provinceMarr[indexPath.row];
            NSString * provinceID = [NSString stringWithFormat:@"%ld",(long)provinceModel.id];
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
            NSString * cityID = [NSString stringWithFormat:@"%ld",(long)cityModel.id];
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
        else if (tableView.tag == 2) {
            CountyModel * countyModel = self.countyMarr[indexPath.row];
            NSString * countyID = [NSString stringWithFormat:@"%ld",(long)countyModel.id];
            [self.titleMarr replaceObjectAtIndex:tableView.tag withObject:countyModel.county_name];
            //1. 修改选中ID
            if (self.titleIDMarr.count > 2){
                [self.titleIDMarr replaceObjectAtIndex:tableView.tag withObject:countyID];
            }
            else{
                [self.titleIDMarr addObject:countyID];
            }
            //2.修改标题
            [self.titleMarr replaceObjectAtIndex:tableView.tag withObject:countyModel.county_name];
            //网络请求，添加县城
            [self getAddressMessageDataAddressID:4 provinceIdOrCityId:countyID];
        }
    }
    else if (tableView.tag == 3) {
        TownModel * townModel = self.townMarr[indexPath.row];
        NSString * townID = [NSString stringWithFormat:@"%ld",(long)townModel.id];
        [self.titleMarr replaceObjectAtIndex:tableView.tag withObject:townModel.town_name];
        //1. 修改选中ID
        if (self.titleIDMarr.count > 3){
            [self.titleIDMarr replaceObjectAtIndex:tableView.tag withObject:townID];
        }
        else{
            [self.titleIDMarr addObject:townID];
        }
        [self setupAllTitle:tableView.tag];
        if (self.isChangeAddress == false){
            [self tapBtnAndcancelBtnClick];
        }
        else{
            self.isChangeAddress = false;
        }
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
//添加tableView和title
-(void)addTableViewAndTitle:(NSInteger)tableViewTag{
    UITableView * tableView2 = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 200) style:UITableViewStylePlain];
    tableView2.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView2 registerClass:[AddressCell class] forCellReuseIdentifier:@"AddressAdministerCellIdentifier"];
    tableView2.tag = tableViewTag;
    [self.tableViewMarr addObject:tableView2];
    [self.titleMarr addObject:@"请选择"];
}
//改变title
-(void)changeTitle:(NSInteger)replaceTitleMarrIndex{
    [self.titleMarr replaceObjectAtIndex:replaceTitleMarrIndex withObject:@"请选择"];
    NSInteger index = [self.titleMarr indexOfObject:@"请选择"];
    NSInteger count = self.titleMarr.count;
    NSInteger loc = index + 1;
    NSInteger range = count - index;
    [self.titleMarr removeObjectsInRange:NSMakeRange(loc, range - 1)];
    [self.tableViewMarr removeObjectsInRange:NSMakeRange(loc, range - 1)];
}
//移除多余的title和tableView,收回选择器
-(void)removeTitleAndTableViewCancel:(NSInteger)index{
    NSInteger indexAddOne = index + 1;
    NSInteger indexsubOne = index - 1;
    if (self.tableViewMarr.count >= indexAddOne){
        [self.titleMarr removeObjectsInRange:NSMakeRange(index, self.titleMarr.count - indexAddOne)];
        [self.tableViewMarr removeObjectsInRange:NSMakeRange(index, self.tableViewMarr.count - indexAddOne)];
    }
    [self setupAllTitle:indexsubOne];
    if (self.isChangeAddress == false){
        [self tapBtnAndcancelBtnClick];
    }
    else{
        self.isChangeAddress = false;
    }
}
//本地数据
-(void)getAddressMessageDataAddressID:(NSInteger)addressID  provinceIdOrCityId: (NSString *)provinceIdOrCityId{
    if (addressID == 1) {
        [self caseProvinceArr:_resultArr];
    }
    else if(addressID == 2){
        [self caseCityArr:_resultArr withSelectedID:provinceIdOrCityId];
    }
    else if(addressID == 3){
        [self caseCountyArr:_resultArr withSelectedID:provinceIdOrCityId];
    }
    else if(addressID == 4){
        [self caseTownArr:_resultArr withSelectedID:provinceIdOrCityId];
    }
    if (self.tableViewMarr.count >= addressID){
        UITableView* tableView1   = self.tableViewMarr[addressID - 1];
        [tableView1 reloadData];
        [tableView1 layoutIfNeeded];
        if (self.isChangeAddress == true){
            //保证列表刷新之后才进行滚动处理
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"%ld",self.scroolToRow);
                if ([tableView1 numberOfRowsInSection:0] >= self.scroolToRow){
                    [tableView1 scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.scroolToRow  inSection:0 ] atScrollPosition: UITableViewScrollPositionBottom animated:false];
                }
            });
        }
    }
}
-(void)caseProvinceArr:(NSArray *)provinceArr{
    [self.provinceMarr removeAllObjects];
    NSInteger j = -1;
    if (provinceArr.count > 0){
        for (NSDictionary *dic in provinceArr)
        {
            if ([dic[@"parentid"] isEqualToString:@"0"]) {
                j = j + 1;
                NSDictionary * dic1 = @{@"id":dic[@"id"],
                                       @"province_name":dic[@"name"]};
                ProvinceModel *provinceModel = [ProvinceModel yy_modelWithDictionary:dic1];
                if (self.titleIDMarr.count > 0){
                    NSInteger provinceID = [self.titleIDMarr[0] integerValue];
                    if (provinceModel.id == provinceID){
                        self.scroolToRow = j;
                    }
                }
                [self.provinceMarr addObject:provinceModel];
            }
        }
    }
    else{
        if (self.isChangeAddress == false){
            [self tapBtnAndcancelBtnClick];
        }
        else{
            self.isChangeAddress = false;
        }
    }
}
-(void)caseCityArr:(NSArray *)cityArr withSelectedID:(NSString *)selectedID{
    [self.cityMarr removeAllObjects];
    NSInteger j = -1;
    for (NSDictionary *dic in cityArr) {
        if ([dic[@"parentid"] isEqualToString:selectedID]) {
            j = j + 1;
            NSDictionary * dic1 = @{@"id":dic[@"id"],
                                   @"city_name":dic[@"name"]};
            CityModel *cityModel = [CityModel yy_modelWithDictionary:dic1];
            if (self.titleIDMarr.count > 1){
                NSInteger cityID = [self.titleIDMarr[1] integerValue];
                if (cityModel.id == cityID){
                    self.scroolToRow = j;
                }
            }
            [self.cityMarr addObject:cityModel];
        }
    }
    if (self.tableViewMarr.count >= 2){
        [self changeTitle:1];
    }
    else{
        [self addTableViewAndTitle:1];
    }
    if (self.cityMarr.count > 0) {
        [self setupAllTitle:1];
    }
    else{
        //没有对应的市
        [self removeTitleAndTableViewCancel:1];
    }
}
-(void)caseCountyArr:(NSArray *)countyArr withSelectedID:(NSString *)selectedID{
    [self.countyMarr removeAllObjects];
    NSInteger j = -1;
    for (NSDictionary *dic in countyArr) {
        if ([dic[@"parentid"] isEqualToString:selectedID]) {
            j = j + 1;
            NSDictionary * dic1 = @{@"id":dic[@"id"],
                                    @"county_name":dic[@"name"]};
            CountyModel *countyModel =  [CountyModel yy_modelWithDictionary:dic1];
            if (self.titleIDMarr.count > 2){
                NSInteger countyID = [self.titleIDMarr[2] integerValue];
                if (countyModel.id == countyID){
                    self.scroolToRow = j;
                }
            }
            [self.countyMarr addObject:countyModel];
        }
    }
    if (self.tableViewMarr.count >= 3){
        [self changeTitle:2];
    }
    else{
        [self addTableViewAndTitle:2];
    }
    if (self.countyMarr.count > 0){
        [self setupAllTitle:2];
    }
    else{
        //没有对应的县
        [self removeTitleAndTableViewCancel:2];
    }
}
-(void)caseTownArr:(NSArray *)countyArr withSelectedID:(NSString *)selectedID{
    [self.townMarr removeAllObjects];
    NSInteger j = -1;
    for (NSDictionary *dic in countyArr) {
        if ([dic[@"parentid"] isEqualToString:selectedID]) {
            j = j + 1;
            NSDictionary * dic1 = @{@"id":dic[@"id"],
                                    @"town_name":dic[@"name"]};
            TownModel *townModel =  [TownModel yy_modelWithDictionary:dic1];
            if (self.titleIDMarr.count > 3){
                NSInteger townID = [self.titleIDMarr[3] integerValue];
                if (townModel.id == townID){
                    self.scroolToRow = j;
                }
            }
            [self.townMarr addObject:townModel];
        }
    }
    if (self.tableViewMarr.count >= 4){
        [self changeTitle:3];
    }
    else{
        [self addTableViewAndTitle:3];
    }
    if (self.townMarr.count > 0){
        [self setupAllTitle:3];
    }
    else{
        //没有对应的乡镇
        [self removeTitleAndTableViewCancel:3];
    }
}
//(以下注释部分是网络请求)
//-(void)getAddressMessageDataAddressID:(NSInteger)addressID  provinceIdOrCityId: (NSString *)provinceIdOrCityId{
//        NSString * addressUrl = [[NSString alloc]init];
//        NSDictionary *parameters = [[NSDictionary alloc]init];
//        NSString * UserID = [[NSString alloc]initWithFormat:@"%ld",self.userID];
//        if (addressID == 1) {
//            //获取省份的URL
//            addressUrl = @"getProvinceAddressUrl";
//            //请求省份需要传递的参数
//            parameters = @{@"user_id" : UserID};
//        } else if(addressID == 2){
//            //获取市区的URL
//            addressUrl = @"getCityAddressUrl";
//            //请求市区需要传递的参数
//            parameters = @{@"province_id" : provinceIdOrCityId,
//                           @"user_id" : UserID};
//        }
//        else if(addressID == 3){
//            //获取县的URL
//            addressUrl = @"getCountyAddressUrl";
//            //请求县需要传递的参数
//            parameters = @{@"city_id" : provinceIdOrCityId,
//                           @"user_id" : UserID};
//        }
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
//                        break;
//                case 2:
//                    //拿到市列表
//                    arr = dic[@"data"];
//                        [self caseCityArr:arr];
//                        break;
//                case 3:
//                    //拿到县列表
//                    arr = dic[@"data"];
//                        [self caseCountyArr:arr];
//                        break;
//                case 4:
//                    //拿到乡镇列表
//                    arr = dic[@"data"];
//                        [self caseTownArr:arr];
//                        break;
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
//    }else{
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
//            [self changeTitle:1];
//        }
//        else{
//            [self addTableViewAndTitle:1];
//        }
//        [self setupAllTitle:1];
//    }
//    else{
//        //没有对应的市
//        [self removeTitleAndTableViewCancel:1];
//    }
//}
//
//-(void)caseCountyArr:(NSArray *)countyArr{
//    if (countyArr.count > 0){
//        [self.countyMarr removeAllObjects];
//        for (int i = 0; i < countyArr.count; i++) {
//            NSDictionary *dic1 = countyArr[i];
//            CountyModel *countyModel = [CountyModel yy_modelWithDictionary:dic1];
//            [self.countyMarr addObject:countyModel];
//        }
//        if (self.tableViewMarr.count >= 3){
//           [self changeTitle:2];
//        }
//        else{
//            [self addTableViewAndTitle:2];
//        }
//        [self setupAllTitle:2];
//    }
//    else{
//        //没有对应的县
//        [self removeTitleAndTableViewCancel:2];
//    }
//}
//
//-(void)caseTownArr:(NSArray *)townArr{
//    if (townArr.count > 0){
//        [self.townMarr removeAllObjects];
//        for (int i = 0; i < townArr.count; i++) {
//            NSDictionary *dic1 = townArr[i];
//            TownModel *townModel = [TownModel yy_modelWithDictionary:dic1];
//            [self.townMarr addObject:townModel];
//        }
//        if (self.tableViewMarr.count >= 4){
//           [self changeTitle:3];
//        }
//        else{
//            [self addTableViewAndTitle:3];
//        }
//        [self setupAllTitle:3];
//    }
//    else{
//        //没有对应的乡镇
//        [self removeTitleAndTableViewCancel:3];
//    }
//}

@end

