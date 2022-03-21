//
//  LoginTableViewController.swift
//  MVVM-Example
//
//  Created by Nitesh on 21/03/22.
//

import UIKit

class LoginTableViewController: UITableViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    private var viewModel = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.errorMessage.bind {[weak self] errorMessage in
            guard let weakSelf = self else { return }
            guard let errorMessage = errorMessage, !errorMessage.isWhitespace else {
                return
            }
            weakSelf.showAlert(title: nil, message: errorMessage, buttonTitles: nil, highlightedButtonIndex: nil, completion: nil)
        }
        
        viewModel.canSubmit.bind { canSubmit in
            self.submitButton.isEnabled = canSubmit
        }
        
        self.emailTextField.text = "nitesh.isave@infinx.com"
        self.passwordTextField.text = "ssdasdas489r"
    }
    
    @IBAction func submitButtonAction(_ sender: Any) {
        self.dismissKeyboard()
        if viewModel.validateLogin(){
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let delegate = windowScene.delegate as? SceneDelegate else { return  }
            let postsTVC = PostsTableViewController()
            let rootVC = UINavigationController(rootViewController: postsTVC)
            delegate.window?.rootViewController = rootVC
            delegate.window?.makeKeyAndVisible()
            
        }
    }

}

extension LoginTableViewController: UITextFieldDelegate{
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField == emailTextField {
            viewModel.email = textField.text ?? ""
        }else if textField == passwordTextField{
            viewModel.password = textField.text ?? ""
        }
    }
    
}
