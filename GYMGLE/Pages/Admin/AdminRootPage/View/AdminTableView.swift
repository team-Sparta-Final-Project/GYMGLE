import UIKit

class AdminTableView: UITableView {
    // MARK: - Properties
    
    lazy var cellContents = ["공지작성", "회원등록", "회원관리", "QR스캐너","정보변경", "탈퇴하기"]
    weak var adminRootDelegate: AdminTableViewDelegate?

    // MARK: - Initialization
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
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
            cell?.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.2) {
            let cell = tableView.cellForRow(at: indexPath)
            cell?.transform = .identity
        }
    }

}

extension AdminTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cellContents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyPageCell", for: indexPath) as! MyPageTableViewCell
        cell.label.text = cellContents[indexPath.row]

        cell.label.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.centerY.equalToSuperview()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
}
