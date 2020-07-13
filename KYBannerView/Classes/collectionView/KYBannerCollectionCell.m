//
//  NDBannerCell.m
//  NDTruck
//
//  Created by yxf on 2019/11/21.
//  Copyright © 2019 k_yan. All rights reserved.
//

#import "KYBannerCollectionCell.h"

@implementation KYBannerCollectionCell

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        UIImageView *imgView = [[UIImageView alloc] init];
        [self.contentView addSubview:imgView];
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        _imgView = imgView;
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    _imgView.frame = self.contentView.bounds;
}

@end
