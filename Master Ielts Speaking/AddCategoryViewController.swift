//
//  AddCategoryViewController.swift
//  Master Ielts Speaking
//
//  Created by seyedamirhossein hashemi on 2017-12-08.
//  Copyright © 2017 seyedamirhossein hashemi. All rights reserved.
//

import UIKit
import RealmSwift

class AddCategoryViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    
    @IBOutlet weak var categorynameField: UITextField!
    var pickedImage2 : UIImage?
    let imagePicker = UIImagePickerController()

    @IBOutlet weak var categoryImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imagePicker.delegate = self
        
    }

    @IBAction func backButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loadImage(_ sender: UIButton) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
    }
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            pickedImage2 = pickedImage
            categoryImage.contentMode = .scaleAspectFit
            categoryImage.image = pickedImage
        }
        let name = self.categorynameField.text
        let category = Category()
        category.categoryId = UUID().uuidString
        category.categoryName = name!
        category.categoryImageData = UIImageJPEGRepresentation(self.pickedImage2!, 1)! as NSData
        saveData(category)
            
        
        dismiss(animated: true, completion: nil)
    }
    
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        dismiss(animated: true, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
