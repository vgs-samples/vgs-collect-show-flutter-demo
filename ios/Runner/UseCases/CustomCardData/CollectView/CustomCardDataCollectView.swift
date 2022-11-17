//
//  CustomCardDataCollectView.swift
//  Runner
//

import Foundation
import UIKit
import VGSCollectSDK

/// Holds UI for custom card data collect view case.
class CustomCardDataCollectView: UIView {

	// MARK: - Vars

  /// Stack view.
	private lazy var stackView: UIStackView = {
		let stackView = UIStackView()
		stackView.translatesAutoresizingMaskIntoConstraints = false
		stackView.axis = .vertical

		stackView.layoutMargins = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
		stackView.distribution = .fill
		stackView.spacing = 16
		return stackView
	}()

  /// Card holder text field.
  lazy var cardHolderField: VGSTextField = {
    let field = VGSTextField()
    field.autocapitalizationType = .words
    field.translatesAutoresizingMaskIntoConstraints = false
    field.placeholder = "Cardholder name"
    field.font = UIFont.systemFont(ofSize: 15)
    field.padding = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)

    return field
  }()

  /// Card number text field.
	lazy var cardNumberField: VGSCardTextField = {
		let field = VGSCardTextField()
		field.translatesAutoresizingMaskIntoConstraints = false
		field.placeholder = "Card number"
		field.font = UIFont.systemFont(ofSize: 15)
		field.padding = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)

		return field
	}()

  /// Exp date text field.
	lazy var expDateField: VGSExpDateTextField = {
		let field = VGSExpDateTextField()
		field.translatesAutoresizingMaskIntoConstraints = false
		field.padding = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)

		field.font = UIFont.systemFont(ofSize: 15)
		// Update validation rules

		field.placeholder = "YYYY/MM"
		field.monthPickerFormat = .numbers
    field.yearPickeFormat = .long

		return field
	}()

  /// CVC text field.
  lazy var cvcTextField: VGSCVCTextField = {
    let field = VGSCVCTextField()
    field.translatesAutoresizingMaskIntoConstraints = false
    field.padding = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)

    field.font = UIFont.systemFont(ofSize: 15)
    // Update validation rules

    field.placeholder = "CVC/CVV"

    return field
  }()

	// MARK: - Initialization

  // no:doc
	override init(frame: CGRect) {
		super.init(frame: frame)

		addSubview(stackView)
		stackView.pinToSuperviewEdges()
//    stackView.addArrangedSubview(cardHolderField)
//		stackView.addArrangedSubview(cardNumberField)
		stackView.addArrangedSubview(expDateField)
    stackView.addArrangedSubview(cvcTextField)

		cardNumberField.heightAnchor.constraint(equalToConstant: 60).isActive = true
		expDateField.heightAnchor.constraint(equalToConstant: 60).isActive = true
    cardHolderField.heightAnchor.constraint(equalToConstant: 60).isActive = true
    cvcTextField.heightAnchor.constraint(equalToConstant: 60).isActive = true

	}

  // no:doc
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Public

  /// Configure fields with VGS Collect instance.
  /// - Parameter vgsCollect: `VGSCollect` object, VGS Collect instance.
	func configureFieldsWithCollect(_ vgsCollect: VGSCollect) {
//		let cardConfiguration = VGSConfiguration(collector: vgsCollect, fieldName: "cardNumber")
//		cardConfiguration.type = .cardNumber
//		cardNumberField.configuration = cardConfiguration

    let expDateConfiguration = VGSExpDateConfiguration(collector: vgsCollect, fieldName: "expDate")
    expDateConfiguration.isRequiredValidOnly = true
    expDateConfiguration.type = .expDate
    expDateConfiguration.inputSource = .keyboard
    expDateConfiguration.inputDateFormat = .longYearThenMonth
    expDateConfiguration.outputDateFormat = .longYearThenMonth

    // Default .expDate format is "##/##"
    expDateConfiguration.formatPattern = "####/##"
    expDateConfiguration.validationRules = VGSValidationRuleSet(rules: [
      VGSValidationRuleCardExpirationDate(dateFormat: .longYearThenMonth, error: VGSValidationErrorType.expDate.rawValue)
    ])


    let cvcConfiguration = VGSConfiguration(collector: vgsCollect, fieldName: "card_cvc")
    cvcConfiguration.isRequired = true
    cvcConfiguration.type = .cvc

    cvcTextField.configuration = cvcConfiguration
    cvcTextField.isSecureTextEntry = true

//    let holderConfiguration = VGSConfiguration(collector: vgsCollect, fieldName: "cardHolder_name")
//    holderConfiguration.type = .cardHolderName
//    holderConfiguration.keyboardType = .namePhonePad
//
//    cardHolderField.textAlignment = .natural
//    cardHolderField.configuration = holderConfiguration

		expDateField.configuration = expDateConfiguration
	}
}
