//
//  TakePhotoViewController.swift
//  Master Ielts Speaking
//
//  Created by seyedamirhossein hashemi on 2018-02-04.
//  Copyright © 2018 seyedamirhossein hashemi. All rights reserved.
//

import UIKit
import CoreML
import RealmSwift

class TakePhotoViewController: UIViewController, UINavigationControllerDelegate {

    @IBOutlet weak var nextBtn: UIBarButtonItem!
    @IBOutlet weak var listOfTopicsfields: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var classifier: UILabel!
    
    var modelRes: SqueezeNet!
    var wordDetected: String?
    var newVocab : Word? = nil
    var category : Category? = nil
    var definitionRecieved = false
    var exampleRecieved = false
    var listOfTopics: Results<Category>?
    var selectedTopic: Category?
    var selectedTopicString: String?
    var pixelBuffer: CVPixelBuffer?
    var ifComeBackFromCamera = false
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.color = UIColor.red
        return activityIndicator
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkConectivity()
        readData(Category.self, predicate: nil) { (response : Results<Category>) in
            self.listOfTopics = response
        }
        createTopicPicker()
        createToolbar()
        self.view.addSubview(activityIndicator)
        activityIndicator.center = view.center
    }
    override func viewWillAppear(_ animated: Bool) {
        modelRes = SqueezeNet()
        self.nextBtn.isEnabled = false
        if !ifComeBackFromCamera {
            startCamera()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.newVocab = nil
        self.wordDetected = nil
        self.category = nil
        self.selectedTopic = nil
        self.listOfTopicsfields.text = ""
        self.classifier.text = ""
        self.exampleRecieved = false
        self.definitionRecieved = false
        ifComeBackFromCamera = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func startCamera() {
        if !UIImagePickerController.isSourceTypeAvailable(.camera) {
            return
        }
        let cameraPicker = UIImagePickerController()
        cameraPicker.delegate = self
        cameraPicker.sourceType = .camera
        cameraPicker.allowsEditing = false
        present(cameraPicker, animated: true)
    }
    
    @IBAction func cancelBtn(_ sender: UIBarButtonItem) {
        self.tabBarController?.selectedIndex = 0
    }
    
    @IBAction func nextButton(_ sender: UIBarButtonItem) {
        guard let wordDetected = self.wordDetected else {
            showAlert("no word ", "no word detected")
            return
        }
        guard wordDetected != "" else {
            showAlert("no word ", "no word detected")
            return
        }
        guard let category = self.selectedTopic else {
            showAlert("Choose Topic", "Choose topic for your new vocabulary")
            return
        }
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        self.nextBtn.isEnabled = false
        self.category = category
        newVocab = Word()
        newVocab?.wordName = wordDetected
        let takenPhoto = self.imageView.image
        self.newVocab?.wordImage = UIImageJPEGRepresentation(takenPhoto!, 0.4)
        WordsApiService.getDefinitionOfVocabulary(word: wordDetected) {
            [weak self] (arrayOfDefenitions) in
            guard let arrayOfDefenitions = arrayOfDefenitions else {
                self?.showAlert("No definition", "There is no definition for this object, Try again", completion: {
                    self?.startCamera()
                })
                return
            }
            for definition in arrayOfDefenitions {
                self?.newVocab?.definitions.append(definition)
            }
            WordsApiService.getExampleOfVocabulary(word: wordDetected, arrayOfExample: { [weak self] (arrayOfExamples) in
                guard let arrayOfExamples = arrayOfExamples else {
                    self?.saveVocabularyAndGoNextPage()
                    return
                }
                for example in arrayOfExamples {
                self?.newVocab?.examples.append(example)
                }
                self?.exampleRecieved = true
                self?.saveVocabularyAndGoNextPage()
            })
        }
    }
    
    func saveVocabularyAndGoNextPage() {
            saveData(newVocab!)
            updateCategoryInDatabase(categoryName: (self.category?.categoryName)!, word: newVocab!)
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let detailViewController = sb.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
            //        let aObjNavi = UINavigationController(rootViewController: detailViewController)
            detailViewController.newVocabulary = self.newVocab
            detailViewController.isComeFromCamera = true
            detailViewController.delegate = self
            let numberOfDefinitions = self.newVocab?.definitions.count
            detailViewController.pageControlDots = numberOfDefinitions! < 14 ? numberOfDefinitions! : 14
            let numberOfExamples = self.newVocab?.examples.count
            detailViewController.pageControlExampleDots = numberOfExamples! < 14 ? numberOfExamples! : 14
            self.activityIndicator.stopAnimating()
            self.show(detailViewController, sender: nil)
    }
    
    func createTopicPicker() {
        let topicPicker = UIPickerView()
        topicPicker.delegate = self
        listOfTopicsfields.inputView = topicPicker
        //Customizations
        topicPicker.backgroundColor = UIColor.white
    }
    
    func createToolbar() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        //Customizations
        toolBar.barTintColor = .black
        toolBar.tintColor = .white
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donePressed))
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        listOfTopicsfields.inputAccessoryView = toolBar
    }
    
    @objc func donePressed() {
        if self.selectedTopic == nil {
            self.selectedTopic = self.listOfTopics?[0]
            selectedTopicString = self.listOfTopics?[0].categoryName
            listOfTopicsfields.text = selectedTopicString
            self.dismissKeyboard()
        }else {
            self.dismissKeyboard()
        }
    }
    
    
    
    /// check connectivity to Internet
    fileprivate func checkConectivity() {
        guard Connectivity.isConnectedToInternet else {
            print("No! internet is not available.")
            self.nextBtn.isEnabled = false
            showAlert("Oh No", "There is no Internet")
            return
        }
    }
}

extension TakePhotoViewController: UIImagePickerControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        ifComeBackFromCamera = true
        dismiss(animated: true, completion: nil)
        self.tabBarController?.selectedIndex = 0
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true)
        ifComeBackFromCamera = true
        classifier.text = "Analyzing Image..."
        guard let image = info["UIImagePickerControllerOriginalImage"] as? UIImage else {
            return
        }
    
        let newImage = resizePhoto(image: image)
        pixelBuffer = createpixelBuffer(newImage: newImage)
        imageView.image = newImage
        let concurrentQueue = DispatchQueue(label: "queuename", attributes: .concurrent)
        concurrentQueue.async {
            guard let pixelBuffer = self.pixelBuffer else { return  }
            // MARK: Core ML
            do {
                let predictionRes = try self.modelRes.prediction(image: pixelBuffer)
                let detectedWord = predictionRes.classLabel
                self.wordDetected = trimWordDetected(word: detectedWord)
            }catch let err {
                print(err)
                print("hhhhh")
            }
//            guard let predictionRes = try? self.modelRes.prediction(image: pixelBuffer) else {
//                return
//            }
            
            
            DispatchQueue.main.async {
                if let wordDetected = self.wordDetected {
                    checkRepeatofWords(word: wordDetected, completion: {[weak self] (status) in
                        guard !status else {
                            self?.showAlert("The \(wordDetected) is repetitive", "Choose another object", completion: {
                                self?.startCamera()
                            })
                            return
                        }
                    })
                    self.classifier.text = "This is a \(wordDetected)."
                    self.nextBtn.isEnabled = true
                }else {
                    self.showAlert("No object found for this photo", "No object found for this photo", completion: {
                        self.startCamera()
                    })
                }
            }
        }
    }
}

extension TakePhotoViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.listOfTopics?.count ?? 0
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.listOfTopics?[row].categoryName
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedTopic = self.listOfTopics?[row]
        selectedTopicString = self.listOfTopics?[row].categoryName
        listOfTopicsfields.text = selectedTopicString
    }
    
//    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
//
//        var label: UILabel
//
//        if let view = view as? UILabel {
//            label = view
//        } else {
//            label = UILabel()
//        }
//
//        label.textColor = .green
//        label.textAlignment = .center
//        label.font = UIFont(name: "Menlo-Regular", size: 17)
//
//        label.text = days[row]
//
//        return label
//    }
}

extension TakePhotoViewController: GoToFirstTabBarDelegate {
    func goToFirstTabBar() {
        self.tabBarController?.selectedIndex = 0
    }
}


protocol GoToFirstTabBarDelegate: class {
    func goToFirstTabBar()
}




