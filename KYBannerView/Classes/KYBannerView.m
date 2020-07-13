//
//  KYBannerView.m
//  KYBannerView
//
//  Created by yxf on 2019/4/12.
//

#import "KYBannerView.h"

@interface KYBannerView ()<UIScrollViewDelegate>{
    __weak UIScrollView *_mainScrollView;
    __weak UIImageView *_leftImgView;
    __weak UIImageView *_midImgView;
    __weak UIImageView *_rightImgView;
    __weak UIPageControl *_pageControl;
    NSInteger _index;
}

/*timer*/
@property (nonatomic,strong)dispatch_source_t timer;

/*semaphore*/
@property (nonatomic,strong)dispatch_semaphore_t semaphore;

/*set img*/
@property (nonatomic,copy)KYSetImgBlock setImgBlock;

///动画间隔
@property (nonatomic,assign)NSTimeInterval interval;

@end

@implementation KYBannerView

-(instancetype)initWithFrame:(CGRect)frame{
    return [self initWithFrame:frame setImg:nil];
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    return [self initWithFrame:CGRectZero setImg:nil];
}

-(instancetype)initWithFrame:(CGRect)frame setImg:(nullable KYSetImgBlock)setImgBlock{
    return [self initWithFrame:frame setImg:setImgBlock interval:3];
}

-(instancetype)initWithFrame:(CGRect)frame setImg:(KYSetImgBlock)setImgBlock interval:(NSTimeInterval)interval{
    if (self = [super initWithFrame:frame]) {
        [self createUI];
        _index = 0;
        _setImgBlock = setImgBlock;
        _interval = interval;
    }
    return self;
}


-(void)dealloc{
    [self deleteTimer];
}

#pragma mark - ui
-(void)createUI{
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    [self addSubview:scrollView];
    scrollView.delegate = self;
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    _mainScrollView = scrollView;
    
    UIImageView *lView = [[UIImageView alloc] init];
    [scrollView addSubview:lView];
    _leftImgView = lView;
    
    UIImageView *mView = [[UIImageView alloc] init];
    [scrollView addSubview:mView];
    _midImgView = mView;
    
    UIImageView *rView = [[UIImageView alloc] init];
    [scrollView addSubview:rView];
    _rightImgView = rView;
    
    UIPageControl *pc = [[UIPageControl alloc] init];
    [self addSubview:pc];
    pc.pageIndicatorTintColor = [UIColor grayColor];
    pc.currentPageIndicatorTintColor = [UIColor whiteColor];
    _pageControl = pc;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    CGFloat width = CGRectGetWidth(self.bounds);
    CGFloat height = CGRectGetHeight(self.bounds);
    _mainScrollView.frame = self.bounds;
    _mainScrollView.contentSize = CGSizeMake(width * 3, 0);
    _leftImgView.frame = CGRectMake(0, 0, width, height);
    _midImgView.frame = CGRectMake(width, 0, width, height);
    _rightImgView.frame = CGRectMake(width * 2, 0, width, height);
    _pageControl.frame = CGRectMake(0, 0, 100, 40);
    _pageControl.center = CGPointMake(width / 2, height - 20);
    _mainScrollView.contentOffset = CGPointMake(width, 0);
}

#pragma mark - setter
-(void)setImages:(NSArray<KYBannerImageModel> *)images{
    _images = images;
    if (images.count > 1) {
        [self createTimer];
        _mainScrollView.scrollEnabled = YES;
        [self resetImgs];
    }else{
        _mainScrollView.scrollEnabled = NO;
        [self deleteTimer];
        if (self.setImgBlock) {
            self.setImgBlock(_midImgView, images.firstObject);
        }
    }
    _pageControl.numberOfPages = images.count;
}

#pragma mark - public func
-(void)setPageControllTintColor:(UIColor *)color{
    _pageControl.pageIndicatorTintColor = color;
}

-(void)setPageControllCurrentTintColor:(UIColor *)color{
    _pageControl.currentPageIndicatorTintColor = color;
}

#pragma mark - private func
#pragma mark - timer
-(void)deleteTimer{
    if (_timer) {
        dispatch_cancel(_timer);
        _timer = nil;
    }
    _semaphore = nil;
}

-(void)pauseTimer{
    dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
    if (_timer) {
        dispatch_suspend(_timer);
    }
    dispatch_semaphore_signal(_semaphore);
}

-(void)resumeTimer{
    dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
    if (_timer) {
        dispatch_resume(_timer);
    }
    dispatch_semaphore_signal(_semaphore);
}

-(void)createTimer{
    _semaphore = dispatch_semaphore_create(1);
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW + _interval * NSEC_PER_SEC, _interval * NSEC_PER_SEC, 0.05 * NSEC_PER_SEC);
    CGFloat width = CGRectGetWidth(self.bounds);
    dispatch_source_set_event_handler(timer, ^{
        self->_mainScrollView.scrollEnabled = NO;
        dispatch_suspend(self.timer);
        [UIView animateWithDuration:0.25
                         animations:^{
                             self->_mainScrollView.contentOffset = CGPointMake(width * 2, 0);
                         } completion:^(BOOL finished) {
                             self->_mainScrollView.contentOffset = CGPointMake(width, 0);
                             [self indexIncrement:YES];
                             dispatch_resume(self.timer);
                             self->_mainScrollView.scrollEnabled = YES;
                         }];
    });
    dispatch_resume(timer);
    
    _timer = timer;
}

#pragma mark - control
-(void)indexIncrement:(BOOL)add{
    if (_images.count == 0) {
        return;
    }
    _index += add ? 1 : -1;
    if (_index < 0) {
        _index = _images.count - 1;
    }
    
    if (_index >= _images.count) {
        _index = 0;
    }
    _pageControl.currentPage = _index;
    [self resetImgs];
}

-(void)resetImgs{
    if (!self.setImgBlock) {
        return;
    }
    self.setImgBlock(_midImgView, _images[_index]);
    
    NSInteger leftIndex = (_index - 1) >= 0 ? (_index - 1) : _images.count - 1;
    self.setImgBlock(_leftImgView, _images[leftIndex]);
    
    NSInteger rightIndex = (_index + 1) < _images.count ? (_index + 1) : 0;
    self.setImgBlock(_rightImgView, _images[rightIndex]);
}

-(void)mainScrollViewDidScroll:(UIScrollView *)scrollView{
    NSInteger index = (NSInteger) (scrollView.contentOffset.x + 10) / CGRectGetWidth(scrollView.bounds);
    scrollView.contentOffset = CGPointMake(CGRectGetWidth(scrollView.bounds), 0);
    if (index != 1) {
        [self indexIncrement:index > 1];
    }
}

#pragma mark - delegate
#pragma mark - UIScrollViewDelegate
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    dispatch_source_set_timer(_timer, DISPATCH_TIME_FOREVER, _interval * NSEC_PER_SEC, 0.05 * NSEC_PER_SEC);
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self mainScrollViewDidScroll:scrollView];
    dispatch_source_set_timer(_timer, dispatch_time(DISPATCH_TIME_NOW, _interval * NSEC_PER_SEC), _interval * NSEC_PER_SEC, 0.05 * NSEC_PER_SEC);
}

@end
