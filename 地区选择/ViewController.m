//
//  ViewController.m
//  地区选择
//
//  Created by apple on 16/4/5.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ViewController.h"
#import "RegionViewController.h"
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
}
- (IBAction)clickButton:(id)sender {
    RegionViewController* regionVc=[RegionViewController new];
    regionVc.currentCityString=@"西安";
   regionVc.selectedStr=^(NSString * str)
    {
        self.nameLabel.text=str;
    };
    [self presentViewController:regionVc animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
