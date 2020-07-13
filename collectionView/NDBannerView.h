//
//  NDBannerView.h
//  NDTruck
//
//  Created by yxf on 2019/11/21.
//  Copyright © 2019 k_yan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NDBannerView : UIView

/*datas*/
@property (nonatomic,strong)NSArray *imgModels;

/*设置图片*/
@property (nonatomic,copy)void (^setImgBlock)(UIImageView *imgView,id imgModel);

/*当前页的回调*/
@property (nonatomic,copy)void (^pageChangedBlock)(int index,int count);

///选中当前banner的回调
@property (nonatomic,copy)void (^selectBannerBlock)(id imgModel);

@property (nonatomic,assign)BOOL autoScroll;

-(void)showAnimation;
-(void)hideAnimation;

@end

NS_ASSUME_NONNULL_END
