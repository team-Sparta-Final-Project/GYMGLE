import UIKit

class AdminTableView: UITableView {
    // MARK: - Properties
    
    lazy var cellContents = ["공지작성", "회원등록", "회원관리", "QR스캐너","정보변경", "탈퇴하기"]
    lazy var secondOfCellContents = ["개인정보 처리방침", "서비스 이용약관", "앱 버전 1.0.0"]
    weak var adminRootDelegate: AdminTableViewDelegate?

    // MARK: - Initialization
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        self.separatorStyle = .none
        self.dataSource = self
        self.delegate = self
        self.isScrollEnabled = false
        self.register(MyPageTableViewCell.self, forCellReuseIdentifier: "MyPageCell")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension AdminTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        deselectRow(at: indexPath, animated: true)
        adminRootDelegate?.didSelectCell(at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.2) {
            let cell = tableView.cellForRow(at: indexPath)
            cell?.transform = CGAffineTransform(scaleX: 0.95, y: 0.90)
            cell?.backgroundColor = ColorGuide.shadowBorder
            cell?.layer.cornerRadius = 26.0
        }
    }
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return indexPath.section != 1 || indexPath.row != 2
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.2) {
            let cell = tableView.cellForRow(at: indexPath)
            cell?.transform = .identity
            cell?.backgroundColor = ColorGuide.white
        }
    }

}

extension AdminTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return cellContents.count
        } else {
            return secondOfCellContents.count
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyPageCell", for: indexPath) as! MyPageTableViewCell
        cell.label.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.centerY.equalToSuperview()
        }
        
        if indexPath.section == 0 {
            cell.label.text = cellContents[indexPath.row]
        } else  if indexPath.section == 1 {
            cell.label.text = secondOfCellContents[indexPath.row]
            if indexPath.row == 2 {
                cell.arrowImageView.isHidden = true
            }
        }
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 52
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return (section == 0) ? 0 : 20
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        header.isUserInteractionEnabled = false
        header.backgroundColor = ColorGuide.background
        header.frame.size.height = 1
        return header
    }
}
