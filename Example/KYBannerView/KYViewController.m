//
//  KYViewController.m
//  KYBannerView
//
//  Created by massyxf on 04/12/2019.
//  Copyright (c) 2019 massyxf. All rights reserved.
//

#import "KYViewController.h"
#import <UIImageView+WebCache.h>
#import "KYBannerScrollView.h"
#import "KYBannerModel.h"
#import "KYBannerCollectionView.h"

@interface KYViewController ()

@end

@implementation KYViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    KYBannerScrollView *bannerView = [[KYBannerScrollView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 200)];
    [self.view addSubview:bannerView];
    bannerView.setImgBlock = ^(UIImageView * _Nonnull imgView, id<KYBannerImageModel>  _Nonnull imgModel) {
        [imgView sd_setImageWithURL:[NSURL URLWithString:imgModel.banner_image] placeholderImage:nil];
    };
    bannerView.selectBannerBlock = ^(id<KYBannerImageModel>  _Nonnull imgModel) {
        NSLog(@"===>%@",imgModel.banner_image);
    };
    NSArray *images = @[@"http://pic17.nipic.com/20111025/533255_215834243000_2.jpg",
                        @"https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fimage1.nphoto.net%2Fnews%2Fimage%2F201307%2F084a057c5177ae78.jpg&refer=http%3A%2F%2Fimage1.nphoto.net&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1624200712&t=37443fdd15dca935128285b3c8b1a96a",
                        @"http://pic31.nipic.com/20130714/1699509_191130287195_2.jpg"];
    NSMutableArray *bannerModels = [NSMutableArray array];
    for (NSString *url in images) {
        KYBannerModel *model = [[KYBannerModel alloc] init];
        model.banner_image = url;
        [bannerModels addObject:model];
    }
    bannerView.images = (NSArray<KYBannerImageModel> *)bannerModels;
    
    KYBannerCollectionView *view = [[KYBannerCollectionView alloc] initWithFrame:CGRectMake(0, 300, [UIScreen mainScreen].bounds.size.width, 200)];
    [self.view addSubview:view];
    view.setImgBlock = ^(UIImageView * _Nonnull imgView, id<KYBannerImageModel>  _Nonnull imgModel) {
        [imgView sd_setImageWithURL:[NSURL URLWithString:imgModel.banner_image] placeholderImage:nil];
    };
    view.images = (NSArray<KYBannerImageModel> *)bannerModels;
    
    
}

@end
