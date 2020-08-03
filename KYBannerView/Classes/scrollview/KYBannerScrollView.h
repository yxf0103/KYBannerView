//
//  KYBannerView.h
//  KYBannerView
//
//  Created by yxf on 2019/4/12.
//

#import <UIKit/UIKit.h>
#import "KYBannerImageModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface KYBannerView : UIView

/*images*/
@property (nonatomic,copy)NSArray<KYBannerImageModel> *images;

/*页码改变的回调*/
@property (nonatomic,copy)KYIndexChangedBlock indexChanged;

/*显示页码*/
@property (nonatomic,assign)BOOL showPageControll;

-(instancetype)initWithFrame:(CGRect)frame
                      setImg:(nullable KYSetImgBlock)setImgBlock
                 activeTimer:(BOOL)activeTimer NS_DESIGNATED_INITIALIZER;

-(void)setPageControllTintColor:(UIColor *)color;

-(void)setPageControllCurrentTintColor:(UIColor *)color;

@end

NS_ASSUME_NONNULL_END
