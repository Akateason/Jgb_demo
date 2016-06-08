
#import <Foundation/Foundation.h>

@interface WPAttributedStyleAction : NSObject

@property (readwrite, copy) void (^action) ();

- (instancetype)initWithAction:(void (^)())action;
+(NSArray*)styledActionWithAction:(void (^)())action;
-(NSArray*)styledAction;


@end

