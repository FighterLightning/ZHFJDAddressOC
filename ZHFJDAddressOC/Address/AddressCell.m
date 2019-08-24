//
//  AddressCell.m
//  ZHFJDAddressOC
//
//  Created by 张海峰 on 2019/8/24.
//  Copyright © 2019年 张海峰. All rights reserved.
//

#import "AddressCell.h"

@implementation AddressCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // 昵称
       self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 30, 40)];
        self.nameLabel.font = [UIFont systemFontOfSize:13];
        self.nameLabel.textColor = UIColor.grayColor;
        [self addSubview:self.nameLabel];
        self.imageIcon = [[UIImageView alloc] init];
        self.imageIcon.image  = [UIImage imageNamed:@"right"];
        [self.imageIcon setHidden: true];
        [self addSubview:self.imageIcon];
    }
    
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
