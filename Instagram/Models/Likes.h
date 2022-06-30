//
//  Likes.h
//  Instagram
//
//  Created by Jose Castillo Guajardo on 6/29/22.
//

#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface Likes : PFObject<PFSubclassing>
@property (nonatomic, strong) NSString *postID;
@property (nonatomic, strong) PFUser *userThatLiked;
@end

NS_ASSUME_NONNULL_END
