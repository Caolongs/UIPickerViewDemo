//
//  LJSheetPickerView.h
//  UIPickerViewDemo
//
//  Created by cao longjian on 17/6/27.
//  Copyright © 2017年 Jiji. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^SheetPickerViewBlock)(NSString *selectedStr, NSInteger index);

@interface LJSheetPickerView : UIView

/**
 showPickView
 
 @param titleArr 数组
 @param selectedTitle 传入已选中标题
 @param returnBlock block
 */
+ (instancetype)showPickViewWithTitleArray:(NSArray<NSString *> *)titleArr
                     selectedTitle:(NSString *)selectedTitle
                       returnBlock:(SheetPickerViewBlock)returnBlock;


/**
 showPickView

 @param titleArr 数组
 @param headerTitle 头部标题
 @param selectedTitle 传入已选中标题
 @param returnBlock block
 */
+ (instancetype)showPickViewWithTitleArray:(NSArray<NSString *> *)titleArr
                       headerTitle:(NSString *)headerTitle
                     selectedTitle:(NSString *)selectedTitle
                       returnBlock:(SheetPickerViewBlock)returnBlock;


@end
