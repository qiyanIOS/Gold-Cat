//
//  RegionResultViewController.h
//  地区选择
//
//  Created by apple on 16/4/7.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol RegionResultViewControllerDelegate<NSObject>
-(void)didScroll;
-(void)didSelectedString:(NSString*)string;
@end
@interface RegionResultViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)NSMutableArray* dataArray;
@property(nonatomic,strong)UITableView* tableView;
@property(nonatomic,assign)id<RegionResultViewControllerDelegate>delegate;
@end
