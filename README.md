# ZHFJDAddressOC
### 这是一个自定义仿京东地址选择器--OC版本（保证集成成功，有不懂的地方可加QQ：991150443 进行讨论。）
Swift版本地址：

`
https://github.com/FighterLightning/ZHFJDAddress.git

---


 
 ![](./ZHFJDAddressOC/1.gif)



#### Demo的使用须知:
 1. 下载该demo。把Address文件拖进项目（里面有一个View（主要），五个model（一个网络，剩下省、市、区、乡镇））

 2. 在 Podfile 中添加:
 * `pod 'AFNetworking'`
 * `pod 'YYModel'`
 	（这两个可以根据需求添加）
 3. 你主要需要关注的是ZHFAddTitleAddressView.m 这个方法

```
-(void)getAddressMessageDataAddressID:(NSInteger)addressID provinceIdOrCityId: (NSString *)provinceIdOrCityId
这个方法。addressID 决定的是展现那个tableView,  provinceIdOrCityId这个决定要请求的是省市区还是乡镇。
```

#### 代码思路分析:
看这个地址选择器的大致框架是UIScrollView与UITableView结合的附带一个展示头的东西.主要就是逻辑展示问题。
```
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
```
  通过对这个点击方法里 self.titleMarr，（ 存放选中地址名字的可变数组)     
  self.titleIDMarr （存放选中地址ID的可变数组）   
  进行增加，删除，改。  
  然后获得下一级数据（同时判断是否有下一级，没有直接回收地址选择器）  
  把当前地址展示，同时把ID传入控制器。  
 
# PS

 如果感觉有帮助，感谢fork star！
 
该demo地址：
`
https://github.com/FighterLightning/ZHFJDAddressOC.git
