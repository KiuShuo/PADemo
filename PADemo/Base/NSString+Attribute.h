//
//  NSString+Height.h
//  HaoCheBidding
//
//  Created by 刘硕 on 14/12/21.
//  Copyright (c) 2014年 pingan.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (Attribute)

+ (NSMutableAttributedString *)attributedString:(NSString *)str attributes:(NSArray *)attributes;

/**
 *  获取属性字符串
 *
 *  @param string      参数字符串
 *  @param fontSize    字体大小
 *  @param lineSpacing 行间距
 *
 *  @return 属性字符串
 */
+ (NSMutableAttributedString *)attributedString:(NSString *)string
                                       fontSize:(CGFloat)fontSize
                                    lineSpacing:(CGFloat)lineSpacing;

/**
 *  attributes [Attribute对象]
 */
+ (NSMutableAttributedString *)attributedString:(NSString *)string
                                     attributes:(NSArray *)attributes
                                    lineSpacing:(CGFloat)lineSpacing;

/**
 *  计算高度不准确，在原有基础上加上5个点
 *
 *  @param string      参数字符串
 *  @param fontSize    字体大小
 *  @param lineSpacing 行间距
 *  @param width       字符串宽度
 *
 *  @return 字符串的高度
 */
CGFloat PAStringHeightMakeWithText(NSString *string, CGFloat fontSize, CGFloat lineSpacing, CGFloat width);

CGFloat PAStringHeightMakeWithAttributedString(NSAttributedString *attributedString, CGFloat width);

/**
 *
 *  获取字符串的宽度(一行能够显示完全)
 */
CGFloat PAStringWidthMakeWithText(NSString *string, CGFloat fontSize);

CGFloat PAStringWidthMakeWithAttributedString(NSAttributedString *attributedString);


+ (NSMutableAttributedString *)setupAttributeString:(NSString *)BlackText highlightText:(NSString *)highlightText;

@end

@interface Attribute : NSObject

@property (nonatomic, assign) CGFloat fontSize;
@property (nonatomic, assign) NSRange range;
@property (nonatomic, strong) NSString *colorStr;

- (id)initWithRange:(NSRange)range fontSize:(CGFloat)fontSize colorStr:(NSString *)colorStr;

@end
