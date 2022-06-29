//
//  ProfileViewController.h
//  Instagram
//
//  Created by Jose Castillo Guajardo on 6/28/22.
//

#import <UIKit/UIKit.h>
#import "Parse/Parse.h"

NS_ASSUME_NONNULL_BEGIN

@interface ProfileViewController : UIViewController
@property PFUser *user;
@end

NS_ASSUME_NONNULL_END
