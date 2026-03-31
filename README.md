# CardProvisioningFramework

## 🚀 Overview

`CardProvisioningFramework` is a lightweight, modular framework designed to assist issuers (banks, card providers) in implementing Apple Pay card provisioning using `PKIssuerProvisioningExtensionHandler`.

The framework focuses on evaluating whether payment cards can be provisioned on an iOS device or a paired Apple Watch, based on existing Wallet data.

---

## 🧠 Key Features

* ✅ Protocol-based abstraction over PassKit (testable design)
* ✅ Supports iPhone and Apple Watch provisioning checks
* ✅ Lightweight and performant (<100ms execution)
* ✅ Easily integrable into App + Extension targets
* ✅ Unit-test friendly with mockable dependencies

---

## 🏗️ Architecture

The framework follows a clean, decoupled architecture:

```
Service Layer → Protocol → PassKit
```

* **Service Layer**: Contains core business logic
* **Protocol Layer**: Abstracts system dependencies
* **Adapter Layer**: Connects to PassKit

---

## 📦 Core Components

### 1. `PassLibraryProtocol`

Defines an abstraction over PassKit APIs.

```swift
func passes() -> [PKSecureElementPass]
func canAddSecureElementPass(primaryAccountIdentifier: String) -> Bool
```

---

### 2. `PassLibraryAdapter`

Concrete implementation of `PassLibraryProtocol` using PassKit.

---

### 3. `CardProvisioningService`

Core business logic that determines:

* Whether a card can be added to the iPhone
* Whether a card can be added to a paired Apple Watch

---

## ⚙️ How It Works

For each card (identified by last digits):

1. Compare with existing Wallet passes
2. If not found → eligible for iPhone provisioning
3. If found and active → check Apple Watch eligibility
4. Aggregate results into a single status object

---

## 🔁 API Usage

```swift
let service = CardProvisioningService(
    passLibrary: PassLibraryAdapter()
)

let status = service.evaluateStatus(lastDigits: ["1234", "5678"])

print(status.passEntriesAvailable)
print(status.remotePassEntriesAvailable)
```

---

## 🧪 Testing Strategy

The framework is designed for testability:

* PassKit is abstracted via `PassLibraryProtocol`
* Mock implementations can simulate:

  * Existing cards
  * Activation states
  * Watch eligibility

---

## ⚡ Performance Consideration

The `evaluateStatus` function is optimized to:

* Avoid heavy operations
* Use in-memory lookups
* Execute within **100ms**, as required by Wallet extension constraints

---

## ⚠️ Limitations

* Requires Apple entitlement for full Apple Pay provisioning
* Cannot be fully tested on Simulator (PassKit limitations)
* Focuses only on **status evaluation**, not full provisioning flow

---

## 🎯 Design Decisions

* **Protocol Abstraction** → Enables unit testing and decoupling
* **Single Status Object** → Matches Apple’s API expectations
* **Separation of Concerns** → Clean division between logic and system APIs

---

## 📚 Related Apple APIs

* `PKIssuerProvisioningExtensionHandler`
* `PKIssuerProvisioningExtensionStatus`
* `PKPassLibrary`
* `PKSecureElementPass`

---

## 👨‍💻 Author

Developed as part of an iOS system design exercise focused on Apple Pay provisioning and scalable architecture.

---
