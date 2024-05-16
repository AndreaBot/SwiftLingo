//
//  FirestoreErrors.swift
//  SwiftLingo
//
//  Created by Andrea Bottino on 16/05/2024.
//

import FirebaseFirestore
import Foundation

struct FirestoreErrors {
    
    static func presentError(using code: FirestoreErrorCode.Code) -> String {
        switch code {
            
        case .OK:
            return "Success!"
        case .cancelled:
            return "Oops, the operatiorn was cancelled"
        case .unknown:
            return "Well that's embarassing... An unknown error has occured"
        case .invalidArgument:
            return "Invalid argument"
        case .deadlineExceeded:
            return "Deadline exceeded"
        case .notFound:
            return "Oops, the specified document could not be found"
        case .alreadyExists:
            return "Hold on a sec... it seems this document already exists."
        case .permissionDenied:
            return "Permission denied."
        case .resourceExhausted:
            return "Some resource has been exhausted, or perhaps the entire file system is out of space."
        case .failedPrecondition:
            return "The operation was rejected because the system is not in a state required for the operation’s execution."
        case .aborted:
            return "The operation was aborted."
        case .outOfRange:
            return "The operation was attempted past the valid range."
        case .unimplemented:
            return "The operation is not implemented or not supported/enabled."
        case .internal:
            return "This is our fault. Some internal error has occured, please try again later."
        case .unavailable:
            return "The service is currently unavailable, please give us some time and try again later"
        case .dataLoss:
            return "Unrecoverable data loss or corruption"
        case .unauthenticated:
            return "The request does not have valid authentication credentials for the operation."
        @unknown default:
            return "Oops, an error as occured."
        }
    }
}
