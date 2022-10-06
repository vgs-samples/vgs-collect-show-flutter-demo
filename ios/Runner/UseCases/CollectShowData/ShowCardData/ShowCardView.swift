//
//  ShowCardView.swift
//  Runner

import Foundation
import UIKit
import VGSShowSDK

/// Native UIView subclass, holds VGSLabels.
class ShowCardView: UIView {
  
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

  /// Cardholder label.
  private lazy var cardHolderLabel: VGSLabel = {
    let label = ShowCardView.provideStylesVGSLabel()

    label.placeholder = "Card holder"
    label.contentPath = "json.payment_card_holder_name"

    return label
  }()

  /// Card number label.
  lazy var cardNumberVGSLabel: VGSLabel = {
    let label = ShowCardView.provideStylesVGSLabel()
    
    label.placeholder = "Card number"
    label.contentPath = "json.payment_card_number"
    
    // Create regex object, split card number to XXXX XXXX XXXX XXXX format.
    do {
      let cardNumberPattern = "(\\d{4})(\\d{4})(\\d{4})(\\d{4})"
      let template = "$1 $2 $3 $4"
      let regex = try NSRegularExpression(pattern: cardNumberPattern, options: [])
      
      // Add transformation regex to your label.
      label.addTransformationRegex(regex, template: template)
    } catch {
      assertionFailure("invalid regex, error: \(error)")
    }
    
    return label
  }()

  /// Exp date label.
  private lazy var expirationDateLabel: VGSLabel = {
    let label = ShowCardView.provideStylesVGSLabel()
    
    label.placeholder = "Expiration date"
    label.contentPath = "json.payment_card_expiration_date"
    
    return label
  }()
  
  // MARK: - Initialization

  // no:doc
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    addSubview(stackView)
    stackView.pinToSuperviewEdges()
    stackView.addArrangedSubview(cardHolderLabel)
    stackView.addArrangedSubview(cardNumberVGSLabel)
    stackView.addArrangedSubview(expirationDateLabel)

    cardHolderLabel.heightAnchor.constraint(equalToConstant: 60).isActive = true
    cardNumberVGSLabel.heightAnchor.constraint(equalToConstant: 60).isActive = true
    expirationDateLabel.heightAnchor.constraint(equalToConstant: 60).isActive = true
  }

  // no:doc
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Public

  /// Subscribe views to vgsShow.
  /// - Parameter vgsShow: `VGSShow` object, vgs show instance.
  func subscribeViewsToShow(_ vgsShow: VGSShow) {
    vgsShow.subscribe(cardHolderLabel)
    vgsShow.subscribe(cardNumberVGSLabel)
    vgsShow.subscribe(expirationDateLabel)
  }
  
  // MARK: - Private

  /// Provides `VGSLabel`.
  /// - Returns: `VGSLabel` object, VGSLabel instance.
  static private func provideStylesVGSLabel() -> VGSLabel {
    let label = VGSLabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = UIFont.systemFont(ofSize: 14)
    label.placeholderStyle.color = .black
    label.placeholderStyle.textAlignment = .center
    label.textAlignment = .center
    
    return label
  }
}
