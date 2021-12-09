//
//  DashboardViewController.swift
//  ML_IOS
//
//  Created by Desktop-simranjeet on 30/11/21.
//

import UIKit

class DashboardViewController: UIViewController {

    var tableItemsNameArray = ["Object Detection",
                               "Text Detection",
                               "Face Detection",
                               "Audio Detection",
    "Barcode Detection"]
    
    var table: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemFill
        view.addSubview(table)
        table.separatorStyle = .none
        table.backgroundColor = .clear
        table.delegate = self
        table.dataSource = self
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
}

//MARK:- TableView Delegates and Datasources
extension DashboardViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableItemsNameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.textColor = .white
        cell?.textLabel!.textAlignment = .center
        cell?.textLabel!.text = tableItemsNameArray[indexPath.row]
        cell?.backgroundColor = .clear
        cell?.selectionStyle = .none
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let objectDetectionVc = storyboard?.instantiateViewController(identifier: "ObjectDetectionViewController") as! ObjectDetectionViewController
            self.navigationController?.pushViewController(objectDetectionVc, animated: true)
        }
        else if indexPath.row == 1 {
            let textDetectionVc = storyboard?.instantiateViewController(identifier: "TextDetectionViewController") as! TextDetectionViewController
            self.navigationController?.pushViewController(textDetectionVc, animated: true)
        }
        else if indexPath.row == 2 {
            let faceDetectionVc = storyboard?.instantiateViewController(identifier: "FaceDetectionViewController") as! FaceDetectionViewController
            self.navigationController?.pushViewController(faceDetectionVc, animated: true)
        }
        else if indexPath.row == 3 {
            let speechDetectionVc = storyboard?.instantiateViewController(identifier: "SpeechDetectionViewController") as! SpeechDetectionViewController
            self.navigationController?.pushViewController(speechDetectionVc, animated: true)
        }
        else if indexPath.row == 4 {
            let barcodeDetectionVc = storyboard?.instantiateViewController(identifier: "BarcodeDetectionViewController") as! BarcodeDetectionViewController
            self.navigationController?.pushViewController(barcodeDetectionVc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
}

//MARK:- Layout Views
extension DashboardViewController {
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        table.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        table.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        table.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        table.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
    }
}
