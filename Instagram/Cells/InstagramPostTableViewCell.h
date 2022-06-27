//
//  InstagramPostTableViewCell.h
//  Instagram
//
//  Created by Jose Castillo Guajardo on 6/27/22.
//

#import <UIKit/UIKit.h>
#import "Post.h"
@import Parse;

NS_ASSUME_NONNULL_BEGIN

@interface InstagramPostTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *captionLabel;
@property (strong, nonatomic) IBOutlet PFImageView *photoImageView;
@property (strong, nonatomic) Post *post;
@end

NS_ASSUME_NONNULL_END
