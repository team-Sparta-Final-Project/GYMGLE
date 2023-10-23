import UIKit
import FirebaseDatabase

class UserManageViewController: UIViewController {
    
    let pageTitle = "회원 관리"
    let buttonTitle = "등록하기"
    
    var cells:[User] = []
    
    let cellHeight = 56
    
    let viewConfigure = UserManageView()
            
    override func loadView() {
        cells = DataManager.shared.realGymInfo?.gymUserList ?? []
        
        viewConfigure.tableView.delegate = self
        viewConfigure.tableView.dataSource = self
        
        viewConfigure.label.text = pageTitle
        
        
        
        view = viewConfigure
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
    }
    
    override func viewWillAppear(_ animated: Bool) { // 네비게이션바 보여주기
        navigationController?.navigationBar.isHidden = false
        
        var ref = Database.database().reference()
        ref.child("users/\(DataManager.shared.gymUid!)/gymInfo/gymUserList").queryOrdered(byChild: "name").observeSingleEvent(of: .value) { DataSnapshot in
            guard let value = DataSnapshot.value as? [String:Any] else { return }
            var temp:[User] = []
            for i in value.values {
                do {
                    let JSONdata = try JSONSerialization.data(withJSONObject: i)
                    let user = try JSONDecoder().decode(User.self, from: JSONdata)
                    temp.append(user)
                } catch let error {
                    print("테스트 - \(error)")
                }
            }
            DataManager.shared.realGymInfo?.gymUserList = temp
            self.cells = DataManager.shared.realGymInfo?.gymUserList ?? []
            self.viewConfigure.tableView.reloadData()
        }
        
        
//        ref.child("users/\(DataManager.shared.gymUid!)/gymInfo/gymUserList").queryOrdered(byChild: "name").observeSingleEvent(of: .value) { snapshot in
//            guard let value = snapshot.value as? [String:Any] else {
//                print("테스트 - 응 에러야")
//                return
//            }
//            do {
//                let JSONdata = try JSONSerialization.data(withJSONObject: value)
//                let List = try JSONDecoder().decode([User].self, from: JSONdata)
//                DataManager.shared.realGymInfo?.gymUserList = List
//            } catch let error {
//                print("테스트 - \(error)")
//            }
//            self.cells = DataManager.shared.realGymInfo?.gymUserList ?? []
//            self.viewConfigure.tableView.reloadData()
//
//        }

        
    }
}




extension UserManageViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath){
        if editingStyle == .delete {
            
            let ref = Database.database().reference()
            ref.child("users/\(cells[indexPath.row].adminUid)/gymInfo/gymUserList/\(indexPath.row)").removeValue()

            
//            do {
//                let userData = try JSONEncoder().encode(cells[indexPath.row])
//                let userJSON = try JSONSerialization.jsonObject(with: userData, options: [])
//
//                let ref = Database.database().reference()
//                ref.child("users/\(emptyUser.adminUid)/gymInfo/gymUserList/\(editIndex)").setValue(userJSON)
//            }catch{
//                print("JSON 인코딩 에러")
//            }
            DataManager.shared.realGymInfo?.gymUserList.remove(at: indexPath.row)
            cells.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)

        }
    }
    
    
    
}


extension UserManageViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = ManageLabelCell()
        cell.name.text = cells[indexPath.row].name
        cell.phone.text = cells[indexPath.row].number
        cell.gender.text = "남"
        
        if cells.count == (indexPath.row + 1) {
//
            
        }
        
        cell.layer.addBorder([.top], color: ColorGuide.shadowBorder, width: 1.0)
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(cellHeight)
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellInfo = cells[indexPath.row]
        
        let userRegisterVC = UserRegisterViewController()
        
        userRegisterVC.emptyUser = cellInfo
        userRegisterVC.nowEdit = true
        userRegisterVC.editIndex = indexPath.row
        
        self.navigationController?.pushViewController(userRegisterVC, animated: true)



    }
    
    
    
}
