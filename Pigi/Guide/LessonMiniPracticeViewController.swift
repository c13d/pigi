//
//  LessonMiniPracticeViewController.swift
//  Pigi
//
//  Created by Chrismanto Natanail Manik on 14/04/22.
//

import UIKit
import AVKit
import Speech
class LessonMiniPracticeViewController: UIViewController {

    @IBOutlet weak var titleStoryLabel: UILabel!
    @IBOutlet weak var storyLabel: UILabel!
    @IBOutlet weak var recordBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var storyView: UIView!
    
    var resultText: String?
    let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
    var recognitionRequest : SFSpeechAudioBufferRecognitionRequest?
    var recognitionTask: SFSpeechRecognitionTask?
    let audioEngine = AVAudioEngine()
    var voiceRecorder : AVAudioRecorder!
    
    var timer: Timer!
    var timeCurrent : Int = 0

    
    
    //Data
    var recordPractice = "recordMiniStory.m4a"
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
        navigationItem.setHidesBackButton(true, animated: true)


        startAudioSession()
        navigationItem.setHidesBackButton(true, animated: true)
        titleStoryLabel.text = "The Proud Rose"
        
        storyView.clipsToBounds = true
        storyView.layer.cornerRadius = 10
        storyView.layer.borderWidth = 0.5
        storyView.layer.borderColor = UIColor.lightGray.cgColor

        // Do any additional setup after loading the view.
    }
    //MARK: - Setup Speech

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
                
                self.recordBtn.isEnabled = true
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
        
//        self.titleLabel.text = "Say something, I'm listening!"
//        self.recordBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
    }
    
    func setupSpeech() {
        
        self.recordBtn.isEnabled = false
        self.nextBtn.isEnabled = false
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
                self.recordBtn.isEnabled = isButtonEnabled
            }
        }
    }

    
    //MARK: - Setup Record
    
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
            nextBtn.isEnabled = false
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
    
    func paceStatus(yourWpm: Int){
        if yourWpm < 100{
            yourPace = .slow
        }else if yourWpm > 150{
            yourPace = .fast
        }else{
            yourPace = .normal
        }
        print(yourPace)
    }
    
    
    //MARK: - Objc Function
    @IBAction func recordPress(_ sender: UIButton) {
        if audioEngine.isRunning{
            self.audioEngine.stop()
            voiceRecorder.stop()
            if resultText != nil{
                let components = resultText!.components(separatedBy: .whitespacesAndNewlines)
                let words = components.filter { !$0.isEmpty }
                
                wpm = words.count / timeCurrent * 60
                print("your wpm = \(wpm)")
                self.paceStatus(yourWpm: wpm)
                
            }
            nextBtn.isEnabled = false
            timer.invalidate()
//            timerLabel.text = "00 : 00"
            timeCurrent = 0

            dataResult = Result(url: getFileURL(), wpm: wpm, pace: yourPace ?? .slow)
            self.recognitionRequest?.endAudio()
            self.recordBtn.isEnabled = false
            self.recordBtn.setImage(UIImage(named: "RecordButton"), for: .normal)
        }else{
            startRecording()
            voiceRecorder.record()
            self.nextBtn.isEnabled = false
            self.recordBtn.setImage(UIImage(named: "StopButton"), for: .normal)
            
        }
    }
    
    @IBAction func nextPress(_ sender: UIButton) {
        performSegue(withIdentifier: "toResultMiniPractice", sender: self)

    }
    
    @IBAction func closePress(_ sender: UIBarButtonItem) {
        self.navigationController?.popToRootViewController(animated: true)

    }
    @objc func step(){
        timeCurrent += 1
//        if timeRemaining! > 0{
//            timeCurrent! -= 1
//        }else{
//            timer.invalidate()
//            timeRemaining = 0
//            self.recordingBtn.isEnabled = false
//        }
//        let timeConvert = secondsToMinutesSeconds(timeCurrent)
//        time.text = "\(timeConvert)"
    }
    //MARK: - Pass Data
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let dataResult = dataResult else {
            return
        }
        if segue.identifier == "toResultMiniPractice"{
            let destinationVc = segue.destination as! LessonResultViewController
            destinationVc.configure(result: dataResult)
        }

        
    }
    
    func secondsToMinutesSeconds(_ seconds: Int) -> NSString {
        return NSString(format: "%0.2d : %0.2d",(seconds % 3600) / 60,(seconds % 3600) % 60)
    }
    
}

extension LessonMiniPracticeViewController: SFSpeechRecognizerDelegate {
    
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available{
            self.recordBtn.isEnabled = true
        } else {
            self.recordBtn.isEnabled = false
        }
    }
}
extension LessonMiniPracticeViewController: AVAudioPlayerDelegate, AVAudioRecorderDelegate{
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        nextBtn.isEnabled = true
    }
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        recordBtn.isEnabled = true
        //        playBtn.setTitle("Play", for: .normal)
    }
}

