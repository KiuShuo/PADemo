//
//  NSString+Height.m
//  HaoCheBidding
//
//  Created by 刘硕 on 14/12/21.
//  Copyright (c) 2014年 pingan.com. All rights reserved.
//

#import "NSString+Attribute.h"
#import <HexColors/HexColors.h>

@implementation NSString (Attribute)

+ (NSMutableAttributedString *)attributedString:(NSString *)str attributes:(NSArray *)attributes {

    if (str.length == 0) {
        return nil;
    }

    NSMutableAttributedString *mAttributeString = [[NSMutableAttributedString alloc] initWithString:str];

    for (Attribute *attribute in attributes) {

        [mAttributeString addAttribute:NSForegroundColorAttributeName
                                 value:[HXColor colorWithHexString:attribute.colorStr]
                                 range:attribute.range];
        [mAttributeString addAttribute:NSFontAttributeName
                                 value:[UIFont systemFontOfSize:attribute.fontSize]
                                 range:attribute.range];
    }

    return mAttributeString;
}

+ (NSMutableAttributedString *)attributedString:(NSString *)string
                                       fontSize:(CGFloat)fontSize
                                    lineSpacing:(CGFloat)lineSpacing {
    if (string.length == 0) {
        return nil;
    }
    UIFont *font = [UIFont systemFontOfSize:fontSize];
    NSMutableAttributedString *attributedStr =
        [[NSMutableAttributedString alloc] initWithString:string attributes:@{NSFontAttributeName : font}];

    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpacing];
    [attributedStr addAttribute:NSParagraphStyleAttributeName
                          value:paragraphStyle
                          range:NSMakeRange(0, [string length])];
    return attributedStr;
}

+ (NSMutableAttributedString *)attributedString:(NSString *)string
                                     attributes:(NSArray *)attributes
                                    lineSpacing:(CGFloat)lineSpacing {
    NSMutableAttributedString *mAttributeString = [self attributedString:string fontSize:0 lineSpacing:lineSpacing];

    for (Attribute *attribute in attributes) {
        [mAttributeString addAttribute:NSForegroundColorAttributeName
                                 value:[HXColor colorWithHexString:attribute.colorStr]
                                 range:attribute.range];
        [mAttributeString addAttribute:NSFontAttributeName
                                 value:[UIFont systemFontOfSize:attribute.fontSize]
                                 range:attribute.range];
    }

    return mAttributeString;
}


CGFloat PAStringHeightMakeWithText(NSString *string, CGFloat fontSize, CGFloat lineSpacing, CGFloat width) {
    // 转换成attributedString
    NSMutableAttributedString *attributedStr =
    [NSString attributedString:string fontSize:fontSize lineSpacing:lineSpacing];
    CGFloat height = PAStringHeightMakeWithAttributedString(attributedStr, width);
    if ([string length] > 0) {
        height += 5;
    }
    
    return height;

}
CGFloat PAStringHeightMakeWithAttributedString(NSAttributedString *attributedString, CGFloat width) {
    CGRect rect =
    [attributedString boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                context:nil];
    CGFloat height = rect.size.height;
    
    return height;
}



CGFloat PAStringWidthMakeWithText(NSString *string, CGFloat fontSize) {
    if (string.length == 0) {
        return 0;
    }
    // 转换成attributedString
    NSMutableAttributedString *attributedStr = [NSString attributedString:string fontSize:fontSize lineSpacing:0];
    return PAStringWidthMakeWithAttributedString(attributedStr);
}

CGFloat PAStringWidthMakeWithAttributedString(NSAttributedString *attributedString) {
    CGRect rect = [attributedString boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, CGFLOAT_MAX)
                                options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                context:nil];
    CGFloat width = rect.size.width;
    return  width;
}

+ (NSMutableAttributedString *)setupAttributeString:(NSString *)BlackText highlightText:(NSString *)highlightText {
    
    NSRange hightlightTextRange = [BlackText rangeOfString:highlightText];
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:BlackText];
    if (hightlightTextRange.length > 0) {
        [attributeStr addAttribute:NSForegroundColorAttributeName
                             value:[UIColor colorWithHexString:@"#353535"]
                             range:hightlightTextRange];
        [attributeStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.0f] range:hightlightTextRange];
        return attributeStr;
    }else {
        return [highlightText copy];
    }
}

@end

@implementation Attribute

- (id)initWithRange:(NSRange)range fontSize:(CGFloat)fontSize colorStr:(NSString *)colorStr {
    self = [super init];
    if (self) {
        self.fontSize = fontSize;
        self.range = range;
        self.colorStr = colorStr;
    }
    return self;
}

@end
