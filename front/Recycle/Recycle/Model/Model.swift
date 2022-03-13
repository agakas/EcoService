//
//  RecycleMap.swift
//  Recycle
//
//  Created by Dima Savelyev on 11.03.2022.
//

import UIKit
import Alamofire
import SwiftyJSON

struct Company {
    var name: String
    var address: String
    var hour: String
    var phone: String
    var website: String
    var eco: Bool
    var materials: [Materials]
    var lati: Double
    var long: Double
}

struct Category{
    var name: String
    var image: UIImage
    var description: String
    var marks: [Mark]
}

struct Mark{
    var image: UIImage
    var material: [Materials]
    var description: String
    var markName: String
}

struct Materials{
    var name: String
    var img: UIImage?
    var warn: String?
}

class CompanyInfo{
    static func getMaterial( _ completion: @escaping ([Materials]?, AFError?)->()){
        var materials = [Materials]()
        let url = "http://10.2.0.30:8000/material"
        AF.request(url, method: .get, parameters: nil).validate().responseData { response in
            if let error = response.error {
                debugPrint(error)
                completion(nil, error)
            }
            guard let res = response.value else {return}
            let company = JSON(res)
            let filtComp = company.arrayValue.filter { i in
                i["material_name"].string != "null"
            }
            for com in filtComp{
                let url1 = URL(string: com["image_url"].string!)
                AF.request(url1!, method: .get, parameters: nil).validate().responseData { response1 in
                    if let error1 = response.error {
                        debugPrint(error1)
                        completion(nil, error1)
                    }
                    guard let res1 = response1.value else {return}
                    materials.append(Materials(name: com["material_name"].string!, img: UIImage(data: res1)!)
                    )
                    completion(materials, nil)
                }
            }
        }
    }
    
    static func getInfo( _ completion: @escaping ([Company]?, AFError?)->()){
        var companies = [Company]()
        var materials = [Materials]()
        let url = "http://10.2.0.30:8000/company"
        AF.request(url, method: .get, parameters: nil).validate().responseData { response in
            if let error = response.error {
                debugPrint(error)
                completion(nil, error)
            }
            guard let res = response.value else {return}
            let company = JSON(res)
            for com in company.arrayValue{
                if(com["eco"].boolValue == false){
                    for j  in com["materials"].arrayValue{
                        materials.append(Materials(name: j["material_name"].description, img: j["image_url"].rawValue as? UIImage))
                    }
                    companies.append(Company(name: com["company_name"].string!, address: com["adress"].string!, hour: com["hours"].string!, phone: com["phone"].string!, website: com["web_link"].string!, eco: com["eco"].bool!, materials: materials , lati: com["latitude"].double!, long: com["longitude"].double!))
                }
            }
            completion(companies, nil)
        }
    }
    
    static func getMark( _ completion: @escaping ([Mark]?, AFError?)->()){
        var marks = [Mark]()
        let url = "http://10.2.0.30:8000/marks"
        AF.request(url, method: .get, parameters: nil).validate().responseData { response in
            if let error = response.error {
                debugPrint(error)
                completion(nil, error)
            }
            guard let res = response.value else {return}
            let company = JSON(res)
            let filtComp = company.arrayValue.filter { i in
                i["mark_name"].string != "null"
            }
            for com in filtComp{
                let url1 = URL(string: com["image_url"].string!)
                AF.request(url1!, method: .get, parameters: nil).validate().responseData { response1 in
                    if let error1 = response.error {
                        debugPrint(error1)
                        completion(nil, error1)
                    }
                    guard let res1 = response1.value else {return}
                    var materials = [Materials]()
                    for j  in com["materials"].arrayValue{
                        materials.append(Materials(name: j["material_name"].string!, img: nil,warn: j["warning"].string!))
                    }
                    marks.append(Mark(image: UIImage(data: res1)!, material: materials, description: com["text"].string!, markName: com["mark_name"].string!))
                    completion(marks, nil)
                }
            }
        }
    }
}

