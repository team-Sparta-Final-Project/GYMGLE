import UIKit

class UserRegisterViewIDPWController: UIViewController {
    
    let pageTitle = "회원 등록"
    let buttonTitle = "등록하기"
    
    let cells = ["회원 아이디","회원 비밀번호"]
    let labelCells = [""]
    let buttonCells = ["회원 아이디"]
    let buttonText = ["중복 확인"]
    
    
    let cellHeight = 45
    let emptyCellHeight = 24
    
    let viewConfigure = UserRegisterView()
    
    private var isCellEmpty = true
    
    
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
        let idTextField = idCell?.contentView.subviews[1] as? UITextField
        let pwCell = self.viewConfigure.tableView.subviews[0] as? UITableViewCell
        let pwField = pwCell?.contentView.subviews[1] as? UITextField
        
        idTextField?.addTarget(self, action: #selector(didChangeText), for: .editingChanged)
        pwField?.addTarget(self, action: #selector(didChangeText), for: .editingChanged)
    }

    
    @objc private func didChangeText(){
        let idCell = self.viewConfigure.tableView.subviews[2] as? UITableViewCell
        let idTextField = idCell?.contentView.subviews[1] as? UITextField
        guard let idText = idTextField?.text else { return }
        let pwCell = self.viewConfigure.tableView.subviews[0] as? UITableViewCell
        let pwField = pwCell?.contentView.subviews[1] as? UITextField
        guard let pwText = pwField?.text else { return }

        if idText != "" && pwText != ""{
            self.viewConfigure.button.backgroundColor = ColorGuide.main
            isCellEmpty = false
        }else{
            self.viewConfigure.button.backgroundColor = .lightGray
            isCellEmpty = true
        }
    }
    
    @objc func buttonClicked(){
        if isCellEmpty {
            
        }
        else {
            let idCell = self.viewConfigure.tableView.subviews[2] as? UITableViewCell
            let idTextField = idCell?.contentView.subviews[1] as? UITextField
            guard let idText = idTextField?.text else { return }
            let pwCell = self.viewConfigure.tableView.subviews[0] as? UITableViewCell
            let pwField = pwCell?.contentView.subviews[1] as? UITextField
            guard let pwText = pwField?.text else { return }
            
            let adminRootVC = navigationController!.viewControllers[2]
            navigationController?.popToViewController(adminRootVC, animated: true)
        }

//        DataManager.addGymUser(name: nameText, number: phoneText)
        
        
    }
    
    
}
