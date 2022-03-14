//
//  CatalogItemView.swift
//  Recycle
//
//  Created by Dima Savelyev on 13.03.2022.
//

import UIKit

class CatalogItemView: UIView {
    
     var image: UIImageView!
     var nameLabel: UILabel!
     var nameTitleLabel: UILabel!
     var descrLabel: UILabel!
     var descrTitleLabel: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .secondarySystemBackground
        layer.cornerRadius = 15
        layer.masksToBounds = true
        
        nameTitleLabel = {
            let lab = UILabel()
            lab.textAlignment = .left
            lab.font = UIFont.font(15, UIFont.FontType.main)
            lab.tintColor = .label
            lab.text = "Наименование:"
            lab.sizeToFit()
            addSubview(lab)
            lab.snp.makeConstraints { snap in
                snap.left.equalToSuperview().offset(20)
                snap.top.equalToSuperview().offset(20)
                snap.width.equalToSuperview().dividedBy(2.5)
            }
            return lab
        }()
        
        nameLabel = {
            let lab = UILabel()
            lab.textAlignment = .right
            lab.font = UIFont.font(15, UIFont.FontType.main)
            lab.tintColor = .label
            lab.sizeToFit()
            addSubview(lab)
            lab.snp.makeConstraints { snap in
                snap.left.equalTo(nameTitleLabel.snp.right).offset(5)
                snap.top.equalTo(nameTitleLabel.snp.top)
                snap.height.equalTo(nameTitleLabel.snp.height)
            }
            return lab
        }()
        
        descrTitleLabel = {
            let lab = UILabel()
            lab.textAlignment = .left
            lab.font = UIFont.font(15, UIFont.FontType.main)
            lab.tintColor = .label
            lab.text = "Описание:"
            lab.sizeToFit()
            addSubview(lab)
            lab.snp.makeConstraints { snap in
                snap.left.equalToSuperview().offset(20)
                snap.top.equalTo(nameLabel.snp.bottom).offset(5)
                snap.width.equalToSuperview().dividedBy(2.5)
            }
            return lab
        }()
        
        descrLabel = {
            let lab = UILabel()
            lab.textAlignment = .left
            lab.font = UIFont.font(12, UIFont.FontType.main)
            lab.tintColor = .label
            lab.numberOfLines = 50
            lab.sizeToFit()
            addSubview(lab)
            lab.snp.makeConstraints { snap in
                snap.left.equalToSuperview().offset(25)
                snap.top.equalTo(descrTitleLabel.snp.bottom).offset(5)
                snap.width.equalToSuperview().dividedBy(2.5)
            }
            return lab
        }()
        
        self.image = {
            let img = UIImageView()
            img.backgroundColor = .cyan
            img.clipsToBounds = true
            img.layer.cornerRadius = 15
            img.contentMode = .scaleAspectFit
            addSubview(img)
            img.snp.makeConstraints { snap in
                snap.centerX.equalToSuperview()
                snap.top.equalTo(self.descrLabel.snp.bottom).offset(10)
                snap.width.equalToSuperview().dividedBy(2.7)
                snap.height.equalTo(frame.width/2.7)
            }
            return img
        }()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
