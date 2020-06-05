//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Timur Krüger on 01.06.20.
//  Copyright © 2020 Timur. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - Properties
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    
    // MARK: - View Handling
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        emailTextField.text = ""
        passwordTextField.text = ""
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    // MARK: - Login Button
    @IBAction func loginTapped(_ sender: UIButton) {
        setLoggingIn(true)
        activityIndicator.startAnimating()
        UdacityClient.login(username: emailTextField.text ?? "", password: passwordTextField.text ?? "", completion: handleLoginResponse(newData:error:))
    }
    
    // MARK: - Login Response
    func handleLoginResponse(newData: Data?, error: Error?) {
        if let newData = newData {
            do {
                let decoder = JSONDecoder()
                let responseObject = try decoder.decode(LoginResponse.self, from: newData)
                Auth.sharedInstance.id = responseObject.account.key
                getUserInformation()
                DispatchQueue.main.async {
                    self.setLoggingIn(false)
                    self.activityIndicator.stopAnimating()
                    self.performSegue(withIdentifier: "completeLogin", sender: nil)
                }
            } catch {
                DispatchQueue.main.async {
                    self.showLoginFailure(message: "Login error!")
                }
            }
        } else {
            DispatchQueue.main.async {
                self.showLoginFailure(message: "Network error!")
            }
        }
        setLoggingIn(false)
    }
    
    
    // MARK: - Get user information from Login
    func getUserInformation() {
        UdacityClient.getUserInfo(userId: Auth.sharedInstance.id) { (data, error) in
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let responseObject = try decoder.decode(UserResponse.self, from: data)
                    Auth.sharedInstance.firstName = responseObject.first_name
                    Auth.sharedInstance.lastName = responseObject.last_name
                } catch {
                    print("Failed to get Account!")
                }
            }
        }
    }
    
    // MARK: - Signup Button
    @IBAction func signUpTapped() {
        let url = URL(string: "https://www.udacity.com")!
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    // MARK: - UITextFieldDelegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if emailTextField.text == "Email" && emailTextField.isEditing {
            emailTextField.text = ""
        }
        if passwordTextField.text == "Password" && passwordTextField.isEditing {
            passwordTextField.text = ""
        }
    }
    
    func setLoggingIn(_ loggingIn: Bool) {
        DispatchQueue.main.async {
            self.emailTextField.isEnabled = !loggingIn
            self.passwordTextField.isEnabled = !loggingIn
            self.loginButton.isEnabled = !loggingIn
        }
    }
    
    func showLoginFailure(message: String) {
        let alertVC = UIAlertController(title: "Login Failed", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        show(alertVC, sender: nil)
    }
}
