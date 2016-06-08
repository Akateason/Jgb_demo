//Teason 2014 08


#import "ImageScrollView.h"
//#import "PlayerViewController.h"


@implementation ImageScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.maximumZoomScale = 3.0;
        self.minimumZoomScale = 1.0;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator   = NO;
        
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.backgroundColor = [UIColor whiteColor] ;
        
        CGRect myRect = self.bounds ;
        float flex = 10.0f ;
        _imageView.frame = CGRectMake(0 + flex, 0 + flex, myRect.size.width - flex * 2, myRect.size.height - flex * 2);
        
        [self addSubview:_imageView];
        
        self.delegate = self;

        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [self addGestureRecognizer:tap];
        
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
        doubleTap.numberOfTapsRequired = 2;
        [self addGestureRecognizer:doubleTap];
        
        [tap requireGestureRecognizerToFail:doubleTap];
    }
    
    return self;
}

#pragma mark - UIScrollView Delegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _imageView;
}

#pragma mark - Touch Action
- (void)tap:(UITapGestureRecognizer *)tapGetrue {
    NSLog(@"单击");
    [_delegateImageSV shutDown] ;//shut down

    if (_type == 1) {
//        [_delegateImageSV wantToPlayTheMovie:_indexBeSend];
    }
}

- (void)doubleTap:(UITapGestureRecognizer *)tapGesture
{
    if(_type == 0) {
        //photo
        if (self.zoomScale >= 2.5) {
            [self setZoomScale:1 animated:YES];
        }else {
            CGPoint point = [tapGesture locationInView:self];
            [self zoomToRect:CGRectMake(point.x - 40, point.y - 40, 80, 80) animated:YES];
        }
    }
}


@end
