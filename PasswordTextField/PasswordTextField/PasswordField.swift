//
//  PasswordField.swift
//  PasswordTextField
//
//  Created by Ben Gohlke on 6/26/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

class PasswordField: UIControl {
    
    // MARK: - Public API - these properties are used to fetch the final password and strength values
    private (set) var password: String = ""
    
    private let standardMargin: CGFloat = 8.0
    private let textFieldContainerHeight: CGFloat = 50.0
    private let textFieldMargin: CGFloat = 6.0
    private let colorViewSize: CGSize = CGSize(width: 60.0, height: 5.0)
    
    private let labelTextColor = UIColor(hue: 233.0/360.0, saturation: 16/100.0, brightness: 41/100.0, alpha: 1)
    private let labelFont = UIFont.systemFont(ofSize: 14.0, weight: .semibold)
    
    private let textFieldBorderColor = UIColor(hue: 208/360.0, saturation: 80/100.0, brightness: 94/100.0, alpha: 1)
    private let bgColor = UIColor(hue: 0, saturation: 0, brightness: 97/100.0, alpha: 1)
    
    // MARK: - States of the password strength indicators
    private let unusedColor = UIColor(hue: 210/360.0, saturation: 5/100.0, brightness: 86/100.0, alpha: 1)
    private let weakColor = UIColor(hue: 0/360, saturation: 60/100.0, brightness: 90/100.0, alpha: 1)
    private let mediumColor = UIColor(hue: 39/360.0, saturation: 60/100.0, brightness: 90/100.0, alpha: 1)
    private let strongColor = UIColor(hue: 132/360.0, saturation: 60/100.0, brightness: 75/100.0, alpha: 1)
    
    // MARK: - UI Element Properties
    
    private var titleLabel: UILabel = UILabel()
    private var textContainer: UIView = UIView()
    private var textField: UITextField = UITextField(frame: CGRect(x: 0, y: 0, width: 10, height: 50.0))
    private var showHideButton: UIButton = UIButton(type: .custom)
    private var weakView: UIView = UIView()
    private var mediumView: UIView = UIView()
    private var strongView: UIView = UIView()
    private var strengthDescriptionLabel: UILabel = UILabel()
    
    
    // MARK: - Methods
    
    private func setup() {
        // Lay out your subviews here
        
        self.backgroundColor = bgColor
        
        // MARK: - titleLabel
        titleLabel.text = "ENTER PASSWORD"
        titleLabel.font = labelFont
        titleLabel.textColor = labelTextColor
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: standardMargin),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: standardMargin)
        ])
        
        // MARK: - Textfield
//
        textField.borderStyle = .roundedRect
        textField.backgroundColor = bgColor
        textField.layer.borderColor = textFieldBorderColor.cgColor
        textField.layer.borderWidth = 2
        textField.layer.cornerRadius = 5
        textField.font = UIFont.systemFont(ofSize: 15)
        textField.minimumFontSize = 15
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.clearButtonMode = .never
        textField.keyboardType = UIKeyboardType.default
        textField.returnKeyType = UIReturnKeyType.default
        textField.contentVerticalAlignment = .center
        textField.textColor = .black
        textField.placeholder = "Is this working"
        textField.textContentType = .password
        textField.isSecureTextEntry = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.isUserInteractionEnabled = true
        textField.isEnabled = true
        textField.delegate = self
        textField.allowsEditingTextAttributes = true
        addSubview(textField)
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor),
            textField.heightAnchor.constraint(equalToConstant: textFieldContainerHeight),
            textField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: standardMargin)
        ])
        
        
        // MARK: - Hide button
        showHideButton.addTarget(self, action: #selector(secureText(_:)), for: .touchUpInside)
        showHideButton.isEnabled = true
        showHideButton.setImage(UIImage(named: "eyes-closed"), for: .normal)
        showHideButton.frame = CGRect(x: textField.frame.maxX - textFieldMargin, y: 0, width: 20, height: 100)
        showHideButton.translatesAutoresizingMaskIntoConstraints = false
        textField.rightView = showHideButton
        textField.rightViewMode = .always
        
        // MARK: - Strength indicators stack view
        let indicatorsArray: [UIView] = [weakView, mediumView, strongView]
        let stackView = UIStackView()
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.axis = .horizontal
        stackView.spacing = 5
        stackView.addArrangedSubview(weakView)
        stackView.addArrangedSubview(mediumView)
        stackView.addArrangedSubview(strongView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        for indicator in indicatorsArray {
            
            if indicator == indicatorsArray.first {
                indicator.backgroundColor = weakColor
            } else {
                indicator.backgroundColor = unusedColor
            }
            
            indicator.translatesAutoresizingMaskIntoConstraints = false
            stackView.addArrangedSubview(indicator)
            indicator.frame.size = colorViewSize
            indicator.layer.cornerRadius = 5
            indicator.heightAnchor.constraint(equalToConstant: indicator.frame.size.height).isActive = true
            indicator.widthAnchor.constraint(equalToConstant: indicator.frame.size.width).isActive = true
        }
        
        strengthDescriptionLabel.text = "Too weak"
        strengthDescriptionLabel.font = labelFont
        strengthDescriptionLabel.textColor = labelTextColor
        strengthDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(strengthDescriptionLabel)
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: standardMargin),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: standardMargin),
            stackView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: standardMargin),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: standardMargin),
            self.bottomAnchor.constraint(equalTo: stackView.bottomAnchor, constant: standardMargin)
        ])
    }
    
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    @objc func secureText(_ sender: Any) {
        
        textField.isSecureTextEntry.toggle()
        
        if textField.isSecureTextEntry {
            showHideButton.setImage(UIImage(named: "eyes-closed"), for: .normal)
        } else {
            showHideButton.setImage(UIImage(named: "eyes-open"), for: .normal)
        }
        
        
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 0, height: 100.0)
    }

    private enum Strength {
        case weak
        case medium
        case strong
    }

    private var strength: Strength = .weak {
        didSet {
            switch strength {
            case .weak:
                strengthDescriptionLabel.text = "Too weak"
                weakView.backgroundColor = weakColor
                weakView.performFlare()
                mediumView.backgroundColor = unusedColor
                strongView.backgroundColor = unusedColor
            case .medium:
                strengthDescriptionLabel.text = "Could be stronger"
                weakView.backgroundColor = weakColor
                mediumView.backgroundColor = mediumColor
                mediumView.performFlare()
                strongView.backgroundColor = unusedColor
            case .strong:
                strengthDescriptionLabel.text = "Strong password"
                weakView.backgroundColor = weakColor
                mediumView.backgroundColor = mediumColor
                strongView.backgroundColor = strongColor
                strongView.performFlare()

            }
        }
    }

    private func determineStrength(_ password: String) {
        var newStrength: Strength = .weak
        if password.count <= 9 {
            newStrength = .weak
        } else if password.count > 9 && password.count <= 19 {
            newStrength = .medium
        } else if password.count > 19 {
            newStrength = .strong
        }

        if strength != newStrength { strength = newStrength }

    }

    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let _ = touch.location(in: textField)
        sendActions(for: [.touchDown])
        return true

    }

    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let touchPoint = touch.location(in: self)

        if textField.bounds.contains(touchPoint) {

            sendActions(for: [.touchDragInside, .valueChanged])
        } else {
            sendActions(for: [.touchDragOutside])
        }
        return true
    }

    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        guard let touch = touch else { return }

        let touchPoint = touch.location(in: textField)
        if showHideButton.bounds.contains(touchPoint) {
            print("touch inside.")
            sendActions(for: [.touchUpInside, .valueChanged])
        } else {
            sendActions(for: [.touchUpOutside])
        }
    }

    override func cancelTracking(with event: UIEvent?) {
        sendActions(for: [.touchCancel])
    }

    
}


// MARK: - Extension

extension PasswordField: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldText = textField.text!
        let stringRange = Range(range, in: oldText)!
        let newText = oldText.replacingCharacters(in: stringRange, with: string)
        // TODO: send new text to the determine strength method
        determineStrength(newText)
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text else { return false }
        
        textField.resignFirstResponder()
        password = text
        sendActions(for: .valueChanged)
        
        return true
    }
}

extension UIView {
    func performFlare() {
        func flare() { transform = CGAffineTransform(scaleX: 1.0, y: 1.6) }
        func unflare() { transform = .identity }
        
        UIView.animate(withDuration: 0.3,
                       animations: { flare() },
                       completion: { _ in UIView.animate(withDuration: 0.1) { unflare() }})
    }
}
