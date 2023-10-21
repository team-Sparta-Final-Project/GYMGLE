import UIKit

final class UserManageViewController: UIViewController {
    
    let viewConfigure = UserManageView()
    let pageTitle = "회원 관리"
    let buttonTitle = "등록하기"
    
    let shared = DataManager.shared
    
    //❗️서치를 하기 위한 변수 생성
    var cells:[User] = []
    var filteredUserList: [User] = []
    
    let cellHeight = 45
    
    override func loadView() {
        cells = DataManager.shared.gymInfo.gymUserList
        
        viewConfigure.dataSourceConfigure(cells: cells)
        viewConfigure.label.text = pageTitle
        //        viewConfigure.button.setTitle(buttonTitle, for: .normal)
        
        view = viewConfigure
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        //❗️ 서치델리게이트와 테이블뷰델리게이트 대리자 선언
        viewConfigure.customSearchBar.delegate = self
        viewConfigure.customSearchBar.showsCancelButton = false
        viewConfigure.customSearchBar.setValue("취소", forKey: "cancelButtonText")
        viewConfigure.customSearchBar.setShowsCancelButton(true, animated: true)
        viewConfigure.tableView.dataSource = self
    }
    
    
    override func viewWillAppear(_ animated: Bool) { // 네비게이션바 보여주기
        navigationController?.navigationBar.isHidden = false
    }
    func searchBarIsEmpty() -> Bool {
        return viewConfigure.customSearchBar.text?.isEmpty ?? true
    }
    func isFiltering() -> Bool {
        return viewConfigure.customSearchBar.isFirstResponder && !searchBarIsEmpty()
    }
}

// MARK: - TableViewDataSource

extension UserManageViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.isFiltering() ? self.filteredUserList.count : self.cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = ManageLabelCell()
        
        if isFiltering() {
            cell.name.text = filteredUserList[indexPath.row].name
            cell.phone.text = filteredUserList[indexPath.row].number
            cell.gender.text = "남"
        } else {
            cell.name.text = cells[indexPath.row].name
            cell.phone.text = cells[indexPath.row].number
            cell.gender.text = "남"
        }
        
        if cells.count == (indexPath.row + 1) || filteredUserList.count == (indexPath.row + 1) {
            cell.contentView.layer.addBorder([.bottom], color: ColorGuide.shadowBorder, width: 1.0)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(cellHeight)
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("테스트 - \(indexPath)")
    }
}

// MARK: - searchbar Delegate

extension UserManageViewController: UISearchBarDelegate {
    // 서치바에서 검색을 시작할 때 호출
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        viewConfigure.customSearchBar.showsCancelButton = true
        viewConfigure.tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        guard let text = searchBar.searchTextField.text?.lowercased() else { return }
        filteredUserList = self.cells.filter {$0.name == text}.sorted {$0.startSubscriptionDate > $1.startSubscriptionDate}
        viewConfigure.tableView.reloadData()
    }
    
    // 서치바에서 취소 버튼을 눌렀을 때 호출
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewConfigure.customSearchBar.text = ""
        viewConfigure.customSearchBar.resignFirstResponder()
        self.viewConfigure.customSearchBar.showsCancelButton = false
        self.viewConfigure.tableView.reloadData()
    }
    
    // 서치바 검색이 끝났을 때 호출
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        viewConfigure.tableView.reloadData()
    }
    
    // 서치바 키보드 내리기
    func dismissKeyboard() {
        viewConfigure.customSearchBar.resignFirstResponder()
    }
}

