//
//  KYBannerView.h
//  KYBannerView
//
//  Created by yxf on 2019/4/12.
//

#import <UIKit/UIKit.h>
#import "KYBannerImageModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^KYSetImgBlock)(UIImageView *imgView,id<KYBannerImageModel> model);

@interface KYBannerView : UIView

-(instancetype)initWithFrame:(CGRect)frame setImg:(nullable KYSetImgBlock)setImgBlock;
-(instancetype)initWithFrame:(CGRect)frame setImg:(nullable KYSetImgBlock)setImgBlock interval:(NSTimeInterval)interval NS_DESIGNATED_INITIALIZER;

@property (nonatomic,copy)NSArray<KYBannerImageModel> *images;

-(void)setPageControllTintColor:(UIColor *)color;

-(void)setPageControllCurrentTintColor:(UIColor *)color;

@end

NS_ASSUME_NONNULL_END
