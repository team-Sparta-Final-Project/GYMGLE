import UIKit
import FirebaseAuth
import FirebaseCore
import FirebaseDatabase

class UserRegisterViewIDPWController: UIViewController {
    
    let viewModel = UserRegisterViewModel()
    
    let buttonTitle = "회원가입"
    
    let cells = ["회원 이메일","회원 비밀번호"]
    
    var idCell:TextFieldCell = TextFieldCell()
    var pwCell:TextFieldCell = TextFieldCell()
    
    var needIdPwUser:User?
    
    let viewConfigure = UserRegisterView()
    
    private var isCellEmpty = true
    private var isNotVerified = true
    
    override func loadView() {
        cellTypeConfigure(cell: cells,labelOrder: [],buttonText: [])
        // 높이설정
        heightConfigure(height: 45, empty: 24)
        
        viewConfigure.textView.isHidden = true
        viewConfigure.button.setTitle(buttonTitle, for: .normal)
        
        view = viewConfigure
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewConfigure.tableView.myDelegate = self
        self.viewConfigure.button.backgroundColor = .lightGray
        viewConfigure.button.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
        
    }
    
    override func viewWillAppear(_ animated: Bool) { // 네비게이션바 보여주기
        navigationController?.navigationBar.isHidden = false
        setCustomBackButton()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        idCell.textField.addTarget(self, action: #selector(didChangeText), for: .editingChanged)
        pwCell.textField.addTarget(self, action: #selector(didChangeText), for: .editingChanged)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        viewConfigure.endEditing(true)
    }
    
    private func buttonOnCheck(){
        if isCellEmpty{
            self.viewConfigure.button.backgroundColor = .lightGray
        }else{
            self.viewConfigure.button.backgroundColor = ColorGuide.main
        }
    }
    
    func setCustomBackButton() {
        navigationController?.navigationBar.topItem?.title = "회원등록"
        navigationController?.navigationBar.tintColor = .black
    }
    
    
    @objc private func didChangeText(){
        // TODO: 중복확인하고 비밀번호가 달라지면 다시 버튼이 비활성화 됨 : 아이디 중복확인하고 비밀번호 바꿔도 버튼 활성화되게 고칠것
        if idCell.textField.text != "" && pwCell.textField.text != ""{
            isCellEmpty = false
        }else{
            isCellEmpty = true
        }
        buttonOnCheck()
    }
    
    @objc func buttonClicked(){
        if isCellEmpty{
            self.showToastStatic(message: "모든 칸을 입력해 주세요.", view: self.view)
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
        guard let id = idCell.textField.text else { return }
        guard let pw = pwCell.textField.text else { return }
        
        var user = needIdPwUser
        user?.account.id = id
        user?.account.password = pw
        user?.adminUid = DataManager.shared.gymUid!
        
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
                    let userData = try JSONEncoder().encode(user)
                    let userJSON = try JSONSerialization.jsonObject(with: userData, options: [])
                    
                    if let user = result?.user {
                        let userRef = Database.database().reference().child("accounts").child(user.uid)
                        userRef.setValue(userJSON)
                        
                    }
                    Auth.auth().signIn(withEmail: DataManager.shared.id!, password: DataManager.shared.pw!) { result, error in
                        if let error = error {
                            print("재로그인 에러")
                        } else {
                            if let user = result?.user {
                                let ref = Database.database().reference().child("accounts/\(user.uid)/account/accountType")
                                ref.observeSingleEvent(of: .value) { (snapshot) in
                                    if let accountType = snapshot.value as? Int {
                                        if accountType == 1 {
                                            let adminRootVC = AdminRootViewController()
                                            adminRootVC.viewModel.isAdmin = false
                                            self.navigationController?.pushViewController(adminRootVC, animated: true)
                                            return
                                        }
                                    }
                                }
                            }
                        }
                    }
                    let vc = AdminRootViewController()
                    self.navigationController?.pushViewController(vc, animated: true)
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
extension UserRegisterViewIDPWController: UserTableViewDelegate {
    func textViewTarget(cell: CustomTextCell) {
        
    }
    
    func textFieldTarget(cell: TextFieldCell) {
        if cell.placeHolderLabel.text == "회원 이메일" {
            idCell = cell
        }else if cell.placeHolderLabel.text == "회원 비밀번호"{
            pwCell = cell
        }
    }
    
    func dateButtonTarget(cell: LabelCell, text: String) {
        
    }
    
    func heightConfigure(height: Int, empty: Int) {
        viewConfigure.tableView.cellHeight = height
        viewConfigure.tableView.emptyCellHeight = empty
    }
    
    func cellTypeConfigure(cell: [String], labelOrder: [String], buttonText: [String]) {
        let maped = cell.map{ [$0] }
        let joined = Array(maped.joined(separator: [""]))
        viewConfigure.tableView.cellData = joined
        
    }
    
}
