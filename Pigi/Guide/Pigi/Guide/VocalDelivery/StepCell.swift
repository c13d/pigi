//
//  StepCell.swift
//  Pigi
//
//  Created by Christophorus Davin on 11/04/22.
//

import UIKit

class StepCell: UITableViewCell {

    @IBOutlet weak var stepImage: UIImageView!
    @IBOutlet weak var stepTitle: UILabel!
    @IBOutlet weak var stepDesc: UILabel!
    
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
        stepImage.image = UIImage(named: data.image ?? "")
        stepTitle.text = data.title
        stepDesc.text = data.description
    }


}
