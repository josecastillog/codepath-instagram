//
//  ProfileViewController.m
//  Instagram
//
//  Created by Jose Castillo Guajardo on 6/28/22.
//

#import "ProfileViewController.h"
#import <Parse/Parse.h>
@import Parse;

@interface ProfileViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate>
@property (strong, nonatomic) IBOutlet PFImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *userLabel;
@property (strong, nonatomic) PFUser *user;
@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.imgView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(tapGesture:)];
    tapGesture1.numberOfTapsRequired = 1;
    tapGesture1.delegate = self;
    [self.imgView addGestureRecognizer:tapGesture1];
    self.imgView.layer.backgroundColor=[[UIColor clearColor] CGColor];
    self.imgView.layer.cornerRadius = self.imgView.frame.size.height/2;
    self.imgView.layer.borderWidth = 0;
    self.imgView.clipsToBounds = YES;
    self.userLabel.text = PFUser.currentUser.username;
    [self profileImageQuery];
}

- (void)setProfileImage {
    if (self.user[@"profileImage"]) {
        self.imgView.file = self.user[@"profileImage"];
        [self.imgView loadInBackground];
    }
}

- (void)profileImageQuery {
    PFQuery *userQuery = [PFUser query];
    [userQuery getObjectWithId:PFUser.currentUser.objectId];
    [userQuery includeKey:@"username"];
    [userQuery includeKey:@"profileImage"];
    
    [userQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error getting user: %@", error.localizedDescription);
        } else {
            NSLog(@"Succesfully retrieved user");
            self.user = objects[0];
            [self setProfileImage];
        }
    }];
}

- (PFFileObject *)getPFFileFromImage: (UIImage * _Nullable)image {
 
    // check if image is not nil
    if (!image) {
        return nil;
    }
    
    NSData *imageData = UIImagePNGRepresentation(image);
    // get image data and check if that is not nil
    if (!imageData) {
        return nil;
    }
    
    return [PFFileObject fileObjectWithName:@"image.png" data:imageData];
}

-(void)tapGesture: (id)sender {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;

    // The Xcode simulator does not support taking pictures, so let's first check that the camera is indeed supported on the device before trying to present it.
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else {
        NSLog(@"Camera unavailable so we will use photo library instead");
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }

    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    // Get the image captured by the UIImagePickerController
    // UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];

    // Do something with the images (based on your use case)
    [self.imgView setImage:editedImage];
    [self.user setObject:[self getPFFileFromImage:editedImage] forKey:@"profileImage"];
    [self.user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error uploading image: %@", error.localizedDescription);
        }
    }];
    
    // Dismiss UIImagePickerController to go back to your original view controller
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end