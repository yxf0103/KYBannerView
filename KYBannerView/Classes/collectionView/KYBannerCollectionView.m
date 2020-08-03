//
//  NDBannerView.m
//  NDTruck
//
//  Created by yxf on 2019/11/21.
//  Copyright © 2019 k_yan. All rights reserved.
//

#import "KYBannerCollectionView.h"
#import "KYBannerCollectionCell.h"

@interface KYBannerCollectionView ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>

@property (nonatomic,weak)UICollectionView *imgCollectionView;
@property (nonatomic,strong)dispatch_source_t timer;

@end
static int const banner_count = 1000;
@implementation KYBannerCollectionView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.bounds
                                                              collectionViewLayout:layout];
        [self addSubview:collectionView];
        _imgCollectionView = collectionView;
        collectionView.delegate = self;
        collectionView.dataSource = self;
        collectionView.pagingEnabled = YES;
        collectionView.showsVerticalScrollIndicator = NO;
        collectionView.showsHorizontalScrollIndicator = NO;
        [collectionView registerClass:[KYBannerCollectionCell class] forCellWithReuseIdentifier:ky_banner_collection_cell];
    }
    return self;
}

-(void)dealloc{
    if (_timer) {
        dispatch_cancel(_timer);
        _timer = nil;
    }
}

#pragma mark - setter
-(void)setBackgroundColor:(UIColor *)backgroundColor{
    [super setBackgroundColor:backgroundColor];
    _imgCollectionView.backgroundColor = backgroundColor;
}

-(void)setImages:(NSArray<KYBannerImageModel> *)images{
    BOOL isOldAni = self.images.count > 1 ;
    BOOL isCurrentAni = images.count > 1;
    [super setImages:images];
    [_imgCollectionView reloadData];
    _imgCollectionView.scrollEnabled = isCurrentAni;
    
    if (![self autoScroll]) { return; }
    if ((isOldAni && isCurrentAni) || (!isOldAni && !isCurrentAni)) {
        return;
    }
    if (isOldAni && !isCurrentAni) {
        [self endAnimation];
        return;
    }
    [self startAnimaiton];
}

#pragma mark - UICollectionViewDelegateFlowLayout,UICollectionViewDataSource
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    KYBannerCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ky_banner_collection_cell forIndexPath:indexPath];
    NSInteger index = indexPath.item % self.images.count;
    !self.setImgBlock ? : self.setImgBlock(cell.imgView,self.images[index]);
    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.images.count * banner_count;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger index = indexPath.item % self.images.count;
    !self.selectBannerBlock ? : self.selectBannerBlock(self.images[index]);
}

#pragma mark - scrollview delegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    int index = (scrollView.contentOffset.x + 10) / CGRectGetWidth(scrollView.bounds);
    [self currentPageChangedWithIndex:index];
    if (!self.autoScroll) {  return; }
    dispatch_source_set_timer(_timer,
                              dispatch_time(DISPATCH_TIME_NOW, self.autoScrollInterval * NSEC_PER_SEC),
                              self.autoScrollInterval * NSEC_PER_SEC,
                              0.05 * NSEC_PER_SEC);
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (!self.autoScroll) {  return; }
    dispatch_source_set_timer(_timer,
                              DISPATCH_TIME_FOREVER,
                              self.autoScrollInterval * NSEC_PER_SEC,
                              0.05 * NSEC_PER_SEC);
}

#pragma mark - custom func
-(void)currentPageChangedWithIndex:(int)index{
    index = index % self.images.count;
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index + self.images.count * banner_count / 2 inSection:0];
    [_imgCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    !self.indexChangedBlock ? : self.indexChangedBlock(index,(int)self.images.count);
    self.pageControl.currentPage = index;
}

#pragma mark - time animation
-(void)startAnimaiton{
    if (_timer) {
        dispatch_resume(_timer);
        return;
    }
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    dispatch_source_set_timer(timer,
                              dispatch_time(DISPATCH_TIME_NOW, self.autoScrollInterval * NSEC_PER_SEC),
                              self.autoScrollInterval * NSEC_PER_SEC,
                              0.05 * NSEC_PER_SEC);
    __weak typeof(self) ws = self;
    dispatch_source_set_event_handler(timer, ^{
        if (!ws) { return; }
        [ws timerAction];
    });
    dispatch_resume(timer);
    _timer = timer;
}

-(void)endAnimation{
    if (_timer) {
        dispatch_suspend(_timer);
    }
}

-(void)timerAction{
    if (self.images.count <= 1) { return; }
    self.imgCollectionView.scrollEnabled = NO;
    dispatch_suspend(self.timer);
    CGFloat width = CGRectGetWidth(self.bounds);
    int index = (self.imgCollectionView.contentOffset.x + 5) / width + 1;
    [self.imgCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]
                                   atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self currentPageChangedWithIndex:index];
        dispatch_resume(self.timer);
        self.imgCollectionView.scrollEnabled = YES;
        if (self.self.images.count <= 1) {
            self.imgCollectionView.scrollEnabled = NO;
        }
    });
}

@end
