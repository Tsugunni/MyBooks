//
//  Book.swift
//  MyBooks
//
//  Created by Tsugumi on 2020/05/29.
//  Copyright © 2020 兼崎亜深. All rights reserved.
//

import UIKit
import os.log

class Book: NSObject, NSSecureCoding {
    static var supportsSecureCoding: Bool = true
    
    static func == (lhs: Book, rhs: Book) -> Bool {
        return lhs.title == rhs.title &&
               lhs.authors == rhs.authors &&
               lhs.publisher == rhs.publisher &&
               lhs.publishedDate == rhs.publishedDate &&
               lhs.printType == rhs.printType &&
               lhs.pageCount == rhs.pageCount &&
               lhs.language == rhs.language &&
               lhs.explanation == rhs.explanation
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
    var explanation: String?
    var status: String
    var rating: Int
    var impression: String
    
    
    //MARK: Archiving Paths
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let allMyBooksArchiveURL = DocumentsDirectory.appendingPathComponent("allMyBooks")
    static let wantToReadBooksArchiveURL = DocumentsDirectory.appendingPathComponent("wantToReadBooks")
    static let readingBooksArchiveURL = DocumentsDirectory.appendingPathComponent("readingBooks")
    static let readBooksArchiveURL = DocumentsDirectory.appendingPathComponent("readBooks")
    
    
    //MARK: Types
    
    struct PropertyKey {
        static let title = "title"
        static let authors = "authors"
        static let image = "image"
        static let publisher = "publisher"
        static let publishedDate = "publishedDate"
        static let printType = "printType"
        static let pageCount = "pageCount"
        static let language = "language"
        static let explanation = "explanation"
        static let status = "status"
        static let rating = "rating"
        static let impression = "impression"
    }
    
    //MARK: Initialization
    
    init?(title: String?, authors: String?, image: UIImage, publisher: String?, publishedDate: String?,
          printType: String?, pageCount: Int?, language: String?, explanation: String?) {
        
        self.title = title
        self.authors = authors
        self.image = image
        self.publisher = publisher
        self.publishedDate = publishedDate
        self.printType = printType
        self.pageCount = pageCount
        self.language = language
        self.explanation = explanation
        self.status = "未追加"
        self.rating = 0
        self.impression = ""
    }
    
    
    //MARK: NSCoding
    
    func encode(with coder: NSCoder) {
        coder.encode(title, forKey: PropertyKey.title)
        coder.encode(authors, forKey: PropertyKey.authors)
        coder.encode(image, forKey: PropertyKey.image)
        coder.encode(publisher, forKey: PropertyKey.publisher)
        coder.encode(publishedDate, forKey: PropertyKey.publishedDate)
        coder.encode(printType, forKey: PropertyKey.printType)
        coder.encode(pageCount, forKey: PropertyKey.pageCount)
        coder.encode(language, forKey: PropertyKey.language)
        coder.encode(explanation, forKey: PropertyKey.explanation)
        coder.encode(status, forKey: PropertyKey.status)
        coder.encode(rating, forKey: PropertyKey.rating)
        coder.encode(impression, forKey: PropertyKey.impression)
    }
    
    required convenience init?(coder decoder: NSCoder) {
        guard let image = decoder.decodeObject(forKey: PropertyKey.image) as? UIImage else {
            os_log("Unable to decode the image for a Book object.", log: OSLog.default, type: .debug)
            return nil
        }
        guard let status = decoder.decodeObject(forKey: PropertyKey.status) as? String else {
            os_log("Unable to decode the status for a Book object.", log: OSLog.default, type: .debug)
            return nil
        }
        guard let impression = decoder.decodeObject(forKey: PropertyKey.impression) as? String else {
            os_log("Unable to decode the impression for a Book object.", log: OSLog.default, type: .debug)
            return nil
        }
        let title = decoder.decodeObject(forKey: PropertyKey.title) as? String
        let authors = decoder.decodeObject(forKey: PropertyKey.authors) as? String
        let publisher = decoder.decodeObject(forKey: PropertyKey.publisher) as? String
        let publishedDate = decoder.decodeObject(forKey: PropertyKey.publishedDate) as? String
        let printType = decoder.decodeObject(forKey: PropertyKey.printType) as? String
        let pageCount = decoder.decodeObject(forKey: PropertyKey.pageCount) as? Int
        let language = decoder.decodeObject(forKey: PropertyKey.language) as? String
        let explanation = decoder.decodeObject(forKey: PropertyKey.explanation) as? String
        let rating = decoder.decodeInteger(forKey: PropertyKey.rating)
        
        
        self.init(title: title, authors: authors, image: image, publisher: publisher, publishedDate: publishedDate, printType: printType, pageCount: pageCount, language: language, explanation: explanation)
        self.status = status
        self.rating = rating
        self.impression = impression
    }
}
