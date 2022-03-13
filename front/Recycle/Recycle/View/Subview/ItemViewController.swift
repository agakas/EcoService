//
//  ItemViewController.swift
//  Recycle
//
//  Created by Dima Savelyev on 12.03.2022.
//

import UIKit
import Alamofire

protocol CameraDelegate {
    func CameraOn()
}

class ItemViewController: UIViewController {
    
    private var code: String = ""
    var delegate: CameraDelegate!
    private var name: UILabel!
    private var consistText: UILabel!
    private var category: UILabel!
    private var categoryTitle: UILabel!
    private var describ: UILabel!
    private var eco: UILabel!
    private var ecoTitle: UILabel!
    private var mark: UILabel!
    private var markText: UILabel!
    private var image: UIImageView!
    private var matArr:  Barcode!
    private var alert: UIAlertController!
    private var indecator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.isHidden = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(close))
    }
    
    func setUp(code: String){
        self.code = code
        
        indecator = {
            let ind = UIActivityIndicatorView()
            ind.style = .large
            ind.center = view.center
            view.addSubview(ind)
            ind.startAnimating()
            return ind
        }()
        
        CompanyInfo.getBarcode(code: code) { com, err in
            guard err == nil else {
                self.alertAction(err!)
                return
            }
            
            guard let coms = com else {return}
            
            self.matArr = coms
            
            self.name = {
                let lab = UILabel()
                lab.textAlignment = .center
                lab.font = UIFont.font(17, UIFont.FontType.main)
                lab.tintColor = .label
                lab.numberOfLines = 3
                lab.text = self.matArr.name
                lab.sizeToFit()
                self.view.addSubview(lab)
                lab.snp.makeConstraints { snap in
                    snap.centerX.equalToSuperview()
                    snap.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(20)
                    snap.width.equalToSuperview().dividedBy(1.2)
                }
                return lab
            }()
            
            
            self.category = {
                let lab = UILabel()
                lab.textAlignment = .center
                lab.font = UIFont.font(15, UIFont.FontType.main)
                lab.tintColor = .label
                lab.numberOfLines = 10
                lab.text = self.matArr.type
                lab.sizeToFit()
                self.view.addSubview(lab)
                lab.snp.makeConstraints { snap in
                    snap.top.equalTo(self.name.snp.bottom).offset(10)
                    snap.centerX.equalToSuperview()
                    snap.width.equalToSuperview().dividedBy(1.2)
                }
                return lab
            }()
            
            self.consistText = {
                let lab = UILabel()
                lab.textAlignment = .left
                lab.font = UIFont.font(15, UIFont.FontType.main)
                lab.tintColor = .label
                lab.numberOfLines = 10
                lab.text = "Состав:"
                lab.sizeToFit()
                self.view.addSubview(lab)
                lab.snp.makeConstraints { snap in
                    snap.top.equalTo(self.category.snp.bottom).offset(10)
                    snap.centerX.equalToSuperview()
                    snap.width.equalToSuperview().dividedBy(1.2)
                }
                return lab
            }()
            
            
            self.describ = {
                let lab = UILabel()
                lab.textAlignment = .justified
                lab.font = UIFont.font(13, UIFont.FontType.main)
                lab.tintColor = .label
                lab.numberOfLines = 50
                lab.sizeToFit()
                lab.text = self.matArr.consist
                self.view.addSubview(lab)
                lab.snp.makeConstraints { snap in
                    snap.width.equalToSuperview().dividedBy(1.2)
                    snap.top.equalTo(self.consistText.snp.bottom).offset(10)
                    snap.centerX.equalToSuperview()
                }
                return lab
            }()
            
            self.eco = {
                let lab = UILabel()
                if(self.matArr.eco){
                    lab.text = "Упоковка товара относится к EcoFriendly"
                } else{
                    lab.text = ""
                }
                lab.textAlignment = .center
                lab.font = UIFont.font(15, UIFont.FontType.main)
                lab.tintColor = .label
                lab.numberOfLines = 3
                lab.sizeToFit()
                self.view.addSubview(lab)
                lab.snp.makeConstraints { snap in
                    snap.top.equalTo(self.describ.snp.bottom).offset(10)
                    snap.centerX.equalToSuperview()
                    snap.width.equalToSuperview().dividedBy(1.2)
                }
                return lab
            }()
            if (self.matArr.text != "null"){
                self.mark = {
                    let lab = UILabel()
                    lab.textAlignment = .center
                    lab.font = UIFont.font(15, UIFont.FontType.main)
                    lab.tintColor = .label
                    lab.numberOfLines = 3
                    lab.text = "Данную упаковку можно переработать, так как она содержит маркировку:"
                    lab.sizeToFit()
                    self.view.addSubview(lab)
                    lab.snp.makeConstraints { snap in
                        snap.top.equalTo(self.eco.snp.bottom).offset(10)
                        snap.centerX.equalToSuperview()
                        snap.width.equalToSuperview().dividedBy(1.2)
                    }
                    return lab
                }()
                
                self.markText = {
                    let lab = UILabel()
                    lab.textAlignment = .center
                    lab.font = UIFont.font(15, UIFont.FontType.main)
                    lab.tintColor = .label
                    lab.numberOfLines = 2
                    lab.text = self.matArr.text
                    lab.sizeToFit()
                    self.view.addSubview(lab)
                    lab.snp.makeConstraints { snap in
                        snap.centerX.equalToSuperview()
                        snap.top.equalTo(self.mark.snp.bottom).offset(10)
                        snap.width.equalToSuperview().dividedBy(1.2)
                    }
                    return lab
                }()
                
                self.image = {
                    let img = UIImageView()
                    img.backgroundColor = .white
                    img.clipsToBounds = true
                    img.layer.cornerRadius = 15
                    img.image = self.matArr.imageMark
                    img.contentMode = .scaleAspectFit
                    self.view.addSubview(img)
                    img.snp.makeConstraints { snap in
                        snap.centerX.equalToSuperview()
                        snap.top.equalTo(self.markText.snp.bottom).offset(10)
                        snap.width.equalToSuperview().dividedBy(2.7)
                        snap.height.equalTo(self.view.frame.width/2.7)
                    }
                    return img
                }()
            }
            
            self.indecator.stopAnimating()
        }
        
        
    }
    
    @objc func close(){
        dismiss(animated: true) {
            self.delegate.CameraOn()
        }
    }
    
    func alertAction(_ er: AFError){
        alert = UIAlertController(title: er.responseCode?.description, message: er.errorDescription!, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "cancel", style: .destructive, handler: nil))
        indecator.stopAnimating()
        present(self.alert, animated: true)
    }
}
