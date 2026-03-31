//
//  MockPassLibrary.swift
//  CardProvisioningApp
//
//  Created by Apple on 31/03/26.
//

import PassKit
@testable import CardProvisioningFramework

final class MockPassLibrary: PassLibraryProtocol {

    var mockPasses: [PKSecureElementPass] = []
    var canAddMap: [String: Bool] = [:]

    func passes() -> [PKSecureElementPass] {
        return mockPasses
    }

    func canAddSecureElementPass(primaryAccountIdentifier: String) -> Bool {
        return canAddMap[primaryAccountIdentifier] ?? false
    }
}
