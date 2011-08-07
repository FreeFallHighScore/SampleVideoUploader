//
//  SampleVideoUploaderViewController.m
//  SampleVideoUploader
//
//  Created by Juan C. Müller on 8/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SampleVideoUploaderViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>

#import "GData/GDataServiceGoogleYouTube.h"
#import "GData/GDataEntryPhotoAlbum.h"
#import "GData/GDataEntryPhoto.h"
#import "GData/GDataFeedPhoto.h"
#import "GData/GDataEntryYouTubeUpload.h"

#import "GTMOAuth2ViewControllerTouch.h"
#import "GData/GTMHTTPFetcher.h"

@implementation SampleVideoUploaderViewController

@synthesize authentication;
@synthesize textView;

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)awakeFromNib {
    // Get the saved authentication, if any, from the keychain.
    GTMOAuth2Authentication *auth;
    auth = [GTMOAuth2ViewControllerTouch authForGoogleFromKeychainForName:kKeychainItemName
                                                                 clientID:kClientID
                                                             clientSecret:kClientSecret];
    
    // Retain the authentication object, which holds the auth tokens
    //
    // We can determine later if the auth object contains an access token
    // by calling its -canAuthorize method
    [self setAuthentication:auth];
    
    NSLog(@"Can Authorize? %d", [authentication canAuthorize]);
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewController:(GTMOAuth2ViewControllerTouch *)viewController
      finishedWithAuth:(GTMOAuth2Authentication *)auth
                 error:(NSError *)error {
    if (error != nil) {
        // Authentication failed
        NSLog(@"failed, auth: %@", auth);
        NSLog(@"failed, can authenticate? %d, error: %@", [authentication canAuthorize], error);
        [textView setText:[NSString stringWithFormat:@"failed, can authenticate? %d, error: %@",
                           [authentication canAuthorize],
                           error]];
    } else {
        // Authentication succeeded
        NSLog(@"succeeded, auth: %@", auth);
        [self setAuthentication:auth];
        [textView setText:[NSString stringWithFormat:@"succeeded, auth: %@", auth]];
    }
    
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction) doSomething:(id)sender {  
    
    NSString *scope = @"https://gdata.youtube.com/feeds/"; //[GDataServiceGoogleYouTube authorizationScope];
    NSLog(@"scope: %@", scope);
    
    GTMOAuth2ViewControllerTouch *viewController;
    viewController = [[[GTMOAuth2ViewControllerTouch alloc] initWithScope:scope
                                                                 clientID:kClientID
                                                             clientSecret:kClientSecret
                                                         keychainItemName:kKeychainItemName
                                                                 delegate:self
                                                         finishedSelector:@selector(viewController:finishedWithAuth:error:)] autorelease];

    [viewController setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    [viewController setModalPresentationStyle:UIModalPresentationFormSheet];
    [self presentModalViewController:viewController animated:YES];

    // [[self navigationController] pushViewController:viewController
     //                                      animated:YES];
    
    // Snippet to access an asset with a known URL
    /*
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    
    NSURL *fileUrl = [NSURL URLWithString:@"assets-library://asset/asset.MOV?id=1000000711&ext=MOV"];
            
    [library assetForURL:fileUrl
             resultBlock:^(ALAsset *asset) {
                 NSAssert(asset != nil, @"Asset shouldn't be nil");
                 [self doSomethingElse:asset];
             }
             failureBlock:^(NSError *error) {
                NSLog(@"ERROR: %@", error);
             }];
     */
    
    // Snippet to get a list of all video assets in phone
    
    /*
     
    NSMutableArray *assets = [[NSMutableArray alloc]init];
    ALAssetsLibrary *library =[[ALAssetsLibrary alloc]init];
    NSUInteger groupTypes = ALAssetsGroupAll;
    
    void (^assetEnumerator)(ALAsset *, NSUInteger, BOOL *) = ^(ALAsset *result, NSUInteger index, BOOL *stop) {
        if(result != NULL) {
            if ([result valueForProperty:ALAssetPropertyType] == ALAssetTypeVideo)
            {
                NSLog(@"See Asset: type = %@; %@", [result valueForProperty:ALAssetPropertyType], result);
                [assets addObject:result];
            }
        }
    };
    
    void (^assetGroupEnumerator)(ALAssetsGroup *group, BOOL *stop) =  ^(ALAssetsGroup *group, BOOL *stop) {
        if(group != nil) {
            NSLog(@"dont See Asset: ");
            [group enumerateAssetsUsingBlock:assetEnumerator];
        }
    };
    
    [library enumerateGroupsWithTypes:groupTypes usingBlock:assetGroupEnumerator failureBlock:^(NSError *error) {
        NSLog(@"Failure: %@", error);
    }];
    
    */
}

- (GDataServiceGoogleYouTube *)youTubeService {
    
    static GDataServiceGoogleYouTube* service = nil;
    
    if (!service) {
        service = [[GDataServiceGoogleYouTube alloc] init];
        
        [service setShouldCacheResponseData:YES];
        [service setServiceShouldFollowNextLinks:YES];
        [service setIsServiceRetryEnabled:YES];
    }
    
    [service setYouTubeDeveloperKey:kDeveloperKey];
    
    return service;
}


- (void) doSomethingElse:(ALAsset*)asset {
    NSLog(@"From another method!: %@", asset);
}

- (void)uploadVideoFile
{
    /*    
    static GDataServiceGoogleYouTube* service = nil;
    
    if (!service) {
        service = [[GDataServiceGoogleYouTube alloc] init];
        
        [service setShouldCacheResponseData:YES];
        [service setServiceShouldFollowNextLinks:YES];
        [service setIsServiceRetryEnabled:YES];
    }
    
    [service setYouTubeDeveloperKey:kDeveloperKey];
    
    NSURL *url = [GDataServiceGoogleYouTube youTubeUploadURLForUserID:kGDataServiceDefaultUser];
        
    // load the file data
    NSString *path = [mFilePathField stringValue];
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingAtPath:path];
    NSString *filename = [path lastPathComponent];
    
    // gather all the metadata needed for the mediaGroup
    NSString *titleStr = [mTitleField stringValue];
    GDataMediaTitle *title = [GDataMediaTitle textConstructWithString:titleStr];
    
    NSString *categoryStr = [[mCategoryPopup selectedItem] representedObject];
    GDataMediaCategory *category = [GDataMediaCategory mediaCategoryWithString:categoryStr];
    [category setScheme:kGDataSchemeYouTubeCategory];
    
    NSString *descStr = [mDescriptionField stringValue];
    GDataMediaDescription *desc = [GDataMediaDescription textConstructWithString:descStr];
    
    NSString *keywordsStr = [mKeywordsField stringValue];
    GDataMediaKeywords *keywords = [GDataMediaKeywords keywordsWithString:keywordsStr];
    
    BOOL isPrivate = ([mPrivateCheckbox state] == NSOnState);
    
    GDataYouTubeMediaGroup *mediaGroup = [GDataYouTubeMediaGroup mediaGroup];
    [mediaGroup setMediaTitle:title];
    [mediaGroup setMediaDescription:desc];
    [mediaGroup addMediaCategory:category];
    [mediaGroup setMediaKeywords:keywords];
    [mediaGroup setIsPrivate:isPrivate];
    
    NSString *mimeType = [GDataUtilities MIMETypeForFileAtPath:path
                                               defaultMIMEType:@"video/mp4"];
    
    // create the upload entry with the mediaGroup and the file
    GDataEntryYouTubeUpload *entry;
    entry = [GDataEntryYouTubeUpload uploadEntryWithMediaGroup:mediaGroup
                                                    fileHandle:fileHandle
                                                      MIMEType:mimeType
                                                          slug:filename];
    
    SEL progressSel = @selector(ticket:hasDeliveredByteCount:ofTotalByteCount:);
    [service setServiceUploadProgressSelector:progressSel];
    
    // YouTube's upload URL is not yet https; we need to explicitly set the
    // authorizer to allow authorizing an http URL
    [[service authorizer] setShouldAuthorizeAllRequests:YES];
    
    GDataServiceTicket *ticket;
    ticket = [service fetchEntryByInsertingEntry:entry
                                      forFeedURL:url
                                        delegate:self
                               didFinishSelector:@selector(uploadTicket:finishedWithEntry:error:)];
    
    [self setUploadTicket:ticket];
    [self updateUI];
     */
}

@end
