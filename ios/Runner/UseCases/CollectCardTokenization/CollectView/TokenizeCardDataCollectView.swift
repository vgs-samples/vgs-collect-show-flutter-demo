//
//  TokenizeCardDataCollectView.swift
//  Runner

import Foundation
import UIKit
import VGSCollectSDK

/// Holds UI for tokenize card data collect view case.
class TokenizeCardDataCollectView: UIView {

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

    field.placeholder = "MM/YYYY"
    field.monthPickerFormat = .longSymbols

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
    stackView.addArrangedSubview(cardHolderField)
    stackView.addArrangedSubview(cardNumberField)
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
    /// Use VGSCardNumberTokenizationConfiguration with predefined tokenization paramaters
    let cardConfiguration = VGSCardNumberTokenizationConfiguration(collector: vgsCollect, fieldName: "card_number")
    cardNumberField.configuration = cardConfiguration
    cardNumberField.placeholder = "4111 1111 1111 1111"
    cardNumberField.textAlignment = .natural
    cardNumberField.cardIconLocation = .right

    /// Use `VGSExpDateTokenizationConfiguration`for tokenization
    let expDateConfiguration = VGSExpDateTokenizationConfiguration(collector: vgsCollect, fieldName: "card_expirationDate")

    /// Edit default tokenization parameters
//        expDateConfiguration.tokenizationParameters.format = VGSVaultAliasFormat.UUID.rawValue
//      expDateConfiguration.serializers = [VGSExpDateSeparateSerializer.init(monthFieldName: "MONTH", yearFieldName: "YEAR")]
    /// Set UI configuration
    expDateConfiguration.inputDateFormat = .shortYear
    expDateConfiguration.outputDateFormat = .longYear

    /// Default .expDate format is "##/##"
    expDateConfiguration.formatPattern = "##/##"

    /// Update validation rules
    expDateConfiguration.validationRules = VGSValidationRuleSet(rules: [
      VGSValidationRuleCardExpirationDate(dateFormat: .shortYear, error: VGSValidationErrorType.expDate.rawValue)
    ])

    expDateField.configuration = expDateConfiguration
    expDateField.placeholder = "MM/YY"
    expDateField.monthPickerFormat = .longSymbols

    let cvcConfiguration = VGSCVCTokenizationConfiguration(collector: vgsCollect, fieldName: "card_cvc")
    cvcTextField.configuration = cvcConfiguration

    cvcTextField.isSecureTextEntry = true
    cvcTextField.placeholder = "CVC"
    cvcTextField.tintColor = .lightGray

    /// Use  default VGSConfiguration for fields tha should not be tokenized. Raw field value will returned in response
    let holderConfiguration = VGSConfiguration(collector: vgsCollect, fieldName: "cardHolder_name")
    holderConfiguration.type = .cardHolderName
    holderConfiguration.keyboardType = .namePhonePad
          // Set max input length
    // holderConfiguration.maxInputLength = 32
    cardHolderField.configuration = holderConfiguration
    cardHolderField.placeholder = "Cardholder Name"
    cardHolderField.textAlignment = .natural
  }
}
