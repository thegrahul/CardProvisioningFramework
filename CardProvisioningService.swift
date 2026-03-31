//
//  CardProvisioningService.swift
//  CardProvisioningApp
//
//  Created by Rahul on 30/03/26.
//

import PassKit

/// Service responsible for evaluating whether card entries can be provisioned
/// to the current device and/or a paired Apple Watch based on known PAN suffixes.
///
/// Optimization notes:
/// - We build a lookup dictionary for faster suffix lookups (O(1)) instead of scanning the array each time (O(n)).
/// - We short-circuit the loop once both availability flags are determined.
 
/// A small service that inspects existing passes and determines provisioning availability
/// for specified primary account number (PAN) suffixes. Uses `PassLibraryProtocol` for
/// indirection to facilitate testing.
public final class CardProvisioningService {

    private let passLibrary: PassLibraryProtocol

    /// Creates a service with the given pass library abstraction.
    /// - Parameter passLibrary: Abstraction over `PKPassLibrary` for querying passes and capabilities.
    public init(passLibrary: PassLibraryProtocol) {
        self.passLibrary = passLibrary
    }

    /// Evaluates whether entries are available for provisioning on this device and remotely (e.g., Apple Watch)
    /// for the provided list of PAN suffixes.
    /// - Parameter lastDigits: Collection of PAN suffix strings to evaluate.
    /// - Returns: A configured `PKIssuerProvisioningExtensionStatus` reflecting availability.
    public func evaluateStatus(lastDigits: [String]) -> PKIssuerProvisioningExtensionStatus {

        // Fetch all passes once.
        let passes = passLibrary.passes()

        // Build a fast lookup by primaryAccountNumberSuffix to avoid repeated linear searches.
        // Key: suffix, Value: pass with that suffix. If duplicates exist, first wins which
        // mirrors previous `first(where:)` behavior.
        let passesBySuffix: [String: PKSecureElementPass] = {
            var dict: [String: PKSecureElementPass] = [:]
            dict.reserveCapacity(passes.count)
            for pass in passes where dict[pass.primaryAccountNumberSuffix] == nil {
                dict[pass.primaryAccountNumberSuffix] = pass
            }
            return dict
        }()

        var canAddToDevice = false
        var canAddToWatch = false

        // Iterate the requested suffixes. We short-circuit if both are already true.
        for digits in lastDigits {
            if canAddToDevice && canAddToWatch { break }

            // If there is no existing pass with this suffix, user can add it to this device.
            guard let pass = passesBySuffix[digits] else {
                canAddToDevice = true
                continue
            }

            // If the pass is active (not deactivated) and can be added to another secure element
            // (e.g., Apple Watch), mark remote availability.
            if pass.passActivationState != .deactivated {
                let canAdd = passLibrary.canAddSecureElementPass(
                    primaryAccountIdentifier: pass.primaryAccountIdentifier
                )
                if canAdd { canAddToWatch = true }
            }
        }

        // Construct and return the status.
        let status = PKIssuerProvisioningExtensionStatus()
        status.passEntriesAvailable = canAddToDevice
        status.remotePassEntriesAvailable = canAddToWatch
        return status
    }
}
