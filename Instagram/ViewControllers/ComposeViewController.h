//
//  ComposeViewController.h
//  Instagram
//
//  Created by Jose Castillo Guajardo on 6/27/22.
//

#import <UIKit/UIKit.h>
#import "Post.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ComposeViewControllerDelegate
- (void)didPost;
@end

@interface ComposeViewController : UIViewController
@property (weak, nonatomic) id<ComposeViewControllerDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
