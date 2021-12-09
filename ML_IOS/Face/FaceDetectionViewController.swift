//
//  FaceDetectionViewController.swift
//  ML_IOS
//
//  Created by Desktop-simranjeet on 02/12/21.
//

import UIKit
import Vision

class FaceDetectionViewController: UIViewController {
  
    var headingLbl: UILabel = {
        let label = UILabel()
        label.text = "Face Detection"
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var faceImage: UIImageView =  {
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemFill
        view.addSubview(backButton)
        view.addSubview(headingLbl)
        view.addSubview(faceImage)
        view.addSubview(addButton)
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
    
    //MARK:- Converting the image to CIImage, making request for face detection.
    private func detectFace(image: UIImage?) {
        
        guard let ciImage = CIImage(image: image!) else {
            return
        }

        // Handler
        let handler = VNImageRequestHandler(ciImage: ciImage, options: [:])

        // Request
        let request = VNDetectFaceRectanglesRequest { [weak self] (request, error) in

            self!.faceImage.layer.sublayers?.forEach({ (layer) in
                layer.removeFromSuperlayer()
            })
            guard let observations = request.results as? [VNFaceObservation],
                  error == nil else {
                return
            }
            observations.forEach{observation in
                let boundingBox = observation.boundingBox

                let size = CGSize(width: boundingBox.width * self!.faceImage.bounds.width, height: boundingBox.height * self!.faceImage.bounds.height)

                let origin = CGPoint(x: boundingBox.minX * self!.faceImage.bounds.width, y: (1 - observation.boundingBox.minY) * self!.faceImage.bounds.height - size.height)

                let layer = CAShapeLayer()
                layer.frame = CGRect(origin: origin, size: size)
                layer.borderColor = UIColor.systemPink.cgColor
                layer.borderWidth = 2
                self!.faceImage.layer.addSublayer(layer)
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
extension FaceDetectionViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        faceImage.image = selectedImage
        detectFace(image: selectedImage)
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

//MARK:- Layout Views
extension FaceDetectionViewController {
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        headingLbl.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: 0).isActive = true
        headingLbl.centerYAnchor.constraint(equalTo: backButton.centerYAnchor, constant: 0).isActive = true
        
        faceImage.topAnchor.constraint(equalTo: headingLbl.bottomAnchor, constant: 30).isActive = true
        faceImage.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: 0).isActive = true
        faceImage.heightAnchor.constraint(equalToConstant: 300).isActive = true
        faceImage.widthAnchor.constraint(equalToConstant: 300).isActive = true
        
        addButton.topAnchor.constraint(equalTo: faceImage.bottomAnchor, constant: 30).isActive = true
        addButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: 0).isActive = true
        addButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        addButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
        
    }
}



