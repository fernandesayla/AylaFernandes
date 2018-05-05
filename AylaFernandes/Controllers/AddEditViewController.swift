//
//  AddEditViewController.swift
//  AylaFernandes
//
//  Created by Ayla Fernandes on 4/25/18.
//  Copyright © 2018 Ayla Fernandes. All rights reserved.
//

import UIKit
import CoreData

class AddEditViewController: UIViewController {
    
    
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var ivImage: UIImageView!
    @IBOutlet weak var tfState: UITextField!
    @IBOutlet weak var tfDollarPrice: UITextField!
    @IBOutlet weak var swIsCard: UISwitch!
    var product: Product!
    var image: UIImage?
    
    lazy var pickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        return pickerView
        }()
//    var settingsViewController: SettingsViewController.shared
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           if segue.identifier == "productSegue" {
        let vc = segue.destination as! AddEditViewController
        vc.product = product
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if product != nil {
           prepareTela()
        }
        
       
    }
    
    func prepareTela(){
        tfName.text = product.name
        tfState.text = product.state?.name
        tfDollarPrice.text =  String(product.dollarPrice) // tc.getFormattedValue(of: product.dollarPrice, with: "US$ ")
        if let image = product.image as? UIImage {
        ivImage.image = image
        }else{
        ivImage.image = UIImage(named: "gift")
    }
    
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func addImage(_ sender: Any) {
        let alert = UIAlertController(title: "Selecionar imagem", message: "De onde você deseja escolher a imagem?", preferredStyle: .actionSheet)
        
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
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    @IBAction func addEditProduct(_ sender: UIButton) {
        if product == nil {
            product = Product(context: context)
        }
        product?.name = tfName.text
        product?.image = image
        product?.dollarPrice = tc.convertToDoble(tfDollarPrice.text!)
        product?.paymentMethod = swIsCard.isOn
        product?.realPrice  = tc.calculate(usingCreditCard: swIsCard.isOn)
        //product?.state implementar seleção
        
        do {
            try context .save()
        } catch{
            print(error.localizedDescription)
        }
        navigationController?.popViewController(animated: true)
        
    }
    
    
    
    @IBAction func addState(_ sender: UIButton) {
        
        
    }
    
}
extension AddEditViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            let size = CGSize(width: image.size.width*0.2, height: image.size.height*0.2)
            UIGraphicsBeginImageContext(size)
            image.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            self.image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            ivImage.image = self.image
        }
        
        dismiss(animated: true, completion: nil)
        
    }
}
extension AddEditViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 100
    }
    
}

