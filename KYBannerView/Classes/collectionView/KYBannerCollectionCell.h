//
//  NDBannerCell.h
//  NDTruck
//
//  Created by yxf on 2019/11/21.
//  Copyright © 2019 k_yan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

static NSString *const ky_banner_collection_cell = @"KYBannerCollectionCell";

@interface KYBannerCollectionCell : UICollectionViewCell

/*imgView*/
@property (nonatomic,weak)UIImageView *imgView;

@end

NS_ASSUME_NONNULL_END
