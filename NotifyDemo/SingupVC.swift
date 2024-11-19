//
//  SingupVC.swift
//  NotifyDemo
//
//  Created by Apple on 16/11/24.
//

import UIKit
import UserNotifications

class SingupVC: UIViewController, UNUserNotificationCenterDelegate {

    private var welcomeLabel: UILabel!
    private var signupLabel: UILabel!
    private var usernameTextField: UITextField!
    private var passwordTextField: UITextField!
    private var submitButton: UIButton!
    private var mobileNumberTextField: UITextField!
    private let toggleButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "eye.slash.fill"), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    private var isPasswordHidden = true
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        setupUI()
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
            if let error = error {
                print("Notification permission error: \(error)")
            }
        }
        
        UNUserNotificationCenter.current().delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleOTPNotification(_:)), name: NSNotification.Name("OTPReceived"), object: nil)
    }

    private func setupUI() {
        welcomeLabel = UILabel()
        welcomeLabel.text = "Welcome to NotifyDemo"
        welcomeLabel.textColor = .white
        welcomeLabel.font = UIFont.monospacedSystemFont(ofSize: 25, weight: .bold)
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(welcomeLabel)
        
        signupLabel = UILabel()
        signupLabel.text = "Sign up"
        signupLabel.textColor = .white
        signupLabel.font = UIFont.boldSystemFont(ofSize: 18)
        signupLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(signupLabel)
        
        usernameTextField = UITextField()
        usernameTextField.placeholder = "Enter Username"
        usernameTextField.borderStyle = .roundedRect
        usernameTextField.textColor = .black
        usernameTextField.backgroundColor = .white
        usernameTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(usernameTextField)
        
        passwordTextField = UITextField()
        passwordTextField.placeholder = "Enter Password"
        passwordTextField.isSecureTextEntry = true
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.textColor = .black
        passwordTextField.backgroundColor = .white
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        
        toggleButton.addTarget(self, action: #selector(togglePasswordVisibility(_:)), for: .touchUpInside)
        passwordTextField.rightView = toggleButton
        passwordTextField.rightViewMode = .always
        view.addSubview(passwordTextField)
        
        mobileNumberTextField = UITextField()
        mobileNumberTextField.placeholder = "Enter Mobile Number"
        mobileNumberTextField.keyboardType = .numberPad
        mobileNumberTextField.borderStyle = .roundedRect
        mobileNumberTextField.textColor = .black
        mobileNumberTextField.backgroundColor = .white
        mobileNumberTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mobileNumberTextField)
        
        submitButton = UIButton(type: .system)
        submitButton.setTitle("Submit", for: .normal)
        submitButton.setTitleColor(.black, for: .normal)
        submitButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        submitButton.addTarget(self, action: #selector(submitButtonClicked(_:)), for: .touchUpInside)
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        submitButton.backgroundColor = .white
        submitButton.layer.cornerRadius = 10
        view.addSubview(submitButton)
        
        NSLayoutConstraint.activate([
            welcomeLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            signupLabel.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 10),
            signupLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            
            usernameTextField.topAnchor.constraint(equalTo: signupLabel.bottomAnchor, constant: 10),
            usernameTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30),
            usernameTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30),
            usernameTextField.heightAnchor.constraint(equalToConstant: 40),
            
            passwordTextField.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor, constant: 20),
            passwordTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30),
            passwordTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30),
            passwordTextField.heightAnchor.constraint(equalToConstant: 40),
            
            mobileNumberTextField.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20),
            mobileNumberTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30),
            mobileNumberTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30),
            mobileNumberTextField.heightAnchor.constraint(equalToConstant: 40),
            
            submitButton.topAnchor.constraint(equalTo: mobileNumberTextField.bottomAnchor, constant: 30),
            submitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            submitButton.heightAnchor.constraint(equalToConstant: 50),
            submitButton.widthAnchor.constraint(equalToConstant: 340)
        ])
    }
    
    @objc private func submitButtonClicked(_ sender: UIButton) {
        guard let username = usernameTextField.text, !username.isEmpty,
              let password = passwordTextField.text, !password.isEmpty,
              let mobileNumber = mobileNumberTextField.text, isValidIndianMobileNumber(mobileNumber) else {
           
            showAlert(title: "Invalid Input", message: "Please fill out all fields with valid data.")
            return
        }
        
        sendMockOTPNotification()
        
        let otpVC = OtpVC()
        navigationController?.pushViewController(otpVC, animated: true)
    }

    private func sendMockOTPNotification() {
        let otp = "1234"
        
        let content = UNMutableNotificationContent()
        content.title = "OTP Received"
        content.body = "Your OTP is \(otp)"
        content.sound = .default
        
        content.userInfo = ["otp": otp]
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        
        let request = UNNotificationRequest(identifier: "OTPNotification", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error adding notification: \(error)")
            }
        }
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }

    @objc private func handleOTPNotification(_ notification: Notification) {
        if let userInfo = notification.userInfo, let otp = userInfo["otp"] as? String {
            let alert = UIAlertController(title: "OTP Received", message: "Your OTP is \(otp)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }

    private func isValidIndianMobileNumber(_ mobileNumber: String) -> Bool {
        let mobileNumberRegex = "^[6-9]\\d{9}$"
        let mobileNumberTest = NSPredicate(format: "SELF MATCHES %@", mobileNumberRegex)
        return mobileNumberTest.evaluate(with: mobileNumber)
    }

    @objc private func togglePasswordVisibility(_ sender: UIButton) {
        let shouldHidePassword = passwordTextField.isSecureTextEntry
        passwordTextField.isSecureTextEntry.toggle()
        let imageName = shouldHidePassword ? "eye.fill" : "eye.slash.fill"
        sender.setImage(UIImage(systemName: imageName), for: .normal)
    }

    private func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
