import UIKit
import FirebaseAuth
import FirebaseCore
import FirebaseDatabase
import SwiftSMTP

class UserRegisterViewIDPWController: UIViewController {    
    
    var isEmailVerified = false
    
    var verificationCodeTextField: UITextField!
    
    let viewModel = UserRegisterViewModel()
    
    let buttonTitle = "회원가입"
    
    let cells = ["회원 이메일","회원 비밀번호","이름","전화번호"]
    
    var cellData:[String] = []
    
    let cellHeight = 45
    let emptyCellHeight = 24
    
    var idCell:TextFieldCell = TextFieldCell()
    var pwCell:TextFieldCell = TextFieldCell()
    var nameCell:TextFieldCell = TextFieldCell()
    var phoneCell:TextFieldCell = TextFieldCell()
    
    let viewConfigure = LoginUserRegisterView()
    
    private var isCellEmpty = true
    private var isNotVerified = true
    
    override func loadView() {
        viewConfigure.textView.isHidden = true
        viewConfigure.button.setTitle(buttonTitle, for: .normal)
        
        view = viewConfigure
        
        let maped = cells.map{ [$0] }
        let joined = Array(maped.joined(separator: [""]))
        cellData = joined
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewConfigure.tableView.dataSource = self
        self.viewConfigure.button.backgroundColor = .lightGray
    }
    
    override func viewWillAppear(_ animated: Bool) { // 네비게이션바 보여주기
        navigationController?.navigationBar.isHidden = false
        setCustomBackButton()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        viewConfigure.button.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
        
        idCell.textField.addTarget(self, action: #selector(didChangeText), for: .editingChanged)
        pwCell.textField.addTarget(self, action: #selector(didChangeText), for: .editingChanged)
        nameCell.textField.addTarget(self, action: #selector(didChangeText), for: .editingChanged)
        phoneCell.textField.addTarget(self, action: #selector(didChangeText), for: .editingChanged)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        viewConfigure.endEditing(true)
    }
    
    private func buttonOnCheck() {
        if isCellEmpty {
            self.viewConfigure.button.backgroundColor = .lightGray
        } else {
            if isEmailVerified {
                self.viewConfigure.button.backgroundColor = ColorGuide.main
            } else {
                self.viewConfigure.button.backgroundColor = .lightGray
            }
        }
    }
    func setCustomBackButton() {
        navigationController?.navigationBar.tintColor = .black
    }
    
    
    @objc private func didChangeText(){
        if idCell.textField.text != "" && pwCell.textField.text != "" && nameCell.textField.text != "" && phoneCell.textField.text != "" {
            isCellEmpty = false
        }else{
            isCellEmpty = true
        }
        buttonOnCheck()
    }
    @objc func buttonClicked() {
        if isCellEmpty {
            self.showToastStatic(message: "모든 칸을 입력해 주세요.", view: self.view)
        } else {
            if isEmailVerified {
                createUser()
            } else {
                self.showToastStatic(message: "이메일 인증이 필요합니다.", view: self.view)
            }
        }
    }
    
    @objc func emailButtonClicked() {
        guard let id = idCell.textField.text else {
            return
        }
        // 이메일이 비어있는지 확인
        guard !id.isEmpty else {
            print("확인할 이메일: \(id)")
            showToastStatic(message: "이메일을 입력해 주세요.", view: view)
            return
        }
        // 백그라운드 스레드에서 이메일 보내기
        DispatchQueue.global().async {
            user_email = id
            self.sendEmail()
            print(user_email)
            print(content)
        }
    }
    
    func sendEmail() {
        smtp.send(mail) { (error) in
            print(error)
            DispatchQueue.main.async {
                if let error = error {
                    print("이메일 전송 실패: \(error.localizedDescription)")
                    // 실패에 대한 처리 (UI 업데이트 등)
                } else {
                    print("이메일 전송 성공!")
                    self.showToastStatic(message: "이메일을 성공적으로 보냈습니다.", view: self.view ?? UIView())
                    // 성공에 대한 처리 (UI 업데이트 등)
                    self.showVerificationCodeInputAlert()
                }
            }
        }
    }
    
    func showVerificationCodeInputAlert() {
        let alertController = UIAlertController(title: "인증 코드 입력", message: "이메일로 전송된 코드를 입력하세요.", preferredStyle: .alert)

        alertController.addTextField { textField in
            textField.placeholder = "인증 코드"
        }

        let confirmAction = UIAlertAction(title: "확인", style: .default) { [weak self] _ in
            guard let verificationCode = alertController.textFields?.first?.text, !verificationCode.isEmpty else {
                // 인증 코드가 비어있는 경우
                self?.showToastStatic(message: "인증 코드를 입력해 주세요.", view: self?.view ?? UIView())
                return
            }

            // TODO: 입력된 인증 코드를 검증하는 로직을 추가 (서버에서 확인하거나, 이메일로 전송된 코드와 비교 등)

            if verificationCode == certiNumber {
                self?.showToastStatic(message: "이메일 인증이 성공했습니다.", view: self?.view ?? UIView())
                self?.isEmailVerified = true
                self?.buttonOnCheck() // 버튼 색상 업데이트
                // TODO: 인증 성공 시 추가 처리 로직을 여기에 추가
            } else {
                self?.showToastStatic(message: "인증 코드가 일치하지 않습니다.", view: self?.view ?? UIView())
            }
        }

        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)

        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)

        present(alertController, animated: true, completion: nil)
    }

    
}

extension UserRegisterViewIDPWController {
    // MARK: - 회원가입
    // 일단 유저만 가입 (accountType: 2)
    // 트레이너는 따로 버튼을 만드는 것도 고려해볼만?
    func createUser() {
        guard let id = idCell.textField.text else { return }
        guard let pw = pwCell.textField.text else { return }
        guard let name = nameCell.textField.text else { return }
        guard let phone = phoneCell.textField.text else { return }

        let tempUser = User(account: Account(id: id, accountType: 2), name: name, number: phone, startSubscriptionDate: Date(timeIntervalSinceReferenceDate: 0), endSubscriptionDate: Date(timeIntervalSinceReferenceDate: 0), userInfo: "임시", isInGym: false, adminUid: "임시")
        
        Auth.auth().createUser(withEmail: id, password: pw) { result, error in
            if let error = error {
                print(error.localizedDescription)
                switch error.localizedDescription {
                case "The email address is badly formatted.":
                    print("이메일 잘못됨")
                    self.showToastStatic(message: "이메일 형식이 잘못되었습니다.", view: self.view)
                case "The email address is already in use by another account.":
                    self.showToastStatic(message: "중복된 이메일 주소입니다.", view: self.view)
                case "The password must be 6 characters long or more.":
                    self.showToastStatic(message: "비밀번호는 6자 이상이어야 합니다.", view: self.view)
                default:
                    print("테스트 - 알수없는오류")
                }
            } else {
                do {
                    let userData = try JSONEncoder().encode(tempUser)
                    let userJSON = try JSONSerialization.jsonObject(with: userData, options: [])
                    
                    if let user = result?.user {
                        let userRef = Database.database().reference().child("accounts").child(user.uid)
                        userRef.setValue(userJSON)
                        
                    }
                    
                    let vc = QrCodeViewController()
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: true)
                    self.navigationController?.popViewController(animated: false)
                } catch {
                    print("JSON 인코딩 에러")
                }
            }
        }
    }
    
    // MARK: - 로그아웃
    
    func signOut() {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
}

//UserRegisterViewIDPWController


extension UserRegisterViewIDPWController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if cellData[indexPath.row] == "회원 이메일" {
            let cell = TextFieldCell()
            cell.layer.addBorder([.bottom], color: ColorGuide.shadowBorder, width: 1.0)
            cell.placeHolderLabel.text = cellData[indexPath.row]
            cell.setButton("인증")
            cell.CheckButton.addTarget(self, action: #selector(emailButtonClicked), for: .touchUpInside)
            idCell = cell
            return cell
        }else if cellData[indexPath.row] == "회원 비밀번호" {
            let cell = TextFieldCell()
            cell.layer.addBorder([.bottom], color: ColorGuide.shadowBorder, width: 1.0)
            cell.placeHolderLabel.text = cellData[indexPath.row]
            pwCell = cell
            return cell
        }
        else if cellData[indexPath.row] == "이름" {
            let cell = TextFieldCell()
            cell.layer.addBorder([.bottom], color: ColorGuide.shadowBorder, width: 1.0)
            cell.placeHolderLabel.text = cellData[indexPath.row]
            nameCell = cell
            return cell
        }
        else if cellData[indexPath.row] == "전화번호" {
            let cell = TextFieldCell()
            cell.layer.addBorder([.bottom], color: ColorGuide.shadowBorder, width: 1.0)
            cell.placeHolderLabel.text = cellData[indexPath.row]
            phoneCell = cell
            return cell
        }
        else {
            return EmptyCell()
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if cellData[indexPath.row] == "" {
            return CGFloat(emptyCellHeight)
        } else {
            return CGFloat(cellHeight)
        }
    }

}

