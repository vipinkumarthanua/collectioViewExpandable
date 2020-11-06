//
//  CollectionViewCell.swift
//  collectioViewExpandableInIOS
//
//  Created by vipin kumar on 10/20/20.
//  Copyright © 2020 vipin kumar. All rights reserved.
//

import UIKit

//protocol ImagePickerDelegate {
//
//    func pickImage()
//    var currentSection: Int { get }
//    var currentRow: Int { get }
//}

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var profileImgView: UIImageView!
    
    
    var currentSection = 0
    var currentRow = 0
    
    var selectedGender: String?
    
    weak var collectionView: UICollectionView?
    
    //var delegate: ImagePickerDelegate?
    
    var viewController = ViewController()
    
    let genderOption = ["Male", "Female", "Others"]
    
    var initialString = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let photoTap = UITapGestureRecognizer(target: self, action: #selector(imgTapped))
        photoTap.numberOfTapsRequired = 1
        profileImgView.isUserInteractionEnabled = true
        profileImgView.addGestureRecognizer(photoTap)
        
        nameTextField.delegate = self
        ageTextField.delegate = self
        genderTextField.delegate = self
        
        
    }
    
    
    @objc func imgTapped() {
        // For launchinf imagePicker
//        delegate?.pickImage()
        launchImagePicker()
    }
    
    
    func configureCell(person: Person, tag: Int) {
        
        nameTextField.tag = tag
        nameTextField.text = person.name
        
        ageTextField.tag = tag
        ageTextField.text = "\(person.age)"
        
        genderTextField.tag = tag
        genderTextField.text = person.gender
        
        profileImgView.image = person.image
        
        createPickerView()
        createToolbar()
    }
    
    
    
    func createPickerView() {
        
        let genderPicker = UIPickerView()
        genderPicker.delegate = self
        
        genderTextField.inputView = genderPicker
    }
    
    func createToolbar() {
        
        //initialString = ageTextField.text ?? ""
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let doneBtn = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(dismissKeyboard))
        
        //let cancelBtn = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelBtnTapped))
        toolBar.setItems([doneBtn], animated: true)
        toolBar.isUserInteractionEnabled = true
        
        genderTextField.inputAccessoryView = toolBar
        
    }
    
    @objc func dismissKeyboard() {
        ViewController.homeArray[currentSection].person[currentRow].age = genderTextField.text!
        self.ageTextField.endEditing(true)
        self.ageTextField.resignFirstResponder()
        self.resignFirstResponder()
        viewController.resignFirstResponder()
        viewController.view.endEditing(true)
        
    }
    
    @objc func cancelBtnTapped() {
        ageTextField.text = initialString
        self.ageTextField.endEditing(true)
        self.ageTextField.resignFirstResponder()
        self.resignFirstResponder()
        viewController.view.resignFirstResponder()
    }
    
    
    
    @IBAction func deleteBtnTapped(_ sender: UIButton) {
        let indexPath = IndexPath(item: currentRow, section: currentSection)
        collectionView?.deleteItems(at: [indexPath])
        ViewController.homeArray[currentSection].person.remove(at: currentRow)
        collectionView?.reloadData()
    }
    
    
    func showAlert(message: String) {
        
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okAction)
        
        viewController.present(alert, animated: true, completion: nil)
    }
    
    
}

//MARK:- UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension CollectionViewCell: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func launchImagePicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        viewController.present(imagePicker, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.originalImage] as? UIImage else { return }
        profileImgView.contentMode = .scaleAspectFill
        profileImgView.image = image
        //viewcontroller.dismiss(animated: true, completion: nil)
        ViewController.homeArray[currentSection].person[currentRow].image = profileImgView.image!
        print("From cell respectively")
        viewController.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        //viewcontroller.dismiss(animated: true, completion: nil)
        viewController.dismiss(animated: true, completion: nil)
    }
    
    
}


//MARK:- UIPickerViewDelegate, UIPickerViewDataSource
extension CollectionViewCell: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return genderOption.count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return genderOption[row]
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedGender = genderOption[row]
        genderTextField.text = selectedGender
        
    }
    
}


//MARK:- UITextFieldDelegate
extension CollectionViewCell: UITextFieldDelegate {
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.nameTextField.endEditing(true)
        self.genderTextField.endEditing(true)
        self.ageTextField.endEditing(true)
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if(textField == ageTextField) {
            
            if ageTextField.text!.count < 2 {
                showAlert(message: "You have entered wrong age")
                self.ageTextField.endEditing(false)
            }
            
            
        }
        
        
        
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == nameTextField {
            
            let mainString = textField.text! + string
            ViewController.homeArray[currentSection].person[currentRow].name = mainString
            
        }else if textField == ageTextField {
            let mainString = textField.text! + string
            ViewController.homeArray[currentSection].person[currentRow].age = mainString
        }else if textField == genderTextField {
            
            let mainString = textField.text! + string
            print("main string is \(mainString)")
            ViewController.homeArray[currentSection].person[currentRow].gender = mainString
        }
        
        return true
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameTextField {
            self.nameTextField.resignFirstResponder()
            self.ageTextField.becomeFirstResponder()
            ViewController.homeArray[currentSection].person[currentRow].name = nameTextField.text!
        }else if textField == ageTextField {
            self.ageTextField.resignFirstResponder()
            self.genderTextField.becomeFirstResponder()
            ViewController.homeArray[currentSection].person[currentRow].age = ageTextField.text!
        }else if textField == genderTextField {
            self.genderTextField.resignFirstResponder()
            ViewController.homeArray[currentSection].person[currentRow].gender = genderTextField.text!
        }
        return true
    }
    
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
}
