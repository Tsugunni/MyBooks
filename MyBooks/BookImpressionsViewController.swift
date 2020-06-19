//
//  BookImpressionsViewController.swift
//  MyBooks
//
//  Created by Tsugumi on 2020/06/09.
//  Copyright © 2020 兼崎亜深. All rights reserved.
//

import UIKit
import os.log

class BookImpressionsViewController: UIViewController, UITextViewDelegate {
    
    //MARK: Properties
    var book: Book?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ratingControl: RatingControl!
    @IBOutlet weak var impressionsTextView: UITextView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        impressionsTextView.delegate = self
        
        titleLabel.numberOfLines = 0
        titleLabel.sizeToFit()
        impressionsTextView.layer.borderWidth = 1.0
        impressionsTextView.layer.cornerRadius = 5.0
        
        titleLabel.text = book?.title
        ratingControl.rating = book?.rating ?? 0
        impressionsTextView.text = book?.impression
    }
    
    
    // MARK: - Navigation
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        let isPresentingInAddMealMode = presentingViewController is UINavigationController
        
        if isPresentingInAddMealMode {
            dismiss(animated: true, completion: nil)
        }
        else if let owningNavigationController = navigationController {
            owningNavigationController.popViewController(animated: true)
        }
        else {
            fatalError("The MealViewController is not inside a navigation controller.")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }

        guard let bookDetailsViewController = segue.destination as? BookDetailsViewController else {
            fatalError("Unexpected destination: \(segue.destination)")
        }
        bookDetailsViewController.book?.rating = ratingControl.rating
        bookDetailsViewController.book?.impression = impressionsTextView.text
    }
    
    
    //MARK: Private Methods
    
    private func setAppearanceOfTextView() {
        
    }
}
