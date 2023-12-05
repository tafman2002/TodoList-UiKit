// Name: Tafadzwa Chimbindi
// Course: CIT 352 Mobile App
// Professor: Osborne
// ToDoItemTableViewCell.swift
//  ToDoList
// Purpose: To specify the tablecellview for the ToDoItemTableView
//  Created by citilab on 4/14/22.
//

import UIKit

class ToDoItemTableViewCell: UITableViewCell {
    // reference the widgets of the toDoItems Table View
    @IBOutlet weak var taskName: UILabel!
    @IBOutlet weak var taskDueDate: UILabel!
    @IBOutlet weak var taskPriority: UILabel!
    @IBOutlet weak var imgCheckMark: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
