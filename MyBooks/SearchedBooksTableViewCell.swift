//
//  SearchedBooksTableViewCell.swift
//  MyBooks
//
//  Created by Tsugumi on 2020/05/28.
//  Copyright © 2020 兼崎亜深. All rights reserved.
//

import UIKit

class SearchedBooksTableViewCell: UITableViewCell {
    
    
    //MARK: Properties
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorsLabel: UILabel!
    @IBOutlet weak var printTypeLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    //MARK: Action
    
//    @IBAction func statusButton(_ sender: UIButton) {
//        let point = self.tableView.convertPoint(sender.frame.origin, fromView: sender.superview)
//        if let indexPath = self.tableView.indexPathForRowAtPoint(point) {
//            print("section: \(indexPath.section) - row: \(indexPath.row)")
//        }
//    }
}
