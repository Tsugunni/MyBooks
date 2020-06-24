//
//  Book.swift
//  MyBooks
//
//  Created by Tsugumi on 2020/05/29.
//  Copyright © 2020 兼崎亜深. All rights reserved.
//

import UIKit

class Book: Equatable {
    
    static func == (lhs: Book, rhs: Book) -> Bool {
        return lhs.title == rhs.title &&
               lhs.authors == rhs.authors &&
               lhs.image == rhs.image &&
               lhs.publisher == rhs.publisher &&
               lhs.publishedDate == rhs.publishedDate &&
               lhs.printType == rhs.printType &&
               lhs.pageCount == rhs.pageCount &&
               lhs.language == rhs.language &&
               lhs.description == rhs.description
    }
    
    
    //MARK: Properties
    
    var title: String?
    var authors: String?
    var image: UIImage
    var publisher: String?
    var publishedDate: String?
    var printType: String?
    var pageCount: Int?
    var language: String?
    var description: String?
    var status: String
    var rating: Int
    var impression: String?
    
    
    //MARK: Initialization
    
    init?(title: String?, authorsList: [String]?, imageLink: URL?, publisher: String?, publishedDate: String?,
          printType: String?, pageCount: Int?, language: String?, description: String?) {
        
        //        guard !title.isEmpty else {
        //            return nil
        //        }
        
        var authors: String = ""
        if let authorsList = authorsList {
            for (i, author) in authorsList.enumerated() {
                if i > 0 {
                    authors += ", "
                }
                authors += author
            }
        }
        
        var imageData: UIImage!
        if let imageLink = imageLink {
            if let imageD = try? Data(contentsOf: imageLink) {
                imageData = UIImage(data: imageD)
            }
        } else {
            imageData = UIImage(named: "NoImage")
        }
        
        self.title = title
        self.authors = authors
        self.image = imageData
        self.publisher = publisher
        self.publishedDate = publishedDate
        self.printType = printType
        self.pageCount = pageCount
        self.language = language
        self.description = description
        self.status = "未追加"
        self.rating = 0
        self.impression = ""
    }
}
