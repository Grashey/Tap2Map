//
//  MainViewController.swift
//  Tap2Map
//
//  Created by Aleksandr Fetisov on 07.09.2020.
//  Copyright © 2020 Aleksandr Fetisov. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    var onMap: (() -> Void)?
    var onLogout: (() -> Void)?
    var onTakePicture: ((UIImage) -> Void)?
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var avatarView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text = UserDefaults.standard.value(forKey: "userName") as? String
        if let savedPhoto = try? Data(contentsOf: makeUrl()) {
            avatarView.image = UIImage(data: savedPhoto)
        }
    }
    
    @IBAction func showMapPressed(_ sender: UIButton) {
        onMap?()
    }
    
    @IBAction func logOutPressed(_ sender: UIButton) {
        UserDefaults.standard.set(false, forKey: "isLogin")
        onLogout?()
    }
    
    @IBAction func takePicture(_ sender: UIButton) {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else { return }
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .camera
        imagePickerController.allowsEditing = true
        imagePickerController.delegate = self
        present(imagePickerController, animated: true)
    }
}

extension MainViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true) { [weak self] in
            guard let image = self?.extractImage(from: info) else { return }
            self?.onTakePicture?(image)
            self?.avatarView.image = image
            let imageData = image.jpegData(compressionQuality: 1)
            try? imageData?.write(to: (self?.makeUrl())!)
        }
    }
    
    private func extractImage(from info: [UIImagePickerController.InfoKey: Any]) -> UIImage? {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            return image
        } else if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            return image
        } else {
            return nil
        }
    }
    
    private func makeUrl() -> URL {
        var documentDirectoryURL: URL {
            return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        }
        let dataURL = documentDirectoryURL.appendingPathComponent(UserDefaults.standard.value(forKey: "userName") as! String).appendingPathExtension("jpeg")
        return dataURL
    }
}
