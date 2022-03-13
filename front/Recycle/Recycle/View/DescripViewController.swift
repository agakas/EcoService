//
//  DescripViewController.swift
//  Recycle
//
//  Created by Dima Savelyev on 11.03.2022.
//

import UIKit

class DescripViewController: UIViewController {
    
    private var name: String!
    private var warning: UILabel!
    private var indecator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(close))
        
        indecator = {
            let ind = UIActivityIndicatorView()
            ind.style = .large
            ind.center = view.center
            view.addSubview(ind)
            ind.startAnimating()
            return ind
        }()
        
        CompanyInfo.getMark { com, err in
            
            guard let coms = com else {return}
            
            print(coms)
            
            let filtComs = coms.filter { i in
                i.material.first?.name == self.name
            }
            self.warning = {
                let lab = UILabel()
                lab.backgroundColor = .yellow
                lab.textAlignment = .center
                lab.font = UIFont.font(12, UIFont.FontType.main)
                lab.tintColor = .label
                lab.layer.cornerRadius = 15
                lab.text = filtComs[0].material[0].warn
                lab.layer.masksToBounds = true
                lab.numberOfLines = 5
                lab.sizeToFit()
                self.view.addSubview(lab)
                lab.snp.makeConstraints { snap in
                    snap.centerX.equalToSuperview()
                    snap.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
                    snap.width.equalToSuperview().dividedBy(1.2)
                }
                return lab
            }()
            
            self.indecator.stopAnimating()
        }
        
    }
    
    func setUp(name: String){
        self.name = name
    }
    
    @objc func close(){
        dismiss(animated: true)
    }
}
