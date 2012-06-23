//
// Copyright 2011-2012 Jeff Verkoeyen
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#import "ModelLauncherViewController.h"

@interface ModelLauncherViewController () <NILauncherViewModelDelegate>
@property (nonatomic, readwrite, retain) NILauncherViewModel* model;
@end

@implementation ModelLauncherViewController

@synthesize model = _model;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
    self.title = @"Model";

    // Load the Nimbus app icon.
    NSString* imagePath = NIPathForBundleResource(nil, @"Icon.png");
    UIImage* image = [[Nimbus imageMemoryCache] objectWithName:imagePath];
    if (nil == image) {
      image = [UIImage imageWithContentsOfFile:imagePath];
      [[Nimbus imageMemoryCache] storeObject:image withName:imagePath];
    }

    // We populate the launcher model with an array of arrays of NILauncherViewObject objects.
    // Each sub array is a single page of the launcher view. The default NILauncherViewObject object
    // allows you to provide a title and image.
    NSArray* contents =
    [NSArray arrayWithObjects:
     [NSArray arrayWithObjects:
      [NILauncherViewObject objectWithTitle:@"Nimbus" image:image],
      [NILauncherViewObject objectWithTitle:@"Nimbus 2" image:image],
      [NILauncherViewObject objectWithTitle:@"Nimbus 3" image:image],
      [NILauncherViewObject objectWithTitle:@"Nimbus 5" image:image],
      [NILauncherViewObject objectWithTitle:@"Nimbus 6" image:image],
      nil],
     [NSArray arrayWithObjects:
      [NILauncherViewObject objectWithTitle:@"Page 2" image:image],
      nil],
     [NSArray arrayWithObjects:
      [NILauncherViewObject objectWithTitle:@"Page 3" image:image],
      nil],
     nil];

    _model = [[NILauncherViewModel alloc] initWithArrayOfPages:contents delegate:self];
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.view.backgroundColor = [UIColor underPageBackgroundColor];

  self.launcherView.dataSource = self.model;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  return NIIsSupportedOrientation(interfaceOrientation);
}

#pragma mark - NILauncherViewModelDelegate

- (void)launcherViewModel:(NILauncherViewModel *)launcherViewModel
      configureButtonView:(UIView<NILauncherButtonView> *)buttonView
          forLauncherView:(NILauncherView *)launcherView
                pageIndex:(NSInteger)pageIndex
              buttonIndex:(NSInteger)buttonIndex
                   object:(id<NILauncherViewObject>)object {
  NILauncherButtonView* launcherButtonView = (NILauncherButtonView *)buttonView;

  launcherButtonView.label.layer.shadowColor = [UIColor blackColor].CGColor;
  launcherButtonView.label.layer.shadowOffset = CGSizeMake(0, 1);
  launcherButtonView.label.layer.shadowOpacity = 1;
  launcherButtonView.label.layer.shadowRadius = 1;
}

#pragma mark - NILauncherDelegate

- (void)launcherView:(NILauncherView *)launcher didSelectItemOnPage:(NSInteger)page atIndex:(NSInteger)index {
  NILauncherViewObject* object = [self.model objectAtIndex:index pageIndex:page];
  UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Notice"
                                                  message:[@"Did tap button with title: " stringByAppendingString:object.title]
                                                 delegate:nil
                                        cancelButtonTitle:@"OK"
                                        otherButtonTitles:nil];
  [alert show];
}

@end
