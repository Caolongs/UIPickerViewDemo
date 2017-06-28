//
//  ViewController.m
//  UIPickerViewDemo
//
//  Created by cao longjian on 17/6/27.
//  Copyright © 2017年 Jiji. All rights reserved.
//

#import "ViewController.h"
#import "LJSheetPickerView.h"

@interface ViewController ()

@property (nonatomic, copy) NSString *strValue;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSArray *arr = @[@"第一个",@"第二个",@"第三个",@"第四个",@"第五个"];
    
    [LJSheetPickerView showPickViewWithTitleArray:arr headerTitle:@"" selectedTitle:_strValue returnBlock:^(NSString *selectedStr, NSInteger index) {
        _strValue = selectedStr;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
