
#import <UIKit/UIKit.h>

@interface WPTappableLabel : UILabel

@property (nonatomic, readwrite, copy) void (^onTap) (CGPoint);

@end

