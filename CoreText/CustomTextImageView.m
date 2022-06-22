//
//  CustomTextImageView.m
//  CoreText
//
//  Created by vincent on 2022/6/22.
//

#import "CustomTextImageView.h"
#import <CoreText/CoreText.h>

@implementation CustomTextImageView


- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    // 1、获取上下文对象
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // 2、翻转坐标系
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    // 3、创建NSAttributedString
    NSMutableAttributedString *astring = [[NSMutableAttributedString alloc] initWithString:self.text];
    
    // 4、创建代理对象
    CTRunDelegateCallbacks callBacks;
    memset(&callBacks, 0, sizeof(CTRunDelegateCallbacks));
    
    callBacks.version = kCTRunDelegateVersion1;
    callBacks.getAscent = ascentCallbacks;
    callBacks.getDescent = descentCallbacks;
    callBacks.getWidth = widthCallbacks;
    
    CTRunDelegateRef delegate = CTRunDelegateCreate(&callBacks, (void *)astring);
    
    // 5、创建空白字符NSMutableAttributedString，并设置代理
    unichar placeHolder = 0xFFFC;
    NSString *placeHolderString = [NSString stringWithCharacters:&placeHolder length:1];
    NSMutableAttributedString *placeHolderAttributedString = [[NSMutableAttributedString alloc]initWithString:placeHolderString];
    
    NSDictionary *attributedDic = [NSDictionary dictionaryWithObjectsAndKeys:(__bridge id)delegate, kCTRunDelegateAttributeName,nil];
    [placeHolderAttributedString setAttributes:attributedDic range:NSMakeRange(0, 1)];
    CFRelease(delegate);
    
    // 6、将空白占位AttributedString插入初始AttributedString
    [astring insertAttributedString:placeHolderAttributedString atIndex:astring.length/2];
    
    // 7、根据新生成AttributedString创建CTFramesetterRef
    CTFramesetterRef frameRef = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)astring);
    
    // 8、创建绘制区域CGPathRef
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, self.bounds);
 
    // 9、根据CTFramesetterRef和CGPathRef创建CTFrame
    CTFrameRef fref = CTFramesetterCreateFrame(frameRef, CFRangeMake(0, astring.length), path, NULL);
    
    // 10、CTFrameDraw绘制
    CTFrameDraw(fref, context);
    
    // 11、绘图
    CGRect imageRect = [self calculateImageRect:fref];
    CGContextDrawImage(context, imageRect, self.image.CGImage);
    
    // 12、释放资源
    CFRelease(path);
    CFRelease(fref);
    CFRelease(frameRef);
}

#pragma mark ---CTRUN代理---
CGFloat ascentCallbacks (void *ref) {
    return 29;
}

CGFloat descentCallbacks (void *ref) {
    return 7;
}

CGFloat widthCallbacks (void *ref) {
    return 36;
}

#pragma mark - Private Method
- (CGRect)calculateImageRect:(CTFrameRef)frame {
    //先找CTLine的原点，再找CTRun的原点
    NSArray *allLine = (NSArray *)CTFrameGetLines(frame);
    NSInteger lineCount = [allLine count];
    //获取CTLine原点坐标
    CGPoint points[lineCount];
    CTFrameGetLineOrigins(frame, CFRangeMake(0, 0), points);
    CGRect imageRect = CGRectMake(0, 0, 0, 0);
    for (int i = 0; i < lineCount; i++) {
        CTLineRef line = (__bridge CTLineRef)allLine[i];
        //获取所有的CTRun
        CFArrayRef allRun = CTLineGetGlyphRuns(line);
        CFIndex runCount = CFArrayGetCount(allRun);
        
        //获取line原点
        CGPoint lineOrigin = points[i];
        
        
        for (int j = 0; j < runCount; j++) {
            CTRunRef run = CFArrayGetValueAtIndex(allRun, j);
            NSDictionary *attributes = (NSDictionary *)CTRunGetAttributes(run);
            CTRunDelegateRef delegate = (__bridge CTRunDelegateRef)[attributes valueForKey:(id)kCTRunDelegateAttributeName];
            if (delegate == nil) {
                // 主要用于点击事件
//                NSString *textClickString = [attributes valueForKey:@"textClick"];
//                if (textClickString != nil) {
//                    [textFrameArray addObject:[NSValue valueWithCGRect:[self getLocWith:frame line:line run:run origin:lineOrigin]]];
//                }
                continue;
            }
           //获取图片的Rect
            imageRect = [self getLocWith:frame line:line run:run origin:lineOrigin];
        }
    }
    return imageRect;
}

- (CGRect)getLocWith:(CTFrameRef)frame line:(CTLineRef)line run:(CTRunRef)run origin:(CGPoint)point {
    CGRect boundRect;
    CGFloat ascent = 0.0f;
    CGFloat descent = 0.0f;
    CGFloat width = CTRunGetTypographicBounds(run, CFRangeMake(0, 0), &ascent, &descent, NULL);
    boundRect.size.width = width;
    boundRect.size.height = ascent + descent;
    
    //获取x偏移量
    CGFloat xoffset = CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(run).location, NULL);
    boundRect.origin.x = point.x + xoffset;
    boundRect.origin.y = point.y - descent;
    
    //获取BoundingBox
    CGPathRef path = CTFrameGetPath(frame);
    CGRect colRect = CGPathGetBoundingBox(path);

    return CGRectOffset(boundRect, colRect.origin.x, colRect.origin.y);
}

@end
