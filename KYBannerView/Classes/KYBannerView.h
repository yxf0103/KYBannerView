//
//  KYBannerView.h
//  KYBannerView
//
//  Created by yxf on 2019/4/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^KYSetImgBlock)(UIImageView *imgView,NSString *url);

@interface KYBannerView : UIView

-(instancetype)initWithFrame:(CGRect)frame setImg:(nullable KYSetImgBlock)setImgBlock NS_DESIGNATED_INITIALIZER;

/*images*/
@property (nonatomic,copy)NSArray<NSString *> *images;

-(void)setPageControllTintColor:(UIColor *)color;

-(void)setPageControllCurrentTintColor:(UIColor *)color;

@end

NS_ASSUME_NONNULL_END
