//
//  OtpVC.swift
//  NotifyDemo
//
//  Created by Apple on 16/11/24.
//

import UIKit
import UserNotifications

class OtpVC: UIViewController, UNUserNotificationCenterDelegate {

    private var otpTitleLabel: UILabel!
    private var otpInstructionLabel: UILabel!
    
    private var otpTextFields: [UITextField] = []
    private var submitButton: UIButton!
    private var resendButton: UIButton!
    
    private var currentOTP: String = ""

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

        generateNewOTP()
    }

    private func setupUI() {
        otpTitleLabel = UILabel()
        otpTitleLabel.text = "OTP Verification"
        otpTitleLabel.textColor = .white
        otpTitleLabel.font = UIFont.boldSystemFont(ofSize: 22)
        otpTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(otpTitleLabel)

        otpInstructionLabel = UILabel()
        otpInstructionLabel.text = "Please enter the OTP "
        otpInstructionLabel.textColor = .white
        otpInstructionLabel.font = UIFont.systemFont(ofSize: 16)
        otpInstructionLabel.translatesAutoresizingMaskIntoConstraints = false
        otpInstructionLabel.textAlignment = .center
        view.addSubview(otpInstructionLabel)

        for i in 0..<4 {
            let otpTextField = UITextField()
            otpTextField.placeholder = "0"
            otpTextField.keyboardType = .numberPad
            otpTextField.borderStyle = .roundedRect
            otpTextField.textColor = .black
            otpTextField.translatesAutoresizingMaskIntoConstraints = false
            otpTextField.textAlignment = .center
            otpTextField.isSecureTextEntry = false

            otpTextFields.append(otpTextField)
            view.addSubview(otpTextField)
        }

        submitButton = UIButton(type: .system)
        submitButton.setTitle("Submit", for: .normal)
        submitButton.addTarget(self, action: #selector(submitButtonClicked(_:)), for: .touchUpInside)
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        submitButton.backgroundColor = .white
        submitButton.setTitleColor(.black, for: .normal)
        submitButton.layer.cornerRadius = 10
        submitButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        view.addSubview(submitButton)
        
        resendButton = UIButton(type: .system)
        resendButton.setTitle("Resend OTP", for: .normal)
        resendButton.addTarget(self, action: #selector(resendButtonClicked(_:)), for: .touchUpInside)
        resendButton.translatesAutoresizingMaskIntoConstraints = false
        resendButton.backgroundColor = .black
        resendButton.setTitleColor(.white, for: .normal)
        resendButton.layer.cornerRadius = 10
        resendButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        view.addSubview(resendButton)

        NSLayoutConstraint.activate([
            otpTitleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            otpTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            otpInstructionLabel.topAnchor.constraint(equalTo: otpTitleLabel.bottomAnchor, constant: 20),
            otpInstructionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            otpInstructionLabel.widthAnchor.constraint(equalToConstant: 250),

            otpTextFields[0].topAnchor.constraint(equalTo: otpInstructionLabel.bottomAnchor, constant: 20),
            otpTextFields[0].leftAnchor.constraint(equalTo: view.centerXAnchor, constant: -120),
            otpTextFields[1].topAnchor.constraint(equalTo: otpInstructionLabel.bottomAnchor, constant: 20),
            otpTextFields[1].leftAnchor.constraint(equalTo: otpTextFields[0].rightAnchor, constant: 10),
            otpTextFields[2].topAnchor.constraint(equalTo: otpInstructionLabel.bottomAnchor, constant: 20),
            otpTextFields[2].leftAnchor.constraint(equalTo: otpTextFields[1].rightAnchor, constant: 10),
            otpTextFields[3].topAnchor.constraint(equalTo: otpInstructionLabel.bottomAnchor, constant: 20),
            otpTextFields[3].leftAnchor.constraint(equalTo: otpTextFields[2].rightAnchor, constant: 10),
            otpTextFields[0].widthAnchor.constraint(equalToConstant: 50),
            otpTextFields[1].widthAnchor.constraint(equalToConstant: 50),
            otpTextFields[2].widthAnchor.constraint(equalToConstant: 50),
            otpTextFields[3].widthAnchor.constraint(equalToConstant: 50),
            otpTextFields[0].heightAnchor.constraint(equalToConstant: 50),
            otpTextFields[1].heightAnchor.constraint(equalToConstant: 50),
            otpTextFields[2].heightAnchor.constraint(equalToConstant: 50),
            otpTextFields[3].heightAnchor.constraint(equalToConstant: 50),

            submitButton.topAnchor.constraint(equalTo: otpTextFields[0].bottomAnchor, constant: 30),
            submitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            submitButton.heightAnchor.constraint(equalToConstant: 50),
            submitButton.widthAnchor.constraint(equalToConstant: 200),

            resendButton.topAnchor.constraint(equalTo: submitButton.bottomAnchor, constant: 20),
            resendButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            resendButton.heightAnchor.constraint(equalToConstant: 50),
            resendButton.widthAnchor.constraint(equalToConstant: 200)
        ])
    }

    @objc private func submitButtonClicked(_ sender: UIButton) {
        let enteredOTP = otpTextFields.map { $0.text ?? "" }.joined()
        
        if enteredOTP == currentOTP {
            let homeVC = HomeVC()
            homeVC.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(homeVC, animated: true)
        } else {
            showAlert(message: "Invalid OTP. Please try again.")
        }
    }

    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    @objc private func resendButtonClicked(_ sender: UIButton) {
        generateNewOTP()
    }

    private func generateNewOTP() {
        currentOTP = String(format: "%04d", Int.random(in: 0...9999))
        print("Generated OTP: \(currentOTP)")
        
        sendOTPNotification(otp: currentOTP)
    }

    private func sendOTPNotification(otp: String) {
        let content = UNMutableNotificationContent()
        content.title = "New OTP Received"
        content.body = "Your OTP is \(otp)"
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        
        let request = UNNotificationRequest(identifier: "OTPNotification", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    for (index, char) in self.currentOTP.enumerated() {
                        self.otpTextFields[index].text = String(char)
                    }
                }
            }
        }
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
}
