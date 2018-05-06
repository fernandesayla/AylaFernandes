//
//  AddEditViewController.swift
//  AylaFernandes
//
//  Created by Ayla Fernandes on 4/25/18.
//  Copyright © 2018 Ayla Fernandes. All rights reserved.
//

import UIKit
import CoreData
import Photos

class AddEditViewController: UIViewController {
    
    
    @IBOutlet weak var btnAddEdit: UIButton!
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var ivImage: UIImageView!
    @IBOutlet weak var tfState: UITextField!
    @IBOutlet weak var tfDollarPrice: UITextField!
    @IBOutlet weak var swIsCard: UISwitch!
    
    var image: UIImage?
    
    var product: Product!

    
    lazy var pickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        return pickerView
        }()
//    var settingsViewController: SettingsViewController.shared
    var  sm = StateManager.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 44))
        let btnCancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        let btnDone = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        let btnFlexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil , action: nil)
        
        toolBar.items = [btnCancel, btnFlexibleSpace, btnDone]
        tfState.inputView = pickerView
        tfState.inputAccessoryView = toolBar
        
   
        
        
    }
    @objc func cancel(){
        tfState.resignFirstResponder()
    }
    
    @objc func done(){
        tfState.text = sm.states[pickerView.selectedRow(inComponent: 0)].name
        cancel()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           if segue.identifier == "productSegue" {
        let vc = segue.destination as! AddEditViewController
        vc.product = product
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        sm.loadStates(with: context)
        
        if product != nil {
           prepareTela()
           btnAddEdit.setTitle("Atualizar", for: .normal)
            
        }
    }
    
    func prepareTela(){
        tfName.text = product.name
        tfState.text = product.state?.name
        tfDollarPrice.text = tc.getFormattedValue(of: product.dollarPrice, with: "")
        swIsCard.isOn = product.paymentMethod
        if let image = product.image as? UIImage {
            ivImage.image = image
        }
      
    
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func addImage(_ sender: Any) {
        let alert = UIAlertController(title: "Selecionar Imagem", message: "De onde você deseja escolher a ?", preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: "Câmera", style: .default) { (action) in
                self.selectPicture(sourceType: .camera)
            }
            alert.addAction(cameraAction)
        }
        
        
        let libraryAction = UIAlertAction(title: "Biblioteca de fotos", style: .default) { (action) in
            self.selectPicture(sourceType: .photoLibrary)
        }
        alert.addAction(libraryAction)
        
        let photosAction = UIAlertAction(title: "Álbum de fotos", style: .default) { (action) in
            self.selectPicture(sourceType: .savedPhotosAlbum)
        }
        alert.addAction(photosAction)
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func selectPicture(sourceType: UIImagePickerControllerSourceType) {
         checkPermission {
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = sourceType
            imagePicker.delegate = self
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @IBAction func addEditProduct(_ sender: UIButton) {
        if !tfName.text!.isEmpty && !tfDollarPrice.text!.isEmpty && !tfState.text!.isEmpty &&  ivImage.image != nil{
            
            if product == nil {
                product = Product(context: context)
            }
            product?.name = tfName.text
            product?.image =  ivImage.image
            product?.dollarPrice = tc.convertToDoble(tfDollarPrice.text!)
            product?.paymentMethod = swIsCard.isOn
 
            if !tfState.text!.isEmpty{
                 let state = sm.states[pickerView.selectedRow(inComponent: 0)]
                 product.state  = state
            }
            
            do {
                try context .save()
            } catch{
                print(error.localizedDescription)
            }
            navigationController?.popViewController(animated: true)
        }
        
        else {
            let alert = UIAlertController(title: "Campos Invalidos", message: "Todos os campos precisam ser preenchidos", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    
    }
}
extension AddEditViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return sm.states.count

    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
      
            let state = sm.states[row]
            return state.name
        
    }
    func checkPermission(hanler: @escaping () -> Void) {
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        switch photoAuthorizationStatus {
        case .authorized:
            
            hanler()
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { (newStatus) in
                if newStatus == PHAuthorizationStatus.authorized {
                  
                    hanler()
                }
            }
        default:
            print("Error: no access to photo album.")
        }
    }
}
extension AddEditViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
       
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        self.dismiss(animated: true) {
            self.ivImage.image = image
        }
    }
}


