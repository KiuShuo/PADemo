//
//  NSMutableAttributedString+DZCategory.h
//  feng
//
//  Created by lichao_liu on 16/8/24.
//  Copyright © 2016年 shuo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface NSMutableAttributedString (DZCategory)

// 字体
- (void)dz_setFont:(UIFont *)font;
- (void)dz_setFont:(UIFont *)font range:(NSRange)range;

// 颜色
- (void)dz_setTextColor:(UIColor *)color;
- (void)dz_setTextColor:(UIColor *)color range:(NSRange)range;
- (void)dz_setTextColor:(UIColor *)color keyword:(NSString *)keyword;

// 对齐
- (void)dz_setTextAlignment:(NSTextAlignment)alignment;
- (void)dz_setTextAlignment:(NSTextAlignment)alignment range:(NSRange)range;

// 下划线
- (void)dz_setUnderline;
- (void)dz_setUnderlineWithRange:(NSRange)range;

// link
- (void)dz_setLinkWithRange:(NSRange)range URL:(NSURL *)URL;
+ (NSDictionary *)dz_linkAttributeWithLinkColor: (UIColor *)color;

// NSParagraphStyle
- (void)dz_setParagraphStyle:(NSParagraphStyle *)style;
- (void)dz_setParagraphStyle:(NSParagraphStyle *)style range:(NSRange)range;

// NSBaselineOffsetAttributeName
- (void)dz_setBaselineOffset:(CGFloat)fOffset;
- (void)dz_setBaselineOffset:(CGFloat)fOffset range:(NSRange)range;

// letter spacing
- (void)dz_setLetterSpacing:(CGFloat)fSpacing;
- (void)dz_setLetterSpacing:(CGFloat)fSpacing range:(NSRange)range;

// line spacing
- (void)dz_setLineSpacing:(CGFloat)fSpacing;
- (void)dz_setLineSpacing:(CGFloat)fSpacing range:(NSRange)range;

// image
- (void)dz_setImageWithName:(NSString *)imageName range:(NSRange)range;
- (void)dz_setImageWithName:(NSString *)imageName range:(NSRange)range size:(CGSize)size;
- (void)dz_setImageWithName:(NSString *)imageName range:(NSRange)range font: (UIFont *)font;
- (void)dz_insertImageWithName:(NSString *)imageName location:(NSUInteger)location bounds:(CGRect)bounds;

// attributedString -> size
- (CGSize)sizeForMaxWidth:(CGFloat)width;
// attributedString appendString
- (void)appendString:(NSString *)string;
 @end
