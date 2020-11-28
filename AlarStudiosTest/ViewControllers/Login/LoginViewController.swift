//
//  LoginViewController.swift
//  AlarStudiosTest
//
//  Created by Pavel Nadolski on 28.11.2020.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var lognTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lognTextField.delegate = self
        passwordTextField.delegate = self
    }


    @IBAction func didTapSignIn(_ sender: Any?) {
        guard let login = lognTextField.text, let password = passwordTextField.text else {
            return
        }
        
        Backend.login(login: login, password: password) { [weak self](result) in
            switch result {
            case .success(let responceCode):
                DispatchQueue.main.async {
                    self?.showDataViewController(code: responceCode)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.errorLabel.text = error.localizedDescription
                    self?.errorLabel.isHidden = false
                }
            }
        }
    }
    
    func showDataViewController(code:String) {
        let navigation = UINavigationController(rootViewController: DataViewController(code: code))
        navigation.modalPresentationStyle = .fullScreen
        self.present(navigation, animated: true, completion: nil)
    }
}

extension LoginViewController : UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.errorLabel.isHidden = true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
}
