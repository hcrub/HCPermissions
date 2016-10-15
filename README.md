# HCPermissions
Functional permissions access management. Simple, stateless, reactive framework for gracefully handling permissions in your application flow. 

### Example

```objc

// Bind your properties to the access state.
@weakify(self)
[[RACObserve([HCPermissions sharedPermissions], hasCameraAccess)
      deliverOnMainThread]
 subscribeNext:^(NSNumber *hasCameraAccess) {
     @strongify(self)
     [self.button setTitleColor:hasCameraAccess.boolValue ? [UIColor greenColor] : [UIColor redColor] forState:UIControlStateNormal];
 }];

// Simply chain the permission to an action.
self.button.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
    return [[[HCPermissions sharedPermissions] requestCameraAccess] catch:^(NSError *error) {
        // Handle error. Show prompt, direct them to settings.
        return [RACSignal empty];
    }];
}];

```
