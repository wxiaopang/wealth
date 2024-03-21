//
//  JCTopic.h
//  PSCollectionViewDemo
//
//  Created by jc on 14-1-7.
//
//

#import <UIKit/UIKit.h>

typedef void(^JCTopicDidClickBlock) (id data , NSInteger tag);
typedef void(^JCTopicCurrentPageBlock) (NSInteger page, NSInteger total);

@interface JCTopic : UIScrollView<UIScrollViewDelegate>
@property (nonatomic, strong) NSMutableArray * advertisementImgArray;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) NSInteger scrollTopicFlag;
@property (nonatomic, assign) BOOL isRefresh;
@property (nonatomic, copy) JCTopicDidClickBlock didClickBlock;
@property (nonatomic, copy) JCTopicCurrentPageBlock currentPageBlock;

-(void)releaseTimer;
-(void)upDate;
-(void)returnDidClickBlock:(JCTopicDidClickBlock)didClickBlock currentPageBlock:(JCTopicCurrentPageBlock)currentPageBlock;
@end
