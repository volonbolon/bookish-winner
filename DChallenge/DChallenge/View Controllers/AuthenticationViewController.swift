//
//  AuthenticationViewController.swift
//  DChallenge
//
//  Created by Ariel Rodriguez on 31/10/2019.
//  Copyright © 2019 Ariel Rodriguez. All rights reserved.
//

import UIKit

class AuthenticationViewController: UIViewController {
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!

    fileprivate let networkManager = AuthenticationNetworkManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    // MARK: - Actions
    private func presentErrorMessage(title: String?, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let actionTitle = NSLocalizedString("OK", comment: "OK")
        let action = UIAlertAction(title: actionTitle, style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }

    private func processAuthentication(isRegistering: Bool) {
        guard let username = usernameTextField.text,
            let pswd = passwordTextField.text,
            username.count > 5,
            pswd.count > 5 else {
                let alertTitle = NSLocalizedString("Invalid tokens", comment: "Invalid tokens")
                let alertMessage = NSLocalizedString("Please, enter a valid username and password",
                                                     comment: "authentication error text")
                presentErrorMessage(title: alertTitle, message: alertMessage)
            return
        }
        networkManager.authenticate(username: username,
                                    pswd: pswd,
                                    isRegistering: isRegistering) { (result: Either<NetworkControllerError, AuthenticationNetworkManager.AuthToken>) in // swiftlint:disable:this line_length
            switch result {
            case .left(let error):
                DispatchQueue.main.async {
                    let alertTitle = NSLocalizedString("Error processing request",
                                                       comment: "Error processing request")
                    self.presentErrorMessage(title: alertTitle, message: error.localizedDescription)
                }
            case .right(let token):
                let sud = UserDefaults.standard
                sud.set(token, forKey: Constants.UserDefaultsKeys.AuthToken)
                DispatchQueue.main.async {
                    self.presentingViewController?.dismiss(animated: true, completion: nil)
                }
            }
        }
    }

    @IBAction func register(_ sender: Any) {
        processAuthentication(isRegistering: true)
    }

    @IBAction func login(_ sender: Any) {
        processAuthentication(isRegistering: false)
    }
}
