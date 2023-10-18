import UIKit

class UserRegisterViewController: UIViewController {
    
    let pageTitle = "회원 등록"
    let buttonTitle = "다음"
    
    let cells = ["회원 이름","회원 전화번호","등록 기간","추가 정보"]
    let labelCells = ["등록 기간", "추가 정보"]
    let buttonCells = ["등록 기간","추가 정보"]
    let buttonText = ["날짜","성별"]
    
    
    let cellHeight = 45
    let emptyCellHeight = 24
    
    private var isCellEmpty = true
    
    let viewConfigure = UserRegisterView()
    
    override func loadView() {
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
        self.viewConfigure.button.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(endEdit))
        self.viewConfigure.addGestureRecognizer(tap)
        
    }
    
    override func viewWillAppear(_ animated: Bool) { // 네비게이션바 보여주기
        navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let dateCell = self.viewConfigure.tableView.subviews[2] as? UITableViewCell
        let dateButton = dateCell?.contentView.subviews[1] as? UIButton
        dateButton?.addTarget(self, action: #selector(showPopUp), for: .touchUpInside)
        
        
        let nameCell = self.viewConfigure.tableView.subviews[6] as? UITableViewCell
        let nameTextField = nameCell?.contentView.subviews[1] as? UITextField
        let phoneCell = self.viewConfigure.tableView.subviews[4] as? UITableViewCell
        let phoneTextField = phoneCell?.contentView.subviews[1] as? UITextField

        nameTextField?.addTarget(self, action: #selector(didChangeText), for: .editingChanged)
        phoneTextField?.addTarget(self, action: #selector(didChangeText), for: .editingChanged)
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
    
    @objc private func didChangeText(){
        let nameCell = self.viewConfigure.tableView.subviews[6] as? UITableViewCell
        let nameTextField = nameCell?.contentView.subviews[1] as? UITextField
        guard let nameText = nameTextField?.text else { return }
        let phoneCell = self.viewConfigure.tableView.subviews[4] as? UITableViewCell
        let phoneTextField = phoneCell?.contentView.subviews[1] as? UITextField
        guard let phoneText = phoneTextField?.text else { return }
        
        if nameText != "" && phoneText.count >= 11{
            self.viewConfigure.button.backgroundColor = ColorGuide.main
            isCellEmpty = false
        }else{
            self.viewConfigure.button.backgroundColor = .lightGray
            isCellEmpty = true
        }
    }
    
    @objc func endEdit(){
        self.view.endEditing(true)
    }

    
    @objc func showPopUp(){
        self.view.endEditing(true)
        let popup = PopUpView()

        self.view.addSubview(popup)
        popup.snp.makeConstraints{
            $0.top.bottom.left.right.equalToSuperview()
        }
    }
    
    @objc func buttonClicked(){
        if isCellEmpty {
            showToast(message: "작성 안된 곳이 있습니다.")
        }
        else {
            let nameCell = self.viewConfigure.tableView.subviews[6] as? UITableViewCell
            let nameTextField = nameCell?.contentView.subviews[1] as? UITextField
            guard let nameText = nameTextField?.text else { return }
            let phoneCell = self.viewConfigure.tableView.subviews[4] as? UITableViewCell
            let phoneTextField = phoneCell?.contentView.subviews[1] as? UITextField
            guard let phoneText = phoneTextField?.text else { return }

            let IdPwVC = UserRegisterViewIDPWController()
            IdPwVC.name = nameText
            IdPwVC.phone = phoneText
            
            navigationController?.pushViewController(IdPwVC, animated: true)

        }
    }
}

