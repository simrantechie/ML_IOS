//
//  BarcodeDetectionViewController.swift
//  ML_IOS
//
//  Created by Desktop-simranjeet on 07/12/21.
//

import UIKit
import Vision

class BarcodeDetectionViewController: UIViewController {

    var headingLbl: UILabel = {
        let label = UILabel()
        label.text = "Barcode Detection"
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var barcodeImage: UIImageView =  {
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
    
    var barcodeTextLbl: UILabel = {
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
        view.addSubview(barcodeImage)
        view.addSubview(addButton)
        view.addSubview(barcodeTextLbl)
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
    
    //MARK:- Converting the image to CGImage, making request for barcode detection.
    private func detectBarcodeImage(image: UIImage?) {
        
        guard let image = image?.cgImage else {
            return
        }
        
        // Handler
        let handler = VNImageRequestHandler(cgImage: image)
        
        // Request
        let request = VNDetectBarcodesRequest { request, error in
            guard let results = request.results else {
                return
            }
            
            for result in results {
                if let barcode = result as? VNBarcodeObservation {
                    print("Payload: \(barcode.payloadStringValue ?? "")")
                    print("Symbology: \(barcode.symbology.rawValue)")
                    self.barcodeTextLbl.text = barcode.payloadStringValue
                    if barcode.symbology.rawValue == "VNBarcodeSymbologyQR" {
                    let webviewVc = self.storyboard?.instantiateViewController(identifier: "WebviewViewController") as! WebviewViewController
                    webviewVc.webViewUrl = barcode.payloadStringValue
                    self.present(webviewVc, animated: true, completion: nil)
                    }
                }
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
extension BarcodeDetectionViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.barcodeTextLbl.text = ""
        let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        barcodeImage.image = selectedImage
        picker.dismiss(animated: true, completion: nil)
        detectBarcodeImage(image: selectedImage)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

//MARK:- Layout Views
extension BarcodeDetectionViewController {
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        headingLbl.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: 0).isActive = true
        headingLbl.centerYAnchor.constraint(equalTo: backButton.centerYAnchor, constant: 0).isActive = true
        
        barcodeImage.topAnchor.constraint(equalTo: headingLbl.bottomAnchor, constant: 30).isActive = true
        barcodeImage.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: 0).isActive = true
        barcodeImage.heightAnchor.constraint(equalToConstant: 350).isActive = true
        barcodeImage.widthAnchor.constraint(equalToConstant: 400).isActive = true
        
        addButton.topAnchor.constraint(equalTo: barcodeImage.bottomAnchor, constant: 30).isActive = true
        addButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: 0).isActive = true
        addButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        addButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
        
        barcodeTextLbl.topAnchor.constraint(equalTo: addButton.bottomAnchor, constant: 30).isActive = true
        barcodeTextLbl.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        barcodeTextLbl.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        barcodeTextLbl.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: 0).isActive = true

    }
}



