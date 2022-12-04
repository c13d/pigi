//
//  TableViewDetail.swift
//  Pigi
//
//  Created by Christophorus Davin on 11/04/22.
//

import Foundation
import UIKit

class TableViewDetail: UIViewController
{
    
    var selectedGuide : StepModel!
    @IBOutlet weak var titleDetail: UILabel!
    
    @IBOutlet weak var timeDetail: UILabel!
    
    @IBOutlet weak var infoDetail: UILabel!
    
    @IBOutlet weak var learnDetail: UILabel!
    
    @IBOutlet weak var helpDetail: UILabel!
    
    @IBAction func StartLessonButton(_ sender: Any) {
        performSegue(withIdentifier: "startLessonSegue", sender: self)
    }
    
    @IBAction func closePress(_ sender: UIBarButtonItem) {
        self.navigationController?.popToRootViewController(animated: true)

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationItem.title = selectedGuide.title
        navigationItem.setHidesBackButton(true, animated: true)

//        self.navigationItem.backBarButtonItem?.isEnabled = false
        
        titleDetail.text = selectedGuide.title
        //raw
        
        if(titleDetail.text == "Speaking Pace")
        {
            timeDetail.text = "20 Min Lesson"
            infoDetail.text = "Learn how to make your voice perfect for presenting your message. "
            learnDetail.text = "Learn how to make your voice perfect for presenting your message."
            helpDetail.text = "Practice with a good pace so you talk not too slow or too fast"
        }
        
        
        
        
        
    }
}
