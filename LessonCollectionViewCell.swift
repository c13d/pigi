//
//  LessonCollectionViewCell.swift
//  Pigi
//
//  Created by alvin anderson on 12/04/22.
//

import UIKit

class LessonCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var nextButton: UIButton!
    
    var object: StepModel? {
        didSet {
            setupView()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

   
    func setupView() {
        guard let data = object else { return }
        
        titleLabel.text = data.title
        infoLabel.text = data.description
        image.image = UIImage(named: data.image ?? "")
    }
    
}
