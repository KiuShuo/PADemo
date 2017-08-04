//
//  UIView+ZJRadius.m
//  BulletAnalyzer
//
//  Created by 张骏 on 17/7/27.
//  Copyright © 2017年 Zj. All rights reserved.
//

#import "UIView+ZJRadius.h"
#import <objc/runtime.h>

@implementation UIView (ZJRadius)

+ (void)load{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        
        SEL originalSelector1 = @selector(setClipsToBounds:);
        SEL swizzledSelector1 = @selector(ZJ_setClipsToBounds:);
        
        Method originalMethod1 = class_getInstanceMethod(class, originalSelector1);
        Method swizzledMethod1 = class_getInstanceMethod(class, swizzledSelector1);
        
        BOOL didAddMethod1 = class_addMethod(class, originalSelector1, method_getImplementation(swizzledMethod1), method_getTypeEncoding(swizzledMethod1));
        
        if (didAddMethod1) {
            class_replaceMethod(class, swizzledSelector1, method_getImplementation(originalMethod1), method_getTypeEncoding(originalMethod1));
        } else {
            method_exchangeImplementations(originalMethod1, swizzledMethod1);
        }
        
        
        SEL originalSelector2 = @selector(layoutSubviews);
        SEL swizzledSelector2 = @selector(ZJ_layoutSubviews);
        
        Method originalMethod2 = class_getInstanceMethod(class, originalSelector2);
        Method swizzledMethod2 = class_getInstanceMethod(class, swizzledSelector2);
        
        BOOL didAddMethod2 = class_addMethod(class, originalSelector2, method_getImplementation(swizzledMethod2), method_getTypeEncoding(swizzledMethod2));
        
        if (didAddMethod2) {
            class_replaceMethod(class, swizzledSelector2, method_getImplementation(originalMethod2), method_getTypeEncoding(originalMethod2));
        } else {
            method_exchangeImplementations(originalMethod2, swizzledMethod2);
        }
    });
}


- (void)ZJ_setClipsToBounds:(BOOL)clipsToBounds{
    
    if (self.layer.cornerRadius <= 0) { //若圆角为0 则允许maskToBounds
        [self ZJ_setClipsToBounds:clipsToBounds];
    } else {
        [self ZJ_maskCorner];
    }
}


- (void)ZJ_layoutSubviews{
    [self ZJ_layoutSubviews];
    
    if (self.layer.cornerRadius > 0) {
        [self ZJ_maskCorner];
    }
}


- (void)ZJ_maskCorner{
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{

        UIImageView *imageView;
        for (UIView *subView in self.subviews) {
            if (subView.tag == 10241024) {
                imageView = (UIImageView *)subView;
                break;
            }
        }
        
        if (!imageView) {
            imageView = [[UIImageView alloc] initWithFrame:self.bounds];
            imageView.userInteractionEnabled = NO;
            imageView.opaque = YES;
            imageView.tag = 10241024; //标记
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self addSubview:imageView];
            });
        }
        
        CGSize size = CGSizeMake(self.layer.cornerRadius * 2, self.layer.cornerRadius * 2);
        size = self.frame.size;
        CGRect rect = CGRectMake(0, 0, size.width, size.height);
        
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0);

        CALayer *bgLayer = [CALayer layer];
        bgLayer.backgroundColor = self.backgroundColor.CGColor;
        bgLayer.frame = self.bounds;
        
        [bgLayer renderInContext:UIGraphicsGetCurrentContext()];
         
        UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:rect];
        [path addClip];
        
        [self.layer renderInContext:UIGraphicsGetCurrentContext()];
        
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
        dispatch_async(dispatch_get_main_queue(), ^{
            imageView.image = image;
        });
    });
}

@end
