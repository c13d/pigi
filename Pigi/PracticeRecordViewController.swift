//
//  PracticeRecordViewController.swift
//  Pigi
//
//  Created by Chrismanto Natanail Manik on 12/04/22.
//

import UIKit
import Speech
import AVKit

class PracticeRecordViewController: UIViewController {
   
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var recordingBtn: UIButton!
    @IBOutlet weak var finishBtn: UIButton!
    
    var recognitionRequest : SFSpeechAudioBufferRecognitionRequest?
    var recognitionTask: SFSpeechRecognitionTask?
    let audioEngine = AVAudioEngine()
    var voiceRecorder : AVAudioRecorder!
    
    var timer: Timer!
    var timeRemaining: Int?
    var timeCurrent : Int?
    
    var resultText: String?
    
    let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
    
    /// Data
    
    var recordPractice = "recordPricee.m4a"
    var wpm = 0
    var dataResult: Result?
    var yourPace: SpeakingPace?
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setupSpeech()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSpeech()
        startAudioSession()
        recordingBtn.clipsToBounds = true
        recordingBtn.layer.cornerRadius = 10
        
        timerLabel.text = "\(secondsToMinutesSeconds(timeRemaining ?? 60))"
        navigationItem.setHidesBackButton(true, animated: true)

        // Do any additional setup after loading the view.
    }
    
    func startAudioSession(){
        let recordSession = AVAudioSession.sharedInstance()
        do {
            try recordSession.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.measurement, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
            try recordSession.setActive(true, options: .notifyOthersOnDeactivation)
            recordSession.requestRecordPermission { allowed in
                print("allow: \(allowed)")
                DispatchQueue.main.async {
                    if allowed {
                        self.setupRecorder()
                    } else {
                        print("failed to recird")
                        // failed to record!
                    }
                }
            }
        } catch {
            print("audioSession properties weren't set because of an error.")
        }
        
    }
    func startRecording() {
        // Clear all previous session data and cancel task
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        
        // Create instance of audio session to record voice
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSession.Category.record, mode: AVAudioSession.Mode.measurement, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("audioSession properties weren't set because of an error.")
        }
        
        
        self.recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        let inputNode = audioEngine.inputNode
        
        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
        }
        
        recognitionRequest.shouldReportPartialResults = true
        
        self.recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in
            
            var isFinal = false
            
            if result != nil {
                
                self.resultText =  result?.bestTranscription.formattedString
                
                isFinal = (result?.isFinal)!
            }
            
            if error != nil || isFinal {
                
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                
                self.recognitionRequest = nil
                self.recognitionTask = nil
                
                self.recordingBtn.isEnabled = true
            }
            
        })
        
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            self.recognitionRequest?.append(buffer)
        }
        
        self.audioEngine.prepare()
        
        do {
            try self.audioEngine.start()
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(step), userInfo: nil, repeats: true)
        } catch {
            print("audioEngine couldn't start because of an error.")
        }
        
        self.titleLabel.text = "Say something, I'm listening!"
        self.recordingBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
    }
    
    
    func setupRecorder(){
        let recordSettings = [AVFormatIDKey : kAudioFormatAppleLossless,
                   AVEncoderAudioQualityKey : AVAudioQuality.max.rawValue,
                        AVEncoderBitRateKey : 320000,
                      AVNumberOfChannelsKey : 2,
                            AVSampleRateKey : 44100.0 ] as [String : Any]
        
        do {
            voiceRecorder = try AVAudioRecorder(url: getFileURL(), settings: recordSettings)
            voiceRecorder.delegate = self
            voiceRecorder.prepareToRecord()
            finishBtn.isEnabled = false
        }
        catch {
            print("\(error)")
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
    
    func setupSpeech() {
        
        self.recordingBtn.isEnabled = false
        self.finishBtn.isEnabled = false
        self.speechRecognizer?.delegate = self
        
        SFSpeechRecognizer.requestAuthorization { (authStatus) in
            
            var isButtonEnabled = false
            
            switch authStatus {
            case .authorized:
                isButtonEnabled = true
                
            case .denied:
                isButtonEnabled = false
                print("User denied access to speech recognition")
                
            case .restricted:
                isButtonEnabled = false
                print("Speech recognition restricted on this device")
                
            case .notDetermined:
                isButtonEnabled = false
                print("Speech recognition not yet authorized")
            }
            
            OperationQueue.main.addOperation() {
                self.recordingBtn.isEnabled = isButtonEnabled
            }
        }
    }
    
    
    
    @IBAction func recordingPress(_ sender: Any) {
        if audioEngine.isRunning{
            self.audioEngine.stop()
            voiceRecorder.stop()
            if resultText != nil{
                let components = resultText!.components(separatedBy: .whitespacesAndNewlines)
                let words = components.filter { !$0.isEmpty }
                
                wpm = words.count / (timeCurrent! - timeRemaining!) * 60
                print("your wpm = \(wpm)")
                self.paceStatus(yourWpm: wpm)
                
            }
            finishBtn.isEnabled = false
            timer.invalidate()
            timerLabel.text = "00 : 00"
            timeRemaining = 0

            dataResult = Result(url: getFileURL(), wpm: wpm, pace: yourPace ?? .slow)
            self.recognitionRequest?.endAudio()
            self.recordingBtn.isEnabled = false
            self.recordingBtn.setTitle("Start Recording", for: .normal)
            self.recordingBtn.backgroundColor = UIColor(named: "ButtonColor")
        }else{
            startRecording()
            voiceRecorder.record()
            //            voiceRecorder.record()
            self.finishBtn.isEnabled = false
            self.recordingBtn.setTitle("Stop Recording", for: .normal)
            self.recordingBtn.backgroundColor = .red
            
        }
    }
    
    func paceStatus(yourWpm: Int){
        if yourWpm < 100{
            yourPace = .slow
        }else if yourWpm > 150{
            yourPace = .fast
        }else{
            yourPace = .normal
        }
    }
    
    @IBAction func finishPress(_ sender: UIButton){
        performSegue(withIdentifier: "toResultPractice", sender: self)
    }
    
    @IBAction func closePress(_ sender: UIBarButtonItem) {
        self.navigationController?.popToRootViewController(animated: true)

//        self.present(vc, animated: true)
//        guard let viewController = U
    }
    
    @objc func step(){
        if timeRemaining! > 0{
            timeRemaining! -= 1
        }else{
            timer.invalidate()
            timeRemaining = 0
            self.recordingBtn.isEnabled = false
        }
        let timeConvert = secondsToMinutesSeconds(timeRemaining!)
        timerLabel.text = "\(timeConvert)"
    }
    
    
    //MARK: - Pass Data
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let dataResult = dataResult else {
            return
        }
        if segue.identifier == "toResultPractice"{
            let destinationVc = segue.destination as! PracticeResultViewController
            destinationVc.configure(result: dataResult)
        }

        
    }
    
    func secondsToMinutesSeconds(_ seconds: Int) -> NSString {
        return NSString(format: "%0.2d : %0.2d",(seconds % 3600) / 60,(seconds % 3600) % 60)
    }

}

extension PracticeRecordViewController: SFSpeechRecognizerDelegate {
    
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available{
            self.recordingBtn.isEnabled = true
        } else {
            self.recordingBtn.isEnabled = false
        }
    }
}

extension PracticeRecordViewController:AVAudioPlayerDelegate, AVAudioRecorderDelegate{
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        finishBtn.isEnabled = true
    }
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        recordingBtn.isEnabled = true
        //        playBtn.setTitle("Play", for: .normal)
    }
}
