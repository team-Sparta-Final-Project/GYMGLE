import UIKit
import FirebaseAuth
import FirebaseCore
import FirebaseDatabase

class UserRegisterViewIDPWController: UIViewController {
    
    var pageTitle = "회원 등록"
    let buttonTitle = "등록하기"
    
    let cells = ["회원 아이디","회원 비밀번호"]
    let labelCells = [""]
    let buttonCells = ["회원 아이디"]
    let buttonText = ["중복 확인"]
    
    var needIdPwUser:User?
    
    let cellHeight = 45
    let emptyCellHeight = 24
    
    let viewConfigure = UserRegisterView()
    
    private var isCellEmpty = true
    private var isNotVerified = true
    
    override func loadView() {
        viewConfigure.textView.isHidden = true
        viewConfigure.heightConfigure(cellHeight: cellHeight, emptyCellHeight: emptyCellHeight)
        viewConfigure.dataSourceConfigure(
            cells: cells,
            labels: labelCells,
            buttons: buttonCells,
            buttonText: buttonText
        )
        viewConfigure.label.text = pageTitle
        viewConfigure.button.setTitle(buttonTitle, for: .normal)
        
        view = viewConfigure
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.viewConfigure.button.backgroundColor = .lightGray
        viewConfigure.button.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
        
    }
    
    override func viewWillAppear(_ animated: Bool) { // 네비게이션바 보여주기
        navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let idCell = self.viewConfigure.tableView.subviews[2] as? UITableViewCell
        let idField = idCell?.contentView.subviews[1] as? UITextField
        let pwCell = self.viewConfigure.tableView.subviews[0] as? UITableViewCell
        let pwField = pwCell?.contentView.subviews[1] as? UITextField
        
        idField?.addTarget(self, action: #selector(didChangeText), for: .editingChanged)
        pwField?.addTarget(self, action: #selector(didChangeText), for: .editingChanged)
        
        let verifyButton = idCell?.contentView.subviews[2] as? UIButton
        verifyButton?.addTarget(self, action: #selector(idVerification), for: .touchUpInside)
        
    }

    private func buttonOnCheck(){
        if isCellEmpty || isNotVerified {
            self.viewConfigure.button.backgroundColor = .lightGray
        }else{
            self.viewConfigure.button.backgroundColor = ColorGuide.main
        }
    }
    
    func showToast(message: String) {
        let toastView = ToastView()
        toastView.configure()
        toastView.text = message
        view.addSubview(toastView)
        toastView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            toastView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            toastView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),
            toastView.widthAnchor.constraint(equalToConstant: view.frame.size.width / 2),
            toastView.heightAnchor.constraint(equalToConstant: view.frame.height / 17),
        ])
        UIView.animate(withDuration: 2.5, delay: 0.2) { //2.5초
            toastView.alpha = 0
        } completion: { _ in
            toastView.removeFromSuperview()
        }
    }
    
    @objc func idVerification(){
        let idCell = self.viewConfigure.tableView.subviews[2] as? UITableViewCell
        let idTextField = idCell?.contentView.subviews[1] as? UITextField
        guard let idText = idTextField?.text else { return }
        
        let idList = DataManager.shared.gymInfo.gymUserList.map{
            $0.account.id
        }
        if idList.contains(idText) {
            isNotVerified = true
            let alert = UIAlertController(title: "중복된 아이디입니다.",
                                          message: "다른 아이디를 입력하여 주시옵소서",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }else{
            isNotVerified = false
            let alert = UIAlertController(title: "사용가능한 아이디 입니다.",
                                          message: "확인 버튼을 눌러주세요.",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            idTextField?.allowsEditingTextAttributes = false
        }
        buttonOnCheck()

        
        print("테스트 - 버리피케이션")
    }
    
    @objc private func didChangeText(){
        let idCell = self.viewConfigure.tableView.subviews[2] as? UITableViewCell
        let idTextField = idCell?.contentView.subviews[1] as? UITextField
        guard let idText = idTextField?.text else { return }
        let pwCell = self.viewConfigure.tableView.subviews[0] as? UITableViewCell
        let pwField = pwCell?.contentView.subviews[1] as? UITextField
        guard let pwText = pwField?.text else { return }
        
        // TODO: 중복확인하고 비밀번호가 달라지면 다시 버튼이 비활성화 됨 : 아이디 중복확인하고 비밀번호 바꿔도 버튼 활성화되게 고칠것
        if idText != "" && pwText != ""{
            isNotVerified = true
            isCellEmpty = false
        }else{
            isCellEmpty = true
        }
        buttonOnCheck()
    }
    
    @objc func buttonClicked(){
        if isCellEmpty || isNotVerified {
            showToast(message: "빈칸이 있거나 중복 확인이 안되었습니다.")
        }
        else {
            createUser()
        }
        
        
    }
    
    
}

extension UserRegisterViewIDPWController {
    // MARK: - 회원가입
    // 일단 유저만 가입 (accountType: 2)
    // 트레이너는 따로 버튼을 만드는 것도 고려해볼만?
    func createUser() {
        let idCell = self.viewConfigure.tableView.subviews[2] as? UITableViewCell
        let idTextField = idCell?.contentView.subviews[1] as? UITextField
        guard let id = idTextField?.text else { return }
        let pwCell = self.viewConfigure.tableView.subviews[0] as? UITableViewCell
        let pwField = pwCell?.contentView.subviews[1] as? UITextField
        guard let pw = pwField?.text else { return }
        
        var user = needIdPwUser
        user?.account.id = id
        user?.account.password = pw
        user?.adminUid = DataManager.shared.gymUid!
                
        Auth.auth().createUser(withEmail: id, password: pw) { result, error in
            if let error = error {
                print(error)
            } else {
                do {
                    let userData = try JSONEncoder().encode(user)
                    let userJSON = try JSONSerialization.jsonObject(with: userData, options: [])
                    
                    if let user = result?.user {
                        let userRef = Database.database().reference().child("accounts").child(user.uid)
                        userRef.child("userData").setValue(userJSON)
                        
                        let adminRef = Database.database().reference().child("users").child(DataManager.shared.gymUid!)
                        adminRef.child("gymInfo").child("gymUserList").childByAutoId().setValue(userJSON)
                        
                    }
                    
                    let vc = AdminRootViewController()
                    self.navigationController?.pushViewController(vc, animated: true)
                } catch {
                    print("JSON 인코딩 에러")
                }
            }
        }
    }
}
