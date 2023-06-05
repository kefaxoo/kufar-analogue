//
//  SignViewController.swift
//  kufar-analogue
//
//  Created by Bahdan Piatrouski on 13.04.23.
//

import UIKit
import FirebaseAuth
import SPIndicator
import FirebaseFirestore

class SignViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var forgetPasswordButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var inputBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var loadingView: UIView!
    
    private var signType: SignType = .signIn
    
    weak var delegate: ViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setInterface()
        setObservers()
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
    }
    
    private func setupLocalization(){
        emailTextField.placeholder = Localization.TextField.Placeholder.typeSomething.rawValue.localizedWithParameter(text: "email")
        passwordTextField.placeholder = Localization.TextField.Placeholder.typeSomething.rawValue.localizedWithParameter(text: Localization.Words.password.rawValue.localized)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        if signType == .signUp {
            self.navigationController?.navigationBar.backItem?.title = Localization.NavigationBar.signIn.rawValue.localized
        } else {
            self.navigationItem.title = nil
        }
        
        if Auth.auth().currentUser != nil {
            Firestore.firestore().collection("users").getDocuments { querySnapshot, error in
                if let error {
                    SPIndicator.present(title: Localization.Indicator.Title.error.localized, message: error.localizedDescription, preset: .error, haptic: .error, from: .top)
                } else {
                    var usersAndRoles = [UserModel]()
                    querySnapshot?.documents.forEach { document in
                        guard let user = UserModel(JSON: document.data()) else { return }
                        
                        usersAndRoles.append(user)
                    }
            
                    guard let currentEmail = Auth.auth().currentUser?.email,
                          let userFromDb = usersAndRoles.first(where: { $0.email == currentEmail }) else {
                        // TODO: Indicator
                        return
                    }
                    
                    if userFromDb.role == "agent" {
                        let agentTabBarController = AgentTabBarController(nibName: nil, bundle: nil)
                        agentTabBarController.modalPresentationStyle = .fullScreen
                        self.present(agentTabBarController, animated: false)
                    } else {
                        let postsVC = UserViewController(nibName: UserViewController.id, bundle: nil)
                        postsVC.set(.user)
                        let navPostsVC = postsVC.configureNavigationController(title: "Posts")
                        navPostsVC.modalPresentationStyle = .fullScreen
                        self.present(navPostsVC, animated: false)
                    }
                }
            }
        } else {
            loadingView.isHidden = true
        }
    }
    
    func set(_ type: SignType) {
        self.signType = type
    }
    
    @objc private func dismissKeyboard(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    private func setObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: NSNotification) {
        if emailTextField.isEditing || passwordTextField.isEditing {
            moveViewWithKeyboard(notification: notification, viewBottomConstraint: inputBottomConstraint, keyboardWillShow: true)
        }
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification) {
        moveViewWithKeyboard(notification: notification, viewBottomConstraint: inputBottomConstraint, keyboardWillShow: false)
    }
    
    func moveViewWithKeyboard(notification: NSNotification, viewBottomConstraint: NSLayoutConstraint, keyboardWillShow: Bool) {
        // Keyboard's size
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        let keyboardHeight = keyboardSize.height
        
        // Keyboard's animation duration
        let keyboardDuration = notification.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
        
        // Keyboard's animation curve
        let keyboardCurve = UIView.AnimationCurve(rawValue: notification.userInfo![UIResponder.keyboardAnimationCurveUserInfoKey] as! Int)!
        
        // Change the constant
        if keyboardWillShow {
            let safeAreaExists = (self.view?.window?.safeAreaInsets.bottom != 0) // Check if safe area exists
            let bottomConstant: CGFloat = 20
            viewBottomConstraint.constant = keyboardHeight + (safeAreaExists ? 0 : bottomConstant)
        }else {
            viewBottomConstraint.constant = 20
        }
        
        // Animate the view the same way the keyboard animates
        let animator = UIViewPropertyAnimator(duration: keyboardDuration, curve: keyboardCurve) { [weak self] in
            // Update Constraints
            self?.view.layoutIfNeeded()
        }
        
        // Perform the animation
        animator.startAnimation()
    }
    
    private func setInterface() {
        self.navigationController?.navigationBar.tintColor = UIColor.systemPurple
        if signType == .signIn {
            forgetPasswordButton.isHidden = false
            signInButton.isHidden = false
        } else if signType == .signUp {
            forgetPasswordButton.isHidden = true
            signInButton.isHidden = true
        }
    }
    
    @IBAction func forgetPasswordAction(_ sender: Any) {
        guard let email = emailTextField.text, !email.isEmpty else {
            SPIndicator.present(title: Localization.Indicator.Title.error.localized, message: Localization.Indicator.Message.emailIsEmpty.rawValue.localized, preset: .error, haptic: .error, from: .top)
            return
        }
        
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                SPIndicator.present(title: Localization.Indicator.Title.error.localized, message: error.localizedDescription, preset: .error, haptic: .error, from: .top)
            } else {
                SPIndicator.present(title: Localization.Indicator.Title.resetPasswordMessageWasSent.localized, preset: .done, haptic: .success, from: .top)
            }
        }
    }
    
    @IBAction func signInAction(_ sender: Any) {
        guard let email = emailTextField.text, !email.isEmpty else {
            SPIndicator.present(title: Localization.Indicator.Title.error.localized, message: Localization.Indicator.Message.emailIsEmpty.rawValue.localized, preset: .error, haptic: .error, from: .top)
            return
        }
        
        guard let password = passwordTextField.text, !password.isEmpty else {
            SPIndicator.present(title: Localization.Indicator.Title.error.localized, message: Localization.Indicator.Message.passwordIsEmpty.rawValue.localized, preset: .error, haptic: .error, from: .top)
            return
        }
        
        var usersAndRoles = [UserModel]()
        Firestore.firestore().collection("users").getDocuments { querySnapshot, error in
            if let error {
                SPIndicator.present(title: Localization.Indicator.Title.error.localized, message: error.localizedDescription, preset: .error, haptic: .error, from: .top)
            } else {
                querySnapshot?.documents.forEach { document in
                    guard let user = UserModel(JSON: document.data()) else { return }
                    
                    usersAndRoles.append(user)
                }
                
                guard let userFromDb = usersAndRoles.first(where: { $0.email == email }) else {
                    // TODO: Indicator
                    return
                }
                
                Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                    if let error {
                        SPIndicator.present(title: Localization.Indicator.Title.error.localized, message: error.localizedDescription, preset: .error, haptic: .error, from: .top)
                    } else {
                        if let user = Auth.auth().currentUser {
                            if user.isEmailVerified {
                                if userFromDb.role == "agent" {
                                    let agentTabBarController = AgentTabBarController(nibName: nil, bundle: nil)
                                    agentTabBarController.modalPresentationStyle = .fullScreen
                                    self.present(agentTabBarController, animated: false)
                                } else {
                                    let postsVC = UserViewController(nibName: UserViewController.id, bundle: nil)
                                    postsVC.set(.user)
                                    let navPostsVC = postsVC.configureNavigationController(title: "Posts")
                                    navPostsVC.modalPresentationStyle = .fullScreen
                                    self.present(navPostsVC, animated: false)
                                }
                            } else {
                                SPIndicator.present(title: Localization.Indicator.Title.error.localized, message: Localization.Indicator.Message.verifyEmail.rawValue.localized, preset: .error, haptic: .error, from: .top)
                            }
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func signUpAction(_ sender: Any) {
        if signType == .signIn {
            let signVC = SignViewController(nibName: SignViewController.id, bundle: nil)
            signVC.set(.signUp)
            self.navigationController?.pushViewController(signVC, animated: true)
        } else if signType == .signUp {
            guard let email = emailTextField.text, !email.isEmpty else {
                SPIndicator.present(title: Localization.Indicator.Title.emailIsEmpty.rawValue.localized, preset: .error, haptic: .error, from: .top)
                return
            }
            
            guard let password = passwordTextField.text, !password.isEmpty else {
                SPIndicator.present(title: Localization.Indicator.Title.passwordIsEmpty.rawValue.localized, preset: .error, haptic: .error, from: .top)
                return
            }
            
            let db = Firestore.firestore()
            let id = email
            db.collection("users").document(id).setData([
                "email": email,
                "role": "user"
            ]) { error in
                if let error {
                    SPIndicator.present(title: Localization.Indicator.Title.error.localized, message: error.localizedDescription, preset: .error, haptic: .error, from: .top)
                } else {
                    Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                        if let error {
                            SPIndicator.present(title: Localization.Indicator.Title.error.rawValue.localized, message: error.localizedDescription, preset: .error, haptic: .error, from: .top)
                        } else {
                            guard let authResult else { return }
                            
                            authResult.user.sendEmailVerification(completion: { error in
                                if let error = error {
                                    SPIndicator.present(title: Localization.Indicator.Title.error.rawValue.localized, message: error.localizedDescription, preset: .error, haptic: .error, from: .top)
                                } else {
                                    SPIndicator.present(title: Localization.Indicator.Title.verificationSent.rawValue.localized, message: Localization.Indicator.Message.plsCheckUrEmailForConfirmNewEmail.rawValue.localized, preset: .done, haptic: .success, from: .top)
                                    self.signType = .signIn
                                    UIView.animate(withDuration: 1) {
                                        self.setInterface()
                                    }
                                }
                            })
                        }
                    }
                }
            }
        }
    }
}
