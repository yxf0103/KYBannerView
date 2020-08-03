//
//  KYBannerView.m
//  KYBannerView
//
//  Created by yxf on 2019/4/12.
//

#import "KYBannerScrollView.h"

@interface KYBannerScrollView ()<UIScrollViewDelegate>{
    __weak UIScrollView *_mainScrollView;
    __weak UIImageView *_leftImgView;
    __weak UIImageView *_midImgView;
    __weak UIButton *_mBtn;
    __weak UIImageView *_rightImgView;
    NSInteger _index;
}

/*timer*/
@property (nonatomic,strong)dispatch_source_t timer;

/*semaphore*/
@property (nonatomic,strong)dispatch_semaphore_t semaphore;

@end

@implementation KYBannerScrollView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _index = 0;
        [self createUI];
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
    mView.userInteractionEnabled = YES;
    UIButton *mBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [mView addSubview:mBtn];
    [mBtn addTarget:self action:@selector(middleBannerClicked:) forControlEvents:UIControlEventTouchUpInside];
    _mBtn = mBtn;
    
    UIImageView *rView = [[UIImageView alloc] init];
    [scrollView addSubview:rView];
    _rightImgView = rView;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    CGFloat width = CGRectGetWidth(self.bounds);
    CGFloat height = CGRectGetHeight(self.bounds);
    _mainScrollView.frame = self.bounds;
    _mainScrollView.contentSize = CGSizeMake(width * 3, 0);
    _leftImgView.frame = CGRectMake(0, 0, width, height);
    _midImgView.frame = CGRectMake(width, 0, width, height);
    _mBtn.frame = _midImgView.bounds;
    _rightImgView.frame = CGRectMake(width * 2, 0, width, height);
    _mainScrollView.contentOffset = CGPointMake(width, 0);
}

#pragma mark - setter
-(void)setImages:(NSArray<KYBannerImageModel> *)images{
    [super setImages:images];
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
}

#pragma mark - action
-(void)middleBannerClicked:(UIButton *)btn{
    !self.selectBannerBlock ? : self.selectBannerBlock(self.images[_index]);
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
    if (!self.autoScroll) {
        return;
    }
    dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
    if (_timer) {
        dispatch_suspend(_timer);
    }
    dispatch_semaphore_signal(_semaphore);
}

-(void)resumeTimer{
    if (!self.autoScroll) {
        return;
    }
    dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
    if (_timer) {
        dispatch_resume(_timer);
    }
    dispatch_semaphore_signal(_semaphore);
}

-(void)createTimer{
    if (!self.autoScroll) {
        return;
    }
    _semaphore = dispatch_semaphore_create(1);
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    dispatch_source_set_timer(timer,
                              dispatch_time(DISPATCH_TIME_NOW, self.autoScrollInterval * NSEC_PER_SEC),
                              self.autoScrollInterval * NSEC_PER_SEC,
                              0.05 * NSEC_PER_SEC);
    __weak typeof(self) ws = self;
    dispatch_source_set_event_handler(timer, ^{
        if (!ws) { return; }
        [ws timerAction];
    });
    dispatch_resume(timer);
    _timer = timer;
}

-(void)timerAction{
    self->_mainScrollView.scrollEnabled = NO;
    dispatch_suspend(self.timer);
    CGFloat width = CGRectGetWidth(self.bounds);
    [UIView animateWithDuration:0.25
                     animations:^{
        self->_mainScrollView.contentOffset = CGPointMake(width * 2, 0);
    } completion:^(BOOL finished) {
        self->_mainScrollView.contentOffset = CGPointMake(width, 0);
        [self indexIncrement:YES];
        dispatch_resume(self.timer);
        self->_mainScrollView.scrollEnabled = YES;
    }];
}

#pragma mark - control
-(void)indexIncrement:(BOOL)add{
    if (self.images.count == 0) {
        return;
    }
    _index += add ? 1 : -1;
    if (_index < 0) {
        _index = self.images.count - 1;
    }
    
    if (_index >= self.images.count) {
        _index = 0;
    }
    self.pageControl.currentPage = _index;
    [self resetImgs];
}

-(void)resetImgs{
    if (!self.setImgBlock) {
        return;
    }
    self.setImgBlock(_midImgView, self.images[_index]);
    
    NSInteger leftIndex = (_index - 1) >= 0 ? (_index - 1) : self.images.count - 1;
    self.setImgBlock(_leftImgView, self.images[leftIndex]);
    
    NSInteger rightIndex = (_index + 1) < self.images.count ? (_index + 1) : 0;
    self.setImgBlock(_rightImgView, self.images[rightIndex]);
}

-(void)mainScrollViewDidScroll:(UIScrollView *)scrollView{
    NSInteger index = (NSInteger) (scrollView.contentOffset.x + 10) / CGRectGetWidth(scrollView.bounds);
    scrollView.contentOffset = CGPointMake(CGRectGetWidth(scrollView.bounds), 0);
    if (index != 1) {
        [self indexIncrement:index > 1];
    }
    if (self.indexChangedBlock) {
        self.indexChangedBlock(_index + 1, self.images.count);
    }
}

#pragma mark - delegate
#pragma mark - UIScrollViewDelegate
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (!self.autoScroll) {
        return;
    }
    dispatch_source_set_timer(_timer,
                              DISPATCH_TIME_FOREVER,
                              self.autoScrollInterval * NSEC_PER_SEC,
                              0.05 * NSEC_PER_SEC);
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self mainScrollViewDidScroll:scrollView];
    if (!self.autoScroll) {
        return;
    }
    dispatch_source_set_timer(_timer,
                              dispatch_time(DISPATCH_TIME_NOW,
                                            self.autoScrollInterval  * NSEC_PER_SEC),
                              self.autoScrollInterval * NSEC_PER_SEC,
                              0.05 * NSEC_PER_SEC);
}

@end
