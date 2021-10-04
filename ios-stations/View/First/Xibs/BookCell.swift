//
//  BookCell.swift
//  ios-stations
//

import UIKit

class BookCell: UITableViewCell {
    
    var bookItem: Book? {
        didSet {
            cellTitleLabel.text = bookItem?.title
            cellDetailLabel.text = bookItem?.detail
        }
    }
    
    @IBOutlet weak var cellImageView: UIImageView!
    @IBOutlet weak var cellTitleLabel: UILabel!
    @IBOutlet weak var cellDetailLabel: UILabel!
    
    var element: Book!
    
    override func awakeFromNib() -> Void {
        super.awakeFromNib()
    }
    
    
}
