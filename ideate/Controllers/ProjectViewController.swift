//
//  ProjectHomeViewController.swift
//  ideate
//
//  Created by Hannah Chung on 4/6/26.
//


import UIKit
import UnsplashPhotoPicker
import CoreData

class ProjectViewController: UIViewController, UITextFieldDelegate, UnsplashPhotoPickerDelegate {
    
    let context = persistentContainer.viewContext
    var user: IdeateUser? = nil
    var project: Project? = nil

    @IBOutlet weak var projectName: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    // MARK: Unsplash Setup
    
    func openPicker() {
            let config = UnsplashPhotoPickerConfiguration(
                accessKey: "mWOTMrl8__lnLHgPA6L3zdOJM149kDOWv-f44iLMDPc",
                secretKey: "g4-oIv4fvyl05mJTGChFIqP9pNpQTI4Bu_65WEDZR-o",
                allowsMultipleSelection: false
            )

            let picker = UnsplashPhotoPicker(configuration: config)
            picker.photoPickerDelegate = self
            present(picker, animated: true)
        }

    func unsplashPhotoPicker(_ photoPicker: UnsplashPhotoPicker, didSelectPhotos photos: [UnsplashPhoto]) {
        guard let photo = photos.first else { return }
        guard let url = photo.urls[.small] else { return }
        
        let imageURL = url.absoluteString
        
        data.append(.image(url: imageURL))
        
        let newIndex = IndexPath(item: data.count - 1, section: 0)
        collectionView.insertItems(at: [newIndex])
        
        photoPicker.dismiss(animated: true)
    }
    
    func unsplashPhotoPickerDidCancel(_ photoPicker: UnsplashPhotoPicker) {
            dismiss(animated: true)
        }
    
    // MARK: Collection Setup
    
    @IBOutlet weak var collectionView: UICollectionView!

    let textCellIdentifier = "TextCellIdentifier"
    let imageCellIdentifier = "ImageCellIdentifier"
    let colorCellIdentifier = "ColorCellIdentifier"
    
    enum CellType {
        case text(content: String)
        case image(url: String)
        case color(color: UIColor)
    }
    
    var data: [CellType] = [.text(content: "this is some notes about a project that i'm working on."), .color(color: .systemBlue), .text(content: "here are some more notes about the same project.")]
    
    // MARK: View Setup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        if let project = project {
            projectName.text = project.name
        }
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .vertical
            layout.itemSize = CGSize(
                width: collectionView.frame.width - 20,
                height: 250
            )
            layout.minimumLineSpacing = 20
        }
        textField.delegate = self
    
        
    }
    
    @IBAction func homeButton(_ sender: UIButton) {
        performSegue(withIdentifier: "toHomeSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toHomeSegue" {
            let destinationVC = segue.destination as! IDViewController
            destinationVC.user = self.user
            destinationVC.modalPresentationStyle = .fullScreen
            
        }
    }
    
    //MARK: Popup
    
    @IBAction func newCellButton(_ sender: UIButton) {
        addNewCell()
    }
    
    func addNewCell() {
        let popup = UIAlertController(title: "Choose Cell Type", message: nil, preferredStyle: .actionSheet)
        popup.addAction(UIAlertAction(title: "Text", style: .default) { _ in
            self.addTextCell()
        })
        popup.addAction(UIAlertAction(title: "Image", style: .default) { _ in
            self.addImageCell()
        })
        popup.addAction(UIAlertAction(title: "Color", style: .default) { _ in
            self.addColorCell()
        })
        present(popup, animated: true)
        
    }
    
    func addTextCell() {
        let alert = UIAlertController(title: "Take a note", message: "Take a note:", preferredStyle: .alert)
            
            alert.addTextField { textField in
                textField.placeholder = "Type something..."
            }
            
            alert.addAction(UIAlertAction(title: "Add", style: .default) { _ in
                let text = alert.textFields?.first?.text
                    self.data.append(.text(content: text!))
                    
                    let newIndex = IndexPath(item: self.data.count - 1, section: 0)
                    self.collectionView.insertItems(at: [newIndex])
            })
                        
            present(alert, animated: true)
    }
    
    func addImageCell() {
        openPicker()

    }
    
    func addColorCell() {
        data.append(.color(color: .systemGreen))
        
        let newIndex = IndexPath(item: data.count - 1, section: 0)
        collectionView.insertItems(at: [newIndex])
    }
    
    //MARK: Text Field
    
    @IBAction func editName(_ sender: UIButton) {
        if textField.hasText {
            projectName.adjustsFontSizeToFitWidth = true
            projectName.text = textField.text!
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    

}

extension ProjectViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}
extension ProjectViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = data[indexPath.item]
        
        switch item {
        case .text(let content):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: textCellIdentifier, for: indexPath) as! TextCell
            cell.configure(text:content)
            cell.layer.borderColor = UIColor.gray.cgColor
            return cell
            
        case .image(let url):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: imageCellIdentifier, for: indexPath) as! ImageCell
            cell.configure(url: url)
            cell.layer.borderColor = UIColor.gray.cgColor
            return cell
        case .color(let color): let cell = collectionView.dequeueReusableCell(withReuseIdentifier: colorCellIdentifier, for: indexPath) as! ColorCell
            cell.configure(color: color)
            cell.layer.borderColor = UIColor.gray.cgColor
            cell.layer.borderColor = UIColor.gray.cgColor
            return cell
        }
    }
}
