//
//  NoteCell.swift
//  Milestone-Projects19-21
//
//  Created by Ayşıl Simge Karacan on 3.10.2020.
//

import UIKit

class NoteCell: UITableViewCell {
    
    @IBOutlet weak var cellTitleLabel: UILabel!

    @IBOutlet weak var cellSubtitleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

}
