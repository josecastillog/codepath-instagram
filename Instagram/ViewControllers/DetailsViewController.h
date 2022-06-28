//
//  DetailsViewController.h
//  Instagram
//
//  Created by Jose Castillo Guajardo on 6/28/22.
//

#import <UIKit/UIKit.h>
#import "Post.h"
@import Parse;

NS_ASSUME_NONNULL_BEGIN

@interface DetailsViewController : UIViewController
@property (strong, nonatomic) Post *post;
@property (strong, nonatomic) IBOutlet PFImageView *photoImageView;
@end

NS_ASSUME_NONNULL_END
