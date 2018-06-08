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


/**
 __bridge是C结构体与OC对象相互转换时的一个修饰词，如果本身就是传递地址数据的则不需要桥接

 */
static CGFloat ascentCallBacks(void *ref) {
    return [(NSNumber *)[(__bridge NSDictionary *)ref valueForKey:@"height"] floatValue];
}

static CGFloat descentCallBacks(void * ref) {
    return 0;
}

static CGFloat widthCallBacks(void * ref) {
    return [(NSNumber *)[(__bridge NSDictionary *)ref valueForKey:@"width"] floatValue];
}

@interface DisplayView()

@property (nonatomic, copy) NSArray<NSValue *> *imageFrameValues;
@property (nonatomic, assign) CTFrameRef frameRef;
@property (nonatomic, assign) NSInteger length;

@end

@implementation DisplayView

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    // 获取当前绘制的上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    // 设置字形的变化矩阵为不做图形变换
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    // 将画布向上平移一个屏幕高
    CGContextTranslateCTM(context, 0, rect.size.height);
    // 缩放方法，x轴缩放系数为1，表示不缩放；y轴缩放系数为-1，表示绕x轴旋转180度
    CGContextScaleCTM(context, 1, -1);
    
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:@"Core Text本身并不支持图片绘制，图片的绘制你还得通过Core Graphics来进行。只是Core Text可以通过CTRun的设置为你的图片在文本绘制的过程中留出适当的空间。这个设置就使用到CTRunDelegate了，CTRunDelegate作为CTRun相关属性或操作扩展的一个入口，使得我们可以对CTRun做一些自定义的行为。为图片留位置的方法就是加入一个空白的CTRun，自定义其ascent，descent，width等参数，使得绘制文本的时候留下空白位置给相应的图片。然后图片在相应的空白位置上使用Core Graphics接口进行绘制。"];
    
    /*
    // 插入图片所需要的代码逻辑
    // 设置一个回调结构体，告诉代理该回调哪些方法
    CTRunDelegateCallbacks callbacks;
    memset(&callbacks, 0, sizeof(CTRunDelegateCallbacks));
    callbacks.version = kCTRunDelegateVersion1; // 设置回调版本
    callbacks.getAscent = ascentCallBacks;
    callbacks.getDescent = descentCallBacks;
    callbacks.getWidth = widthCallBacks;
    
    NSDictionary *dicPic = @{@"width": @82,@"height": @78}; // 创建一个图片尺寸的字典，初始化代理对象需要
    CTRunDelegateRef delegate = CTRunDelegateCreate(&callbacks, (__bridge void *)dicPic);// 创建代理
    
    unichar placeHolder = 0xFFFC; // 创建空白字符
    NSString *placeHolderStr = [NSString stringWithCharacters:&placeHolder length:1]; // 以空白字符生成字符串
    NSMutableAttributedString *placeHolderAttrStr = [[NSMutableAttributedString alloc] initWithString:placeHolderStr]; // 用字符串初始化占位符的富文本
    CFAttributedStringSetAttribute((CFMutableAttributedStringRef)placeHolderAttrStr, CFRangeMake(0, 1), kCTRunDelegateAttributeName, delegate); // 给范围中字符串设置代理
    CFRelease(delegate); // 释放（__bridge进行C与OC数据类型的转换，C为非ARC，需要手动管理）
    [attributeStr insertAttributedString:placeHolderAttrStr atIndex:8]; // 将占位符插入富文本
    */
    
    // 绘制
    // 绘制文本
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attributeStr);
    CGMutablePathRef path = CGPathCreateMutable(); // 创建绘制区域
    CGPathAddRect(path, NULL, self.bounds); // 添加绘制尺寸
    self.length = attributeStr.length;
    CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, _length), path, NULL); // 工厂根据绘制区域及富文本设置frame
    self.frameRef = frame;
    CTFrameDraw(frame, context); // 根据frame绘制文本
    
    /*
    // 绘制图片
    self.imageFrameValues = [self imageFrame:frame];
    for (NSValue *imageFrameValue in self.imageFrameValues) {
        CGRect imageFrame = imageFrameValue.CGRectValue;
        UIImage *image = [UIImage imageNamed:@"guide_detail_0"];
        CGContextDrawImage(context, imageFrame, image.CGImage);
    }
    */
    
    // 释放资源
    CFRelease(path);
    CFRelease(frameSetter);
}

- (void)dealloc {
    CFRelease(self.frameRef);
}

// 获取图片的frame
- (NSArray<NSValue *> *)imageFrame:(CTFrameRef)frame {
    NSArray *arrLines = (NSArray *)CTFrameGetLines(frame);//根据frame获取需要绘制的线的数组
    NSInteger count = [arrLines count];//获取线的数量
    CGPoint points[count];//建立起点的数组（cgpoint类型为结构体，故用C语言的数组）
    CTFrameGetLineOrigins(frame, CFRangeMake(0, 0), points);//获取起点
    NSMutableArray *imageBoundArr = [NSMutableArray array];
    for (int i = 0; i < count; i++) {//遍历线的数组
        CTLineRef line = (__bridge CTLineRef)arrLines[i];
        NSArray *arrGlyphRun = (NSArray *)CTLineGetGlyphRuns(line);//获取GlyphRun数组（GlyphRun：高效的字符绘制方案）
        for (int j = 0; j < arrGlyphRun.count; j++) {//遍历CTRun数组
            CTRunRef run = (__bridge CTRunRef)arrGlyphRun[j];//获取CTRun
            NSDictionary * attributes = (NSDictionary *)CTRunGetAttributes(run);//获取CTRun的属性
            CTRunDelegateRef delegate = (__bridge CTRunDelegateRef)[attributes valueForKey:(id)kCTRunDelegateAttributeName];//获取代理
            if (delegate == nil) {//非空
                continue;
            }
            NSDictionary * dic = CTRunDelegateGetRefCon(delegate);//判断代理字典
            if (![dic isKindOfClass:[NSDictionary class]]) {
                continue;
            }
            CGPoint point = points[i];//获取一个起点
            CGFloat ascent;//获取上距
            CGFloat descent;//获取下距
            CGRect boundsRun;//创建一个frame
            boundsRun.size.width = CTRunGetTypographicBounds(run, CFRangeMake(0, 0), &ascent, &descent, NULL);
            boundsRun.size.height = ascent + descent;//取得高
            CGFloat xOffset = CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(run).location, NULL);//获取x偏移量
            boundsRun.origin.x = point.x + xOffset;//point是行起点位置，加上每个字的偏移量得到每个字的x
            boundsRun.origin.y = point.y - descent;//计算原点
            CGPathRef path = CTFrameGetPath(frame);//获取绘制区域
            CGRect colRect = CGPathGetBoundingBox(path);//获取剪裁区域边框
            CGRect imageBounds = CGRectOffset(boundsRun, colRect.origin.x, colRect.origin.y);
            NSValue *value = [NSValue valueWithCGRect:imageBounds];
            [imageBoundArr addObject:value];
        }
    }
    return imageBoundArr;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint originLocation = [touch locationInView:self];
    NSLog(@"originLocation = (%lf, %lf)", originLocation.x, originLocation.y);
    CGPoint transLocation = [self systemPointFromScreenPoint:originLocation];
    NSLog(@"transLocation = (%lf, %lf)", transLocation.x, transLocation.y);
    if ([self checkIsClickOnImageWithPoint:transLocation]) {
        NSLog(@"点击图片");
    } else {
        NSLog(@"点击文字");
        [self clickOnStrWithPoint:transLocation];
    }
}

- (CGPoint)systemPointFromScreenPoint:(CGPoint)origin {
    return CGPointMake(origin.x, self.bounds.size.height - origin.y);
}

- (BOOL)checkIsClickOnImageWithPoint:(CGPoint)point {
    for (NSValue *imageFrameValue in self.imageFrameValues) {
        CGRect imageFrame = imageFrameValue.CGRectValue;
        if ([self isFrame:imageFrame containsPoint:point]) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)isFrame:(CGRect)frame containsPoint:(CGPoint)point {
    return CGRectContainsPoint(frame, point);
}

// 字符串点击检查
- (void)clickOnStrWithPoint:(CGPoint)point {
    CTFrameRef frame = self.frameRef;
    NSArray *lines = (NSArray *)CTFrameGetLines(frame); // 根据frame拿到所有line
    NSInteger count = lines.count;
    CGPoint origins[count]; // 建立一个起点数组
    CFRange ranges[count]; // 建立一个范围数组
    CTFrameGetLineOrigins(frame, CFRangeMake(0, 0), origins); // 获取所有CTLine的起点
    // 获取所有CTLine的range
    for (int i = 0; i < count; i++) {
        CTLineRef line = (__bridge CTLineRef)lines[i];
        CFRange range = CTLineGetStringRange(line);
        ranges[i] = range;
    }
    for (int i = 0; i < _length; i++) {//逐字检查 遍历所有的文字
        long maxLoc;
        int lineNum;
        for (int j = 0; ; j ++) {//获取对应字符所在CTLine的index  获取lineNum
            CFRange range = ranges[j];
            maxLoc = range.location + range.length - 1;
            if (i <= maxLoc) {
                lineNum = j;
                break;
            }
        }
        CTLineRef line = (__bridge CTLineRef)lines[lineNum];//取到字符对应的CTLine
        CGPoint origin = origins[lineNum]; // 获取line对应的起点
        CGRect CTRunFrame = [self frameForCTRunWithIndex:i CTLine:line origin:origin];//计算对应字符的frame
        if ([self isFrame:CTRunFrame containsPoint:point]) {//如果点击位置在字符范围内，响应时间，跳出循环
            NSLog(@"您点击到了第 %d 个字符，位于第 %d 行，然而他没有响应事件。",i,lineNum + 1);//点击到文字，然而没有响应的处理。可以做其他处理
            return;
        }
    }
    NSLog(@"您没有点击到文字");//没有点击到文字，可以做其他处理
}

///字符frame计算
/*
 返回索引字符的frame
 
 index：索引
 line：索引字符所在CTLine
 origin：line的起点
 */
-(CGRect)frameForCTRunWithIndex:(NSInteger)index CTLine:(CTLineRef)line origin:(CGPoint)origin {
    CGFloat offsetX = CTLineGetOffsetForStringIndex(line, index, NULL);//获取字符起点相对于CTLine的原点的偏移量
    CGFloat offsexX2 = CTLineGetOffsetForStringIndex(line, index + 1, NULL);//获取下一个字符的偏移量，两者之间即为字符X范围
    offsetX += origin.x;
    offsexX2 += origin.x;//坐标转换，将点的CTLine坐标转换至系统坐标
    CGFloat offsetY = origin.y;//取到CTLine的起点Y
    CGFloat lineAscent;//初始化上下边距的变量
    CGFloat lineDescent;
    NSArray * runs = (__bridge NSArray *)CTLineGetGlyphRuns(line);//获取line对应的所有CTRun
    CTRunRef runCurrent;
    for (int k = 0; k < runs.count; k ++) {//获取当前字符对应的index的CTRun
        CTRunRef run = (__bridge CTRunRef)runs[k];
        CFRange range = CTRunGetStringRange(run);
        NSRange rangeOC = NSMakeRange(range.location, range.length);
        if ([self isIndex:index inRange:rangeOC]) {
            runCurrent = run;
            break;
        }
    }
    CTRunGetTypographicBounds(runCurrent, CFRangeMake(0, 0), &lineAscent, &lineDescent, NULL);//计算当前点击的CTRun高度
    offsetY -= lineDescent;
    CGFloat height = lineAscent + lineDescent;
    return CGRectMake(offsetX, offsetY, offsexX2 - offsetX, height);//返回一个字符的Frame
}

///范围检测
/*
 范围内返回yes，否则返回no
 */
-(BOOL)isIndex:(NSInteger)index inRange:(NSRange)range {
    if ((index <= range.location + range.length - 1) && (index >= range.location)) {
        return YES;
    }
    return NO;
}


@end
