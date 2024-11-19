//
//  SecondVC.swift
//  NotifyDemo
//
//  Created by Apple on 16/11/24.
//

import UIKit

class SecondVC: UIViewController {

    private let usernameTextField = UITextField()
    private let passwordTextField = UITextField()
    private let loginButton = UIButton()
    private let forgotPasswordButton = UIButton()
    private let signupButton = UIButton()

    private let notifyLabel = UILabel()
    
    private let loginLabel: UILabel = {
        let label = UILabel()
        label.text = "Login"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .white
        label.textAlignment = .left
        return label
    }()

    private let passwordToggleButton: UIButton = {
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
        passwordToggleButton.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
    }

    private func setupUI() {
        usernameTextField.placeholder = "Username"
        usernameTextField.borderStyle = .roundedRect
        usernameTextField.backgroundColor = .white
        usernameTextField.textColor = .black
        usernameTextField.font = UIFont.boldSystemFont(ofSize: 16)
        usernameTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(usernameTextField)
        
        passwordTextField.placeholder = "Password"
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.isSecureTextEntry = true
        passwordTextField.backgroundColor = .white
        passwordTextField.textColor = .black
        passwordTextField.font = UIFont.boldSystemFont(ofSize: 16)
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        
        passwordTextField.rightView = passwordToggleButton
        passwordTextField.rightViewMode = .always
        view.addSubview(passwordTextField)

        loginButton.setTitle("Login", for: .normal)
        loginButton.backgroundColor = .white
        loginButton.setTitleColor(.black, for: .normal)
        loginButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        loginButton.layer.cornerRadius = 5
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        view.addSubview(loginButton)

        forgotPasswordButton.setTitle("Forgot Password?", for: .normal)
        forgotPasswordButton.setTitleColor(.white, for: .normal)
        forgotPasswordButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        forgotPasswordButton.translatesAutoresizingMaskIntoConstraints = false
        forgotPasswordButton.addTarget(self, action: #selector(forgotPasswordButtonTapped), for: .touchUpInside)
        view.addSubview(forgotPasswordButton)

        signupButton.setTitle("New to NotifyDemo? Sign up now", for: .normal)
        signupButton.setTitleColor(.white, for: .normal)
        signupButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        signupButton.translatesAutoresizingMaskIntoConstraints = false
        signupButton.addTarget(self, action: #selector(singupButtonTapped), for: .touchUpInside)
        view.addSubview(signupButton)

        notifyLabel.text = "Welcome to NotifyDemo"
        notifyLabel.font = UIFont.monospacedSystemFont(ofSize: 25, weight: .bold)
        notifyLabel.textColor = .white
        notifyLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(notifyLabel)
        
        loginLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loginLabel)

        setupConstraints()
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            notifyLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            notifyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            loginLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            loginLabel.topAnchor.constraint(equalTo: notifyLabel.bottomAnchor, constant: 10),
            
            usernameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            usernameTextField.topAnchor.constraint(equalTo: loginLabel.bottomAnchor, constant: 10),
            usernameTextField.widthAnchor.constraint(equalToConstant: 340),
            usernameTextField.heightAnchor.constraint(equalToConstant: 40),

            passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordTextField.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor, constant: 30),
            passwordTextField.widthAnchor.constraint(equalToConstant: 340),
            passwordTextField.heightAnchor.constraint(equalToConstant: 40),

            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 30),
            loginButton.widthAnchor.constraint(equalToConstant: 340),
            loginButton.heightAnchor.constraint(equalToConstant: 50),

            forgotPasswordButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            forgotPasswordButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 30),

            signupButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signupButton.topAnchor.constraint(equalTo: forgotPasswordButton.bottomAnchor, constant: 25)
        ])
    }

    @objc private func togglePasswordVisibility() {
        isPasswordHidden.toggle()
        passwordTextField.isSecureTextEntry = isPasswordHidden
        
        let imageName = isPasswordHidden ? "eye.slash.fill" : "eye.fill"
        passwordToggleButton.setImage(UIImage(systemName: imageName), for: .normal)
    }

    @objc private func loginButtonTapped() {
        guard let username = usernameTextField.text, !username.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            showAlert(title: "Error", message: "Please enter both username and password.")
            return
        }

        let homeVC = HomeVC()
        navigationController?.pushViewController(homeVC, animated: true)
        showAlert(title: "Login", message: "You have successfully logged in!")
    }

    @objc private func forgotPasswordButtonTapped() {
        let forgotVC = ForgotVC()
        navigationController?.pushViewController(forgotVC, animated: true)
        showAlert(title: "Forgot Password", message: "Forgot password flow initiated.")
    }

    @objc private func singupButtonTapped() {
        let singupVC = SingupVC()
        navigationController?.pushViewController(singupVC, animated: true)
    }

    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
