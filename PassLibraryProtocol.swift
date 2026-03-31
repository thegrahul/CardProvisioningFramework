//
//  PassLibraryProtocol.swift
//  CardProvisioningApp
//
//  Created by Rahul on 30/03/26.
//

import PassKit
/// Abstraction over `PKPassLibrary` used by `CardProvisioningService` to enable testing and
/// decouple PassKit from higher-level modules.

/// Defines the minimal interface required from a pass library to query secure element passes
/// and determine whether a pass can be added to another device (e.g., Apple Watch).
public protocol PassLibraryProtocol {
    /// Returns all secure element passes available on the current device.
    /// - Returns: An array of `PKSecureElementPass` instances.
    func passes() -> [PKSecureElementPass]

    /// Indicates whether a pass with the given primary account identifier can be added to
    /// another secure element (e.g., paired Apple Watch).
    /// - Parameter primaryAccountIdentifier: The unique identifier for the pass' primary account.
    /// - Returns: `true` if the pass can be added, otherwise `false`.
    func canAddSecureElementPass(primaryAccountIdentifier: String) -> Bool
}
