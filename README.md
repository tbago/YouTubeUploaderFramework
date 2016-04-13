# YouTubeUploader
Based on [yt-direct-lite-ios](https://github.com/youtube/yt-direct-lite-iOS).
The sample code is hard to use.So I create union framework to support update video to youtube.
The framework also contain process block, so you can get update precent value.

## API Call
```objective-c
///< check authorized
    if (![self.youtubeUploader isAuthorized]) {
        UIViewController *authViewController = [self.youtubeUploader createAuthViewController];
        [self.navigationController pushViewController:authViewController animated:YES];
    }
    
///< update video
    ///< FixMe(tbago) before use the project
    ///< drag the video to the project or select video from camera
    NSString *videoFilePath = [[NSBundle mainBundle] pathForResource:@"FCA"
                                                              ofType:@"mp4"];   //Get the Video from Bundle
    NSURL *videoFileURL = [NSURL fileURLWithPath:videoFilePath];    //Convert the NSString To NSURL
    NSData *fileData = [NSData dataWithContentsOfURL:videoFileURL];
    [self.youtubeUploader uploadYoutubeVideo:fileData
                                       title:@"Test video"
                                 description:@"A video for youtube test"
                                     process:^(float percent) {
                                         NSLog(@"upload percent:%f", percent);
                                     }
                                    complate:^(BOOL success, NSString *message) {
                                        if (success) {
                                            NSLog(@"upload success:%@", message);
                                        }
                                        else {
                                            NSLog(@"%@", message);
                                        }
                                    }];
```
## How to use
Because the Google API contain oauth xib file. So I create the bundle target(GTMOAuth2View).Before you compile the demo project.You need drag the GTMOAuth2View.bundle to the project directory.
