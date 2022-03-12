//
//  ItemViewController.swift
//  Recycle
//
//  Created by Dima Savelyev on 12.03.2022.
//

import UIKit

protocol CameraDelegate {
    func CameraOn()
}

class ItemViewController: UIViewController {
    
    private var code: String = ""
    var delegate: CameraDelegate!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(close))
    }
    
    func setUp(code: String){
        self.code = code
        print(code)
    }
    
    @objc func close(){
        dismiss(animated: true) {
            self.delegate.CameraOn()
        }
    }
}
