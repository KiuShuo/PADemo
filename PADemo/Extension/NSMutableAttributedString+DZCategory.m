//
//  NSMutableAttributedString+DZCategory.m
//  feng
//
//  Created by lichao_liu on 16/8/24.
//  Copyright © 2016年 shuo. All rights reserved.
//
#import "NSMutableAttributedString+DZCategory.h"
#import <CoreText/CoreText.h>

@implementation NSMutableAttributedString (DZCategory)

- (void)dz_setFont:(UIFont *)font
{
    [self dz_setFont:font range:NSMakeRange(0, self.string.length)];
}

- (void)dz_setFont:(UIFont *)font range:(NSRange)range
{
    [self addAttributes:@{NSFontAttributeName: font} range:range];
}

- (void)dz_setTextColor:(UIColor *)color
{
    [self dz_setTextColor:color range:NSMakeRange(0, self.string.length)];
}

- (void)dz_setTextColor:(UIColor *)color range:(NSRange)range
{
    [self addAttributes:@{NSForegroundColorAttributeName: color} range:range];
}

- (void)dz_setTextColor:(UIColor *)color keyword:(NSString *)keyword
{
    NSArray *arrayRanges = [self dz_rangesOfString:keyword content:self.string];
    for (NSValue *valueRange in arrayRanges) {
        NSRange range = [valueRange rangeValue];
        [self dz_setTextColor:color range:range];
    }
}

- (NSArray *)dz_rangesOfString:(NSString *)searchString content:(NSString *)content{
    NSMutableArray *results = [NSMutableArray array];
    NSRange searchRange = NSMakeRange(0, [self length]);
    NSRange range;
    while ((range = [content rangeOfString:searchString options:0 range:searchRange]).location != NSNotFound) {
        [results addObject:[NSValue valueWithRange:range]];
        searchRange = NSMakeRange(NSMaxRange(range), [self length] - NSMaxRange(range));
    }
    return results;
}

- (void)dz_setTextAlignment:(NSTextAlignment)alignment
{
    [self dz_setTextAlignment:alignment range:NSMakeRange(0, self.string.length)];
}

- (void)dz_setTextAlignment:(NSTextAlignment)alignment range:(NSRange)range
{
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [style setAlignment:alignment];
    [self addAttributes:@{NSParagraphStyleAttributeName: style} range:range];
}

- (void)dz_setUnderline
{
    [self dz_setUnderlineWithRange:NSMakeRange(0, self.string.length)];
}

- (void)dz_setUnderlineWithRange:(NSRange)range
{
    [self addAttributes:@{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)} range:range];
}


+ (NSDictionary *)dz_linkAttributeWithLinkColor: (UIColor *)color
{
    return @{NSForegroundColorAttributeName: color};
}

- (void)dz_setLinkWithRange:(NSRange)range URL:(NSURL *)URL
{
    [self addAttributes:@{NSLinkAttributeName: URL} range:range];
}

- (void)dz_setParagraphStyle:(NSParagraphStyle *)style
{
    [self dz_setParagraphStyle:style range:NSMakeRange(0, self.string.length)];
}

- (void)dz_setParagraphStyle:(NSParagraphStyle *)style range:(NSRange)range
{
    [self addAttributes:@{NSParagraphStyleAttributeName: style} range:range];
}

// NSBaselineOffsetAttributeName
- (void)dz_setBaselineOffset:(CGFloat)fOffset
{
    [self dz_setBaselineOffset:fOffset range:NSMakeRange(0, self.string.length)];
}

- (void)dz_setBaselineOffset:(CGFloat)fOffset range:(NSRange)range
{
    [self addAttributes:@{NSBaselineOffsetAttributeName: @(fOffset)} range:range];
}

// letter spacing
- (void)dz_setLineSpacing:(CGFloat)fSpacing
{
    [self dz_setLineSpacing:fSpacing range: NSMakeRange(0, self.string.length)];
}

- (void)dz_setLineSpacing:(CGFloat)fSpacing range:(NSRange)range
{
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [style setLineSpacing:fSpacing];
    [self dz_setParagraphStyle:style range:range];
}

- (void)dz_setLetterSpacing:(CGFloat)fSpacing
{
    [self dz_setLetterSpacing:fSpacing range:NSMakeRange(0, self.string.length)];
}

- (void)dz_setLetterSpacing:(CGFloat)fSpacing range:(NSRange)range
{
    [self addAttribute:NSKernAttributeName
                 value:@(fSpacing)
                 range:range];
}

- (void)dz_setImageWithName:(NSString *)imageName range:(NSRange)range
{
    [self dz_setImageWithName:imageName range:range size:CGSizeZero];
}

- (void)dz_setImageWithName:(NSString *)imageName range:(NSRange)range font: (UIFont *)font
{
    NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
    textAttachment.image = [UIImage imageNamed:imageName];
    textAttachment.bounds = CGRectMake(0, font.descender, font.lineHeight, font.lineHeight);
    NSAttributedString *attrStringWithImage = [NSAttributedString attributedStringWithAttachment:textAttachment];
    [self replaceCharactersInRange:range withAttributedString:attrStringWithImage];
}

- (void)dz_insertImageWithName:(NSString *)imageName location:(NSUInteger)location bounds:(CGRect)bounds {
    NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
    textAttachment.image = [UIImage imageNamed:imageName];
    textAttachment.bounds = bounds;
    NSAttributedString *attrStringWithImage = [NSAttributedString attributedStringWithAttachment:textAttachment];
    [self insertAttributedString:attrStringWithImage atIndex:location];
}



- (void)dz_setImageWithName:(NSString *)imageName range:(NSRange)range size:(CGSize)size
{
    NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
    textAttachment.image = [UIImage imageNamed:imageName];
    
    if (!CGSizeEqualToSize(size, CGSizeZero)) {
        textAttachment.bounds = CGRectMake(0,
                                           -2,
                                           size.width,
                                           size.height);
    }
    NSAttributedString *attrStringWithImage = [NSAttributedString attributedStringWithAttachment:textAttachment];
    [self replaceCharactersInRange:range withAttributedString:attrStringWithImage];
}

- (CGSize)sizeForMaxWidth:(CGFloat)width {
    CGSize size = [self boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
    return CGSizeMake(ceilf(size.width), ceilf(size.height));
}

- (void)appendString:(NSString *)string
{
    NSUInteger selfLengthBefore = [self length];
    
    [self.mutableString appendString:string];
    
    NSRange appendedStringRange = NSMakeRange(selfLengthBefore, [string length]);
    
    // we need to remove the image placeholder (if any) to prevent duplication
    [self removeAttribute:NSAttachmentAttributeName range:appendedStringRange];
    [self removeAttribute:(id)kCTRunDelegateAttributeName range:appendedStringRange];
}
 

@end
