//
//  DescripViewController.swift
//  Recycle
//
//  Created by Dima Savelyev on 11.03.2022.
//

import UIKit
import Alamofire

class DescripViewController: UIViewController, UIScrollViewDelegate {
    
    private var name: String!
    private var warning: PaddingLabel!
    private var indecator: UIActivityIndicatorView!
    private var alert: UIAlertController!
    private var matView: UIStackView!
    private var scrollView: UIScrollView!
    private var matArr =  [Mark]()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(close))
        title = name
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor:  UIColor.label, .font: UIFont.font(35, .main)]
        
        indecator = {
            let ind = UIActivityIndicatorView()
            ind.style = .large
            ind.center = view.center
            view.addSubview(ind)
            ind.startAnimating()
            return ind
        }()
        
        CompanyInfo.getMark { com, err in
            
            guard err == nil else {
                self.alertAction(err!)
                return
            }
            
            guard let coms = com else {return}
            
            self.matArr = coms
            
            DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
                
                let filtComs = self.matArr.filter { i in
                    i.material.name == self.name!
                }
                  
                self.warning = {
                    let lab = PaddingLabel()
                    lab.backgroundColor = .systemOrange
                    lab.textAlignment = .justified
                    lab.font = UIFont.font(12, UIFont.FontType.main)
                    lab.tintColor = .black
                    lab.contentMode = .scaleAspectFit
                    lab.layer.cornerRadius = 15
                    lab.text = filtComs[0].material.warn?.replacingOccurrences(of: "// ", with: "\n")
                    lab.layer.masksToBounds = true
                    lab.numberOfLines = 30
                    lab.sizeToFit()
                    lab.paddingBottom = 5
                    lab.paddingTop = 5
                    lab.paddingLeft = 10
                    lab.paddingRight = 10
                    self.view.addSubview(lab)
                    lab.snp.makeConstraints { snap in
                        snap.centerX.equalToSuperview()
                        snap.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
                        snap.width.equalToSuperview().dividedBy(1.2)
                    }
                    return lab
                }()
                
                self.scrollView = {
                    let v = UIScrollView()
                    v.delegate = self
                    v.layer.cornerRadius = 15
                    v.layer.masksToBounds = true
                    v.sizeToFit()
                    v.backgroundColor = .tertiarySystemBackground
                    v.showsVerticalScrollIndicator = false
                    v.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
                    self.view.addSubview(v)
                    v.snp.makeConstraints { make in
                        make.centerX.equalToSuperview()
                        make.top.equalTo(self.warning.snp.bottom).offset(10)
                        make.width.equalToSuperview().dividedBy(1.05)
                        make.bottom.equalToSuperview()
                    }
                    return v
                }()
                
                self.matView = {
                    let v = UIStackView()
                    v.sizeToFit()
                    v.alignment = .fill
                    v.spacing = 10
                    v.axis = .vertical
                    v.distribution = .fill
                    self.scrollView.addSubview(v)
                    v.snp.makeConstraints { make in
                        make.edges.equalTo(self.scrollView)
                        make.height.equalToSuperview()
                    }
                    return v
                }()
                
                for i in filtComs{
                    let _: CatalogItemView! = {
                        let c = CatalogItemView()
                        c.nameLabel.text = i.markName
                        c.descrLabel.text = i.description.replacingOccurrences(of: "// ", with: "\n")
                        c.image.image = i.image ?? UIImage()
                        self.matView.addArrangedSubview(c)
                        c.snp.makeConstraints { snap in
                            snap.width.equalTo(self.scrollView.snp.width).dividedBy(1.05)
                        }
                        return c
                    }()
                }
                
                self.indecator.stopAnimating()
            }
            
        }
        
    }
    
    func setUp(name: String){
        self.name = name
    }
    
    @objc func close(){
        dismiss(animated: true)
    }
    
    func alertAction(_ er: AFError){
        alert = UIAlertController(title: er.responseCode?.description, message: er.errorDescription!, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "cancel", style: .destructive, handler: nil))
        indecator.stopAnimating()
        present(self.alert, animated: true)
    }
}
