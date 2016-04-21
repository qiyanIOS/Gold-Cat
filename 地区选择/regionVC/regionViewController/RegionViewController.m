//
//  RegionViewController.m
//  地区选择
//
//  Created by apple on 16/4/5.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "RegionViewController.h"
#import "CustomTopView.h"
#import "CustomSearchView.h"
#import "CityTableViewCell.h"
#import "regionModel.h"
#import "RegionResultViewController.h"
@interface RegionViewController ()<UITableViewDataSource,UITableViewDelegate,CustomTopViewDelegate,CustomSearchViewDelegate,RegionResultViewControllerDelegate>
@property(nonatomic,strong)UITableView* tableView;
@property(nonatomic,strong)CustomTopView* naviView;
@property(nonatomic,strong)CustomSearchView* searchView;
@property(nonatomic,strong)UIView* backView;
@property (nonatomic,retain)NSDictionary *bigDic; // 读取本地plist文件的字典
@property (nonatomic,retain)NSMutableArray *sectionTitlesArray; // 区头数组
@property (nonatomic,retain)NSMutableArray *rightIndexArray; // 右边索引数组
@property (nonatomic,retain)NSMutableArray *dataArray;// cell数据源数组
@property (nonatomic,retain)NSMutableArray *pinYinArray; // 地区名字转化为拼音的数组
@property (nonatomic,retain)RegionResultViewController *resultController;//显示结果的controller
@property (nonatomic,retain)NSArray *currentCityArray;// 当前城市
@property (nonatomic,retain)NSArray *hotCityArray; // 热门城市
@end

@implementation RegionViewController
-(RegionResultViewController*)resultController
{
    if (!_resultController) {
        _resultController=[[RegionResultViewController alloc]init];
        _resultController.view.frame=CGRectMake(0, 64 ,self.view.frame.size.width, self.view.frame.size.height-64);
        _resultController.delegate=self;
       // _resultController.view.backgroundColor=[UIColor redColor];
        [self.view addSubview:_resultController.view];
        
    }
    return _resultController;
}
-(UIView*)backView
{
    if (!_backView) {
        _backView=[[UIView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64)];
        _backView.backgroundColor= [UIColor colorWithRed:60/255.0 green:60/255.0 blue:60/255.0 alpha:0.6];
        _backView.alpha=0;
        UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didSelectCancelBtn)];
        [_backView addGestureRecognizer:ges];
    }
    return _backView;
}
-(UITableView*)tableView
{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64) style:UITableViewStyleGrouped];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.sectionIndexColor=[UIColor redColor];
        
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    }
    return _tableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    
    [self.view addSubview:self.tableView];
    self.naviView=[[CustomTopView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    self.naviView.delegate=self;
    [self.view addSubview:self.naviView];
    self.searchView=[[CustomSearchView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width-20, 44)];
    self.searchView.delegate=self;
    self.tableView.tableHeaderView=self.searchView;
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.sectionTitlesArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 1;
    }else if(section==1)
    {
        return 1;
    }else
    {
        return [self.dataArray[section] count];
    }
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        if (indexPath.section<2)
       {
         __weak typeof(self) weakSelf = self;
        CityTableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:@"cityCell"];
        if (cell==nil)
        {
            cell=[[CityTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cityCell" cityArray:self.dataArray[indexPath.section]];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.didSelectedBtn = ^(int tag)
        {
            if(tag==1111)
            {
                weakSelf.selectedStr(weakSelf.currentCityString);
               
                
            }
            else
            {
                weakSelf.selectedStr(weakSelf.hotCityArray[tag]);
               
            }
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
        };

           return cell;
    }
      else
    {
    
    UITableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
        NSArray *array = self.dataArray[indexPath.section];
        cell.textLabel.text = array[indexPath.row];
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        cell.textLabel.textColor = [UIColor colorWithRed:54/255.0 green:54/255.0 blue:54/255.0 alpha:1];
        return cell;
    return cell;
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    
    if(_backView)
    {
        return nil;
    }
    else
    {
        
        return self.rightIndexArray;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0)
    {
        return 60;
    }
    else if (indexPath.section==1)
    {
        return 150;
    }
    else
    {
        return 44;
    }
}
-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    //此方法返回的是section的值
    NSLog(@"%d",(int)index);
    if(index==0)
    {
        [tableView setContentOffset:CGPointZero animated:YES];
        
        return -1;
    }
    else
    {
        return index+1;
    }
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    static NSString* headerIdentifier=@"header";
    UITableViewHeaderFooterView* headerView=[tableView dequeueReusableHeaderFooterViewWithIdentifier:headerIdentifier];
    if (headerView==nil) {
        headerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:headerIdentifier];
        UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 80, 25)];
        titleLabel.tag = 1;
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textColor = [UIColor colorWithRed:100/255.0 green:100/255.0 blue:100/255.0 alpha:1];
        [headerView.contentView addSubview:titleLabel];
    }
    headerView.contentView.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
    UILabel *label = (UILabel *)[headerView viewWithTag:1];
    label.text = self.sectionTitlesArray[section];
    return headerView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 25;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}
#pragma _ mark CustomeTopViewDelegate
-(void)didSelectBackButton
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma _ mark CustomeSearchViewDelegate
-(void)searchString:(NSString *)string
{
    
    // ”^[A-Za-z]+$”
    NSMutableArray *resultArray  =  [NSMutableArray array];
    if([self isZimuWithstring:string])
    {
        //证明输入的是字母
        self.pinYinArray = [NSMutableArray array]; //和输入的拼音首字母相同的地区的拼音
        NSString *upperCaseString2 = string.uppercaseString;
        NSString *firstString = [upperCaseString2 substringToIndex:1];
        NSArray *array = [self.bigDic objectForKey:firstString];
        [array enumerateObjectsUsingBlock:^(NSString *cityName, NSUInteger idx, BOOL * _Nonnull stop) {
            regionModel *model = [[regionModel alloc] init];
            NSString *pinYin = [self Charactor:cityName getFirstCharactor:NO];
            
            model.name = cityName;
            model.pinYinName = pinYin;
            [self.pinYinArray addObject:model];
        }];
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"pinYinName BEGINSWITH[c] %@",string];
        NSArray *smallArray = [self.pinYinArray filteredArrayUsingPredicate:pred];
        [smallArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            regionModel *model = obj;
            [resultArray addObject:model.name];
        }];
    }
    else
    {
        //证明输入的是汉字
        [self.dataArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSArray *sectionArray  = obj;
            NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF BEGINSWITH[c] %@",string];
            NSArray *array = [sectionArray filteredArrayUsingPredicate:pred];
            [resultArray addObjectsFromArray:array];
            
        }];
    }
    
    self.resultController.dataArray = resultArray;
    
    NSLog(@"%lu",(unsigned long)resultArray.count);
    [self.resultController.tableView reloadData];
}-(void)didSelectCancelBtn
{
    UIView* view1=(UIView*)[self.view viewWithTag:333];
    [view1 removeFromSuperview];
    [self.backView removeFromSuperview];
    self.backView=nil;
    [self.resultController.view removeFromSuperview];
    self.resultController=nil;
    [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        self.naviView.frame = CGRectMake(0, 0, self.view.frame.size.width, 64);
        self.tableView.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64);
        
        [self.searchView.searchBar  setShowsCancelButton:NO animated:YES];
        [self.searchView.searchBar resignFirstResponder];
        
    } completion:^(BOOL finished) {
    }];
    [self.tableView reloadData];
}
-(void)searchBeginEditing
{
    [self.view addSubview:self.backView];
    [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.naviView.frame=CGRectMake(0, -64, self.view.frame.size.width, 64);
        _tableView.frame=CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height);
        self.backView.alpha = 0.6;
    } completion:^(BOOL finished) {
        UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
        view1.tag = 333;
        view1.backgroundColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1];
        [self.view addSubview:view1];
    }];

    [self.tableView reloadData];
}
-(void)loadData
{
    self.rightIndexArray=[NSMutableArray array];
    self.sectionTitlesArray=[NSMutableArray array];
    self.dataArray=[NSMutableArray array];
    NSString* path=[[NSBundle mainBundle]pathForResource:@"citydict.plist" ofType:nil];
    self.bigDic=[[NSDictionary alloc]initWithContentsOfFile:path];
    NSArray* allKeys=[self.bigDic allKeys];
    [self.sectionTitlesArray addObjectsFromArray:[allKeys sortedArrayUsingSelector:@selector(compare:)]];
    
    [self.sectionTitlesArray enumerateObjectsUsingBlock:^(NSString*zimu, NSUInteger idx, BOOL * _Nonnull stop) {
        NSArray*smallArray=self.bigDic[zimu];
        [self.dataArray addObject:smallArray];
        
    }];
    [self.rightIndexArray addObjectsFromArray:self.sectionTitlesArray];
    [self.rightIndexArray insertObject:UITableViewIndexSearch atIndex:0];
    [self.sectionTitlesArray insertObject:@"热门城市" atIndex:0];
    [self.sectionTitlesArray insertObject:@"定位城市" atIndex:0];
    self.currentCityArray = @[self.currentCityString];
    self.hotCityArray = @[@"上海",@"北京",@"广州",@"深圳",@"武汉",@"天津",@"西安",@"南京",@"杭州"];
    [self.dataArray insertObject:self.hotCityArray atIndex:0];
    [self.dataArray insertObject:self.currentCityArray atIndex:0];

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
       
    }else if(indexPath.section==1)
    {
        
    }else
    {
        NSString* string=self.dataArray[indexPath.section][indexPath.row];
        self.selectedStr(string);
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}
//
- (NSString *)Charactor:(NSString *)aString getFirstCharactor:(BOOL)isGetFirst
{
    //转成了可变字符串
    NSMutableString *str = [NSMutableString stringWithString:aString];
    //先转换为带声调的拼音
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformMandarinLatin,NO);
    //再转换为不带声调的拼音
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformMandarinLatin,NO);
    CFStringTransform((CFMutableStringRef)str, NULL, kCFStringTransformStripDiacritics, NO);
    NSString *pinYin = [str capitalizedString];
    //转化为大写拼音
    if(isGetFirst)
    {
        //获取并返回首字母
        return [pinYin substringToIndex:1];
    }
    else
    {
        return pinYin;
    }
}

-(BOOL)isZimuWithstring:(NSString*)string
{
    NSString* number=@"^[A-Za-z]+$";
    NSPredicate* numberPre=[NSPredicate predicateWithFormat:@"SELF MATCHES %@",number];
    return [numberPre evaluateWithObject:string];
}
#pragma mark --ResultCityControllerDelegate
-(void)didScroll
{
    [self.searchView.searchBar resignFirstResponder];
}
-(void)didSelectedString:(NSString *)string
{
    self.selectedStr(string);
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
