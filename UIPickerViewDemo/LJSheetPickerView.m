//
//  LJSheetPickerView.m
//  UIPickerViewDemo
//
//  Created by cao longjian on 17/6/27.
//  Copyright © 2017年 Jiji. All rights reserved.
//

#import "LJSheetPickerView.h"


#define SCREEN_SIZE [UIScreen mainScreen].bounds.size
#define PICKVIEW_HEIGHT 250

@interface LJSheetPickerView () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) NSArray<NSString *> *titleArr;
@property (nonatomic, copy  ) NSString *selectedTitle;
@property (nonatomic, assign) NSInteger selectedIdx;
@property (nonatomic, copy) NSString *headerTitle;
@property (nonatomic, copy) SheetPickerViewBlock returnBlock;

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIPickerView *pickerView;

@end

@implementation LJSheetPickerView


+ (instancetype)showPickViewWithTitleArray:(NSArray<NSString *> *)titleArr
                     selectedTitle:(NSString *)selectedTitle
                       returnBlock:(SheetPickerViewBlock)returnBlock {
    return [self showPickViewWithTitleArray:titleArr headerTitle:nil selectedTitle:selectedTitle returnBlock:returnBlock];

}


+ (instancetype)showPickViewWithTitleArray:(NSArray<NSString *> *)titleArr
                       headerTitle:(NSString *)headerTitle
                     selectedTitle:(NSString *)selectedTitle
                       returnBlock:(SheetPickerViewBlock)returnBlock {
    LJSheetPickerView *pickerView = [[LJSheetPickerView alloc] initWithFrame:[UIScreen mainScreen].bounds titleArray:titleArr headerTitle:headerTitle selectedTitle:selectedTitle returnBlock:returnBlock];
    [pickerView show];
    return pickerView;
    
}

- (instancetype)initWithFrame:(CGRect)frame
                   titleArray:(NSArray<NSString *> *)titleArr
                  headerTitle:(NSString *)headerTitle
                selectedTitle:(NSString *)selectedTitle
                  returnBlock:(SheetPickerViewBlock)returnBlock {
    self = [super initWithFrame:frame];
    if (self) {
        _titleArr       = titleArr;
        _headerTitle    = headerTitle;
        _selectedTitle  = selectedTitle;
        _returnBlock    = returnBlock;
        if (_selectedTitle) {
            
            [titleArr enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([_selectedTitle isEqualToString:obj]) {
                    _selectedTitle = obj;
                    _selectedIdx = idx;
                    *stop = YES;
                }
            }];
        }
        
        [self setupUI];
    }
    return self;
}



- (void)setupUI {
    
    //背景
    [[[[UIApplication sharedApplication] delegate] window] addSubview:self.backView];
    
    
    //self
    self.backgroundColor = [UIColor whiteColor];
    [self setFrame:CGRectMake(0, SCREEN_SIZE.height - 300, SCREEN_SIZE.width, 300)];
    self.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    [[[[UIApplication sharedApplication] delegate] window] addSubview:self];
    [self setFrame:CGRectMake(0, SCREEN_SIZE.height, SCREEN_SIZE.width, 250)];
    
    
    UIView *toolView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, 44)];
    [self addSubview:toolView];
    
    //  标题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width * 0.5, 44)];
    titleLabel.center = toolView.center;
    titleLabel.font = [UIFont systemFontOfSize:18];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    titleLabel.text = self.headerTitle;
    [titleLabel setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [self addSubview:titleLabel];
    titleLabel.hidden = !self.headerTitle;
    
    //取消按钮
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(8, 0, SCREEN_SIZE.width * 0.2, 44);
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:@"取消"
                                                                     attributes:
                                      @{NSForegroundColorAttributeName: [UIColor grayColor],
                                        NSFontAttributeName: [UIFont systemFontOfSize:16],
                                        NSUnderlineStyleAttributeName: @(NSUnderlineStyleNone)}];
    [cancelButton setAttributedTitle:attrString forState:UIControlStateNormal];
    cancelButton.adjustsImageWhenHighlighted = NO;
    cancelButton.backgroundColor = [UIColor clearColor];
    [cancelButton addTarget:self action:@selector(cancleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [toolView addSubview:cancelButton];
    
    
    //完成按钮
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    doneButton.frame = CGRectMake(SCREEN_SIZE.width - SCREEN_SIZE.width * 0.2 - 8, 0,SCREEN_SIZE.width * 0.2, 44);
    [doneButton setTitleColor:[UIColor colorWithRed:52/255.0 green:188/255.0 blue:255/255.0 alpha:1.0] forState:UIControlStateNormal];
    [doneButton setTitle:@"确定" forState:UIControlStateNormal];
    doneButton.titleLabel.font = [UIFont systemFontOfSize:16];
    doneButton.adjustsImageWhenHighlighted = NO;
    doneButton.backgroundColor = [UIColor clearColor];
    [doneButton addTarget:self action:@selector(doneBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [toolView addSubview:doneButton];
    
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 43.5, SCREEN_SIZE.width, 0.5)];
    lineView.backgroundColor = [UIColor colorWithRed:223/255.0 green:223/255.0 blue:223/255.0 alpha:1.0];
    [toolView addSubview:lineView];
    
    //选择器
    UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(5, 44, SCREEN_SIZE.width - 10, 230)];
    [pickerView setShowsSelectionIndicator:YES];
    [pickerView setDelegate:self];
    [pickerView setDataSource:self];
    [self addSubview:pickerView];
    self.pickerView = pickerView;
    self.pickerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;

}

#pragma mark - Action

- (void)cancleBtnClick:(UIButton *)btn {
    [self dismissPicker];
}

- (void)doneBtnClick:(UIButton *)btn {
    if (self.returnBlock) {
        self.returnBlock(self.selectedTitle, self.selectedIdx);
    }
    [self dismissPicker];
}

- (void)tap {
    [self dismissPicker];
}


#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.titleArr.count;
}

#pragma mark - UIPickerViewDelegate

//- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
//{
//    return self.titleArr[row];
//}

//- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component {
//    
//    NSDictionary *dict = @{NSForegroundColorAttributeName: [UIColor blackColor],
//                           NSFontAttributeName: [UIFont systemFontOfSize:10],
//                           NSUnderlineStyleAttributeName: @(NSUnderlineStyleNone)};
//    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:self.titleArr[row] attributes:dict];
//    return attrString;
//}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *label = (UILabel *)view;//ios7后不生效
    if (!label) {//卡顿可尝试 drawRect
        label = [[UILabel alloc] init];
        label.textColor = [UIColor blackColor];
        label.textAlignment = NSTextAlignmentCenter;
    }
    label.text = self.titleArr[row];
    return label;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {

    _selectedTitle  = self.titleArr[row];
    _selectedIdx    = row;
}



- (void)show {
    [UIView animateWithDuration:0.3f
                          delay:0
         usingSpringWithDamping:0.9f
          initialSpringVelocity:0.7f
                        options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionLayoutSubviews animations:^{
                            self.backView.alpha = 1.0;
                            
                            self.frame = CGRectMake(0, SCREEN_SIZE.height - 250, SCREEN_SIZE.width, 250);
                        }
                     completion:NULL];
    if (_selectedIdx < self.titleArr.count) {
        [_pickerView selectRow:_selectedIdx inComponent:0 animated:NO];
    }
}

- (void)dismissPicker {
    [UIView animateWithDuration:0.3f
                          delay:0
         usingSpringWithDamping:0.9f
          initialSpringVelocity:0.7f
                        options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionLayoutSubviews
                     animations:^{
                         self.backView.alpha = 0.0;
                         self.frame = CGRectMake(0, SCREEN_SIZE.height, SCREEN_SIZE.width, 250);
                         
                     }
                     completion:^(BOOL finished) {
                         [self.backView removeFromSuperview];
                         [self removeFromSuperview];
                         
                     }];
}

#pragma mark - Getter
- (UIView *)backView {
    if (!_backView) {
        UIView *bgView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        bgView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.45];
        bgView.alpha = 0.0f;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
        [bgView addGestureRecognizer:tap];
        _backView = bgView;
    }
    return _backView;
}


@end
