import UIKit

class UserRegisterViewController: UIViewController {
    
    override func loadView() {
        view = UserRegisterView()
//        view = AdminRegisterView()
        print("테스트 - loaded")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}
