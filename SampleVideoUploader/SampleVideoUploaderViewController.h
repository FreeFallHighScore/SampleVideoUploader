//
//  SampleVideoUploaderViewController.h
//  SampleVideoUploader
//
//  Created by Juan C. Müller on 8/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

#import "GTMOAuth2ViewControllerTouch.h"
#import "GData/GDataServiceGoogleYouTube.h"

#define kKeychainItemName @"OAuth: YouTube FreeFallHighScore"
#define kClientID         @"1045440843497.apps.googleusercontent.com"
#define kClientSecret     @"Nz6Ytrwzqr5tnD_E8-QzJ4Sh"
#define kDeveloperKey     @"AI39si7H3MXz-tQpyTjyqa5BnHlNVqVWB9YAubils0HqAbETSafztzK1-_nGM5pg5Lv9xcATljHho5VCEP40lnm-kjWRvVNxZQ"

@interface SampleVideoUploaderViewController : UIViewController {
}

@property(retain, nonatomic) GTMOAuth2Authentication* authentication;

- (IBAction) doSomething:(id)sender;
- (void) doSomethingElse:(ALAsset *)asset;
- (void)uploadVideoFile;
- (void)viewController:(GTMOAuth2ViewControllerTouch *)viewController
      finishedWithAuth:(GTMOAuth2Authentication *)auth
                 error:(NSError *)error;
- (GDataServiceGoogleYouTube *)youTubeService;

@end

