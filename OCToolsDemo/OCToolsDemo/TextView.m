//
//  TextView.m
//  OCToolsDemo
//
//  Created by chengfei on 2017/11/16.
//  Copyright © 2017年 chengfei. All rights reserved.
//

#import "TextView.h"
#import <CoreText/CoreText.h>

@implementation TextView

- (void)drawRect:(CGRect)rect{
    NSString *src = @"其实流程是这样的： 1、生成要绘制的NSAttributedString对象。 其实流程是这样的： 1、生成要绘制的NSAttributedString对象。 ";
    NSAttributedString * string = [[NSAttributedString alloc]initWithString:src];
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)string);
    // add frame
    CGMutablePathRef Path = CGPathCreateMutable();
    CGPathAddRect(Path, NULL ,CGRectMake(0 , 0 ,self.bounds.size.width , self.bounds.size.height));
    // 生成 frame
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), Path, NULL);
    // 上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();

    
    
    CGPathRef framePath = CTFrameGetPath(frame);
    CGRect frameRect = CGPathGetBoundingBox(framePath);

    
    CFArrayRef lines = CTFrameGetLines(frame);
    CFIndex numLines = CFArrayGetCount(lines);
    
    CGFloat maxWidth =0;
    CGFloat textHeight =0;
    
    CFIndex lastLineIndex = numLines -1;
    for(CFIndex index =0; index < numLines; index++){
        CGFloat ascent, descent, leading, width;
        CTLineRef line = (CTLineRef)CFArrayGetValueAtIndex(lines, index);
        width =CTLineGetTypographicBounds(line, &ascent,  &descent, &leading);
        if(width > maxWidth){
            maxWidth = width;
        }
        if(index == lastLineIndex){
            CGPoint lastLineOrigin;
            CTFrameGetLineOrigins(frame,CFRangeMake(lastLineIndex,1), &lastLineOrigin);
            textHeight = CGRectGetMaxY(frameRect) - lastLineOrigin.y+ descent;
        }
    }
    CGSize size = CGSizeMake(ceil(maxWidth),ceil(textHeight));
    
    // 绘制背景色
    CGContextSetRGBFillColor(ctx, 0, 0.25, 0, 0.5);
//    CGRect rects = {CGPointMake(0, 0), size};
    CGContextFillRect(ctx, (CGRect){CGPointMake(0, 0), size});
    CGContextStrokePath(ctx);
    
    CGContextSetTextMatrix(ctx , CGAffineTransformIdentity);
    //x，y轴方向移动
    CGContextTranslateCTM(ctx , 0 ,self.bounds.size.height);
    //缩放x，y轴方向缩放，－1.0为反向1.0倍,坐标系转换,沿x轴翻转180度
    CGContextScaleCTM(ctx, 1.0 ,-1.0);
    // 绘制
    CTFrameDraw(frame,ctx);
    // 释放资源
    CGPathRelease(Path);
    CFRelease(framesetter);
}






//- (void)drawRect:(CGRect)rect
//{
//    NSString *src = @"其实流程是这样的： 1、生成要绘制的NSAttributedString对象。 其实流程是这样的： 1、生成要绘制的NSAttributedString对象。 ";
//
//    NSAttributedString * string = [[NSAttributedString alloc]initWithString:src];
//
//    CGContextRef ctx = UIGraphicsGetCurrentContext();
//
//    CGContextSetTextMatrix(ctx , CGAffineTransformIdentity);
//
//    //CGContextSaveGState(ctx);
//
//    //x，y轴方向移动
//    CGContextTranslateCTM(ctx , 0 ,self.bounds.size.height);
//
//    //缩放x，y轴方向缩放，－1.0为反向1.0倍,坐标系转换,沿x轴翻转180度
//    CGContextScaleCTM(ctx, 1.0 ,-1.0);
//
//    // layout master
//    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString(
//                                                                           (CFAttributedStringRef)string);
//    CGMutablePathRef Path = CGPathCreateMutable();
//
//    //坐标点在左下角
//    CGPathAddRect(Path, NULL ,CGRectMake(0 , 0 ,self.bounds.size.width , self.bounds.size.height));
//
//    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), Path, NULL);
//
//    CFArrayRef Lines = CTFrameGetLines(frame);
//
//    int linecount = CFArrayGetCount(Lines);
////
//    CGPoint origins[linecount];
//    CTFrameGetLineOrigins(frame,
//                          CFRangeMake(0, 0), origins);
//    NSInteger lineIndex = 0;
//
//    for (id oneLine in (__bridge NSArray *)Lines)
//        {
//            CGRect lineBounds = CTLineGetImageBounds((CTLineRef)oneLine, ctx);
////
////            lineBounds.origin.x += origins[lineIndex].x;
////            lineBounds.origin.y += origins[lineIndex].y;
////
////            lineIndex++;
////            //画长方形
////
////            //设置颜色，仅填充4条边
////            CGContextSetStrokeColorWithColor(ctx, [[UIColor redColor] CGColor]);
////            //设置线宽为1
////            CGContextSetLineWidth(ctx, 1.0);
////            //设置长方形4个顶点
////            CGPoint poins[] = {CGPointMake(lineBounds.origin.x, lineBounds.origin.y),CGPointMake(lineBounds.origin.x+lineBounds.size.width, lineBounds.origin.y),CGPointMake(lineBounds.origin.x+lineBounds.size.width, lineBounds.origin.y+lineBounds.size.height),CGPointMake(lineBounds.origin.x, lineBounds.origin.y+lineBounds.size.height)};
////            CGContextAddLines(ctx,poins,4);
////            CGContextClosePath(ctx);
////            CGContextStrokePath(ctx);
//
//        }
//
//
//
//    CTFrameDraw(frame,ctx);
//    // 释放资源
//    CGPathRelease(Path);
//    CFRelease(framesetter);
//}

@end
