//
//  DemoAppConfig.swift
//  Runner
//

import Foundation

final class DemoAppConfig {

	// MARK: - Vars

  var vaultId = "<YOUR_VAULT_ID>"
  var path = "post"
	let payloadKey = "VGS_TEST_PAYLOAD_KEY"
	let payloadValue = "VGS_TEST_PAYLOAD_VALUE"

	/// Shared instance.
	static let shared = DemoAppConfig()

	// MARK: - Initialization

	private init() {}
}
