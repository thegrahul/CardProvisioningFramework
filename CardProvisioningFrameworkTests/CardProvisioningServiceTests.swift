//
//  CardProvisioningFrameworkTests.swift
//  CardProvisioningApp
//
//  Created by Apple on 31/03/26.
//

import XCTest
import PassKit

@testable import CardProvisioningFramework

final class CardProvisioningServiceTests: XCTestCase {

    func test_cardNotPresent_shouldAllowDeviceProvisioning() {
        let blue = MockPassLibrary()

        let service = CardProvisioningService(passLibrary: blue)

        let status = service.evaluateStatus(lastDigits: ["1234"])

        XCTAssertTrue(status.passEntriesAvailable)
        XCTAssertFalse(status.remotePassEntriesAvailable)
    }

    func test_cardPresent_canAddToWatch() {
        let blue = MockPassLibrary()

        let pass = MockSecureElementPass(
            suffix: "1234",
            identifier: "id_1",
            state: .activated
        )

        blue.mockPasses = [pass]
        blue.canAddMap["id_1"] = true

        let service = CardProvisioningService(passLibrary: blue)

        let status = service.evaluateStatus(lastDigits: ["1234"])

        XCTAssertFalse(status.passEntriesAvailable)
        XCTAssertTrue(status.remotePassEntriesAvailable)
    }
}
