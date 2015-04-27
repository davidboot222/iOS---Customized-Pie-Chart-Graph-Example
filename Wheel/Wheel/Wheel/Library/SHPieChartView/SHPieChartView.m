// SHPieChartView.m
//
// Copyright (c) 2014 Shan Ul Haq (http://grevolution.me)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

#import "SHPieChartView.h"
#import <math.h>
#import <CoreText/CoreText.h>

#define ANGLE(val) DEG2RAD(270 + (val))
#define DEG2RAD(val) (M_PI / 180) * (val)
#define RADIUS_MARGIN 5

@implementation ArcValueClass

@end

@implementation SHPieChartView {
  CGPoint _center;
  CGFloat _radius;
}

#pragma mark - initializer methods

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self bootstrap];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    _mainFrame = frame;
    self = [super initWithFrame:frame];
    if (self) {
        [self bootstrap];
    }
    return self;
}

- (void)bootstrap {
    self.backgroundColor = [UIColor clearColor];
    _valuesAndColors = [NSMutableArray array];
}

#pragma mark - Pie addition methods

- (void)addAngleValue:(CGFloat)angle andColor:(UIColor *)color {
    ArcValueClass *v = [[ArcValueClass alloc] init];
    v.color = color;
    v.angle = angle;
    [_valuesAndColors addObject:v];
    
    [self setNeedsDisplay];
}

- (void)insertAngleValue:(CGFloat)angle andColor:(UIColor *)color atIndex:(int)index {
    ArcValueClass *v = [[ArcValueClass alloc] init];
    v.color = color;
    v.angle = angle;
    
    [_valuesAndColors insertObject:v atIndex:index];
    
    [self setNeedsDisplay];
}

- (void)reset {
    [_valuesAndColors removeAllObjects];
}


#pragma mark - drawing methods

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    //center of the view
    _center = CGPointMake(self.center.x - self.frame.origin.x, self.center.y - self.frame.origin.y);
    _radius = (MIN(self.bounds.size.width, self.bounds.size.height) / 2) - RADIUS_MARGIN;
    
    //apply the chart background color
    if(_chartBackgroundColor) {
        CGMutablePathRef path = createArc(_center, _radius, ANGLE(0), ANGLE(360));
        createAndFillArc(context, path, _chartBackgroundColor.CGColor);
    }
  
    if(!_isGraph) {
        
        __block CGFloat startAngle = 0;
        
        [_valuesAndColors enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            
            ArcValueClass *v = (ArcValueClass *)obj;
            CGColorRef color = v.color.CGColor;
            CGFloat value = v.angle;
            
            CGFloat angleValue = (360 * value);
            CGFloat endAngle = startAngle + angleValue;
            
            CGMutablePathRef path = createArc(_center, _radius, ANGLE(startAngle), ANGLE(endAngle));
            createAndFillArc(context, path, color);

            startAngle += angleValue;
        }];
        
        //check and apply the concentric circle
        if(_isConcentric && _concentricRadius > 0 && _concentricColor) {
            CGMutablePathRef path = createArc(_center, _concentricRadius, ANGLE(0), ANGLE(360));
            createAndFillArc(context, path, _concentricColor.CGColor);
        }
    
    } else {
        int i = 0;
        CGPoint pointCurrent, pointOld, pointFirst;
        
        CGPoint graphCenter  = CGPointMake(self.center.x - self.frame.origin.x, self.center.y - self.frame.origin.y);
        for(NSMutableDictionary *dicCategory in _graphData) {
            NSMutableArray *arrComponents = [[NSMutableArray alloc] init];
            arrComponents = [dicCategory objectForKey:@"components"];
            for(NSMutableDictionary *dicComponent in arrComponents) {
                float radian = ((360.0 / (float)_graphCount)) * ((float)i + 0.5 ) * M_PI / 180.0f;
                float rating = [[dicComponent objectForKey:@"rating"] intValue];
                float graphRadius1 = _graphRadius + 0.8f * (rating - 2);
                if(rating > 4) graphRadius1 -= 0.2f;
                if(rating > 3) graphRadius1 -= 0.8f;
                if(rating < 2) graphRadius1 -= 1.6f;
                pointCurrent.x = (sin(radian) * ((float)rating * graphRadius1)) + graphCenter.x;
                pointCurrent.y = -(cos(radian) * ((float)rating * graphRadius1)) + graphCenter.y;
                
                CGMutablePathRef path = createArc(pointCurrent, _graphPointRadius, ANGLE(0), ANGLE(360));
                createAndFillArc(context, path, _graphColor.CGColor);
                
                if(i > 0) {
                    drawLine(context, pointOld, pointCurrent, _graphColor.CGColor);
                } else {
                    pointFirst = pointCurrent;
                }
                pointOld = pointCurrent;

                i++;
            }
        }
        drawLine(context, pointOld, pointFirst, _graphColor.CGColor);

    }
}

- (void) drawStringAtContext:(CGContextRef) context string:(NSString*) text atAngle:(float) angle withRadius:(float) radius withCenterPoint:(CGPoint) centerPoint atFontSize:(float)fontSize {
    
    CGSize textSize = [text sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:fontSize]}];

    float perimeter = 2 * M_PI * radius;
    float textAngle = textSize.width / perimeter * 2 * M_PI;
    
    angle += textAngle / 2;
    
    
    CGPoint point = centerPoint;
    float radian = (360 * angle) * M_PI / 180.0f;
    point.x += sin(radian) * radius;
    point.y -= cos(radian) * radius;
    
    for (int index = 0; index < [text length]; index++)
    {
        NSRange range = {index, 1};
        NSString *letter = [text substringWithRange:range];
        char *c = (char *)[letter cStringUsingEncoding:NSASCIIStringEncoding];
        CGSize charSize = [letter sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:fontSize]}];
        
        NSLog(@"Char %@ with size: %f x %f", letter, charSize.width, charSize.height);
        
        float x = radius * cos(angle);
        float y = radius * sin(angle);
        
        float letterAngle = (charSize.width / perimeter * -2 * M_PI);
        
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, x, y);
        CGContextRotateCTM(context, (angle - 0.5 * M_PI));
        
        [[NSString stringWithFormat:@"%s" , c] drawAtPoint:CGPointMake(0, 0)
                   withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]}];
        CGContextRestoreGState(context);
        
        angle += letterAngle;
        
        NSLog(@"%f", angle);
    }
    
}

void createAndFillArc(CGContextRef context, CGPathRef path, CGColorRef color) {
    CGContextSetFillColorWithColor(context, color);
    CGContextAddPath(context, path);
    
    CGContextDrawPath(context, kCGPathFill);
}

void drawLine(CGContextRef context, CGPoint lastPoint, CGPoint newPoint, CGColorRef color) {
    CGContextSetStrokeColorWithColor(context, color);
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineWidth(context, 1);

    CGContextMoveToPoint(context, lastPoint.x, lastPoint.y);
    CGContextAddLineToPoint(context, newPoint.x, newPoint.y);
    CGContextStrokePath(context);
}

CGMutablePathRef createArc(CGPoint center, CGFloat radius, CGFloat startAngle, CGFloat endAngle) {
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGPathAddArc(path, NULL, center.x, center.y, radius, startAngle, endAngle, 0);
    CGPathAddLineToPoint(path, NULL, center.x, center.y);
    CGPathCloseSubpath(path);
    
    return path;
}


@end
