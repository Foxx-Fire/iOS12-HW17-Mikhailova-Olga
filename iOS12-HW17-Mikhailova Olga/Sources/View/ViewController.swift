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
    
    // MARK: - Outlets
    
    private lazy var buttonColor: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Change Color", for: .normal)
        button.backgroundColor = .blue
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(onBut), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var buttonPassword: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Start brut", for: .normal)
        button.setTitle("Clear brut", for: .selected)
        button.backgroundColor = .blue
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(brut), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.isSecureTextEntry = true
        textField.textContentType = .password
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
        setupLayout()
        setupHierarchy()
    }
    
    // MARK: - Setups
    
    private func setupLayout() {
        textField.addSubview(activity)
        [buttonColor, buttonPassword, textField,  label, labelBrut].forEach{view.addSubview($0)}
    }
    
    private func setupHierarchy() {
        NSLayoutConstraint.activate([
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
    
    @objc
    func onBut() {
        DispatchQueue.main.async {
            self.view.backgroundColor = UIColor.random
        }
    }
    
    @objc
    func brut() {
        self.activity.startAnimating()
        buttonPassword.isSelected = !buttonPassword.isSelected
        let brutedText = textField.text ?? ""
        if buttonPassword.isSelected {
            DispatchQueue.global(qos: .background).async { [weak self] in
                self?.presenter?.bruteForce(passwordToUnlock: brutedText)
            }
        } else if !buttonPassword.isSelected {
            textField.text = ""
            label.text = nil
            labelBrut.text = ""
            DispatchQueue.main.async {
                self.textField.isSecureTextEntry = true
                self.activity.stopAnimating()
            }
        }
    }
}

//MARK: Extension

extension ViewController: ViewProcotol {
    func setBrut(textField: String, label: String, bruting: String) {
        DispatchQueue.main.async {
            if label.isEmpty {
                self.activity.startAnimating()
                self.labelBrut.text = bruting
            } else {
                self.label.text = label
                self.textField.isSecureTextEntry = false
            }
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

