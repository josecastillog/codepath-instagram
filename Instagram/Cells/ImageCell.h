//
//  ImageCell.h
//  Instagram
//
//  Created by Jose Castillo Guajardo on 6/28/22.
//

#import <UIKit/UIKit.h>
#import "Post.h"
@import Parse;

NS_ASSUME_NONNULL_BEGIN

@interface ImageCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet PFImageView *imgView;
@property (strong, nonatomic) Post *post;
@end

NS_ASSUME_NONNULL_END
