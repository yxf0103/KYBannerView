//
//  KYBannerModel.h
//  KYBannerView_Example
//
//  Created by yxf on 2020/7/13.
//  Copyright © 2020 massyxf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KYBannerImageModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface KYBannerModel : NSObject<KYBannerImageModel>

@property (nonatomic,copy)NSString *banner_image;

@end

NS_ASSUME_NONNULL_END
