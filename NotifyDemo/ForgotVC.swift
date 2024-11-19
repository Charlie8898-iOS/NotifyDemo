//
//  ForgotVC.swift
//  NotifyDemo
//
//  Created by Apple on 16/11/24.
//

import UIKit
import UserNotifications

class ForgotVC: UIViewController {

    private let forgotPasswordLabel: UILabel = {
        let label = UILabel()
        label.text = "Forgot Password"
        label.font = UIFont.monospacedSystemFont(ofSize: 25, weight: .bold)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    private let mobileTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter Mobile Number"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .numberPad
        return textField
    }()
    
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter New Password"
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private let togglePasswordButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "eye.slash.fill"), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    private let submitButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Submit", for: .normal)
        button.backgroundColor = .white
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.layer.cornerRadius = 8
        return button
    }()

    private var isPasswordVisible = false

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        requestNotificationPermission()
        
        togglePasswordButton.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
        submitButton.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
    }

    private func setupUI() {
        view.backgroundColor = .black
        
        view.addSubview(forgotPasswordLabel)
        view.addSubview(mobileTextField)
        view.addSubview(passwordTextField)
        view.addSubview(togglePasswordButton)
        view.addSubview(submitButton)
        
        forgotPasswordLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            forgotPasswordLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            forgotPasswordLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            forgotPasswordLabel.widthAnchor.constraint(equalToConstant: 250),
            forgotPasswordLabel.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        mobileTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mobileTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mobileTextField.topAnchor.constraint(equalTo: forgotPasswordLabel.bottomAnchor, constant: 20),
            mobileTextField.widthAnchor.constraint(equalToConstant: 340),
            mobileTextField.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordTextField.topAnchor.constraint(equalTo: mobileTextField.bottomAnchor, constant: 20),
            passwordTextField.widthAnchor.constraint(equalToConstant: 340),
            passwordTextField.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        togglePasswordButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(togglePasswordButton)
        NSLayoutConstraint.activate([
            togglePasswordButton.trailingAnchor.constraint(equalTo: passwordTextField.trailingAnchor, constant: -10),
            togglePasswordButton.centerYAnchor.constraint(equalTo: passwordTextField.centerYAnchor)
        ])
        
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            submitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            submitButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 40),
            submitButton.widthAnchor.constraint(equalToConstant: 340),
            submitButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    @objc private func togglePasswordVisibility() {
        isPasswordVisible.toggle()
        passwordTextField.isSecureTextEntry = !isPasswordVisible
        let imageName = isPasswordVisible ? "eye.fill" : "eye.slash.fill"
        togglePasswordButton.setImage(UIImage(systemName: imageName), for: .normal)
    }

    @objc private func submitButtonTapped() {
        let otp = generateOTP()
        print("Generated OTP: \(otp)")
        sendLocalNotification(with: otp)
        
        let otpVC = OtpVC()
        otpVC.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(otpVC, animated: true)
    }

    private func generateOTP() -> String {
        let otp = String(format: "%04d", arc4random_uniform(10000))
        return otp
    }

    private func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                print("Notification permission granted.")
            } else {
                print("Notification permission denied.")
            }
        }
    }

    private func sendLocalNotification(with otp: String) {
        let content = UNMutableNotificationContent()
        content.title = "Your OTP Code"
        content.body = "Your OTP is: \(otp)"
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: "otpNotification", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            }
        }
    }
}
