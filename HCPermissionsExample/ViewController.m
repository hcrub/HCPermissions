//
//  ViewController.m
//  HCPermissions
//
//  Created by Neil Burchfield on 10/15/16.
//  Copyright © 2016 Neil Burchfield. All rights reserved.
//

#import "ViewController.h"

// Reactive
#import <ReactiveCocoa.h>

// Permissions
#import "HCPermissions.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *camera;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    @weakify(self)
    
    [[[RACObserve([HCPermissions sharedPermissions], hasCameraAccess)
      deliverOnMainThread]
     logAll]
     subscribeNext:^(NSNumber *hasCameraAccess) {
         @strongify(self)
         [self.camera setTitleColor:hasCameraAccess.boolValue ? [UIColor greenColor] : [UIColor redColor] forState:UIControlStateNormal];
     }];
    
    self.camera.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [[HCPermissions sharedPermissions] requestCameraAccess];
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
