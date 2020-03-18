#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "AppAuth 2.h"
#import "AppAuth 4.h"
#import "AppAuthCore 2.h"
#import "AppAuthCore 4.h"
#import "AppAuthCore.h"
#import "OIDAuthorizationRequest 2.h"
#import "OIDAuthorizationRequest.h"
#import "OIDAuthorizationResponse 2.h"
#import "OIDAuthorizationResponse 4.h"
#import "OIDAuthorizationResponse.h"
#import "OIDAuthorizationService 2.h"
#import "OIDAuthorizationService.h"
#import "OIDAuthState 2.h"
#import "OIDAuthState.h"
#import "OIDAuthStateChangeDelegate 2.h"
#import "OIDAuthStateChangeDelegate 4.h"
#import "OIDAuthStateChangeDelegate.h"
#import "OIDAuthStateErrorDelegate 2.h"
#import "OIDAuthStateErrorDelegate 4.h"
#import "OIDAuthStateErrorDelegate.h"
#import "OIDClientMetadataParameters 2.h"
#import "OIDClientMetadataParameters 4.h"
#import "OIDClientMetadataParameters.h"
#import "OIDDefines 2.h"
#import "OIDDefines 4.h"
#import "OIDDefines.h"
#import "OIDEndSessionRequest 2.h"
#import "OIDEndSessionRequest 4.h"
#import "OIDEndSessionRequest.h"
#import "OIDEndSessionResponse 2.h"
#import "OIDEndSessionResponse 4.h"
#import "OIDEndSessionResponse.h"
#import "OIDError 2.h"
#import "OIDError.h"
#import "OIDErrorUtilities 2.h"
#import "OIDErrorUtilities 4.h"
#import "OIDErrorUtilities.h"
#import "OIDExternalUserAgent 2.h"
#import "OIDExternalUserAgent 4.h"
#import "OIDExternalUserAgent.h"
#import "OIDExternalUserAgentRequest 2.h"
#import "OIDExternalUserAgentRequest 4.h"
#import "OIDExternalUserAgentRequest.h"
#import "OIDExternalUserAgentSession 3.h"
#import "OIDExternalUserAgentSession 4.h"
#import "OIDExternalUserAgentSession.h"
#import "OIDFieldMapping 2.h"
#import "OIDFieldMapping 4.h"
#import "OIDFieldMapping.h"
#import "OIDGrantTypes 2.h"
#import "OIDGrantTypes 4.h"
#import "OIDGrantTypes.h"
#import "OIDIDToken 2.h"
#import "OIDIDToken 4.h"
#import "OIDIDToken.h"
#import "OIDRegistrationRequest 2.h"
#import "OIDRegistrationRequest.h"
#import "OIDRegistrationResponse 2.h"
#import "OIDRegistrationResponse 4.h"
#import "OIDRegistrationResponse.h"
#import "OIDResponseTypes 2.h"
#import "OIDResponseTypes 4.h"
#import "OIDResponseTypes.h"
#import "OIDScopes 2.h"
#import "OIDScopes 4.h"
#import "OIDScopes.h"
#import "OIDScopeUtilities 2.h"
#import "OIDScopeUtilities 4.h"
#import "OIDScopeUtilities.h"
#import "OIDServiceConfiguration 2.h"
#import "OIDServiceConfiguration 4.h"
#import "OIDServiceConfiguration.h"
#import "OIDServiceDiscovery 2.h"
#import "OIDServiceDiscovery.h"
#import "OIDTokenRequest 2.h"
#import "OIDTokenRequest.h"
#import "OIDTokenResponse 2.h"
#import "OIDTokenResponse 4.h"
#import "OIDTokenResponse.h"
#import "OIDTokenUtilities 2.h"
#import "OIDTokenUtilities 4.h"
#import "OIDTokenUtilities.h"
#import "OIDURLQueryComponent 2.h"
#import "OIDURLQueryComponent 4.h"
#import "OIDURLQueryComponent.h"
#import "OIDURLSessionProvider 2.h"
#import "OIDURLSessionProvider 4.h"
#import "OIDURLSessionProvider.h"
#import "AppAuth 2.h"
#import "AppAuth 4.h"
#import "AppAuth.h"
#import "AppAuthCore 2.h"
#import "AppAuthCore 4.h"
#import "AppAuthCore.h"
#import "OIDAuthorizationRequest 2.h"
#import "OIDAuthorizationRequest.h"
#import "OIDAuthorizationResponse 2.h"
#import "OIDAuthorizationResponse 4.h"
#import "OIDAuthorizationResponse.h"
#import "OIDAuthorizationService 2.h"
#import "OIDAuthorizationService.h"
#import "OIDAuthState 2.h"
#import "OIDAuthState.h"
#import "OIDAuthStateChangeDelegate 2.h"
#import "OIDAuthStateChangeDelegate 4.h"
#import "OIDAuthStateChangeDelegate.h"
#import "OIDAuthStateErrorDelegate 2.h"
#import "OIDAuthStateErrorDelegate 4.h"
#import "OIDAuthStateErrorDelegate.h"
#import "OIDClientMetadataParameters 2.h"
#import "OIDClientMetadataParameters 4.h"
#import "OIDClientMetadataParameters.h"
#import "OIDDefines 2.h"
#import "OIDDefines 4.h"
#import "OIDDefines.h"
#import "OIDEndSessionRequest 2.h"
#import "OIDEndSessionRequest 4.h"
#import "OIDEndSessionRequest.h"
#import "OIDEndSessionResponse 2.h"
#import "OIDEndSessionResponse 4.h"
#import "OIDEndSessionResponse.h"
#import "OIDError 2.h"
#import "OIDError.h"
#import "OIDErrorUtilities 2.h"
#import "OIDErrorUtilities 4.h"
#import "OIDErrorUtilities.h"
#import "OIDExternalUserAgent 2.h"
#import "OIDExternalUserAgent 4.h"
#import "OIDExternalUserAgent.h"
#import "OIDExternalUserAgentRequest 2.h"
#import "OIDExternalUserAgentRequest 4.h"
#import "OIDExternalUserAgentRequest.h"
#import "OIDExternalUserAgentSession 3.h"
#import "OIDExternalUserAgentSession 4.h"
#import "OIDExternalUserAgentSession.h"
#import "OIDFieldMapping 2.h"
#import "OIDFieldMapping 4.h"
#import "OIDFieldMapping.h"
#import "OIDGrantTypes 2.h"
#import "OIDGrantTypes 4.h"
#import "OIDGrantTypes.h"
#import "OIDIDToken 2.h"
#import "OIDIDToken 4.h"
#import "OIDIDToken.h"
#import "OIDRegistrationRequest 2.h"
#import "OIDRegistrationRequest.h"
#import "OIDRegistrationResponse 2.h"
#import "OIDRegistrationResponse 4.h"
#import "OIDRegistrationResponse.h"
#import "OIDResponseTypes 2.h"
#import "OIDResponseTypes 4.h"
#import "OIDResponseTypes.h"
#import "OIDScopes 2.h"
#import "OIDScopes 4.h"
#import "OIDScopes.h"
#import "OIDScopeUtilities 2.h"
#import "OIDScopeUtilities 4.h"
#import "OIDScopeUtilities.h"
#import "OIDServiceConfiguration 2.h"
#import "OIDServiceConfiguration 4.h"
#import "OIDServiceConfiguration.h"
#import "OIDServiceDiscovery 2.h"
#import "OIDServiceDiscovery.h"
#import "OIDTokenRequest 2.h"
#import "OIDTokenRequest.h"
#import "OIDTokenResponse 2.h"
#import "OIDTokenResponse 4.h"
#import "OIDTokenResponse.h"
#import "OIDTokenUtilities 2.h"
#import "OIDTokenUtilities 4.h"
#import "OIDTokenUtilities.h"
#import "OIDURLQueryComponent 2.h"
#import "OIDURLQueryComponent 4.h"
#import "OIDURLQueryComponent.h"
#import "OIDURLSessionProvider 2.h"
#import "OIDURLSessionProvider 4.h"
#import "OIDURLSessionProvider.h"
#import "OIDAuthorizationService+IOS 3.h"
#import "OIDAuthorizationService+IOS 4.h"
#import "OIDAuthorizationService+IOS.h"
#import "OIDAuthState+IOS 3.h"
#import "OIDAuthState+IOS 4.h"
#import "OIDAuthState+IOS.h"
#import "OIDExternalUserAgentCatalyst 3.h"
#import "OIDExternalUserAgentCatalyst 4.h"
#import "OIDExternalUserAgentCatalyst.h"
#import "OIDExternalUserAgentIOS 3.h"
#import "OIDExternalUserAgentIOS 4.h"
#import "OIDExternalUserAgentIOS.h"
#import "OIDExternalUserAgentIOSCustomBrowser 3.h"
#import "OIDExternalUserAgentIOSCustomBrowser 4.h"
#import "OIDExternalUserAgentIOSCustomBrowser.h"

FOUNDATION_EXPORT double AppAuthVersionNumber;
FOUNDATION_EXPORT const unsigned char AppAuthVersionString[];
