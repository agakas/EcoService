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
    var image: UIImage?
    var material: Materials
    var description: String
    var markName: String
}

struct Materials{
    var name: String
    var img: UIImage?
    var warn: String?
}

struct Barcode{
    var name: String
    var material: Materials
    var eco: Bool
    var type: String
    var consist: String
    var text: String?
    var imageMark: UIImage?
}

class CompanyInfo{
    static func getMaterial( _ completion: @escaping ([Materials]?, AFError?)->()){
        var materials = [Materials]()
        let url = "http://10.2.0.30:8000/material/"
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
                getImg(url: com["image_url"].string!) { img, errrr in
                    materials.append(Materials(name: com["material_name"].string!, img: img))
                    completion(materials, nil)
                }
            }
        }
    }
    
    static func getInfo( _ completion: @escaping ([Company]?, AFError?)->()){
        var companies = [Company]()
        var materials = [Materials]()
        let url = "http://10.2.0.30:8000/company/"
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
        let url = "http://10.2.0.30:8000/marks/"
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
                getImg(url: com["image_url"].string!) { img, errrr in
                    guard errrr == nil else {
                        completion(nil, errrr)
                        return
                    }
                    marks.append(Mark(image: img, material: Materials(name: (com["material_id"].dictionaryValue["material_name"]?.string!)!, img: nil, warn: (com["material_id"].dictionaryValue["warning"]?.string!)!), description: com["text"].string!, markName: com["mark_name"].string!))
                    completion(marks, nil)
                }
            }
        }
    }
    
    static func getImg(url: String, _ completion: @escaping (UIImage?, AFError?)->()){
        AF.request(url, method: .get, parameters: nil).validate().responseData { response in
            if let error = response.error {
                debugPrint(error)
                completion(nil, error)
            }
            guard let res = response.value else {return}
            completion(UIImage(data: res)!,nil)
        }
    }
    
    static func getBarcode(code: String, _ completion: @escaping (Barcode?, AFError?)->()){
        let url = "http://10.2.0.30:8000/barcode/\(code)"
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
                if com["mark"].dictionaryValue["text"]?.stringValue != "null"{
                    getImg(url: com["mark"].dictionaryValue["image_url"]!.stringValue) { img, errrr in
                        guard errrr == nil else {
                            completion(nil, errrr)
                            return
                        }
                        completion(Barcode(name: com["name_ware"].stringValue, material: Materials(name: (com["material"].dictionaryValue["material_name"]?.string!)!, img: nil, warn: nil), eco: com["eco"].boolValue, type: (com["ware_type"].dictionaryValue["ware_type"]?.string!)!, consist: com["consist"].stringValue, text: (com["mark"].dictionaryValue["text"]?.string!)!, imageMark: img), nil)
                    }
                } else {
                    completion(Barcode(name: com["name_ware"].stringValue, material: Materials(name: (com["material_id"].dictionaryValue["material_name"]?.string!)!, img: nil, warn: nil), eco: com["eco"].boolValue, type: (com["ware_type"].dictionaryValue["ware_type"]?.string!)!, consist: com["eco"].stringValue, text: (com["mark"].dictionaryValue["text"]?.string!)!, imageMark: nil), nil)
                }
            }
        }
    }
    
    
}

