//
//  PracticeResultViewController.swift
//  Pigi
//
//  Created by Chrismanto Natanail Manik on 12/04/22.
//

import UIKit
import AVFoundation
enum SpeakingPace{
    case slow
    case normal
    case fast
}
class PracticeResultViewController: UIViewController {
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var speakingPaceInfoLabel: UILabel!
    @IBOutlet weak var speakingPaceDetailLabel: UILabel!
    @IBOutlet weak var motivateLabel: UILabel!
    
    @IBOutlet weak var playButton: UIButton!
    
    var isPlay = true
    var audioPlayer : AVAudioPlayer!
    
    var pace: SpeakingPace?
    var resultPractice: Result?
//    var urlRecord : URL?
//    var wpm: Int?
    var recordPractice = "recordPricee.m4a"
    
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
                speakingPaceInfoLabel.text = "Your speaking pace is too slow."
                motivateLabel.text = "Let’s practice it again!"
            case .normal:
                speakingPaceInfoLabel.text = "Your speaking pace is normal."
                motivateLabel.text = "Keep up the good work!"
            case .fast:
                speakingPaceInfoLabel.text = "Your speaking pace is too fast."
                motivateLabel.text = "Let’s practice it again!"
            }
        if let resultPractice = resultPractice {
            
            let attString = NSMutableAttributedString(string: "The average speaking pace is around 100 - 140 wpm, \n while", attributes:[
                .font: UIFont.systemFont(ofSize: 14), .foregroundColor: UIColor.lightGray])
            let valueAtt = NSMutableAttributedString(string: " your speaking pace is around \(resultPractice.wpm) wpm.", attributes:[
                .font: UIFont.boldSystemFont(ofSize: 14), .foregroundColor: UIColor.black])
            attString.append(valueAtt)
            
            speakingPaceDetailLabel.attributedText = attString
        }
    }
//
    func configure(result: Result){
        pace = result.pace
        resultPractice = result
    }
    @IBAction func closeBarButton(_ sender: UIBarButtonItem) {
        self.navigationController?.popToRootViewController(animated: true)
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
            //            sender.setTitle("Play", for: .normal)
        }
        isPlay = !isPlay
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
    
    func getCacheDirectory() -> URL {
        let fm = FileManager.default
        let docsurl = try! fm.url(for:.documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        return docsurl
    }
    func getFileURL() -> URL{
        let path  = getCacheDirectory()
        let filePath = path.appendingPathComponent("\(recordPractice)")
        print("path: \(filePath)")
        
        return filePath
    }
}
extension PracticeResultViewController: AVAudioPlayerDelegate, AVAudioRecorderDelegate{
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
//        finishBtn.isEnabled = true
    }
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
//        recordingBtn.isEnabled = true
        playButton.setBackgroundImage(UIImage(systemName: "play.circle.fill")?.withTintColor(UIColor(named: "ButtonColor")!), for: .normal)
        isPlay = !isPlay
    }
}
