//
//  CityTableViewCell.h
//  地区选择
//
//  Created by apple on 16/4/5.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CityTableViewCell : UITableViewCell
@property(nonatomic,strong)NSArray*cityArray;
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cityArray:(NSArray*)array;
@property(nonatomic,copy)void(^didSelectedBtn)(int tag);

@end
