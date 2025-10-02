import UIKit
import SnapKit

class MainViewController: UIViewController {
    private var mainInfo: [Information] = []
    private let coreDataManager = CoreDataManager.shared

    private let listLabel = UILabel()
    private let addButton = UIButton()
    let tableView = UITableView()
    private var didReloadOnce = false
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureTable()
        setTable()
        mainInfo = coreDataManager.getInformation()
        // CoreDataManager.shared.deleteAll()

    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        mainInfo = coreDataManager.getInformation()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
        // 이름순 정렬
        mainInfo.sort {
            ($0.name ?? "").localizedCaseInsensitiveCompare($1.name ?? "") == .orderedAscending
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !didReloadOnce {
            tableView.reloadData()
            didReloadOnce = true
        }
    }
    
    
    
    private func configureUI() {
        view.backgroundColor = .white
        [listLabel, addButton, tableView]
            .forEach { view.addSubview($0) }
        
        
        /* ---------- 상단바 UI ----------*/
        listLabel.text = "친구 목록"
        listLabel.textAlignment = .center
        listLabel.textColor = .black
        listLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        listLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(10)
        }
        navigationItem.titleView = listLabel
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "추가",
            style: .plain,
            target: self,
            action: #selector(buttonTapped)
        )
        
        // 네비게이션 바 appearance 세팅
        let ap = UINavigationBarAppearance()
        ap.configureWithOpaqueBackground()
        ap.backgroundColor = .systemBackground
        
        // 추가 버튼 색상
        ap.buttonAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor.systemGray
        ]

        // 백 버튼
        ap.backButtonAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor.label
        ]

        navigationController?.navigationBar.standardAppearance = ap
        navigationController?.navigationBar.compactAppearance = ap
    }
    
    @objc private func buttonTapped() {
        let nextPage = PhoneBookViewController()
        navigationController?.pushViewController(nextPage, animated: true)
    }
    
    
    /* ---------- 테이블뷰 -----------*/
    private func configureTable() {
        view.addSubview(tableView)
        tableView.rowHeight = 80
        tableView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func setTable() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.identifier)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let selected = mainInfo[indexPath.row]
        print("➡️ push url:", selected.imageURL as Any)
        
        let nextPage = PhoneBookViewController()
        nextPage.infoEdit = selected
        navigationController?.pushViewController(nextPage, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        print("👉 swipe called", indexPath)
        let deleteAction = UIContextualAction(style: .destructive, title: nil) {
            [weak self](action, view, completion) in
            guard let self = self else { return }
            
            let info = self.mainInfo[indexPath.row]
            
            CoreDataManager.shared.deleteData(info: info)
            self.mainInfo.remove(at: indexPath.row)
            
            tableView.deleteRows(at: [indexPath], with: .automatic)
            completion(true)
        }
        
        deleteAction.image = UIImage(systemName: "trash")
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = true
        return configuration
    }

}

/* ---------- 테이블뷰 delegate -----------*/
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mainInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier, for: indexPath) as? TableViewCell
        else { return .init() }
         
        cell.configure(with: mainInfo[indexPath.row])
        return cell
    }
}


