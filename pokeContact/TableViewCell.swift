//
//  TableViewCell.swift
//  pokeContact
//
//  Created by Jihye의 MacBook Pro on 9/26/25.
//

import Foundation
import UIKit
import SnapKit

class TableViewCell: UITableViewCell {
    static let identifier = "TableViewCell"
    
    let avatar = UIImageView()
    let nameLabel = UILabel()
    let contactLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI() {
        [avatar, nameLabel, contactLabel]
            .forEach { contentView.addSubview($0) }
        
        avatar.layer.cornerRadius = 30
        avatar.layer.borderWidth = 1
        avatar.layer.shouldRasterize = true
        avatar.clipsToBounds = true
        avatar.layer.borderColor = UIColor.lightGray.cgColor

        
        avatar.snp.makeConstraints {
            $0.width.height.equalTo(60)
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(20)
        }
        
        nameLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(avatar.snp.right).offset(20)
        }
        
        contactLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset( -20)
        }
        
    }
    
    func configure(data: MainViewController.CellItem) {
        nameLabel.text = data.name
        contactLabel.text = data.contacts
    }
    
    
    
}
