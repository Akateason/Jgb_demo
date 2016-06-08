//
//  StartMoveView.m
//  JGB
//
//  Created by JGBMACMINI01 on 14-9-18.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import "StartMoveView.h"
#import <QuartzCore/CoreAnimation.h>


@implementation StartMoveView

- (id)initWithFrame:(CGRect)frame
      AndWithPicStr:(NSString *)picStr
  AndWithButtonShow:(BOOL)YesOrNo
       AndWithCloud:(BOOL)cloud
        AndWithFire:(BOOL)fire
      AndWithBgView:(UIView *)bgView

{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        // Initialization code
//        NSLog(@"starframe : %@",NSStringFromCGRect(frame)) ;
        
        CGRect myFrame = CGRectMake(0, 0, frame.size.width, frame.size.height) ;
        
        bgView.frame = myFrame ;
        self.layer.masksToBounds = YES ;
        [self addSubview:bgView] ;

//        NSLog(@"bagframe : %@",NSStringFromCGRect(bgView.frame)) ;
        
        if (YesOrNo)
        {
            self.button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 150, 44)] ;
            [self.button setTitle:@"立即体验" forState:UIControlStateNormal]  ;
            [self.button setCenter:CGPointMake(160, APPFRAME.size.height - 200)]       ;
            [self.button setTitleColor:[UIColor colorWithRed:126.0/255.0 green:59.0/255.0 blue:0/255.0 alpha:1.0] forState:UIControlStateNormal] ;
            [self.button setFont:[UIFont boldSystemFontOfSize:22.0f]] ;
            self.button.backgroundColor = [UIColor colorWithRed:1 green:198.0/255.0 blue:16.0/255.0 alpha:1.0] ;
            self.button.layer.cornerRadius = 4.0f ;
            
            [self addSubview:self.button] ;
            
            [self.button addTarget:self action:@selector(goBackHomeAction) forControlEvents:UIControlEventTouchUpInside] ;
            
    
        }
        
        if (cloud)
        {
            [self cloudAnimationShow] ;
        }

        if (fire)
        {
            [self fireWorksShow] ;
        }
        
        
//        if (!arrow)
//        {
//            [self setArrows] ;
//        }
        

        
    }
    return self;
}

//- (void)setArrows
//{
//    UIImageView *imgArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"downArrows"]] ;
//    imgArrow.frame = CGRectMake(0, 0, 30, 30) ;
//    imgArrow.center = CGPointMake(APPFRAME.size.width / 2, APPFRAME.size.height - 30) ;
//    [self addSubview:imgArrow] ;
//    
//    CAKeyframeAnimation *k = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
//    k.values    = @[@(0.8),@(1.0),@(1.2)];
//    k.keyTimes  = @[@(0.0),@(0.25),@(0.5),@(1.0)];
//    k.duration = 0.55;
//    k.calculationMode = kCAAnimationLinear;
//    k.repeatCount = 1000 ;
//    [imgArrow.layer addAnimation:k forKey:@"SHOW"];
//    
//}


- (void)cloudAnimationShow
{
    // Configure the particle emitter to the top edge of the screen
	CAEmitterLayer *snowEmitter = [CAEmitterLayer layer]                        ;
	snowEmitter.emitterPosition = CGPointMake(self.bounds.size.width / 2.0, 300);
	snowEmitter.emitterSize		= CGSizeMake(self.bounds.size.width * 2.0, 0.0) ;
	
	// Spawn points for the flakes are within on the outline of the line
	snowEmitter.emitterMode		= kCAEmitterLayerOutline    ;
	snowEmitter.emitterShape	= kCAEmitterLayerSphere     ; //kCAEmitterLayerLine;
	// Configure the snowflake emitter cell
	CAEmitterCell *snowflake = [CAEmitterCell emitterCell]  ;
    //	snowflake.emissionLongitude = -1 ;
    
	snowflake.birthRate		= 0.8     ;
	snowflake.lifetime		= 6.0   ;
	
    snowflake.alphaRange    = 1     ;
    snowflake.alphaSpeed    = 1     ;
    
    //	snowflake.velocity		=  5;				// falling down slowly
    //	snowflake.velocityRange =  5;
    //	snowflake.yAcceleration = -20;
    snowflake.xAcceleration = 20    ;
    snowflake.zAcceleration = 4     ;
    
	snowflake.emissionRange = 0.5 * M_PI;		// some variation in angle
    //	snowflake.spinRange		= 0.25 * M_PI;		// slow spin
	
    //    snowflake.minificationFilter     = @"1" ;
    //    snowflake.minificationFilterBias = 0.5 ;
    
	snowflake.contents		= (id) [[UIImage imageNamed:@"cloud"] CGImage];
	snowflake.color			= [[UIColor whiteColor] CGColor];
    
    snowflake.scale      = 0.1  ;
    snowflake.scaleRange = 0.5  ;
    snowflake.scaleSpeed = 0.25 ;
    
    
    
	// Make the flakes seem inset in the background
	snowEmitter.shadowOpacity = 1.0;
	snowEmitter.shadowRadius  = 0.0;
	snowEmitter.shadowOffset  = CGSizeMake(0.0, 1.0);
	snowEmitter.shadowColor   = [[UIColor whiteColor] CGColor];
	
	// Add everything to our backing layer below the UIContol defined in the storyboard
	snowEmitter.emitterCells = [NSArray arrayWithObject:snowflake];
	[self.layer insertSublayer:snowEmitter atIndex:0];
    
}

- (void)fireWorksShow
{
    // Cells spawn in the bottom, moving up
	CAEmitterLayer *fireworksEmitter = [CAEmitterLayer layer];
	CGRect viewBounds = self.layer.bounds;
	fireworksEmitter.emitterPosition = CGPointMake(viewBounds.size.width/2.0, viewBounds.size.height);
	fireworksEmitter.emitterSize	= CGSizeMake(viewBounds.size.width/2.0, 0.0);
	fireworksEmitter.emitterMode	= kCAEmitterLayerOutline;
	fireworksEmitter.emitterShape	= kCAEmitterLayerLine;
	fireworksEmitter.renderMode		= kCAEmitterLayerAdditive;
	fireworksEmitter.seed           = (arc4random()%100)+1;
	
	// Create the rocket
	CAEmitterCell* rocket = [CAEmitterCell emitterCell];
	
	rocket.birthRate		= 1.0;
	rocket.emissionRange	= 0.25 * M_PI;  // some variation in angle
	rocket.velocity			= 380;
	rocket.velocityRange	= 100;
	rocket.yAcceleration	= 75;
	rocket.lifetime			= 1.02;	// we cannot set the birthrate < 1.0 for the burst
	
	rocket.contents			= (id) [[UIImage imageNamed:@"DazRing"] CGImage];
	rocket.scale			= 0.2;
//	rocket.color			= [[UIColor colorWithRed:(arc4random()%10-1.0)/5.0 green:(arc4random()%10-1.0)/5.0 blue:(arc4random()%10-1.0)/10.0 alpha:1] CGColor];
    rocket.color			= [UIColor yellowColor].CGColor;
    
    
	rocket.greenRange		= 1.0;		// different colors
	rocket.redRange			= 1.0;
	rocket.blueRange		= 1.0;
	rocket.spinRange		= M_PI;		// slow spin
	
	
	// the burst object cannot be seen, but will spawn the sparks
	// we change the color here, since the sparks inherit its value
	CAEmitterCell* burst = [CAEmitterCell emitterCell];
	
	burst.birthRate			= 1.0;		// at the end of travel
	burst.velocity			= 0;
	burst.scale				= 2.5;
    
    int hehe = 1 ;
    
	burst.redSpeed			= arc4random()%2 ? (arc4random()%hehe) : (-(arc4random()%hehe));//-1.5;		// shifting
	burst.blueSpeed			= arc4random()%2 ? (arc4random()%hehe) : (-(arc4random()%hehe));//+1.5;		// shifting
	burst.greenSpeed		= arc4random()%2 ? (arc4random()%hehe) : (-(arc4random()%hehe));//-1.5;		// shifting
	burst.lifetime			= 0.35;
    burst.alphaSpeed		= -0.25;

    
    
	// and finally, the sparks
	CAEmitterCell* spark = [CAEmitterCell emitterCell];
	
	spark.birthRate			= 400;
	spark.velocity			= 125;
	spark.emissionRange		= 2 * M_PI;	// 360 deg
	spark.yAcceleration		= 75;		// gravity
	spark.lifetime			= 3 ;
    
	spark.contents			= (id) [[UIImage imageNamed:@"DazStarOutline"] CGImage];
	spark.scaleSpeed		= -0.1;
	spark.greenSpeed		=  arc4random()%1;//0.1;
	spark.redSpeed			=  arc4random()%1;//0.1;
	spark.blueSpeed			=  arc4random()%1;//0.1;
	spark.alphaSpeed		= 1;
    spark.alphaRange        = 1;
    
    
	spark.spin				= 2 * M_PI;
	spark.spinRange			= 2 * M_PI;
	
	// putting it together
	fireworksEmitter.emitterCells	= [NSArray arrayWithObject:rocket];
	rocket.emitterCells				= [NSArray arrayWithObject:burst];
	burst.emitterCells				= [NSArray arrayWithObject:spark];
	[self.layer addSublayer:fireworksEmitter];

}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


#pragma mark - go Back Home Action
- (void)goBackHomeAction
{
//    NSLog(@"goBackHomeAction") ;
    [self.delegate goHome] ;
}


@end
