//
//  DisplayView.m
//  PADemo
//
//  Created by shuo on 2018/6/6.
//  Copyright © 2018年 shuo. All rights reserved.
//
// 参考资料：[CoreText实现图文混排](https://www.jianshu.com/p/6db3289fb05d)

#import "DisplayView.h"
#import <CoreText/CoreText.h>

static CGFloat ascentCallBacks(void *ref) {
    return [(NSNumber *)[(__bridge NSDictionary *)ref valueForKey:@"height"] floatValue];
}

static CGFloat descentCallBacks(void * ref) {
    return 0;
}

static CGFloat widthCallBacks(void * ref) {
    return [(NSNumber *)[(__bridge NSDictionary *)ref valueForKey:@"width"] floatValue];
}

@implementation DisplayView

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // 获取当前绘制的上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    // 设置字形的变化矩阵为不做图形变换
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    // 将画布向上平移一个屏幕高
    CGContextTranslateCTM(context, 0, [UIScreen mainScreen].bounds.size.height);
    // 缩放方法，x轴缩放系数为1，表示不缩放；y轴缩放系数为-1，表示绕x轴旋转180度
    CGContextScaleCTM(context, 1, -1);
    
    // 设置一个回调结构体，告诉代理该回调哪些方法
    CTRunDelegateCallbacks callbacks;
    memset(&callbacks, 0, sizeof(CTRunDelegateCallbacks));
    callbacks.version = kCTRunDelegateVersion1; // 设置回调版本
    callbacks.getAscent = ascentCallBacks;
    callbacks.getDescent = descentCallBacks;
    callbacks.getWidth = widthCallBacks;
    
    NSDictionary *dicPic = @{@"height": @129,@"width": @400}; // 创建一个图片尺寸的字典，初始化代理对象需要
    CTRunDelegateRef delegate = CTRunDelegateCreate(&callbacks, (__bridge void *)dicPic);// 创建代理
    
    unichar placeHolder = 0xFFFC; // 创建空白字符
    NSString *placeHolderStr = [NSString stringWithCharacters:&placeHolder length:1]; // 以空白字符生成字符串
    NSMutableAttributedString *placeHolderAttrStr = [[NSMutableAttributedString alloc] initWithString:placeHolderStr]; // 用字符串初始化占位符的富文本
    CFAttributedStringSetAttribute((CFMutableAttributedStringRef)placeHolderAttrStr, CFRangeMake(0, 1), kCTRunDelegateAttributeName, delegate); // 给范围中字符串设置代理
    CFRelease(delegate); // 释放（__bridge进行C与OC数据类型的转换，C为非ARC，需要手动管理）
    
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:@"这是一个有图片的富文本内容"];
    [attributeStr insertAttributedString:placeHolderAttrStr atIndex:8]; // 将占位符插入富文本
    
    // 绘制
    
    
}


@end
