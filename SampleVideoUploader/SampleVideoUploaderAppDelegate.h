//
//  SampleVideoUploaderAppDelegate.h
//  SampleVideoUploader
//
//  Created by Juan C. Müller on 8/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SampleVideoUploaderViewController;

@interface SampleVideoUploaderAppDelegate : NSObject <UIApplicationDelegate>

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet SampleVideoUploaderViewController *viewController;

@end
