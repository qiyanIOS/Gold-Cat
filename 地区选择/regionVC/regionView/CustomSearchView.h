//
//  CustomSearchView.h
//  地区选择
//
//  Created by apple on 16/4/5.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CustomSearchViewDelegate<NSObject>
-(void)searchBeginEditing;
-(void)didSelectCancelBtn;
-(void)searchString:(NSString *)string;
@end
@interface CustomSearchView : UIView<UISearchBarDelegate>
@property(nonatomic,strong)UISearchBar* searchBar;
@property(nonatomic,strong)UIButton* cancelBtn;
@property(nonatomic,assign)id<CustomSearchViewDelegate>delegate;
@end
