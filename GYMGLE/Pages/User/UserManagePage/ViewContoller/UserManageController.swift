import UIKit

class UserManageViewController: UIViewController {
    
    let pageTitle = "회원 관리"
    let buttonTitle = "등록하기"
    
    var cells = ["김기호","공성표","박성원","조규연"]
    var phones = ["","","",""]
    
    let cellHeight = 45
    
    override func loadView() {
        let viewConfigure = UserManageView()
        
        userConfigure()
        
        viewConfigure.dataSourceConfigure(cells: cells, phones:phones)
        viewConfigure.label.text = pageTitle
//        viewConfigure.button.setTitle(buttonTitle, for: .normal)
        
        view = viewConfigure
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
    }
    
    override func viewWillAppear(_ animated: Bool) { // 네비게이션바 보여주기
        navigationController?.navigationBar.isHidden = false
    }

    private func userConfigure(){
        
        for i in 1...10{
            DataManager.randomGymUser(id: "회원\(i)", name: "회원이름\(i)", isIn: true)
        }
        
        cells = gyms.gymUserList.map { $0.name }
        phones = gyms.gymUserList.map { $0.number }
        
        
    }
}
