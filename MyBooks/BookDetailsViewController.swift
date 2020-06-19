//
//  BookDetailsViewController.swift
//  MyBooks
//
//  Created by Tsugumi on 2020/05/28.
//  Copyright © 2020 兼崎亜深. All rights reserved.
//

import UIKit
import os.log

class BookDetailsViewController: UIViewController {
    
    //MARK: Properties
    
    var book: Book?
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorsLabel: UILabel!
    @IBOutlet weak var statusButton: UIButton!
    
    @IBOutlet weak var writeImpressionsButton: UIButton!
    @IBOutlet weak var impressionsStackView: UIStackView!
    @IBOutlet weak var ratingControl: RatingControl!
    @IBOutlet weak var impressionsLabel: UILabel!
    
    @IBOutlet weak var publisherLabel: UILabel!
    @IBOutlet weak var publishedDateLabel: UILabel!
    @IBOutlet weak var printTypeLabel: UILabel!
    @IBOutlet weak var pageCountLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadSampleBook()
        allMyBooks.append(book!)
        setBookData()
        updateImpresstionsView()
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        print("appear")
//
//        setBookData()
//        if allMyBooks.contains(book!) {
//            if book?.rating == 0, book?.impression == nil {
//                impressionsStackView.isHidden = true
//            }
//            else {
//                writeImpressionsButton.isHidden = true
//            }
//        }
//        else {
//            writeImpressionsButton.isHidden = true
//            impressionsStackView.isHidden = true
//        }
//
//
//    }
    
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch (segue.identifier ?? "") {
        case "addImpressions":
            guard
                let navigationController = segue.destination as? UINavigationController,
                let bookImpressionsViewController = navigationController.visibleViewController as? BookImpressionsViewController
                else {
                    fatalError("Unexpected destination: \(segue.destination)")
            }
            bookImpressionsViewController.book = self.book
            
        case "editImpressions":
            guard let bookImpressionsViewController = segue.destination as? BookImpressionsViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            bookImpressionsViewController.book = self.book
            
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }
    
    //MARK: Actions
    
    @IBAction func unwindToBookDetails(sendr: UIStoryboardSegue) {
        ratingControl.rating = self.book?.rating ?? 0
        impressionsLabel.text = self.book?.impression ?? "感想を入力してください"
        
//        setBookData()
        updateImpresstionsView()

    }
    
    @IBAction func statusButton(_ sender: Any) {
    }
    
    
    //MARK: Private Methods
    
    private func setBookData() {
        photoImageView.image = self.book?.image
        titleLabel.text = self.book?.title ?? "-"
        authorsLabel.text = self.book?.authors ?? "-"
        ratingControl.rating = self.book?.rating ?? 0
        impressionsLabel.text = self.book?.impression ?? "感想を入力してください"
        publisherLabel.text = self.book?.publisher ?? "-"
        publishedDateLabel.text = self.book?.publishedDate ?? "-"
        printTypeLabel.text = self.book?.printType ?? "-"
        pageCountLabel.text = self.book?.pageCount?.description ?? "-"
        languageLabel.text = self.book?.language ?? "-"
        descriptionLabel.text = self.book?.description ?? "-"
        
        titleLabel.numberOfLines = 0
        titleLabel.sizeToFit()
        impressionsLabel.numberOfLines = 0
        impressionsLabel.sizeToFit()
        descriptionLabel.numberOfLines = 0
        descriptionLabel.sizeToFit()
    }
    
    private func updateImpresstionsView() {
        if allMyBooks.contains(book!) {
            if book?.rating == 0, book?.impression == "" {
                writeImpressionsButton.isHidden = false
                impressionsStackView.isHidden = true
            }
            else {
                writeImpressionsButton.isHidden = true
                impressionsStackView.isHidden = false
            }
        }
        else {
            writeImpressionsButton.isHidden = true
            impressionsStackView.isHidden = true
        }
    }
    
    private func loadSampleBook() {
        self.book = Book(
            title: "また、同じ夢を見ていた【無料お試し読み増量版】",
            authorsList: ["住野よる"],
            imageLink: URL(string: "http://books.google.com/books/content?id=gPpqDwAAQBAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api"),
            //            imageLink: nil,
            publisher: "双葉社",
            publishedDate: nil,
            printType: "BOOK",
            pageCount: 256,
            language: "ja",
            description: "【劇場アニメ「君の膵臓をたべたい」大ヒット記念！ 無料お試し読み増量版公開中！】デビュー作にして80万部を超えるベストセラーとなった「君の膵臓（すいぞう）をたべたい」の著者が贈る、待望の最新作。友達のいない少女、リストカットを繰り返す女子高生、アバズレと罵られる女、一人静かに余生を送る老婆。彼女たちの“幸せ”は、どこにあるのか。「やり直したい」ことがある、“今”がうまくいかない全ての人たちに送る物語。"
        )
//        book?.rating = 3
//        book?.impression = "ああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああ"
    }
}

