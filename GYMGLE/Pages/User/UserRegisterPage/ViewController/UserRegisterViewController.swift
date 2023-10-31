import UIKit
import FirebaseDatabase


final class UserRegisterViewController: UIViewController {
    
    let buttonTitle = "다음"
    
    let cells = ["이름","전화번호","등록일","마감일","추가 정보"]
    let labelCells = ["등록일","마감일","추가 정보"]
    let buttonText = ["날짜","날짜","성별"]
    
    var emptyUser = User(account: Account(id: "", password: "", accountType: 2), name: "", number: "", startSubscriptionDate: Date(), endSubscriptionDate: Date(), userInfo: "", isInGym: false, adminUid: DataManager.shared.gymUid!)
    
    var nowEdit = false
    var editIndex = 0
    
    var nameCell:TextFieldCell = TextFieldCell()
    var phoneCell:TextFieldCell = TextFieldCell()
    var startCell:LabelCell = LabelCell()
    var endCell:LabelCell = LabelCell()
    
    private var isCellEmpty = true
    
    var startDate = Date()
    var endDate = Date(timeIntervalSinceNow: 60*60*24*30)
    let viewConfigure = UserRegisterView()
    
    override func loadView() {
        cellTypeConfigure(cell: cells, labelOrder: labelCells, buttonText: buttonText)
        //셀높이설정
        heightConfigure(height: 45, empty: 24)

        viewConfigure.button.setTitle(buttonTitle, for: .normal)
        
        viewConfigure.tableView.myDelegate = self
        
        view = viewConfigure
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.viewConfigure.button.backgroundColor = .lightGray
        self.viewConfigure.segmented.addTarget(self, action: #selector(trainerRegister), for: .valueChanged)
        self.viewConfigure.button.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(endEdit))
        self.viewConfigure.addGestureRecognizer(tap)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
        setCustomBackButton()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        nameCell.textField.addTarget(self, action: #selector(didChangeText), for: .editingChanged)
        phoneCell.textField.addTarget(self, action: #selector(didChangeText), for: .editingChanged)
        
        editingOn()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        viewConfigure.endEditing(true)
    }
}

// MARK: - extension custom func

private extension UserRegisterViewController {
    
    func editingOn(){
        if self.nowEdit {
            nameCell.textField.text = emptyUser.name
            phoneCell.textField.text = emptyUser.number
            nameCell.placeHolderLabel.font = UIFont.systemFont(ofSize: 10)
            phoneCell.placeHolderLabel.font = UIFont.systemFont(ofSize: 10)
            
            UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseInOut) {
                self.nameCell.placeHolderLabel.transform = CGAffineTransform(translationX: 0, y: -16)
                self.phoneCell.placeHolderLabel.transform = CGAffineTransform(translationX: 0, y: -16)
            }
            
            startCell.label.text = "등록일 : " + emptyUser.startSubscriptionDate.formatted(date:.complete, time: .omitted)
            endCell.label.text = "등록일 : " + emptyUser.endSubscriptionDate.formatted(date:.complete, time: .omitted)
            
            self.viewConfigure.textView.text = emptyUser.userInfo
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
    //updatedUser
    func userDataUpdate(completion: @escaping() -> Void) {
        if isCellEmpty {
            showToast(message: "작성 안된 곳이 있습니다.")
        }
        else {

            let info = self.viewConfigure.textView.text
            if nowEdit {
                emptyUser.name = nameCell.textField.text ?? ""
                emptyUser.number = phoneCell.textField.text ?? ""
                emptyUser.startSubscriptionDate = startDate
                emptyUser.endSubscriptionDate = endDate
                emptyUser.userInfo = info ?? "정보없음"
                
                do {
                    let userData = try JSONEncoder().encode(emptyUser)
                    let userJSON = try JSONSerialization.jsonObject(with: userData, options: [])
                    
                    let ref = Database.database().reference()
                    // 어카운트 접근해서 id값이 편집하려는 유저 id와 동일한 것 받아와서 uid값 찾아내기
                    ref.child("accounts").queryOrdered(byChild: "account/id").queryEqual(toValue: "\(emptyUser.account.id)").observeSingleEvent(of: .value) { DataSnapshot in
                        guard let value = DataSnapshot.value as? [String:Any] else { return }
                        var uid = ""
                        for i in value.keys {
                            uid = i
                        }
                        ref.child("accounts/\(uid)").setValue(userJSON)
                        completion()
                    }
                }catch{
                    print("JSON 인코딩 에러")
                    completion()
                }
            } else {
                let IdPwVC = UserRegisterViewIDPWController()
                IdPwVC.viewConfigure.segmented.isHidden = true
                
                emptyUser.name = nameCell.textField.text ?? ""
                emptyUser.number = phoneCell.textField.text ?? ""
                emptyUser.startSubscriptionDate = startDate
                emptyUser.endSubscriptionDate = Date().addingTimeInterval(60*60*24*365)
                emptyUser.userInfo = info ?? "정보없음"
                
                if viewConfigure.textView.isHidden {
                    emptyUser.account.accountType = 1 
                }
                IdPwVC.needIdPwUser = emptyUser
                navigationController?.pushViewController(IdPwVC, animated: true)
            }
        }
    }
    
    func setCustomBackButton() {
        navigationController?.navigationBar.topItem?.title = "회원등록"
        navigationController?.navigationBar.tintColor = .black
    }
}

extension UserRegisterViewController {
    @objc private func didChangeText(){
        if nameCell.textField.text != "" && phoneCell.textField.text?.count ?? 0 >= 11{
            self.viewConfigure.button.backgroundColor = ColorGuide.main
            isCellEmpty = false
        }else{
            self.viewConfigure.button.backgroundColor = .lightGray
            isCellEmpty = true
        }
    }
    
    @objc private func endEdit(){
        self.view.endEditing(true)
    }
    
    //MARK: - 바텀시트
    @objc private func presentBottomSheetSetStartDate(){
        let bottomSheet = BottomSheetController(onlyDate: true)
        bottomSheet.delegate = self
        bottomSheet.date = startDate
        bottomSheet.endDate = endDate
        present(bottomSheet, animated: true)
    }
    
    @objc private func presentBottomSheetSetEndDate(){
        let bottomSheet = BottomSheetController(onlyDate: false)
        bottomSheet.delegate = self
        bottomSheet.minDate = startDate
        bottomSheet.date = endDate
        present(bottomSheet, animated: true)
    }
    
    
    
    @objc private func trainerRegister(){
        viewConfigure.textView.isHidden.toggle()
        
    }
    @objc private func buttonClicked(){
        DispatchQueue.main.async {
            self.userDataUpdate {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}

extension UserRegisterViewController: BottomSheetControllerDelegate {
    func didClickDoneButton(date: Date, isOnlyDate: Bool) {
        if isOnlyDate {
            startCell.label.text = "등록일 : " + date.formatted(date:.complete, time: .omitted)
            self.startDate = date
        } else {
            endCell.label.text = "등록 기간 : " + date.formatted(date:.complete, time: .omitted)
            self.endDate = date
        }
    }
    
}

extension UserRegisterViewController: UserTableViewDelegate {
    func textFieldTarget(cell: TextFieldCell) {
        if cell.placeHolderLabel.text == "이름" {
            nameCell = cell
        }else if cell.placeHolderLabel.text == "전화번호"{
            phoneCell = cell
        }
    }
    
    func dateButtonTarget(cell: LabelCell, text:String) {
        if text == "등록일" {
            startCell = cell
            cell.CheckButton.addTarget(self, action: #selector(presentBottomSheetSetStartDate), for: .touchUpInside)
        }else if text == "마감일" {
            endCell = cell
            cell.CheckButton.addTarget(self, action: #selector(presentBottomSheetSetEndDate), for: .touchUpInside)
        }
        
    }
        
    func heightConfigure(height: Int, empty: Int) {
        viewConfigure.tableView.cellHeight = height
        viewConfigure.tableView.emptyCellHeight = empty
    }
    
    func cellTypeConfigure(cell: [String], labelOrder: [String], buttonText: [String]) {
        let maped = cell.map{ [$0] }
        let joined = Array(maped.joined(separator: [""]))
        viewConfigure.tableView.cellData = joined
        viewConfigure.tableView.labelCellData = labelOrder
        viewConfigure.tableView.buttonText = buttonText
    }
}
