//
//  FirebaseAuthErrors.swift
//  SwiftLingo
//
//  Created by Andrea Bottino on 16/05/2024.
//

import FirebaseAuth
import Foundation


struct FirebaseAuthErrors {
    
    static func presentError(using code: AuthErrorCode.Code) -> String {
        switch code {
            
        case .invalidCustomToken:
            return "The custom token provided in invalid."
        case .customTokenMismatch:
            return "The custom token provided does not match the expected token."
        case .invalidCredential:
            return "Invalid credentials, please try again"
        case .userDisabled:
            return "This account appears to be disabled on our end. If you're the account holder please get in touch and we'll be happy to assist."
        case .operationNotAllowed:
            return "The administrator has disabled sign in with the specified identity provider."
        case .emailAlreadyInUse:
            return "We already have an account registered under this account. Please use a different one"
        case .invalidEmail:
            return "The email address provided is invalid. Maybe check the spelling?"
        case .wrongPassword:
            return "The password provided is incorrect. Maybe check the spelling?"
        case .tooManyRequests:
            return "We have received too many incorrect many requests. Please try again later, if you're trying to login to your account consider resetting the password"
        case .userNotFound:
            return "User not found"
        case .accountExistsWithDifferentCredential:
            return "We recognise the account details but not the credentials provided. Please try again"
        case .requiresRecentLogin:
            return "You are attempting a privacy-related operation. For security reasons, please re-identify yourself"
        case .providerAlreadyLinked:
            return "Provider already linked"
        case .noSuchProvider:
            return "Unable to unlink the provider. The provider is not linked"
        case .invalidUserToken:
            return "The user token provided is invalid"
        case .networkError:
            return "We cannot connect you to our systems. You have either lost connection or the connection has timed out"
        case .userTokenExpired:
            return "The user token provided has expired. Please generate a new one"
        case .invalidAPIKey:
            return "The API Key provided is invalid"
        case .userMismatch:
            return "Mmm, those are not the credentials we expected. Please try again"
        case .credentialAlreadyInUse:
            return "These credentials are already in use by a different user"
        case .weakPassword:
            return "Hold on, that is a weak-looking password! Consider using a longer (at least 6 characters) one and/or including capital letter, letters and or symbols."
        case .appNotAuthorized:
            return "This app is not authorized to use Firebase Authentication with the provided API Key."
        case .expiredActionCode:
            return "Expired code."
        case .invalidActionCode:
            return "Invalid code."
        case .invalidMessagePayload:
            return "There are invalid parameters in the payload during a 'send password reset email' attempt."
        case .invalidSender:
            return "The sender email is invalid during a 'send password reset email' attempt."
        case .invalidRecipientEmail:
            return "The recipient email is invalid. Please check the spelling"
        case .missingEmail:
            return "The email address is missing, please provide one."
        case .missingIosBundleID:
            return "The iOS bundle ID is missing, please provide one."
        case .missingAndroidPackageName:
            return "The android package name is missing. Please provide one."
        case .unauthorizedDomain:
            return "The domain specified in the continue URL is not allowlisted in the Firebase console."
        case .invalidContinueURI:
            return "The domain specified in the continue URI is not valid."
        case .missingContinueURI:
            return "The domain specified in the continue URI is missing."
        case .missingPhoneNumber:
            return "Missing phone number, please provide one."
        case .invalidPhoneNumber:
            return "The phone number provided is invalid."
        case .missingVerificationCode:
            return "The phone authorisation credential was created with an empty verification code."
        case .invalidVerificationCode:
            return "The verification code provided is invalid."
        case .missingVerificationID:
            return "The verification code provided is missing, please provide one."
        case .invalidVerificationID:
            return "The verification ID provided is invalid."
        case .missingAppCredential:
            return "The APNS device token is missing in the verifyClient request."
        case .invalidAppCredential:
            return "An invalid APNS device token was used."
        case .sessionExpired:
            return "The SMS code has expired"
        case .quotaExceeded:
            return "The quota of SMS messages has been exceeded."
        case .missingAppToken:
            return "The APNs device token could not be obtained. The app may not have set up remote notification correctly, or may fail to forward the APNs device token to Auth if app delegate swizzling is disabled."
        case .notificationNotForwarded:
            return "Notification not forwarded"
        case .appNotVerified:
            return "App not verified"
        case .captchaCheckFailed:
            return "The reCAPTCHA token is not valid."
        case .webContextAlreadyPresented:
            return "You are trying to present a new web content while one is already being displayed."
        case .webContextCancelled:
            return "The URL presentation was cancelled prematurely."
        case .appVerificationUserInteractionFailure:
            return "Oops, an error has occured."
        case .invalidClientID:
            return "The clientID used to invoke a web flow is invalid."
        case .webNetworkRequestFailed:
            return "Network request failed."
        case .webInternalError:
            return "Oops, an error has occured"
        case .webSignInUserInteractionFailure:
            return "Oops, an error has occured"
        case .localPlayerNotAuthenticated:
            return "The player was not authenticated prior to attempting Game Center signin."
        case .nullUser:
            return "User not found"
        case .dynamicLinkNotActivated:
            return "The Firebase Dynamic Link is not activated."
        case .invalidProviderID:
            return "Invalid ID."
        case .tenantIDMismatch:
            return "Could not update ID"
        case .unsupportedTenantOperation:
            return "Multitenancy not enabled"
        case .invalidDynamicLinkDomain:
            return "The Firebase Dynamic Link domain used is either not configured or is unauthorized for the current project."
        case .rejectedCredential:
            return "The credential is rejected because it’s misformed or mismatching."
        case .gameKitNotLinked:
            return "GameKit not linked."
        case .secondFactorRequired:
            return "A second factor is required for signin."
        case .missingMultiFactorSession:
            return "The multi factor session is missing."
        case .missingMultiFactorInfo:
            return "The multi factor info is missing."
        case .invalidMultiFactorSession:
            return "The multi factor session is invalid"
        case .multiFactorInfoNotFound:
            return "The multi factor info was not found."
        case .adminRestrictedOperation:
            return "Access denied: the operation is admin restricted."
        case .unverifiedEmail:
            return "The email is required for verification."
        case .secondFactorAlreadyEnrolled:
            return "The second factor is already enrolled."
        case .maximumSecondFactorCountExceeded:
            return "The maximum second factor count was exceeded."
        case .unsupportedFirstFactor:
            return "Unsupported first factor."
        case .emailChangeNeedsVerification:
            return "Email change needs verification"
        case .missingOrInvalidNonce:
            return "The nonce is missing or invalid."
        case .blockingCloudFunctionError:
            return "Oops, there was an error."
        case .missingClientIdentifier:
            return "Missing Client identifier"
        case .keychainError:
            return "Oops, an error occurred while attempting to access the keychain."
        case .internalError:
            return "Oops, an internal error occured. Please try again later. If you are trying to login it might be that you have entered the wrong login details"
        case .malformedJWT:
            return "Malformed JWT"
        @unknown default:
            return "Oops, an error has occured."
        }
    }
}
