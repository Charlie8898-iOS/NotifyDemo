//
//  HomeVC.swift
//  NotifyDemo
//
//  Created by Apple on 16/11/24.
//

import UIKit

class HomeVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupLogoutButton()
    }

    private func setupUI() {
        view.backgroundColor = .black

        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)

        let imageView = UIImageView()
        imageView.image = UIImage(named: "Home")
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 100
        imageView.clipsToBounds = true

        imageView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 200).isActive = true

        stackView.addArrangedSubview(imageView)

        let label1 = UILabel()
        label1.text = "Our Earth, Our Responsibility."
        label1.textColor = .white
        label1.font = UIFont.boldSystemFont(ofSize: 20)
        label1.textAlignment = .center

        let label2 = UILabel()
        label2.text = "Protect the Environment for Future Generations."
        label2.textColor = .white
        label2.font = UIFont.systemFont(ofSize: 16)
        label2.textAlignment = .center

        stackView.addArrangedSubview(label1)
        stackView.addArrangedSubview(label2)

        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func setupLogoutButton() {
        let logoutButton = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoutButtonClicked))
        logoutButton.tintColor = .white
        navigationItem.rightBarButtonItem = logoutButton
    }

    @objc private func logoutButtonClicked() {
        let secondVC = SecondVC()
        navigationController?.pushViewController(secondVC, animated: true)
        secondVC.navigationItem.hidesBackButton = true
    }
}
