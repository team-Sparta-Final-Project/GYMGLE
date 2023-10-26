
import UIKit
import FirebaseAuth
import FirebaseCore
import FirebaseDatabase

class AdminTableView: UITableView {
    // MARK: - Properties
    
    lazy var cellContents = ["공지작성", "회원등록", "회원관리", "QR스캐너","탈퇴하기"]
    weak var myPageDelegate: AdminTableViewDelegate?
    var adminRootViewController: AdminRootViewController?

    // MARK: - Initialization
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        self.dataSource = self
        self.delegate = self
        self.register(MyPageTableViewCell.self, forCellReuseIdentifier: "MyPageCell")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension AdminTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        deselectRow(at: indexPath, animated: true)
//        myPageDelegate?.didSelectCell(at: indexPath)
        switch indexPath.row {
        case 0:
            let adminNoticeVC = AdminNoticeViewController()
            adminRootViewController?.navigationController?.pushViewController(adminNoticeVC, animated: true)
        case 1:
            let userRegisterVC = UserRegisterViewController()
            adminRootViewController?.navigationController?.pushViewController(userRegisterVC, animated: true)
        case 2:
            let userManageVC = UserManageViewController()
            adminRootViewController?.navigationController?.pushViewController(userManageVC, animated: true)
        case 3:
            let qrcodeCheckVC = QRcodeCheckViewController()
            adminRootViewController?.navigationController?.pushViewController(qrcodeCheckVC, animated: true)
        default:
            break
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.2) {
            let cell = tableView.cellForRow(at: indexPath)
            cell?.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.2) {
            let cell = tableView.cellForRow(at: indexPath)
            cell?.transform = .identity
        }
    }

extension AdminTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cellContents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyPageCell", for: indexPath) as! MyPageTableViewCell
        cell.label.text = cellContents[indexPath.row]
        
        if indexPath.row == 0 {
            
            cell.label.snp.makeConstraints {
                $0.left.equalToSuperview().offset(20)
                $0.centerY.equalToSuperview()
            }
        } else {
            cell.label.snp.makeConstraints {
                $0.left.equalToSuperview().offset(20)
                $0.centerY.equalToSuperview()
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
}
