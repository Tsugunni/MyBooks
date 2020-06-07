//
//  BookDetailsViewController.swift
//  MyBooks
//
//  Created by Tsugumi on 2020/05/28.
//  Copyright © 2020 兼崎亜深. All rights reserved.
//

import UIKit

class BookDetailsViewController: UIViewController {
    
    //MARK: Properties
    
    var book: Book?
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorsLabel: UILabel!
    @IBOutlet weak var statusButton: UIButton!
    
    @IBOutlet weak var publisherLabel: UILabel!
    @IBOutlet weak var publishedDateLabel: UILabel!
    @IBOutlet weak var printTypeLabel: UILabel!
    @IBOutlet weak var pageCountLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        loadSampleBook()
        setBookData()
    }
    
    
    //MARK: Action
    
    @IBAction func statusButton(_ sender: Any) {
    }
    
    
    //MARK: Private Methods
    
    private func setBookData() {
        photoImageView.image = book?.image
        titleLabel.text = book?.title ?? "-"
        authorsLabel.text = book?.authors ?? "-"
        publisherLabel.text = book?.publisher ?? "-"
        publishedDateLabel.text = book?.publishedDate ?? "-"
        printTypeLabel.text = book?.printType ?? "-"
        pageCountLabel.text = book?.pageCount?.description ?? "-"
        languageLabel.text = book?.language ?? "-"
        descriptionLabel.text = book?.description ?? "-"
        
        titleLabel.numberOfLines = 0
        titleLabel.sizeToFit()
        descriptionLabel.numberOfLines = 0
        descriptionLabel.sizeToFit()
    }
    
    private func loadSampleBook() {
        book = Book(
            title: "また、同じ夢を見ていた【無料お試し読み増量版】",
            authorsList: ["住野よる"],
//            imageLink: URL(string: "http://books.google.com/books/content?id=gPpqDwAAQBAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api"),
            imageLink: nil,
            publisher: "双葉社",
            publishedDate: nil,
            printType: "BOOK",
            pageCount: 256,
            language: "ja",
            description: "【劇場アニメ「君の膵臓をたべたい」大ヒット記念！ 無料お試し読み増量版公開中！】デビュー作にして80万部を超えるベストセラーとなった「君の膵臓（すいぞう）をたべたい」の著者が贈る、待望の最新作。友達のいない少女、リストカットを繰り返す女子高生、アバズレと罵られる女、一人静かに余生を送る老婆。彼女たちの“幸せ”は、どこにあるのか。「やり直したい」ことがある、“今”がうまくいかない全ての人たちに送る物語。"
        )
    }
}

