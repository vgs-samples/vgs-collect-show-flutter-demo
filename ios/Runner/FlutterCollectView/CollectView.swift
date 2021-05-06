//
//  CollectView.swift
//  Runner
//

import Foundation
import UIKit
import VGSCollectSDK

class CollectView: UIView {

	// MARK: - Vars

	private lazy var stackView: UIStackView = {
		let stackView = UIStackView()
		stackView.translatesAutoresizingMaskIntoConstraints = false
		stackView.axis = .vertical

		stackView.layoutMargins = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
		stackView.distribution = .fill
		stackView.spacing = 16
		return stackView
	}()

	private lazy var cardNumberField: VGSCardTextField = {
		let field = VGSCardTextField()
		field.translatesAutoresizingMaskIntoConstraints = false
		field.placeholder = "Card number"
		field.font = UIFont.systemFont(ofSize: 12)
		field.padding = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)

		return field
	}()

	private lazy var expDateField: VGSExpDateTextField = {
		let field = VGSExpDateTextField()
		field.translatesAutoresizingMaskIntoConstraints = false
		field.padding = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)

		field.font = UIFont.systemFont(ofSize: 12)
		// Update validation rules

		field.placeholder = "MM/YYYY"
		field.monthPickerFormat = .longSymbols

		return field
	}()

	// MARK: - Initialization

	override init(frame: CGRect) {
		super.init(frame: frame)

		addSubview(stackView)
		stackView.pinToSuperviewEdges()
		stackView.addArrangedSubview(cardNumberField)
		stackView.addArrangedSubview(expDateField)

		cardNumberField.heightAnchor.constraint(equalToConstant: 60).isActive = true
		expDateField.heightAnchor.constraint(equalToConstant: 60).isActive = true
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Public

	func configureFieldsWithCollect(_ vgsCollect: VGSCollect) {
		let cardConfiguration = VGSConfiguration(collector: vgsCollect, fieldName: "cardNumber")
		cardConfiguration.type = .cardNumber
		cardNumberField.configuration = cardConfiguration

		let expDateConfiguration = VGSConfiguration(collector: vgsCollect, fieldName: "expDate")
		expDateConfiguration.isRequiredValidOnly = true
		expDateConfiguration.type = .expDate

		// Default .expDate format is "##/##"
		expDateConfiguration.formatPattern = "##/####"
		expDateConfiguration.validationRules = VGSValidationRuleSet(rules: [
			VGSValidationRuleCardExpirationDate(dateFormat: .longYear, error: VGSValidationErrorType.expDate.rawValue)
		])

		expDateField.configuration = expDateConfiguration
	}
}
