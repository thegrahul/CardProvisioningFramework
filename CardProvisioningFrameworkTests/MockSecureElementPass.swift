//
//  CardProvisioningFrameworkTests.swift
//  CardProvisioningFrameworkTests
//
//  Created by Apple on 31/03/26.
//

import Testing
import PassKit

final class MockSecureElementPass: PKSecureElementPass {

    private let suffixValue: String
    private let identifierValue: String
    private let stateValue: PKSecureElementPass.PassActivationState

    init(suffix: String, identifier: String, state: PKSecureElementPass.PassActivationState) {
        self.suffixValue = suffix
        self.identifierValue = identifier
        self.stateValue = state
        super.init()
    }

    override var primaryAccountNumberSuffix: String {
        return suffixValue
    }

    override var primaryAccountIdentifier: String {
        return identifierValue
    }

    override var passActivationState: PKSecureElementPass.PassActivationState {
        return stateValue
    }
}
