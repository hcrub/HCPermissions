//
//  HCPermissions.m
//  HCPermissions
//
//  Created by Neil Burchfield on 10/15/16.
//  Copyright © 2016 Neil Burchfield. All rights reserved.
//

#import "HCPermissions.h"

// Reactive
#import <ReactiveCocoa.h>

// Core
@import AVFoundation;

#pragma mark -
#pragma mark - NSError+HCPermissions -

@interface NSError (HCPermissions)

/**
 @return Generic Denied Permission Error.
 */
+ (NSError *)hc_permissionDeniedError;

/**
 Generic Restricted Permission Error.
 */
+ (NSError *)hc_permissionRestrictedError;

@end

#pragma mark -
#pragma mark - HCPermissions -

NSInteger const kHCPermissionDeniedErrorCode = 4412;
NSString *const kHCPermissionDeniedErrorDomain = @"com.HCPermissions.denied";
NSString *const kHCPermissionDeniedErrorDescription = @"User has denied permissions";

NSInteger const kHCPermissionRestrictedErrorCode = 4413;
NSString *const kHCPermissionRestrictedErrorDomain = @"com.HCPermissions.restricted";
NSString *const kHCPermissionRestrictedErrorDescription = @"Permissions unavailable for device";

@implementation HCPermissions

#pragma mark -
#pragma mark - Shared -

+ (instancetype)sharedPermissions {
    static HCPermissions *_shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shared = [[[self class] alloc] init];
    });
    return _shared;
}

#pragma mark -
#pragma mark - Camera -

#pragma mark - Microphone

- (BOOL)hasMicrophoneAccess {
    return [self hasMediaAccess:HCMediaTypeMicrophone];
}

- (RACSignal *)requestMicrophoneAccess {
    return [self requestMediaAccess:HCMediaTypeMicrophone];
}

#pragma mark - Camera

- (BOOL)hasCameraAccess {
    return [self hasMediaAccess:HCMediaTypeCamera];
}

- (RACSignal *)requestCameraAccess {
    return [self requestMediaAccess:HCMediaTypeCamera];
}

#pragma mark - Media

- (BOOL)hasMediaAccess:(HCMediaType)mediaType {
    NSString *const avMediaType = [self _mediaTypeForLocalType:mediaType];
    NSParameterAssert(avMediaType);
    
    AVAuthorizationStatus const status = [AVCaptureDevice authorizationStatusForMediaType:avMediaType];
    return status == AVAuthorizationStatusAuthorized;
}

- (RACSignal *)requestMediaAccess:(HCMediaType)mediaType {
    NSString *const avMediaType = [self _mediaTypeForLocalType:mediaType];
    NSParameterAssert(avMediaType);
    
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        AVAuthorizationStatus const status = [AVCaptureDevice authorizationStatusForMediaType:avMediaType];
        
        // Unknown, request permission.
        if (status == AVAuthorizationStatusNotDetermined) {
            [AVCaptureDevice requestAccessForMediaType:avMediaType completionHandler:^(BOOL granted) {
                [self _willChangeMedia:mediaType];
                
                if (granted) {
                    [subscriber sendCompleted];
                } else {
                    [subscriber sendError:[NSError hc_permissionDeniedError]];
                }
                
                [self _didChangeMedia:mediaType];
            }];
        } else {
            [self _willChangeMedia:mediaType];

            // Authorized
            if (status == AVAuthorizationStatusAuthorized) {
                [subscriber sendCompleted];
            }
            // Denied
            else if (status == AVAuthorizationStatusDenied) {
                [subscriber sendError:[NSError hc_permissionDeniedError]];
            }
            // Restricted
            else if (status == AVAuthorizationStatusRestricted) {
                [self _willChangeMedia:mediaType];
                [subscriber sendError:[NSError hc_permissionRestrictedError]];
            }
            
            [self _didChangeMedia:mediaType];
        }
        
        return nil;
    }];
}

#pragma mark - Private

- (NSString *)_mediaTypeForLocalType:(HCMediaType)type {
    switch (type) {
        case HCMediaTypeCamera: return AVMediaTypeVideo; break;
        case HCMediaTypeMicrophone: return AVMediaTypeAudio; break;
        default: return nil; break;
    }
}

- (void)_willChangeMedia:(HCMediaType)type {
    switch (type) {
        case HCMediaTypeCamera: {
            [self willChangeValueForKey:@keypath(self, hasCameraAccess)];
        } break;
        case HCMediaTypeMicrophone: {
            [self willChangeValueForKey:@keypath(self, hasMicrophoneAccess)];
        } break;
        default: break;
    }
}

- (void)_didChangeMedia:(HCMediaType)type {
    switch (type) {
        case HCMediaTypeCamera: {
            [self didChangeValueForKey:@keypath(self, hasCameraAccess)];
        } break;
        case HCMediaTypeMicrophone: {
            [self didChangeValueForKey:@keypath(self, hasMicrophoneAccess)];
        } break;
        default: break;
    }
}

@end

#pragma mark -
#pragma mark - NSError+HCPermissions -

@implementation NSError (HCPermissions)

#pragma mark -
#pragma mark - Methods

+ (NSError *)hc_permissionDeniedError {
    return [[self class] errorWithDomain:kHCPermissionDeniedErrorDomain code:kHCPermissionDeniedErrorCode userInfo:@{NSLocalizedDescriptionKey:kHCPermissionDeniedErrorDescription}];
}

+ (NSError *)hc_permissionRestrictedError {
    return [[self class] errorWithDomain:kHCPermissionDeniedErrorDomain code:kHCPermissionDeniedErrorCode userInfo:@{NSLocalizedDescriptionKey:kHCPermissionDeniedErrorDescription}];
}

@end
