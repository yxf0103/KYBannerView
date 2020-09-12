# KYBannerView

a banner view.

[![CI Status](https://img.shields.io/travis/massyxf/KYBannerView.svg?style=flat)](https://travis-ci.org/massyxf/KYBannerView)
[![Version](https://img.shields.io/cocoapods/v/KYBannerView.svg?style=flat)](https://cocoapods.org/pods/KYBannerView)
[![License](https://img.shields.io/cocoapods/l/KYBannerView.svg?style=flat)](https://cocoapods.org/pods/KYBannerView)
[![Platform](https://img.shields.io/cocoapods/p/KYBannerView.svg?style=flat)](https://cocoapods.org/pods/KYBannerView)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

KYBannerView is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'KYBannerView'
```

## How to use

### 方案1
```

KYBannerScrollView *bannerView = [[KYBannerScrollView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 200)];
[self.view addSubview:bannerView];
bannerView.images = (NSArray<KYBannerImageModel> *)bannerModels;

```

### 方案2
```

KYBannerCollectionView *view = [[KYBannerCollectionView alloc] initWithFrame:CGRectMake(0, 300, [UIScreen mainScreen].bounds.size.width, 200)];
[self.view addSubview:view];
view.images = (NSArray<KYBannerImageModel> *)bannerModels;

```
> 事件回调
```
///页码改变的回调
@property (nonatomic,copy)void (^indexChangedBlock)(NSInteger index,NSInteger totalPage);

///设置imageview的图片
@property (nonatomic,copy)void (^setImgBlock)(UIImageView * _Nonnull imgView,id<KYBannerImageModel> _Nonnull model);

///选中当前banner的回调
@property (nonatomic,copy)void (^selectBannerBlock)(id<KYBannerImageModel> imgModel);
```

## Author

massyxf, messy007@163.com

## License

KYBannerView is available under the MIT license. See the LICENSE file for more info.
