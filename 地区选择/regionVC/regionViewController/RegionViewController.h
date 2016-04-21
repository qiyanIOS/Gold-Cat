//
//  RegionViewController.h
//  地区选择
//
//  Created by apple on 16/4/5.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegionViewController : UIViewController
@property (nonatomic,copy)NSString *currentCityString;
@property(nonatomic,copy)void(^selectedStr)(NSString*str);
@end
