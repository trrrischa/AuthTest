//
//  AuthViewController.swift
//  AuthTest
//
//  Created by Ekaterina Nesterova on 11/03/2019.
//  Copyright © 2019 Ekaterina Nesterova. All rights reserved.
//

import UIKit
import Alamofire

class AuthViewController: UIViewController {
    
    @IBOutlet weak var forgetButton: UIButton!
    @IBOutlet weak var authView: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // UI appearance
        self.navigationItem.title = "Авторизация"
        self.forgetButton.layer.cornerRadius = 4
        self.forgetButton.layer.borderWidth = 1
        self.forgetButton.layer.borderColor = UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 1).cgColor
        
        //UITextField delegates

        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
        
        //keyboard notifications
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tap))
        self.view.addGestureRecognizer(tapGesture)

    }
    
    // MARK: - Private
    private func requestWeather() {
        self.view.endEditing(true)
        let url = APPURL.OpenWeather + APPURL.Query.key + "Cupertino" + "&" + APPURL.Query.appIdKey + APPKey.appkey
        request(url)
            .responseJSON
             { response in
                switch response.result {
                case .success:
                    guard let jsonData = response.data else { return }
                    let weather: Weather = try! JSONDecoder().decode(Weather.self, from: jsonData)
                    let weatherMessage = "Current weather in \(weather.name ?? ""):\nhumidity: \(weather.main.humidity ?? 0)%\npressure: \(weather.main.pressure ?? 0)\ntemp: \(weather.main.temp ?? 0)"
                    let alert = UIAlertController(title: nil, message: weatherMessage, preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default, handler:nil)
                    alert.addAction(okAction)
                    self.present(alert, animated: true, completion: nil)
                case .failure(let error):
                    let alert = UIAlertController(title: nil, message: error.localizedDescription, preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default, handler:nil)
                    alert.addAction(okAction)
                    self.present(alert, animated: true, completion: nil)
                }
        }
    }

    // MARK: - keyboard events
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
//            self.centerConstraint.priority = UILayoutPriority(rawValue: 250)
//            self.topConstraint.priority = UILayoutPriority(rawValue: 1000)
//            let diff = (self.view.frame.size.height - keyboardSize.height)/2 - self.authView.frame.size.height/2
//            self.topConstraint.constant = diff;
            
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height/2
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    //MARK: - Gestures
    
    @objc func tap() {
        self.view.endEditing(true)
    }

    //MARK: - Fields validation
    func validateEmail(email: String) -> Bool {
        let validator = Validator()
        do {
            try validator.checkEmail(email: email)
        }
        catch let error as Validator.Errors {
            let alert = UIAlertController(title: nil, message: error.errorDescription, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler:nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
            return false
        }
        catch {
            return false
        }
        return true
    }
    
    func validatePassword(password: String) -> Bool {
        let validator = Validator()
        do {
            try validator.checkPassword(password: password)
        }
        catch let error as Validator.Errors {
            let alert = UIAlertController(title: nil, message: error.errorDescription, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler:nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
            return false
        }
        catch {
            return false
        }
        return true
    }

    //MARK: - Actions
    
    @IBAction func forgetPressed(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: "Вспоминаем пароль!", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler:nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func enterPressed(_ sender: Any) {
        if let email = self.emailTextField.text {
            if !self.validateEmail(email: email) {
                return
            }
        }
        if let password = self.passwordTextField.text {
            if !self.validatePassword(password: password) {
                return
            }
            self.requestWeather()
        }
    }
    
    @IBAction func createPressed(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: "Создаем аккаунт!", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler:nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension AuthViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.emailTextField {
            if let email = self.emailTextField.text {
                if !self.validateEmail(email: email) {
                    return false
                }
                self.passwordTextField.becomeFirstResponder()
            }
        }
        if textField == self.passwordTextField {
            if let password = self.passwordTextField.text {
                if !self.validatePassword(password: password) {
                    return false
                }
                self.requestWeather()
            }
        }
        return true
    }
        
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField == self.emailTextField {
            if let email = self.emailTextField.text {
                if !self.validateEmail(email: email) {
                    return false
                }
            }
        }
        if textField == self.passwordTextField {
            if let password = self.passwordTextField.text {
                if !self.validatePassword(password: password) {
                    return false
                }
            }
        }
        return true

    }
}
