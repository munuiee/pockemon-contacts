//
//  PhoneBookViewController.swift
//  pokeContact
//
//  Created by Jihye의 MacBook Pro on 9/26/25.
//

import Foundation
import UIKit
import SnapKit


class PhoneBookViewController: UIViewController {
    private let addLabel = UILabel()
    private let doneButton = UIButton()
    private let profileImage = UIImageView()
    private let randomButton = UIButton()
    private let nameTextField = UITextField()
    private let contactTextField = UITextField()
    
    var currentImageURL: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        }
    
    private func configureUI() {
        [addLabel, doneButton, profileImage, randomButton, nameTextField, contactTextField]
            .forEach { view.addSubview($0) }
        view.backgroundColor = .white
        
        
        /* ---------- 상단바 UI ---------- */
        addLabel.text = "연락처 추가"
        addLabel.textColor = .black
        addLabel.textAlignment = .center
        addLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        navigationItem.titleView = addLabel
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "적용",
            style: .plain,
            target: self,
            action: #selector(saveButtonTapped)
        )
        
        // 네비게이션 바 appearance 세팅
        let ap = UINavigationBarAppearance()
        ap.configureWithOpaqueBackground()
        ap.backgroundColor = .systemBackground
        
        navigationController?.navigationBar.standardAppearance = ap
        navigationController?.navigationBar.compactAppearance = ap
        
        
        /* ---------- 수정 화면 UI ---------- */
       // profileImage.image = UIImage(systemName: "person.circle.fill")
        profileImage.contentMode = .scaleAspectFit
        profileImage.clipsToBounds = true
        profileImage.layer.cornerRadius = 100
        profileImage.layer.borderWidth = 1
        profileImage.layer.borderColor = UIColor.systemGray.cgColor
        profileImage.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(200)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
        }
        
        randomButton.setTitle("랜덤 이미지 생성", for: .normal)
        randomButton.setTitleColor(.systemGray, for: .normal)
        randomButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(profileImage.snp.bottom).offset(10)
        }
        randomButton.addTarget(self, action: #selector(randomTapped), for: .touchUpInside)
        
        nameTextField.placeholder = " 이름"
        nameTextField.textAlignment = .left
        nameTextField.keyboardType = .default
        nameTextField.borderStyle = .none  // 기본 테두리 제거
        nameTextField.layer.borderColor = UIColor.lightGray.cgColor
        nameTextField.layer.borderWidth = 1
        nameTextField.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.equalTo(350)
            $0.height.equalTo(35)
            $0.top.equalTo(randomButton.snp.bottom).offset(10)
        }
        
        contactTextField.placeholder = " 전화번호"
        contactTextField.textAlignment = .left
        contactTextField.keyboardType = .numberPad
        contactTextField.borderStyle = .none  // 기본 테두리 제거
        contactTextField.layer.borderColor = UIColor.lightGray.cgColor
        contactTextField.layer.borderWidth = 1
        contactTextField.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.equalTo(350)
            $0.height.equalTo(35)
            $0.top.equalTo(nameTextField.snp.bottom).offset(10)
        }
        
        
    }
    
    /* ---------- API ---------- */
    // 포켓몬 정보 가져오기
    func fetchPokemon() {
        let id = Int.random(in: 1...1000)
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon/\(id)") else {
            print("잘못된 URL입니다.")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data, error == nil else { return }
            
            do {
                let result = try JSONDecoder().decode(Pokemon.self, from: data)
                
                if let imageURLString = result.sprites.frontDefault,
                   let imageURL = URL(string: imageURLString) {
                    
                    self.loadImage(from: imageURL)
                    self.currentImageURL = imageURL.absoluteString // coredata 저장용
                }
            } catch {
                print("디코딩 실패 \(error)")
            }
        }.resume()
    }
    
    // UIImage로 변환 및 메인스레드에 보내기
    private func loadImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data, error == nil,
                  let image = UIImage(data: data) else { return }
            
            DispatchQueue.main.async {
                self.profileImage.image = image
            }
        }.resume()
    }
    
    @objc private func saveButtonTapped() {
        let name = nameTextField.text ?? ""
        let contact = contactTextField.text ?? ""
        let imageURL = currentImageURL ?? ""
        CoreDataManager.shared.createData(name: name, contact: contact, imageURL: imageURL)
        CoreDataManager.shared.readAllData()
        
        // 현재 화면을 닫고 이전 화면으로 돌아감
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func randomTapped() {
        fetchPokemon()
    }
    
    

}
