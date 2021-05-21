//
//  KYBannerView.m
//  KYBannerView
//
//  Created by yxf on 2020/8/3.
//

#import "KYBannerBaseView.h"

@interface KYBannerBaseView ()

@property (nonatomic,strong)KYBannerConfig *config;

@property (nonatomic,weak)UIPageControl *pageControl;

@end

@implementation KYBannerBaseView

-(instancetype)initWithFrame:(CGRect)frame config:(KYBannerConfig *)config{
    if (self = [super initWithFrame:frame]) {
        _config = config;
        if (config.showPageControl) {
            UIPageControl *pc = [[UIPageControl alloc] init];
            [self addSubview:pc];
            pc.pageIndicatorTintColor = config.tintColor;
            pc.currentPageIndicatorTintColor = config.currentColor;
            _pageControl = pc;
        }
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    KYBannerConfig *config = [[KYBannerConfig alloc] init];
    return [self initWithFrame:frame config:config];
}

-(instancetype)initWithCoder:(NSCoder *)coder{
    return [self initWithFrame:CGRectZero];
}

-(BOOL)autoScroll{
    return _config.autoScroll;
}

-(NSTimeInterval)autoScrollInterval{
    return _config.duration;
}

-(void)setImages:(NSArray<KYBannerImageModel> *)images{
    _images = images;
    _pageControl.numberOfPages = images.count;
    _pageControl.hidden = images.count <= 1;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    if (self.pageControl) {
        CGFloat width = CGRectGetWidth(self.bounds);
        CGFloat height = CGRectGetHeight(self.bounds);
        if (@available(iOS 14.0, *)) {
            CGSize size = [self.pageControl sizeForNumberOfPages:self.pageControl.numberOfPages];
            self.pageControl.frame = CGRectMake((width - size.width)/2,
                                                height - size.height,
                                                size.width,
                                                size.height);
        } else {
            self.pageControl.frame = CGRectMake(0, 0, 100, 40);
            self.pageControl.center = CGPointMake(width / 2, height - 20);
        }
        [self bringSubviewToFront:self.pageControl];
    }
}


@end
