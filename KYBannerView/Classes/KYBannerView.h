//
//  KYBannerView.h
//  KYBannerView
//
//  Created by yxf on 2020/8/3.
//

#import <UIKit/UIKit.h>
#import "KYBannerImageModel.h"
#import "KYBannerConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface KYBannerView : UIView

///images data
@property (nonatomic,copy)NSArray<KYBannerImageModel> *images;

///页码改变的回调
@property (nonatomic,copy)void (^indexChangedBlock)(NSInteger index,NSInteger totalPage);

///设置imageview的图片
@property (nonatomic,copy)void (^setImgBlock)(UIImageView * _Nonnull imgView,id<KYBannerImageModel> _Nonnull model);

///选中当前banner的回调
@property (nonatomic,copy)void (^selectBannerBlock)(id<KYBannerImageModel> imgModel);

///页码
@property (nonatomic,weak,readonly)UIPageControl *pageControl;

-(instancetype)initWithFrame:(CGRect)frame config:(KYBannerConfig *)config NS_DESIGNATED_INITIALIZER;

-(BOOL)autoScroll;
-(NSTimeInterval)autoScrollInterval;

@end

NS_ASSUME_NONNULL_END
