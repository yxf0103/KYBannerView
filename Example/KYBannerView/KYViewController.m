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

@interface KYViewController ()

@end

@implementation KYViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    KYBannerView *bannerView = [[KYBannerView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 200) setImg:^(UIImageView * _Nonnull imgView, NSString * _Nonnull url) {
        [imgView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:nil];
    }];
    [self.view addSubview:bannerView];
    bannerView.images = @[@"http://pic17.nipic.com/20111025/533255_215834243000_2.jpg",
                          @"http://pic43.nipic.com/20140702/3822951_125854430000_2.jpg",
                          @"http://pic31.nipic.com/20130714/1699509_191130287195_2.jpg"];
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
