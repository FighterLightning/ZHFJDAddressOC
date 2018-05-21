//
//  TownModel.h
//  ZHFJDAddressOC
//
//  Created by 张海峰 on 2018/5/21.
//  Copyright © 2018年 张海峰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TownModel : NSObject
@property(nonatomic,assign)NSInteger county_id;
@property(nonatomic,copy)NSString *town_name;
@property(nonatomic,copy)NSString *created_time;
@property(nonatomic,assign)NSInteger id;
@property(nonatomic,assign)NSInteger is_enabled;
@property(nonatomic,assign)NSInteger seq_no;
@property(nonatomic,copy)NSString *updated_time;
@property(nonatomic,assign)NSInteger updated_user;
@end
