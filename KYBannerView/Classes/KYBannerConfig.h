//
//  KYBannerConfig.h
//  KYBannerView
//
//  Created by yxf on 2020/8/3.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KYBannerConfig : NSObject

///自动滑动
@property (nonatomic,assign)BOOL autoScroll;
///自动滑动的时间间隔，只有autoScroll=yes时才有效
@property (nonatomic,assign)NSTimeInterval duration;

///展示分页符
@property (nonatomic,assign)BOOL showPageControl;
@property (nonatomic,strong)UIColor *tintColor;
@property (nonatomic,strong)UIColor *currentColor;

@end

NS_ASSUME_NONNULL_END
