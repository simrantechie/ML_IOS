//
//  SpeechDetectionViewController.swift
//  ML_IOS
//
//  Created by Desktop-simranjeet on 01/12/21.
//

import UIKit
import Speech

class SpeechDetectionViewController: UIViewController, SFSpeechRecognizerDelegate {
    
    //MARK: Properties
    let audioEngine = AVAudioEngine()
    let speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer()
    let request = SFSpeechAudioBufferRecognitionRequest()
    var recongitionTask: SFSpeechRecognitionTask?
    var iStart:Bool = false
    
    var backButton: UIButton =  {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0).cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var headingLbl: UILabel = {
        let label = UILabel()
        label.text = "Speech Detection"
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var startAudio: UIButton =  {
        let button = UIButton()
        button.setTitle("Start Audio", for: .normal)
        button.backgroundColor = .brown
        button.layer.cornerRadius = 20
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var audioTextLbl: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemFill
        view.addSubview(backButton)
        view.addSubview(headingLbl)
        view.addSubview(startAudio)
        view.addSubview(audioTextLbl)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        startAudio.addTarget(self, action: #selector(startAudioBtnTapped), for: .touchUpInside)
        requestPermission()
    }
    
    @objc private func backButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func requestPermission() {
        SFSpeechRecognizer.requestAuthorization { (authStatus) in
            DispatchQueue.main.async {
                if authStatus == .authorized {
                    print("Accepted")
                }
                else {
                    print("Not Accepted or not available")
                }
            }
        }
    }
    
    func startSpeechRecognizer() {
        let node = audioEngine.inputNode
        let recordingFormat = node.outputFormat(forBus: 0)
        
        node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, _) in
            self.request.append(buffer)
        }
        
        audioEngine.prepare()
        do {
            try audioEngine.start()
        }
        catch {
            print(error.localizedDescription)
        }
        
        guard let myRecognition = SFSpeechRecognizer() else {
            print("Recognizer not available")
            return
        }
        
        if !myRecognition.isAvailable {
            print("Try after sometime")
        }
        
        recongitionTask = speechRecognizer?.recognitionTask(with: request, resultHandler: { (response, error) in
            guard let response = response else {
                print("Some issue while recognizing")
                return
            }
            let message = response.bestTranscription.formattedString
            self.audioTextLbl.text = message
        })
    }
    
    
    func cancelSpeechRecognizer() {
        recongitionTask?.finish()
        recongitionTask?.cancel()
        recongitionTask = nil
        
        request.endAudio()
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
    }
    
    
    @objc private func startAudioBtnTapped(_ sender: UIButton) {
        iStart = !iStart
        if iStart {
            startSpeechRecognizer()
            startAudio.setTitle("Stop Audio", for: .normal)
        }
        else {
            cancelSpeechRecognizer()
            startAudio.setTitle("Start Audio", for: .normal)
        }
    }
    
}

//MARK:- Layout Views
extension SpeechDetectionViewController {
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        headingLbl.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: 0).isActive = true
        headingLbl.centerYAnchor.constraint(equalTo: backButton.centerYAnchor, constant: 0).isActive = true
        
        startAudio.topAnchor.constraint(equalTo: headingLbl.bottomAnchor, constant: 30).isActive = true
        startAudio.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: 0).isActive = true
        startAudio.heightAnchor.constraint(equalToConstant: 40).isActive = true
        startAudio.widthAnchor.constraint(equalToConstant: 150).isActive = true
        
        audioTextLbl.topAnchor.constraint(equalTo: startAudio.bottomAnchor, constant: 30).isActive = true
        audioTextLbl.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        audioTextLbl.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        audioTextLbl.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: 0).isActive = true

    }
}



