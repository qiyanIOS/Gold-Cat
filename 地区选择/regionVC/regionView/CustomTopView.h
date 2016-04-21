//
//  CustomTopView.h
//  地区选择
//
//  Created by apple on 16/4/5.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CustomTopViewDelegate<NSObject>
-(void)didSelectBackButton;
@end
@interface CustomTopView : UIView
@property(nonatomic,assign) id<CustomTopViewDelegate>delegate;
@end
