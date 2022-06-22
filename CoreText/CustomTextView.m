//
//  CustomView.m
//  CoreText
//
//  Created by vincent on 2022/6/22.
//

#import "CustomTextView.h"
#import <CoreText/CoreText.h>

@implementation CustomTextView

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    // 1、获取上下文对象
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // 2、翻转坐标系
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    // 3、创建NSAttributedString
    NSAttributedString *attString = [[NSAttributedString alloc] initWithString:self.text];
    
    // 4、根据NSAttributedString创建CTFramesetterRef
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attString);
    
    // 5、创建绘制区域CGPathRef
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, self.bounds);
    
    // 6、根据CTFramesetterRef和CGPathRef创建CTFrame
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, [attString length]), path, NULL);
    
    // 7、CTFrameDraw绘制
    CTFrameDraw(frame, context);
    
    // 8、释放资源
    CFRelease(frame);
    CFRelease(path);
    CFRelease(framesetter);
}

@end
