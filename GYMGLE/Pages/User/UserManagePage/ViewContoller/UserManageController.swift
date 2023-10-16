import UIKit

class UserManageViewController: UIViewController {
    
    let pageTitle = "회원 관리"
    let buttonTitle = "등록하기"
    
    let cells = ["김기호","공성표","박성원","조규연"]
//    let labelCells = ["회원 이름","회원 전화번호","등록 기간","추가 정보","텍스트 필드"]
//    let buttonCells = ["추가 정보"]
//    let buttonText = ["성별"]
    
    
    let cellHeight = 45
    
    override func loadView() {
        let viewConfigure = UserManageView()
        
        viewConfigure.dataSourceConfigure(cells: cells)
        viewConfigure.label.text = pageTitle
//        viewConfigure.button.setTitle(buttonTitle, for: .normal)
        
        view = viewConfigure
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
    }
    
}
//
