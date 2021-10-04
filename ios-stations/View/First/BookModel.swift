//
//  FirstViewBookModel.swift
//  ios-stations
//
//  Created by MBP潤 on 2021/09/22.
//

struct Book: Decodable {
    var id: String
    var title: String
    var url: String
    var detail: String
    var review: String
    var reviewer: String
}
