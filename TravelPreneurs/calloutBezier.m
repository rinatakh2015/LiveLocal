//
//  calloutBezier.m
//  Loaction
//
//  Created by martin on 6/25/14.
//  Copyright (c) 2014 Openlanguage. All rights reserved.
//

#import "calloutBezier.h"

@implementation calloutBezier

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{

    //// Color Declarations
    UIColor* fillColor = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 1];
    UIColor* strokeColor = [UIColor colorWithRed:0.839 green:0.384 blue:0.435 alpha:1.0];
    
    //// Bezier 2 Drawing
    UIBezierPath* bezier2Path = [UIBezierPath bezierPath];
    [bezier2Path moveToPoint: CGPointMake(195.5, 16.07)];
    [bezier2Path addLineToPoint: CGPointMake(195.5, 52.26)];
    [bezier2Path addCurveToPoint: CGPointMake(180.5, 65.83) controlPoint1: CGPointMake(195.5, 59.76) controlPoint2: CGPointMake(188.78, 65.83)];
    [bezier2Path addLineToPoint: CGPointMake(110.75, 65.83)];
    [bezier2Path addLineToPoint: CGPointMake(98.5, 78.5)];
    [bezier2Path addLineToPoint: CGPointMake(88, 65.83)];
    [bezier2Path addLineToPoint: CGPointMake(19.5, 65.83)];
    [bezier2Path addCurveToPoint: CGPointMake(4.5, 52.26) controlPoint1: CGPointMake(11.22, 65.83) controlPoint2: CGPointMake(4.5, 59.76)];
    [bezier2Path addLineToPoint: CGPointMake(4.5, 16.07)];
    [bezier2Path addCurveToPoint: CGPointMake(19.5, 2.5) controlPoint1: CGPointMake(4.5, 8.58) controlPoint2: CGPointMake(11.22, 2.5)];
    [bezier2Path addLineToPoint: CGPointMake(180.5, 2.5)];
    [bezier2Path addCurveToPoint: CGPointMake(195.5, 16.07) controlPoint1: CGPointMake(188.78, 2.5) controlPoint2: CGPointMake(195.5, 8.58)];
    [bezier2Path closePath];
    [fillColor setFill];
    [bezier2Path fill];
    [strokeColor setStroke];
    bezier2Path.lineWidth = 1;
    [bezier2Path stroke];
    
    

    
}


@end
