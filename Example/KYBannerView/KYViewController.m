//
//  KYViewController.m
//  KYBannerView
//
//  Created by massyxf on 04/12/2019.
//  Copyright (c) 2019 massyxf. All rights reserved.
//

#import "KYViewController.h"
#import "KYBannerView.h"
#import <UIImageView+WebCache.h>
#import "KYBannerModel.h"

@interface KYViewController ()

@end

@implementation KYViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    KYBannerView *bannerView = [[KYBannerView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 200) setImg:^(UIImageView * _Nonnull imgView, id<KYBannerImageModel> model) {
        [imgView sd_setImageWithURL:[NSURL URLWithString:model.banner_image] placeholderImage:nil];
    }];
    [self.view addSubview:bannerView];
    NSArray *images = @[@"http://pic17.nipic.com/20111025/533255_215834243000_2.jpg",
                        @"http://pic43.nipic.com/20140702/3822951_125854430000_2.jpg",
                        @"http://pic31.nipic.com/20130714/1699509_191130287195_2.jpg"];
    NSMutableArray *bannerModels = [NSMutableArray array];
    for (NSString *url in images) {
        KYBannerModel *model = [[KYBannerModel alloc] init];
        model.banner_image = url;
        [bannerModels addObject:model];
    }
    bannerView.images = (NSArray<KYBannerImageModel> *)bannerModels;
    //@"http://pic43.nipic.com/20140702/3822951_125854430000_2.jpg"
    //@"http://pic31.nipic.com/20130714/1699509_191130287195_2.jpg"
    
    //org.cocoapods.demo.KYBannerView-Example
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
