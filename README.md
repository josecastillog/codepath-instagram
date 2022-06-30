# Project 3 - *Instagram*

**Instagram** is a photo sharing app using Parse as its backend.

Time spent: **18** hours spent in total

## User Stories

The following **required** functionality is completed:

- [X] User can sign up to create a new account using Parse authentication
- [X] User can log in and log out of his or her account
- [X] The current signed in user is persisted across app restarts
- [X] User can take a photo, add a caption, and post it to "Instagram"
- [X] User can view the last 20 posts submitted to "Instagram"
- [X] User can pull to refresh the last 20 posts submitted to "Instagram"
- [X] User can tap a post to view post details, including timestamp and caption

The following **optional** features are implemented:

- [X] Run your app on your phone and use the camera to take the photo
- [X] User can load more posts once he or she reaches the bottom of the feed using infinite scrolling
- [X] Show the username and creation time for each post
- [X] User can use a Tab Bar to switch between a Home Feed tab (all posts) and a Profile tab (only posts published by the current user)
- User Profiles:
  - [X] Allow the logged in user to add a profile photo
  - [X] Display the profile photo with each post
  - [X] Tapping on a post's username or profile photo goes to that user's profile page
- [X] After the user submits a new post, show a progress HUD while the post is being uploaded to Parse
- [ ] User can comment on a post and see all comments for each post in the post details screen
- [X] User can like a post and see number of likes for each post in the post details screen
- [X] Style the login page to look like the real Instagram login page
- [X] Style the feed to look like the real Instagram feed
- [ ] Implement a custom camera view

Please list two areas of the assignment you'd like to **discuss further with your peers** during the next class (examples include better ways to implement something, how to extend your app in certain ways, etc):

1. Discuss if likes development approach is the best or could it improve.

## Video Walkthrough

Here's a walkthrough of implemented user stories:

![](https://media.giphy.com/media/JjAuMlM4JAAIbAwixV/giphy.gif)

## Credits

List an 3rd party libraries, icons, graphics, or other assets you used in your app.

- [AFNetworking](https://github.com/AFNetworking/AFNetworking) - networking task library
- [Parse](https://github.com/parse-community/Parse-SDK-iOS-OSX) - parse library
- [Parse/UI](https://github.com/parse-community/ParseUI-iOS) - parse UI library
- [DateTools](https://github.com/MatthewYork/DateTools) - date formatting library
- [MBProgressHUD](https://github.com/matej/MBProgressHUD) - progress hud library

## Notes

Describe any challenges encountered while building the app.

- Most challenging part was keeping track of which users liked which posts. This was done by adding a new class to the database and storing the postID with a userID. 
