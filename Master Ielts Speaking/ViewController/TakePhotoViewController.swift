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
    
    var model: Inceptionv3!
    var wordDetected: String?
    var newVocab : Word? = nil
    var category : Category? = nil
    var definitionRecieved = false
    var exampleRecieved = false
    var listOfTopics: Results<Category>?
    var selectedTopic: Category?
    var selectedTopicString: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        readData(Category.self, predicate: nil) { (response : Results<Category>) in
            self.listOfTopics = response
        }
        createDayPicker()
        createToolbar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        model = Inceptionv3()
        self.nextBtn.isEnabled = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.newVocab = nil
        self.wordDetected = nil
        self.category = nil
        self.selectedTopic = nil
        self.listOfTopicsfields.text = ""
        self.imageView.image = UIImage(named: "imagePlaceholder")
        self.classifier.text = ""
        self.exampleRecieved = false
        self.definitionRecieved = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func camera(_ sender: Any) {
        
        if !UIImagePickerController.isSourceTypeAvailable(.camera) {
            return
        }
        
        let cameraPicker = UIImagePickerController()
        cameraPicker.delegate = self
        cameraPicker.sourceType = .camera
        cameraPicker.allowsEditing = false
        
        present(cameraPicker, animated: true)
    }
    @IBAction func openLibrary(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.allowsEditing = false
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true)
    }
    
    
    @IBAction func nextButton(_ sender: UIBarButtonItem) {
        guard let wordDetected = self.wordDetected else {
            showAlert("no word ", "no word detected")
            return
        }
        guard wordDetected != "" else {
            return
        }
        guard let category = self.selectedTopic else {
            showAlert("Choose Topic", "Choose topic for your new vocabulary")
            return
        }
        self.nextBtn.isEnabled = false
        self.category = category
        newVocab = Word()
        newVocab?.wordName = wordDetected
        let takenPhoto = self.imageView.image
        self.newVocab?.wordImage = UIImageJPEGRepresentation(takenPhoto!, 0.4)
        WordsApiService.getDefinitionAndExamples(viewController: self, word: wordDetected, arrayOfWordsDefinition: {[weak self] (arrayOfDefenitions) in
            for definition in arrayOfDefenitions {
                self?.newVocab?.definitions.append(definition)
            }
            self?.definitionRecieved = true
            //            self.saveVocabularyAndGoNextPage()
        }, arrayOfExample: {[weak self] (arrayOfExamples) in
            for example in arrayOfExamples {
                self?.newVocab?.examples.append(example)
                
            }
            self?.exampleRecieved = true
            self?.saveVocabularyAndGoNextPage()
        }) { (_) in
            // error
        }
        
    }
    
    func saveVocabularyAndGoNextPage() {
        if (definitionRecieved && exampleRecieved) {
            // save in database
            saveData(newVocab!)
 
            updateCategoryInDatabase(categoryName: (self.category?.categoryName)!, word: newVocab!)
            
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let detailViewController = sb.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
            //        let aObjNavi = UINavigationController(rootViewController: detailViewController)
            detailViewController.newVocabulary = self.newVocab
            detailViewController.isComeFromCamera = true
            let numberOfDefinitions = self.newVocab?.definitions.count
            detailViewController.pageControlDots = numberOfDefinitions! < 14 ? numberOfDefinitions! : 14
            let numberOfExamples = self.newVocab?.examples.count
            detailViewController.pageControlExampleDots = numberOfExamples! < 14 ? numberOfExamples! : 14
            self.show(detailViewController, sender: nil)
            
        }
        
    }
    
    func createDayPicker() {
        
        let dayPicker = UIPickerView()
        dayPicker.delegate = self
        
        listOfTopicsfields.inputView = dayPicker
        
        //Customizations
        dayPicker.backgroundColor = UIColor.white
    }
    
    
    func createToolbar() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        //Customizations
        toolBar.barTintColor = .black
        toolBar.tintColor = .white
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.dismissKeyboard))
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        listOfTopicsfields.inputAccessoryView = toolBar
    }
    
    // seperate just one of the meaning
    func trimWordDetected(word: String) -> String? {
        if word.contains(",") {
            var firstWord = ""
            for char in word {
                if char == "," {
                    return firstWord
                }else {
                    firstWord = firstWord + String(char)
                }
            }
        }
        return nil
    }
}

extension TakePhotoViewController: UIImagePickerControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true)
        
        classifier.text = "Analyzing Image..."
        guard let image = info["UIImagePickerControllerOriginalImage"] as? UIImage else {
            return
        } //1
        

        UIGraphicsBeginImageContextWithOptions(CGSize(width: 299, height: 299), true, 2.0)
        image.draw(in: CGRect(x: 0, y: 0, width: 299, height: 299))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        let attrs = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue, kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue] as CFDictionary
        var pixelBuffer : CVPixelBuffer?
        let status = CVPixelBufferCreate(kCFAllocatorDefault, Int(newImage.size.width), Int(newImage.size.height), kCVPixelFormatType_32ARGB, attrs, &pixelBuffer)
        guard (status == kCVReturnSuccess) else {
            return
        }
        
        CVPixelBufferLockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        let pixelData = CVPixelBufferGetBaseAddress(pixelBuffer!)
        
        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext(data: pixelData, width: Int(newImage.size.width), height: Int(newImage.size.height), bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer!), space: rgbColorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue) //3
        
        context?.translateBy(x: 0, y: newImage.size.height)
        context?.scaleBy(x: 1.0, y: -1.0)
        
        UIGraphicsPushContext(context!)
        newImage.draw(in: CGRect(x: 0, y: 0, width: newImage.size.width, height: newImage.size.height))
        UIGraphicsPopContext()
        CVPixelBufferUnlockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        imageView.image = newImage
        
        // Core ML
        guard let prediction = try? model.prediction(image: pixelBuffer!) else {
            return
        }
            let detectedWord = prediction.classLabel
            self.wordDetected = self.trimWordDetected(word: detectedWord)
            classifier.text = "This is a \(self.wordDetected ?? "")."
        
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




