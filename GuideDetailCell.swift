//
//  GuideDetailCell.swift
//  Pigi
//
//  Created by Christophorus Davin on 12/04/22.
//

import Foundation
import UIKit

class GuideDetailCell: UITableViewCell {
    @IBOutlet weak var imageGuideDetailCell: UIImageView!
    @IBOutlet weak var titleGuideDetailCell: UILabel!
    @IBOutlet weak var descGuideDetailCell: UILabel!
    
    var object: StepModel? {
        didSet {
            setupView()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setupView() {
        guard let data = object else { return }
        imageGuideDetailCell.image = UIImage(named: data.image ?? "")
        titleGuideDetailCell.text = data.title
        descGuideDetailCell.text = data.description
    }
}
