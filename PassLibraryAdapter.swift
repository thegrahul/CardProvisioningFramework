//
//  PassLibraryAdapter.swift
//  CardProvisioningApp
//
//  Created by Rahul on 30/03/26.
//

import PassKit
/// Concrete adapter that bridges `PKPassLibrary` to `PassLibraryProtocol`.
/// Encapsulates PassKit specifics and provides a testable surface for higher layers.

/// Production implementation of `PassLibraryProtocol` backed by `PKPassLibrary`.
public final class PassLibraryAdapter: PassLibraryProtocol {

    // MARK: - Private State
    /// Underlying PassKit library used to query passes and capabilities.
    private let library = PKPassLibrary()

    /// Creates an adapter with a default `PKPassLibrary` instance.
    public init() {}

    /// Returns all secure element passes by querying `PKPassLibrary` and downcasting to `PKSecureElementPass`.
    /// - Note: `passes(of:)` returns `[PKPass]`, so we `compactMap` to keep only secure element passes.
    public func passes() -> [PKSecureElementPass] {
        return library.passes(of: .secureElement)
            .compactMap { $0 as? PKSecureElementPass }
    }

    /// Delegates to `PKPassLibrary` to determine whether the pass can be added to another secure element.
    /// - Parameter primaryAccountIdentifier: Identifier of the primary account for the pass.
    /// - Returns: `true` if the pass can be added, otherwise `false`.
    public func canAddSecureElementPass(primaryAccountIdentifier: String) -> Bool {
        return library.canAddSecureElementPass(primaryAccountIdentifier: primaryAccountIdentifier)
    }
}
