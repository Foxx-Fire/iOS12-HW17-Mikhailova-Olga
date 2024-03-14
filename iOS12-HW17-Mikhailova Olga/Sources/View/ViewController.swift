//
//  ViewController.swift
//  iOS12-HW17-Mikhailova Olga
//
//  Created by FoxxFire on 10.03.2024.
//

import UIKit

class ViewController: UIViewController {
   
    var presenter: PresenterProtocol?
    var timer: Timer?
    var isStartBruting = false
    
    // MARK: - Outlets
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var buttonColor: UIButton = {
        let button = UIButton(type: .system)
        button.configuration = .createConfig()
        button.setTitle("Colors", for: .normal)
        button.addTarget(self, action: #selector(onBut), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var buttonPassword: UIButton = {
        let button = UIButton()
        button.configuration = .createConfig()
        button.setTitle("Start brut", for: .normal)
        button.setTitle("Clear brut", for: .selected)
        button.addTarget(self, action: #selector(brut), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.isSecureTextEntry = true
        textField.textContentType = .password
        textField.keyboardType = .asciiCapable
        textField.backgroundColor = .lightGray
        textField.layer.cornerRadius = 16
        textField.font = UIFont(name:"Times New Roman", size: 30)
        textField.textColor = .red
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.textColor = .green
        label.textAlignment = .center
        label.font = UIFont(name:"Times New Roman", size: 30)
        label.backgroundColor = .lightGray
        label.layer.cornerRadius = 16
        label.layer.masksToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
        
    private lazy var labelBrut: UILabel = {
        let label = UILabel()
        label.textColor = .blue
        label.textAlignment = .center
        label.font = UIFont(name:"Times New Roman", size: 30)
        label.layer.cornerRadius = 16
        label.layer.masksToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var activity: UIActivityIndicatorView = {
        let active = UIActivityIndicatorView(style: .medium)
        active.color = .red
        active.translatesAutoresizingMaskIntoConstraints = false
        return active
    }()

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHierarchy()
        setupLayout()
        registerKeyboard()
    }
    
    deinit {
        removeKeyboard()
    }
    
    // MARK: - Setups
    
    private func registerKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func removeKeyboard() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func setupHierarchy() {
        textField.addSubview(activity)
        [scrollView, buttonColor, buttonPassword, textField,  label, labelBrut].forEach{view.addSubview($0)}
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.centerYAnchor),
            
            buttonColor.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -100),
            buttonColor.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            buttonColor.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 20),
            
            buttonPassword.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 100),
            buttonPassword.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            buttonPassword.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 20),
            
            textField.bottomAnchor.constraint(equalTo: buttonColor.topAnchor, constant: -23),
            textField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textField.leadingAnchor.constraint(equalTo: buttonColor.centerXAnchor),
            textField.trailingAnchor.constraint(equalTo: buttonPassword.centerXAnchor),
            textField.topAnchor.constraint(equalTo: textField.centerYAnchor, constant: -35),
            
            activity.trailingAnchor.constraint(equalTo: textField.trailingAnchor, constant: -10),
            activity.centerYAnchor.constraint(equalTo: textField.centerYAnchor),
            
            label.centerXAnchor.constraint(equalTo: textField.centerXAnchor),
            label.leadingAnchor.constraint(equalTo: textField.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: textField.trailingAnchor),
            label.topAnchor.constraint(equalTo: label.centerYAnchor, constant: -35),
            label.bottomAnchor.constraint(equalTo: textField.topAnchor, constant: -15),
            
            labelBrut.centerXAnchor.constraint(equalTo: label.centerXAnchor),
            labelBrut.leadingAnchor.constraint(equalTo: label.leadingAnchor),
            labelBrut.trailingAnchor.constraint(equalTo: label.trailingAnchor),
            labelBrut.topAnchor.constraint(equalTo: labelBrut.centerYAnchor, constant: -35),
            labelBrut.bottomAnchor.constraint(equalTo: label.topAnchor, constant: -15)
        ])
    }
    
    // MARK: - Actions
    
    @objc private func keyboardWillShow(notification: NSNotification) {
            let userInfo = notification.userInfo
            let keyboardFrame = (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            scrollView.contentOffset = CGPoint(x: 0, y: keyboardFrame?.height ?? CGFloat())
        }
    
    @objc private func keyboardWillHide() {
        scrollView.contentOffset = CGPoint.zero
    }
    
    @objc private func activateTextField() {
        textField.resignFirstResponder()
    }
    
    @objc
    func onBut() {
        DispatchQueue.main.async {
            self.view.backgroundColor = UIColor.random
        }
    }
    
    @objc
    func brut() {
        buttonPassword.isSelected = !buttonPassword.isSelected
        guard let brutedText = textField.text else {return}
        if brutedText.isEmpty {
            showAlert(title: "Type text here", message: "TextField can't be empty", style: .alert)
        }
        
        if brutedText.printable.contains(textField.text!) != true {
            showAlert(title: "Wrong symbols", message: "", style: .alert)
            textField.text = ""
            buttonPassword.isSelected = false
        }
        
        if brutedText.printable.contains(textField.text!) {
            
            if buttonPassword.isSelected {
                self.activity.startAnimating()
                DispatchQueue.global(qos: .background).async { [weak self] in
                    self?.presenter?.bruteForce(passwordToUnlock: brutedText)
                }
            } else {
                textField.text = ""
                label.text = nil
                labelBrut.text = ""
                self.textField.isSecureTextEntry = true
                
            }
        }
    }
    
    func showAlert(title: String, message: String, style: UIAlertController.Style) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        let action = UIAlertAction(title: "Try again", style: .cancel)
        alert.addAction(action)
        self.present(alert, animated: true)
    }
}

//MARK: Extension

extension ViewController: ViewProcotol {
    
    func setBrut(label: String) {
        DispatchQueue.main.async {
            self.labelBrut.text = label
        }
    }
    
    func result(label: String) {
        DispatchQueue.main.async {
            self.label.text = label
            self.textField.isSecureTextEntry = false
            self.activity.stopAnimating()
        }
    }
}

extension UIColor {
    static var random: UIColor {
        return UIColor(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1),
            alpha: 1.0
        )
    }
}

extension UIButton.Configuration {
    static func createConfig() -> UIButton.Configuration {
        var config: UIButton.Configuration = .filled()
        config.baseBackgroundColor = .blue
        config.subtitle = "Tap me"
        config.titleAlignment = .center
        config.cornerStyle = .capsule
        return config
    }
}
