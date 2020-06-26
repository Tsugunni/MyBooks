//
//  MyBooksCollectionViewController.swift
//  MyBooks
//
//  Created by Tsugumi on 2020/06/01.
//  Copyright © 2020 兼崎亜深. All rights reserved.
//

import UIKit

private let reuseIdentifier = "MyBooksCollectionViewCell"
var allMyBooks = [Book]()
var wantToReadBooks = [Book]()
var readingBooks = [Book]()
var readBooks = [Book]()

class MyBooksCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    //MARK: Properties
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var currentBooksList: [Book] = allMyBooks
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        setCollectionViewCellSize()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        separateBooksByStatus()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

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

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */
    
    
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
        separateBooksByStatus()
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
    
    private func separateBooksByStatus() {
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
}
