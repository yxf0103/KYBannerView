//
//  KYBannerConfig.m
//  KYBannerView
//
//  Created by yxf on 2020/8/3.
//

#import "KYBannerConfig.h"

@implementation KYBannerConfig

-(instancetype)init{
    if (self = [super init]) {
        _autoScroll = YES;
        _duration = 3;
        _showPageControl = YES;
        _currentColor = [UIColor whiteColor];
        _tintColor = [UIColor grayColor];
    }
    return self;
}

@end
