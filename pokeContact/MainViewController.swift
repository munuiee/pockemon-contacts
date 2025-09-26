import UIKit
import SnapKit

class MainViewController: UIViewController {
    
    
    struct CellItem {
        let name: String
        let contacts: String
    }
    
    let AllItems: [CellItem] = [
        .init(name: "가나디", contacts: "010-1234-5678"),
        .init(name: "고냐니", contacts: "010-1234-5678"),
        .init(name: "하치와레", contacts: "010-1234-5678"),
        .init(name: "치이카와", contacts: "010-1234-5678"),
        .init(name: "농담곰", contacts: "010-1234-5678")
    ]
    
    private let listLabel = UILabel()
    private let addButton = UIButton()
    let tableView = UITableView()
    
  

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureTable()
        setTable()
        
        tableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.identifier)
    }
    
    private func setTable() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    
    private func configureUI() {
        view.backgroundColor = .white
        [listLabel, addButton, tableView]
            .forEach { view.addSubview($0) }
        
        // 상단바 UI
        listLabel.text = "친구 목록"
        listLabel.textAlignment = .center
        listLabel.textColor = .black
        listLabel.font = .systemFont(ofSize: 20, weight: .semibold)
        listLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(10)
        }
        
        addButton.setTitle("추가", for: .normal)
        addButton.setTitleColor(.systemGray, for: .normal)
        addButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(7)
            $0.right.equalToSuperview().inset(20)
        }
    }
    
    private func configureTable() {
        view.addSubview(tableView)
        tableView.rowHeight = 80
        //tableView.backgroundColor = .systemGray3
        tableView.snp.makeConstraints {
            $0.top.equalTo(listLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
    }


}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AllItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier, for: indexPath) as? TableViewCell
        else { return .init() }
        
        let data = AllItems[indexPath.row]
        cell.configure(data: data)
        return cell
    }
}

