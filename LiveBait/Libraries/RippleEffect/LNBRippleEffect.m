//
//  LNBRippleEffect.m
//  LNBRippleEffect
//
//  Created by BHARATH Lalgudi Natarajan on 25/12/14.
//  Copyright (c) 2014 Bharath. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.


#import <QuartzCore/QuartzCore.h>
#import "LNBRippleEffect.h"
#import <QuartzCore/CAAnimation.h>

@interface LNBRippleEffect () <UIGestureRecognizerDelegate>

@property (nonatomic, assign) BOOL animationWorking;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation LNBRippleEffect
@synthesize buttonImage;

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    self.buttonImage.transform = CGAffineTransformMakeScale(0.98f, 0.98f);
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    self.buttonImage.transform = CGAffineTransformIdentity;

    [self buttonTapped:nil];
    
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    return YES;
}

- (void)stopTimer {
    
    [self.timer invalidate];
    self.timer = nil;
}

- (void)starTimer {
 
    if (!self.timer) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.2 target:self selector:@selector(continuoousripples) userInfo:nil repeats:YES];
    }
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
      
       
    }
    
    return self;
}

-(void)drawImageWithFrame:(UIImage *)image Frame:(CGRect)frame Color:(UIColor*)bordercolorr{
    
    buttonImage = [[UIImageView alloc]initWithImage:image];
    buttonImage.frame = CGRectMake(0, 0, frame.size.width-5, frame.size.height-5);
    buttonImage.layer.borderColor = [UIColor clearColor].CGColor;
    buttonImage.layer.borderWidth = 1.0;
    buttonImage.clipsToBounds = YES;
    buttonImage.userInteractionEnabled = YES;
    [buttonImage setContentMode:UIViewContentModeScaleAspectFill];
    buttonImage.layer.cornerRadius = buttonImage.frame.size.height/2;
    [self addSubview:buttonImage];
    
    self.userInteractionEnabled = YES;
    
    buttonImage.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    self.layer.cornerRadius = self.frame.size.height/2;
    self.layer.borderWidth = 10.0f;
    self.layer.borderColor = bordercolorr.CGColor;
    
    
    self.userInteractionEnabled = YES;
    
//    UITapGestureRecognizer *gestrure = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(buttonTapped:)];
//    gestrure.delegate = self;
//
//    [self addGestureRecognizer:gestrure];
//    self.tapGesture = gestrure;
//    gestrure = nil;

    
    [self starTimer];
    
}


-(instancetype)initWithImage:(UIImage *)image
                    Frame:(CGRect)frame
                    Color:(UIColor*)bordercolor
                   Target:(SEL)action
                       ID:(id)sender {
    self = [super initWithFrame:frame];
    
    if(self){
        [self drawImageWithFrame:image Frame:frame Color:bordercolor];
        selectedMethod = action;
        senderid = sender;
    }
    
    return self;
}

-(instancetype)initWithImage:(UIImage *)image Frame:(CGRect)frame didEnd:(onFinish)executeOnFinish {
    self = [super initWithFrame:frame];
    
    if(self){
        
        [self drawImageWithFrame:image Frame:frame Color:bordercolor];
        self.block = executeOnFinish;
    }
    
    return self;
}


-(void)setRippleColor:(UIColor *)color {
    rippleColor = color;
}

-(void)setRippleTrailColor:(UIColor *)color {
    rippleTrailColor = color;
}



- (void)animationDidStart:(CAAnimation *)anim {
  //  NSLog(@"animationDidStart -- %@ ",anim);

    
}

/* Called when the animation either completes its active duration or
 * is removed from the object it is attached to (i.e. the layer). 'flag'
 * is true if the animation reached the end of its active duration
 * without being removed. */

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    
    
    CALayer *layerAnimation = [anim valueForKey:@"animationLayer"];
    
    if (layerAnimation) {
        
        NSMutableArray *layers = [[self.layer sublayers]mutableCopy];
        [layers removeObject:layerAnimation];
        [layerAnimation removeAllAnimations];
        [layerAnimation removeFromSuperlayer];
        layerAnimation = nil;
       // NSLog(@" Remove----------");

    }

}


-(void)buttonTapped:(UIGestureRecognizer *)gesture {
    
    
    self.buttonImage.transform = CGAffineTransformIdentity;
    
    if (self.animationWorking) {
        return;
    }
    
    self.animationWorking = YES;
    CGRect pathFrame = CGRectMake(-CGRectGetMidX(self.bounds), -CGRectGetMidY(self.bounds), self.bounds.size.width, self.bounds.size.height);
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:pathFrame cornerRadius:self.layer.cornerRadius];
    CGPoint shapePosition = CGPointMake(CGRectGetWidth(self.frame)/2.0, CGRectGetHeight(self.frame)/2.0);
    CAShapeLayer *circleShape = [CAShapeLayer layer];
    circleShape.path = path.CGPath;
    circleShape.position = shapePosition;
    circleShape.fillColor = rippleTrailColor.CGColor;
    circleShape.opacity = 0.2;
    circleShape.strokeColor = rippleColor.CGColor;
    circleShape.lineWidth = 3;
    circleShape.shouldRasterize = YES;
    [circleShape setRasterizationScale:[UIScreen mainScreen].scale];
    circleShape.name = @"CIRCELLAYER";
    [self.layer insertSublayer:circleShape atIndex:0];
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    scaleAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(2.5, 2.5, 1)];
    scaleAnimation.removedOnCompletion = NO;
    scaleAnimation.delegate = self;
    
    CABasicAnimation *alphaAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    alphaAnimation.fromValue = @1;
    alphaAnimation.toValue = @0;
    alphaAnimation.delegate = self;
    alphaAnimation.removedOnCompletion = NO;
    
    
    CAAnimationGroup *animation = [CAAnimationGroup animation];
    [animation setValue:circleShape forKey:@"animationLayer"];
    animation.animations = @[scaleAnimation, alphaAnimation];
    animation.duration = 1.2f;
    animation.delegate  = self;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [circleShape addAnimation:animation forKey:nil];
    animation.removedOnCompletion = NO;
    [animation setValue:circleShape forKey:@"animationLayer"];
    
    [UIView animateWithDuration:2.5 animations:^{
        
    }completion:^(BOOL finished) {
        self.animationWorking = NO;
    }];
    
    
}



- (UIBezierPath *)layoutPath {
    
    const double TWO_M_PI = 2.0 * M_PI;
    const double startAngle = 0.75 * TWO_M_PI;
    const double endAngle = startAngle + TWO_M_PI;
    
    CGFloat width = self.frame.size.width;
    CGFloat lineWidth = 10.0;
    
    //	CGFloat borderWidth = self.shapeLayer.borderWidth;
    return [UIBezierPath bezierPathWithArcCenter:CGPointMake(width/2.0f, width/2.0f)
                                          radius:width/2.0f - lineWidth/2.0f
                                      startAngle:startAngle
                                        endAngle:endAngle
                                       clockwise:YES];
    
}


-(void)continuoousripples
{
    
    if (self.animationWorking) {
        return;
    }
    
    CGRect pathFrame = CGRectMake(-CGRectGetMidX(self.bounds), -CGRectGetMidY(self.bounds), self.bounds.size.width, self.bounds.size.height);
    UIBezierPath *path =  [UIBezierPath bezierPathWithRoundedRect:pathFrame cornerRadius:self.layer.cornerRadius];
    CGPoint shapePosition = CGPointMake(CGRectGetWidth(self.frame)/2.0, CGRectGetHeight(self.frame)/2.0);

    CAShapeLayer *circleShape = [CAShapeLayer layer];
    circleShape.path = path.CGPath;
    circleShape.position = shapePosition;
    circleShape.fillColor =  rippleTrailColor.CGColor;
    circleShape.opacity = 1.0;
    circleShape.strokeColor = rippleColor.CGColor;
    circleShape.lineWidth = 10.0;
    circleShape.shouldRasterize = YES;
    [circleShape setRasterizationScale:[UIScreen mainScreen].scale];
    [self.layer insertSublayer:circleShape atIndex:0];
    circleShape.name = @"CIRCELLAYER";

    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    scaleAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(2.5, 2.5, 1)];
    scaleAnimation.removedOnCompletion = NO;

    CABasicAnimation *alphaAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    alphaAnimation.fromValue = @1;
    alphaAnimation.toValue = @0.0;
    alphaAnimation.removedOnCompletion = NO;
    
    CAAnimationGroup *animation = [CAAnimationGroup animation];
    [animation setValue:circleShape forKey:@"animationLayer"];
    animation.animations = @[scaleAnimation, alphaAnimation];
    animation.duration = 1.2f;
    animation.delegate = self;
     animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [circleShape addAnimation:animation forKey:nil];
    [animation setValue:circleShape forKey:@"animationLayer"];

    
}


- (void)stopRippleAnimation {
    
    [self stopTimer];
    
}

- (void)startRippleAnimation {
    
    [self starTimer];
    
}


@end
