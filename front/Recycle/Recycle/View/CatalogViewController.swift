//
//  CatalogViewController.swift
//  Recycle
//
//  Created by Dima Savelyev on 11.03.2022.
//

import UIKit

class CatalogViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private var indecator: UIActivityIndicatorView!
    private var companiesGet: [Category?]!
    private var gallery: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        indecator = {
            let ind = UIActivityIndicatorView()
            ind.style = .large
            ind.center = view.center
            view.addSubview(ind)
            ind.startAnimating()
            return ind
        }()
        
        self.gallery = {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .vertical
            let gal = UICollectionView(frame: .zero, collectionViewLayout: layout)
            gal.register(MarkCollectionViewCell.self, forCellWithReuseIdentifier: MarkCollectionViewCell.cell)
            gal.dataSource = self
            gal.delegate = self
            gal.layer.masksToBounds = true
            gal.layer.cornerRadius = 15
            gal.backgroundColor = .tertiarySystemBackground
            gal.contentInsetAdjustmentBehavior = .always
            gal.contentInset = UIEdgeInsets(top: 20, left: 30, bottom: 20, right: 30)
            self.view.insertSubview(gal, belowSubview: self.indecator)
            gal.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
                make.width.equalToSuperview()
                make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(10)
            }
            return gal
        }()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        19
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MarkCollectionViewCell.cell, for: indexPath) as! MarkCollectionViewCell
        if let com = companiesGet{
//            cell.img.image =  com[indexPath.row]!.image
//            cell.title.text = com[indexPath.row]!.name
        }
        cell.imgGet.image = UIImage()
        cell.titleGet.text = "descri"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/2.5, height: collectionView.frame.width/2.5)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let com = companiesGet{
            let vc = DescripViewController()
//            vc.setup(ticker: com[indexPath.row]?.ticker ?? "")
            let nav = UINavigationController(rootViewController: vc)
            present(nav, animated: true, completion: nil)
        }
    }
}
