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
        }
         
        return cell
     }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    
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
        bookDetailsVC.book = selectedBook
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
        guard let req_url = URL(string: "https://www.googleapis.com/books/v1/volumes?maxResults=10&q=\(keyword_encode)") else {
            return
        }
        print(req_url)
        
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
                        
                        let book = Book.init(title: item.volumeInfo.title, authorsList: item.volumeInfo.authors, imageLink: imageLink, publisher: item.volumeInfo.publisher, publishedDate: item.volumeInfo.publishedDate, printType: item.volumeInfo.printType, pageCount: item.volumeInfo.pageCount, language: item.volumeInfo.language, description: item.volumeInfo.description)
                        
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
            allMyBooks.append(book)
            
            if allMyBooks.contains(book) {
//                self.tableView.reloadRows(at: [indexPath], with: .none)
                self.tableView.reloadData()
            }
        }
    }
}
