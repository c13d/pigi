//
//  PracticeSetTimerViewController.swift
//  Pigi
//
//  Created by Chrismanto Natanail Manik on 10/04/22.
//

import UIKit
import MobileCoreServices

class PracticeSetTimerViewController: UIViewController {

    @IBOutlet weak var timerButton: UIButton!{
        didSet{
            timerButton.clipsToBounds = true
            timerButton.layer.cornerRadius = 10
        }
    }
    @IBOutlet weak var timerPicker: UIDatePicker!
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true

        // Do any additional setup after loading the view.
    }
    
    @IBAction func timerPress(_ sender: Any) {
        
        performSegue(withIdentifier: "toRecord", sender: self)

//        let minuteDuration = Int(timerPicker.countDownDuration)
//        secondsToMinutesSeconds(minuteDuration)
        
//        VideoHelper.startMediaBrowser(delegate: self, sourceType: .camera, duration: minuteDuration)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let secondDuration = Int(timerPicker.countDownDuration)
        if segue.identifier == "toRecord"{
            let destinationVc = segue.destination as! PracticeRecordViewController
            destinationVc.timeRemaining = secondDuration
            destinationVc.timeCurrent = secondDuration
        }
    }
    
//    @objc func step(){
//        let timeVerify = UILabel()
//        if timeRemaining > 0{
//            timeRemaining -= 1
//        }else{
//            timer.invalidate()
//            timeRemaining = 0
//        }
//        let timeConvert = secondsToMinutesSeconds(timeRemaining)
//        Utilities.styleAlertLabel(label: timeVerify, text: "\(timeConvert)")
//        NSLayoutConstraint.activate([timeVerify.widthAnchor.constraint(equalToConstant: 45)])
//        timeVerify.textAlignment = .left
//        otpTextField.rightView = timeVerify
//    }
//
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension PracticeSetTimerViewController: UIImagePickerControllerDelegate{
    
}
extension PracticeSetTimerViewController: UINavigationControllerDelegate{
    
}
