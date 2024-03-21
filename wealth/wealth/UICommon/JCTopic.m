//
//  JCTopic.m
//  PSCollectionViewDemo
//
//  Created by jc on 14-1-7.
//
//

#import "JCTopic.h"
//#import "DemandPageControl.h"

@interface JCTopic ()
{
    bool flag;
    NSTimer * scrollTimer;
    CGSize imageSize;
    UIImage *image;
}
@end

@implementation JCTopic

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        self.isRefresh = YES;
        self.advertisementImgArray = [[NSMutableArray alloc]init];
        [self setSelf];
    }
    return self;
}

-(void)setSelf{
    self.pagingEnabled = YES;
    self.scrollEnabled = YES;
    self.delegate = self;
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    self.backgroundColor = [UIColor whiteColor];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    [self setSelf];
    
    // Drawing code
}
- (void)upDate {
    
    for (UIView * view in self.subviews) {
        if ([view isKindOfClass:[UIButton class]] || [view isKindOfClass:[UIImageView class]]) {
            [view removeFromSuperview];
        }
    }
    if (self.advertisementImgArray.count == 0) {
        /**< 数据没有请求成功，或者没有数据时候 展示一个默认的image*/
        [self setContentSize:CGSizeMake(ScreenWidth, self.height)];
        UIImageView *placeholderImage = [[UIImageView alloc]initWithFrame:CGRectMake(self.contentOffset.x,0, self.width, self.height)];
        placeholderImage.image = [UIImage imageNamed:@"banner_default"];
        placeholderImage.backgroundColor = [UIColor clearColor];
        [self addSubview:placeholderImage];
    } else {
        
        
        if (self.isRefresh) {
            id lastObj = self.advertisementImgArray.lastObject;
            id firstObj = self.advertisementImgArray.firstObject;
            [self.advertisementImgArray insertObject:lastObj atIndex:0];
            [self.advertisementImgArray addObject:firstObj];
        }
            int i = 0;
            for (id obj in self.advertisementImgArray) {
                UIImageView * tempImage = [[UIImageView alloc]initWithFrame:CGRectMake(i*self.width, 0, self.width, self.height)];
                tempImage.tag = i;
                tempImage.userInteractionEnabled = YES;
                tempImage.contentMode = UIViewContentModeScaleAspectFit;
                [tempImage setClipsToBounds:YES];
                if ([[obj objectForKey:@"isLoc"]boolValue]) {
                    [tempImage setImage:[obj objectForKey:@"pic"]];
                }else{
    //                [tempImage setImage:[UIImage imageNamed:@"banner_default"]];
                    [tempImage sd_setImageWithURL:[NSURL URLWithString:[obj objectForKey:@"pic"]]
                                 placeholderImage:[UIImage imageNamed:@"banner_default"]
                                          options:GET_SDWEBIMAGE_OPTIONS];
                }
                [self addSubview:tempImage];
                
                UITapGestureRecognizer * imgTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImageViewClick:)];
                
                [tempImage addGestureRecognizer:imgTap];
            
            //        DemandPageControl *pageControl = [[DemandPageControl alloc]initWithFrame:CGRectMake(i*self.frame.size.width, self.frame.size.height-30, self.frame.size.width,30)];
            ////        pageControl.numberOfPages = [self.pics count]-2;
            //        pageControl.currentPage = (i== 0)?([self.pics count]- 3):((i == (self.pics.count - 1))? 0:(i-1));
            //        pageControl.tag = i + 10000;
            //        @weakify(self);
            //        pageControl.buttonClickBlock = ^(NSInteger selectedPage){
            //            @strongify(self);
            //            [self releaseTimer];
            //            [self scrollRectToVisible:CGRectMake(self.frame.size.width*(selectedPage+1), 0, self.frame.size.width, 200) animated:NO];
            //            [self performSelector:@selector(buttondidClick) withObject:self afterDelay:3.0];
            //        };
            //        [self addSubview:pageControl];
                
                i ++;
            }
            [self setContentSize:CGSizeMake(self.width*(self.advertisementImgArray.count>3?[self.advertisementImgArray count]:1), self.height)];
            [self setContentOffset:CGPointMake(self.width*((self.advertisementImgArray.count>3)?1:0) , 0) animated:NO];

            if (scrollTimer) {
                [scrollTimer invalidate];
                scrollTimer = nil;
                
            }
            if ([self.advertisementImgArray count]>3) {
                scrollTimer = [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(scrollTopic) userInfo:nil repeats:YES];
            }
        }
    
}

- (void)buttondidClick {
    [self releaseTimer];
    scrollTimer = [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(scrollTopic) userInfo:nil repeats:YES];
}


- (void)tapImageViewClick:(UITapGestureRecognizer *)tapImg {
    if (self.didClickBlock) {
        self.didClickBlock([self.advertisementImgArray objectAtIndex:[tapImg.view tag]],[tapImg.view tag]);
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat Width=self.frame.size.width;
    if (scrollView.contentOffset.x == self.frame.size.width) {
        flag = YES;
    }
    if (flag) {
        if (scrollView.contentOffset.x <= 0) {
            [self setContentOffset:CGPointMake(Width*([self.advertisementImgArray count]-2), 0) animated:NO];
        }else if (scrollView.contentOffset.x >= Width*([self.advertisementImgArray count]-1)) {
            [self setContentOffset:CGPointMake(self.width, 0) animated:NO];
        }
    }
    _currentPage = scrollView.contentOffset.x/self.width - 1;
    if (self.currentPageBlock) {
        self.currentPageBlock(_currentPage,[self.advertisementImgArray count]-2);
    }
    _scrollTopicFlag = _currentPage+2==2?2:_currentPage+2;
}
- (void)setScrollTopicFlag:(NSInteger)scrollTopicFlag {
    _scrollTopicFlag = scrollTopicFlag;
    [self releaseTimer];
    scrollTimer = [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(scrollTopic) userInfo:nil repeats:YES];
}

- (void)scrollTopic {
    [self setContentOffset:CGPointMake(self.width*_scrollTopicFlag, 0) animated:YES];
    if (_scrollTopicFlag > [self.advertisementImgArray count]) {
        _scrollTopicFlag = 1;
    }else {
        _scrollTopicFlag++;
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self releaseTimer];
    scrollTimer = [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(scrollTopic) userInfo:nil repeats:YES];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (scrollTimer) {
        [scrollTimer invalidate];
        scrollTimer = nil;
    }
}

- (void)releaseTimer{
    if (scrollTimer) {
        [scrollTimer invalidate];
        scrollTimer = nil;
    }
}

- (void)returnDidClickBlock:(JCTopicDidClickBlock)didClickBlock currentPageBlock:(JCTopicCurrentPageBlock)currentPageBlock {
    self.didClickBlock = didClickBlock;
    self.currentPageBlock = currentPageBlock;
}

@end
