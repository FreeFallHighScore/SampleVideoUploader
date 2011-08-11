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


@interface SampleVideoUploaderViewController : UIViewController {
}

@property(retain, nonatomic) GTMOAuth2Authentication* authentication;
@property(retain, nonatomic) IBOutlet UITextView* textView;

- (IBAction) doSomething:(id)sender;
- (void) doSomethingElse:(ALAsset *)asset;
- (void)uploadVideoFile;
- (void)viewController:(GTMOAuth2ViewControllerTouch *)viewController
      finishedWithAuth:(GTMOAuth2Authentication *)auth
                 error:(NSError *)error;
- (GDataServiceGoogleYouTube *)youTubeService;

@end

