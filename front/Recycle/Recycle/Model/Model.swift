//
//  RecycleMap.swift
//  Recycle
//
//  Created by Dima Savelyev on 11.03.2022.
//

import UIKit

struct Company {
    var name: String
    var address: String
    var hour: String
    var description: String
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
    var description: String
}

