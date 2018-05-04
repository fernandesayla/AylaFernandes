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
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        product?.dollarPrice = Double(tfDollarPrice.text!)!
        product?.paymentMethod = swIsCard.isOn
        // product?.realPrice implementar conversão
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

