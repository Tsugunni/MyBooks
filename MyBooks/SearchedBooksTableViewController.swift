//
//  SearchedBooksTableViewController.swift
//  MyBooks
//
//  Created by Tsugumi on 2020/05/28.
//  Copyright © 2020 兼崎亜深. All rights reserved.
//

import UIKit

class SearchedBooksTableViewController: UITableViewController, UISearchBarDelegate {
    
    //MARK: Properties
    
    @IBOutlet weak var searchText: UISearchBar!
    var searchedBooks = [Book]()
    let numberOfGettingBooks = 10
    
    struct ResultJson: Codable {
        let items: [ItemJson]?
    }
    
    struct ItemJson: Codable {
        let volumeInfo: VolumeInfoJson
    }
    
    struct VolumeInfoJson: Codable {
        let title: String?
        let authors: [String]?
        let imageLinks: ImageLinkJson?
        let publisher: String?
        let publishedDate: String?
        let printType: String?
        let pageCount: Int?
        let language: String?
        let description: String?
    }
    
    struct ImageLinkJson: Codable {
        let thumbnail: URL?
        let small: URL?
        let medium: URL?
        let large: URL?
        let smallThumbnail: URL?
        let extraLarge: URL?
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchText.delegate = self
        searchText.placeholder = "本のタイトルや著者名を入力してください"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return searchedBooks.count
    }
    
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchedBooksTableViewCell", for: indexPath) as? SearchedBooksTableViewCell else {
            fatalError("The dequeued cell is not an instance of SearchedBooksTableViewCell.")
        }
        
        let book = searchedBooks[indexPath.row]
        
        cell.photoImageView.image = book.image
        cell.titleLabel.text = book.title
        cell.authorsLabel.text = book.authors
        cell.printTypeLabel.text = book.printType
        
        if allMyBooks.contains(book) {
            cell.addButton.isHidden = true
        } else {
            cell.addButton.isHidden = false
        }
         
        return cell
     }
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard let bookDetailsVC = segue.destination as? BookDetailsViewController else {
            fatalError("Unexpected destination: \(segue.destination)")
        }
        
        guard let selectedBookCell = sender as? SearchedBooksTableViewCell else {
            fatalError("Unexpected sender: \(String(describing: sender))")
        }
        
        guard let indexPath = tableView.indexPath(for: selectedBookCell) else {
            fatalError("The selected cell is not being displayed by the table")
        }
        
        let selectedBook = searchedBooks[indexPath.row]
        
        if allMyBooks.contains(selectedBook) {
            let index = allMyBooks.firstIndex(of: selectedBook)
            bookDetailsVC.book = allMyBooks[index!]
        } else {
            bookDetailsVC.book = selectedBook
        }
     }
    
    
    //MARK: Search Books
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
        
        if let searchWord = searchBar.text {
            searchBooks(keyword: searchWord)
        }
    }
    
    func searchBooks(keyword: String) {
        guard let keyword_encode = keyword.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return
        }
        
        // create request URL
        guard let req_url = URL(string: "https://www.googleapis.com/books/v1/volumes?maxResults=\(numberOfGettingBooks)&q=\(keyword_encode)") else {
            return
        }
        
        let req = URLRequest(url: req_url)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: req, completionHandler: {
            (data, response, error) in
            session.finishTasksAndInvalidate()
            
            do {
                let decoder = JSONDecoder()
                let json = try decoder.decode(ResultJson.self, from: data!)
                
                self.searchedBooks.removeAll()
                
                if let items = json.items {
                    for item in items {
                        
                        var imageLink: URL?
                        if let imageLinks = item.volumeInfo.imageLinks {
                            if let mediumImage = imageLinks.medium {
                                imageLink = mediumImage
                            }
                            else if let smallImage = imageLinks.small{
                                imageLink = smallImage
                            }
                            else if let largeImage = imageLinks.large {
                                imageLink = largeImage
                            }
                            else if let extraLargeImage = imageLinks.extraLarge {
                                imageLink = extraLargeImage
                            }
                            else if let thumbnailImage = imageLinks.thumbnail {
                                imageLink = thumbnailImage
                            }
                            else if let smallThumbnailImage = imageLinks.smallThumbnail {
                                imageLink = smallThumbnailImage
                            } else {
                                return
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
                        
                        var authors: String = ""
                        if let authorsList = item.volumeInfo.authors {
                            for (i, author) in authorsList.enumerated() {
                                if i > 0 {
                                    authors += ", "
                                }
                                authors += author
                            }
                        }

                        let book = Book(title: item.volumeInfo.title, authors: authors, image: imageData, publisher: item.volumeInfo.publisher, publishedDate: item.volumeInfo.publishedDate, printType: item.volumeInfo.printType, pageCount: item.volumeInfo.pageCount, language: item.volumeInfo.language, explanation: item.volumeInfo.description)
                        
                        if let book = book {
                            self.searchedBooks.append(book)
                        } else {
                            print("book is nil")
                        }
                    }
                    self.tableView.reloadData()
                }
            } catch {
                print("error")
                print(error)
            }
        })
        task.resume()
    }
    
    
    //MARK: Action
    
    @IBAction func statusButton(_ sender: UIButton) {
        let point = self.tableView.convert(sender.frame.origin, from: sender.superview)
        if let indexPath = self.tableView.indexPathForRow(at: point) {
            let book = searchedBooks[indexPath.row]
            if allMyBooks.contains(book) {
                return
            }
            
            let alertController = UIAlertController(title: "読書状況", message: "選択してください", preferredStyle: .actionSheet)
            
            let wantToReadAction = UIAlertAction(title: "読みたい", style: .default, handler: { (action) in
                book.status = "読みたい"
                wantToReadBooks.append(book)
                allMyBooks.append(book)
                MyBooksCollectionViewController.saveBooks()
                if allMyBooks.contains(book) {
                    self.tableView.reloadRows(at: [indexPath], with: .none)
                }
            })
            alertController.addAction(wantToReadAction)
            
            let readingAction = UIAlertAction(title: "読んでる", style: .default, handler: { (action) in
                book.status = "読んでる"
                readingBooks.append(book)
                allMyBooks.append(book)
                MyBooksCollectionViewController.saveBooks()
                if allMyBooks.contains(book) {
                    self.tableView.reloadRows(at: [indexPath], with: .none)
                }
            })
            alertController.addAction(readingAction)
            
            let readAction = UIAlertAction(title: "読んだ", style: .default, handler: { (action) in
                book.status = "読んだ"
                readBooks.append(book)
                allMyBooks.append(book)
                MyBooksCollectionViewController.saveBooks()
                if allMyBooks.contains(book) {
                    self.tableView.reloadRows(at: [indexPath], with: .none)
                }
            })
            alertController.addAction(readAction)
            
            let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            
            alertController.popoverPresentationController?.sourceView = view
            
            present(alertController, animated: true, completion: nil)
        }
    }
}
