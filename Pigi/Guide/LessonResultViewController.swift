//
//  LessonResultViewController.swift
//  Pigi
//
//  Created by Christophorus Davin on 12/04/22.
//

import UIKit
import AVFoundation

class LessonResultViewController: UIViewController {

    @IBOutlet weak var speedLbl: UILabel!
    @IBOutlet weak var wordPerMinLbl: UILabel!
    @IBOutlet weak var motivationLbl: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var timeLbl1: UILabel!
    @IBOutlet weak var timeLbl2: UILabel!
    
    @IBOutlet weak var wordsView: UIView!
    @IBOutlet weak var motivateView: UIView!
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var slowStsLabel: UILabel!
    @IBOutlet weak var normalStsLabel: UILabel!
    @IBOutlet weak var fastStsLabel: UILabel!
    
    @IBOutlet weak var statusStackView: UIStackView!
    
    var pace: SpeakingPace?
    var resultPractice: Result?
    
    var isPlay = true
    var audioPlayer : AVAudioPlayer!

    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.setHidesBackButton(true, animated: true)
        
        guard let pace = pace else {
            return
        }
        switch pace{
            case .slow:
            slowStsLabel.backgroundColor = .gray
            speedLbl.text = "Too Slow"
            motivationLbl.text = "Try to speak more faster!"
            
            case .normal:
            normalStsLabel.backgroundColor = .gray
            speedLbl.text = "Normal"
            motivationLbl.text = "Keep Up the good work!"
            
            case .fast:
            fastStsLabel.backgroundColor = .gray
            speedLbl.text = "Too Fast"
            motivationLbl.text = "Try and slow down your speaking speed."
            }
        if let resultPractice = resultPractice {
            wordPerMinLbl.text = "\(resultPractice.wpm)"
        }
        
        statusStackView.layer.cornerRadius = 10
        statusStackView.clipsToBounds = true
        statusStackView.layer.borderWidth = 0.5
        statusStackView.layer.borderColor = UIColor.lightGray.cgColor
        
        wordsView.layer.cornerRadius = 10
        wordsView.clipsToBounds = true
        wordsView.layer.borderWidth = 0.5
        wordsView.layer.borderColor = UIColor.lightGray.cgColor
        
        motivateView.layer.cornerRadius = 10
        motivateView.clipsToBounds = true
        motivateView.layer.borderWidth = 0.5
        motivateView.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    func configure(result: Result){
        pace = result.pace
        resultPractice = result
    }
    @IBAction func playPress(_ sender: UIButton) {
        if isPlay{
            sender.setBackgroundImage(UIImage(systemName: "pause.circle.fill")?.withTintColor(UIColor(named: "ButtonColor")!), for: .normal)
            preparePlayer()
            audioPlayer.play()
            //            isPlay = false
            //            audioPlayer.play(atTime: audioPlayer.duration - 2)
        }else{
            audioPlayer.pause()
            //            isPlay = true
            sender.setBackgroundImage(UIImage(systemName: "play.circle.fill")?.withTintColor(UIColor(named: "ButtonColor")!), for: .normal)
        }
        isPlay = !isPlay
    }
    @IBAction func closePress(_ sender: UIBarButtonItem) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    
    func preparePlayer(){
        do {
            guard let resultPractice = resultPractice else {
                return
            }

            audioPlayer =  try AVAudioPlayer(contentsOf: resultPractice.url)

            audioPlayer.delegate = self
            audioPlayer.prepareToPlay()
            audioPlayer.volume = 1.0
        } catch {
            print("Audio Record Failed ")
        }
    }
}
extension LessonResultViewController: AVAudioPlayerDelegate, AVAudioRecorderDelegate{
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
//        finishBtn.isEnabled = true
    }
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        playBtn.setBackgroundImage(UIImage(systemName: "play.circle.fill")?.withTintColor(UIColor(named: "ButtonColor")!), for: .normal)
        isPlay = !isPlay
    }
}

