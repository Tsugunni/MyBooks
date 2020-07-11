//
//  MyBooksCollectionViewController.swift
//  MyBooks
//
//  Created by Tsugumi on 2020/06/01.
//  Copyright © 2020 兼崎亜深. All rights reserved.
//

import UIKit
import os.log

private let reuseIdentifier = "MyBooksCollectionViewCell"
var allMyBooks: [Book] = []
var wantToReadBooks: [Book] = []
var readingBooks: [Book] = []
var readBooks: [Book] = []

class MyBooksCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate {
    
    
    //MARK: Properties
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var currentBooksList: [Book] = allMyBooks
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        let longPressGesture = UILongPressGestureRecognizer(
            target: self,
            action: #selector(self.longPressAction(_:)))
        longPressGesture.delegate = self
        self.view.addGestureRecognizer(longPressGesture)
        
        setCollectionViewCellSize()
        
        let loadedBooks: [[Book]] = loadBooks()
        allMyBooks += loadedBooks[0]
        wantToReadBooks += loadedBooks[1]
        readingBooks += loadedBooks[2]
        readBooks += loadedBooks[3]
        
        currentBooksList = allMyBooks
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        matchListAndSegment()
    }
    
    
    // MARK: - UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return currentBooksList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? MyBooksCollectionViewCell else {
            fatalError("The dequeued cell is not an instance of MyBooksTableViewCell.")
        }
        
        let book = currentBooksList[indexPath.row]
        
        cell.photoImageView.image = book.image
        
        return cell
    }
    
    
    //MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard let bookDetailsVC = segue.destination as? BookDetailsViewController else {
            fatalError("Unexpected destination: \(segue.destination)")
        }
        
        guard let selectedBookCell = sender as? MyBooksCollectionViewCell else {
            fatalError("Unexpected sender: \(String(describing: sender))")
        }
        
        guard let indexPath = collectionView.indexPath(for: selectedBookCell) else {
            fatalError("The selected cell is not being displayed by the table")
        }
        
        let selectedBook = currentBooksList[indexPath.row]
        bookDetailsVC.book = selectedBook
    }
    
    
    //MARK: Actions
    
    @IBAction func segmantChanged(_ sender: Any) {
        matchListAndSegment()
    }
    
    @objc func longPressAction(_ sender: UILongPressGestureRecognizer) {
        let point = sender.location(in: self.collectionView)
        let indexPath = self.collectionView.indexPathForItem(at: point)
        
        if let indexPath = indexPath {
            let alertController = UIAlertController(title: "編集", message: "選択してください", preferredStyle: .actionSheet)
            
            let deleteAction = UIAlertAction(title: "削除", style: .destructive, handler: { (action) in
                print(indexPath, "delete")
                print(self.currentBooksList)
                
                let book: Book = self.currentBooksList[indexPath.row]
                switch book.status {
                case "読みたい":
                    let index = wantToReadBooks.firstIndex(of: book)
                    wantToReadBooks.remove(at: index!)
                case "読んでる":
                    let index = readingBooks.firstIndex(of: book)
                    readingBooks.remove(at: index!)
                case "読んだ":
                    let index = readBooks.firstIndex(of: book)
                    readBooks.remove(at: index!)
                default:
                    fatalError("The status is not exist")
                }
                
                let index = allMyBooks.firstIndex(of: book)
                allMyBooks.remove(at: index!)
                MyBooksCollectionViewController.saveBooks()
                
                self.matchListAndSegment()
            })
            alertController.addAction(deleteAction)
            
            let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            
            alertController.popoverPresentationController?.sourceView = view
            
            present(alertController, animated: true, completion: nil)
        }
    }
    
    
    //MARK: Private Methods
    
    private func setCollectionViewCellSize() {
        let layout = UICollectionViewFlowLayout()
        let width: CGFloat = self.collectionView.layer.bounds.width / 3 - 40
        let height: CGFloat = width / 0.6
        layout.itemSize = CGSize(width: width, height: height)
        layout.minimumLineSpacing = 20
        layout.sectionInset = UIEdgeInsets(top: 10, left: 20, bottom: 0, right: 20)
        collectionView.collectionViewLayout = layout
    }
    
    private func matchListAndSegment() {
        let selectedIndex = segmentedControl.selectedSegmentIndex
        let segmentTitle = segmentedControl.titleForSegment(at: selectedIndex)
        
        switch segmentTitle {
        case "全て":
            currentBooksList = allMyBooks
        case "読みたい":
            currentBooksList = wantToReadBooks
        case "読んでる":
            currentBooksList = readingBooks
        case "読んだ":
            currentBooksList = readBooks
        default:
            fatalError("The selected segment is not exist")
        }
        
        self.collectionView.reloadData()
    }
    
    
    internal func loadBooks() -> [[Book]] {
        
        var loadedBooks: [[Book]] = []
        let userDefaults = UserDefaults.standard
        
        // check if there is a value in UserDefaults
//        if let userDefaultsObject = userDefaults.object(forKey: Book.allMyBooksArchiveURL.path) {
//            print("\nuserDefaultsObject")
//            dump(userDefaultsObject)
//        } else {
//            print("\nuserDefaultsObject is not exist")
//        }
        
        if let loadedAllMyBooksData = userDefaults.data(forKey: Book.allMyBooksArchiveURL.path) {
            do {
                let loadedAllMyBooks = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(loadedAllMyBooksData) as? [Book]
                loadedBooks.append(loadedAllMyBooks ?? [])
            } catch let error {
                print("Unexpected error: \(error).")
            }
        } else {
            loadedBooks.append([])
        }
        
        if let loadedWantToReadBooksData = userDefaults.data(forKey: Book.wantToReadBooksArchiveURL.path) {
            do {
                let loadedWantToReadBooks = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(loadedWantToReadBooksData) as? [Book]
                loadedBooks.append(loadedWantToReadBooks ?? [])
            } catch {
                print("Unexpected error: \(error).")
            }
        } else {
            loadedBooks.append([])
        }
        
        if let loadedReadingBooksData = userDefaults.data(forKey: Book.readingBooksArchiveURL.path) {
            do {
                let loadedReadingBooks = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(loadedReadingBooksData) as? [Book]
                loadedBooks.append(loadedReadingBooks ?? [])
            } catch {
                print("Unexpected error: \(error).")
            }
        } else {
            loadedBooks.append([])
        }
        
        if let loadedReadBooksData = userDefaults.data(forKey: Book.readBooksArchiveURL.path) {
            do {
                let loadedReadBooks = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(loadedReadBooksData) as? [Book]
                loadedBooks.append(loadedReadBooks ?? [])
            } catch {
                print("Unexpected error: \(error).")
            }
        } else {
            loadedBooks.append([])
        }
        
        return loadedBooks
    }
    
    
    //MARK: Class Methods
    
    class func saveBooks() {
        let userDefaults = UserDefaults.standard
        
        guard let archiveAllMyBooks = try? NSKeyedArchiver.archivedData(withRootObject: allMyBooks, requiringSecureCoding: true) else {
            fatalError("Archive failed")
        }
        userDefaults.set(archiveAllMyBooks, forKey: Book.allMyBooksArchiveURL.path)
        guard let archiveWantToReadBooks = try? NSKeyedArchiver.archivedData(withRootObject: wantToReadBooks, requiringSecureCoding: true) else {
            fatalError("Archive failed")
        }
        userDefaults.set(archiveWantToReadBooks, forKey: Book.wantToReadBooksArchiveURL.path)
        
        guard let archiveReadingBooks = try? NSKeyedArchiver.archivedData(withRootObject: readingBooks, requiringSecureCoding: true) else {
            fatalError("Archive failed")
        }
        userDefaults.set(archiveReadingBooks, forKey: Book.readingBooksArchiveURL.path)
        
        guard let archiveReadBooks = try? NSKeyedArchiver.archivedData(withRootObject: readBooks, requiringSecureCoding: true) else {
            fatalError("Archive failed")
        }
        userDefaults.set(archiveReadBooks, forKey: Book.readBooksArchiveURL.path)
        
        let isSuccessfulSave =
            NSKeyedArchiver.archiveRootObject(allMyBooks, toFile: Book.allMyBooksArchiveURL.path) &&
            NSKeyedArchiver.archiveRootObject(wantToReadBooks, toFile: Book.wantToReadBooksArchiveURL.path) &&
            NSKeyedArchiver.archiveRootObject(readingBooks, toFile: Book.readingBooksArchiveURL.path) &&
            NSKeyedArchiver.archiveRootObject(readBooks, toFile: Book.readBooksArchiveURL.path)
        
        if isSuccessfulSave {
            os_log("Books successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save books...", log: OSLog.default, type: .error)
        }
    }
}
