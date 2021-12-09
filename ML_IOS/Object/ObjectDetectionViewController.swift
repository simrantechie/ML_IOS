//
//  ObjectDetectionViewController.swift
//  ML_IOS
//
//  Created by Desktop-simranjeet on 29/11/21.
//

import UIKit
import CoreML

class ObjectDetectionViewController: UIViewController{
    
    var headingLbl: UILabel = {
        let label = UILabel()
        label.text = "Object Detection"
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var objectImage: UIImageView =  {
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
    
    var objectTextLbl: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemFill
        view.addSubview(backButton)
        view.addSubview(headingLbl)
        view.addSubview(objectImage)
        view.addSubview(addButton)
        view.addSubview(objectTextLbl)
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
    
    //MARK:- Creating a pixel buffer, configuration for model and getting the output.
    private func detectImage(image: UIImage?) {
        
        // Model:- Inception v3
        guard let buffer = image!.pixelBuffer(width: 299, height: 299) else {
            return
        }
        do {
            let config = MLModelConfiguration()
            let model = try Inceptionv3(configuration: config)
            let output = try model.prediction(image: buffer)
            let probs = output.classLabelProbs.sorted {$0.value > $1.value }
            if let prob = probs.first {
                objectTextLbl.text = prob.key
            }
        }
        catch {
            print(error.localizedDescription)
        }
    }

}

//MARk:- Image picker delegate methods
extension ObjectDetectionViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        objectImage.image = selectedImage
        detectImage(image: selectedImage)
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

//MARK:- Layout Views
extension ObjectDetectionViewController {
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        headingLbl.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: 0).isActive = true
        headingLbl.centerYAnchor.constraint(equalTo: backButton.centerYAnchor, constant: 0).isActive = true
        
        objectImage.topAnchor.constraint(equalTo: headingLbl.bottomAnchor, constant: 30).isActive = true
        objectImage.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: 0).isActive = true
        objectImage.heightAnchor.constraint(equalToConstant: 200).isActive = true
        objectImage.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        addButton.topAnchor.constraint(equalTo: objectImage.bottomAnchor, constant: 30).isActive = true
        addButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: 0).isActive = true
        addButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        addButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
        
        objectTextLbl.topAnchor.constraint(equalTo: addButton.bottomAnchor, constant: 30).isActive = true
        objectTextLbl.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        objectTextLbl.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        objectTextLbl.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: 0).isActive = true

    }
}



