//
//  MarkCollectionViewCell.swift
//  Recycle
//
//  Created by Dima Savelyev on 11.03.2022.
//

import UIKit

class MarkCollectionViewCell: UICollectionViewCell {
    static let cell = "cell"
    
    var img: UIImageView!
    var title: UILabel!
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.cornerRadius = 15
        backgroundColor = .secondarySystemBackground
        
        self.img = {
            let lab = UIImageView()
            lab.contentMode = .scaleAspectFit
            lab.backgroundColor = .white
            lab.layer.cornerRadius = 15
            lab.layer.masksToBounds = true
            self.addSubview(lab)
            lab.snp.makeConstraints { snap in
                snap.top.equalToSuperview().offset(20)
                snap.centerX.equalToSuperview()
                snap.width.equalToSuperview().dividedBy(2)
                snap.height.equalTo(self.frame.width/2)
            }
            return lab
        }()
        
        self.title = {
            let lab = UILabel()
            lab.textAlignment = .center
            lab.font = UIFont.font(17, UIFont.FontType.main)
            lab.tintColor = .label
            lab.numberOfLines = 2
            lab.sizeToFit()
            self.addSubview(lab)
            lab.snp.makeConstraints { snap in
                snap.centerX.equalToSuperview()
                snap.top.equalTo(img.snp.bottom).offset(10)
                snap.width.equalToSuperview().dividedBy(1.2)
            }
            return lab
        }()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
