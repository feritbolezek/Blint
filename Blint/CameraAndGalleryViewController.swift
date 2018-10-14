//
//  CameraAndGalleryViewController.swift
//  Blint
//
//  Created by Ferit Bölezek on 2017-06-23.
//  Copyright © 2017 Ferit Bölezek. All rights reserved.
//

import UIKit

class CameraAndGalleryViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var camera: UIImagePickerController?
    
    var sender: String!
    
    weak var delegate: CameraViewDelegate?
    
    var imagePicked = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if !imagePicked {
        if sender == "camera" {
            prepareCamera()
        } else {
            prepareLibrary()
        }
        }
    }
    
    func prepareCamera() {
        self.camera = UIImagePickerController()
        self.camera?.delegate = self
        self.camera?.allowsEditing = true
        self.camera?.sourceType = UIImagePickerControllerSourceType.camera
        self.camera?.cameraCaptureMode = .photo
        self.camera?.showsCameraControls = true
        
        self.present(self.camera!, animated: true, completion: nil)
    }
    func prepareLibrary() {
        self.camera = UIImagePickerController()
        self.camera?.delegate = self
        self.camera?.allowsEditing = true
        self.camera?.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        self.present(self.camera!, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let imagePicked = info[UIImagePickerControllerEditedImage] as! UIImage
        delegate?.newPhotoChosen(theImage: imagePicked)
        self.imagePicked = true
        dismiss(animated: true, completion: nil)
        navigationController?.popViewController(animated: true)
        self.camera = nil
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        navigationController?.popViewController(animated: true)
        self.camera = nil
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}
