








#import <UIKit/UIKit.h>

@protocol ImageScrollViewDelegate <NSObject>

- (void)wantToPlayTheMovie:(int)vIndex;

- (void)shutDown ;

@end


@interface ImageScrollView : UIScrollView <UIScrollViewDelegate>
{
    UIImageView *_imageView;
    int indexBeSend;
    
    NSMutableArray *m_mediaPathArr;
}

@property (nonatomic, retain) UIImageView *imageView;

@property (nonatomic, assign) int type;                                 //  0 is photo(default), 1 is video

@property (nonatomic, assign) int indexBeSend;                          //  current index

@property (nonatomic, assign) id <ImageScrollViewDelegate> delegateImageSV;

@end
