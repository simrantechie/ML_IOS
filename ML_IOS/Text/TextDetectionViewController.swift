//
//  TextDetectionViewController.swift
//  ML_IOS
//
//  Created by Desktop-simranjeet on 30/11/21.
//

import UIKit
import Vision

class TextDetectionViewController: UIViewController {

    var headingLbl: UILabel = {
        let label = UILabel()
        label.text = "Text Detection"
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var textImage: UIImageView =  {
        let image = UIImageView()
        image.image = UIImage(systemName: "")
        image.tintColor = .white
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
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
    
    var addButton: UIButton =  {
        let button = UIButton()
        button.setTitle("Add Image", for: .normal)
        button.backgroundColor = .brown
        button.layer.cornerRadius = 20
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var textLbl: UILabel = {
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
        view.addSubview(textImage)
        view.addSubview(addButton)
        view.addSubview(textLbl)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        
    }
    
    @objc private func backButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func addButtonTapped(_ sender: UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
        
    }
    
   //MARK:- Converting the image to CGImage, making request for text detection.
    private func recognizeText(image: UIImage?) {
        guard let cgImage = image?.cgImage else {
            return
        }
        
        // Handler
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        
        // Request
        let request = VNRecognizeTextRequest { [weak self] (request, error) in
            guard let observations = request.results as? [VNRecognizedTextObservation],
                  error == nil else {
                return
            }
            // To combine text
            let text = observations.compactMap({
                $0.topCandidates(1).first?.string
            }).joined(separator: ", ")
            
            DispatchQueue.main.async {
                self?.textLbl.text = text
            }
        }
        do {
            try handler.perform([request])
        }
        catch {
            print(error.localizedDescription)
        }
    }
}

//MARk:- Image picker delegate methods
extension TextDetectionViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        textImage.image = selectedImage
        recognizeText(image: selectedImage)
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

//MARK:- Layout Views
extension TextDetectionViewController {
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
      
        headingLbl.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        headingLbl.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: 0).isActive = true
        headingLbl.centerYAnchor.constraint(equalTo: backButton.centerYAnchor, constant: 0).isActive = true
        
        textImage.topAnchor.constraint(equalTo: headingLbl.bottomAnchor, constant: 30).isActive = true
        textImage.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: 0).isActive = true
        textImage.heightAnchor.constraint(equalToConstant: 200).isActive = true
        textImage.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        addButton.topAnchor.constraint(equalTo: textImage.bottomAnchor, constant: 30).isActive = true
        addButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: 0).isActive = true
        addButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        addButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
        
        
        textLbl.topAnchor.constraint(equalTo: addButton.bottomAnchor, constant: 30).isActive = true
        textLbl.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        textLbl.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        textLbl.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: 0).isActive = true
        textLbl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true

    }
}



