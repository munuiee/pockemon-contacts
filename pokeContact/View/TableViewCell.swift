import Foundation
import UIKit
import SnapKit

class TableViewCell: UITableViewCell {
    static let identifier = "TableViewCell"
    
    let avatar = UIImageView()
    let nameLabel = UILabel()
    let contactLabel = UILabel()
    
    private var imageTask: URLSessionDataTask?
    private var currentImageURL: URL?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /* ---------- 셀 레이아웃 ---------- */
    
    func configureUI() {
        [avatar, nameLabel, contactLabel]
            .forEach { contentView.addSubview($0) }
        
        avatar.layer.cornerRadius = 30
        avatar.layer.borderWidth = 1
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
    
    func configure(with info: Information) {
        nameLabel.text = info.name ?? "No Name"
        contactLabel.text = PhoneFormatter.korean(info.contact)
        
        imageTask?.cancel()
        imageTask = nil
        currentImageURL = nil
        avatar.image = UIImage(systemName: "person.circle")
        
        guard let urlStr = info.imageURL, let url = URL(string:urlStr) else { return }
        currentImageURL = url
        
        if let cached = ImageCache.shared.image(forKey: urlStr) {
            avatar.image = cached
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            guard let self = self,
                  let data = data,
                  let image = UIImage(data: data) else { return }
            
            ImageCache.shared.set(image, forKey: urlStr)
            
            DispatchQueue.main.async {
                if self.currentImageURL == url {
                    self.avatar.image = image
                }
            }
        }
        task.resume()
        imageTask = task

    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageTask?.cancel()
        imageTask = nil
        currentImageURL = nil
        avatar.image = UIImage(systemName: "person.circle")
    }
    
    
    
}

// 빌드시 다른 이미지가 보이는 문제 해결
final class ImageCache {
    static let shared = ImageCache()
    
    private let cache = NSCache<NSString, UIImage>()
    private init() {}
    
    func image(forKey key: String) -> UIImage? {
        cache.object(forKey: key as NSString)
    }
    
    func set(_ image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as NSString)
    }
}
