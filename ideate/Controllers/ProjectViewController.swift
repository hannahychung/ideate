//
//  ProjectHomeViewController.swift
//  ideate
//
//  Created by Hannah Chung on 4/6/26.
//


import UIKit
import UnsplashPhotoPicker
import CoreData

class ProjectViewController: UIViewController, UITextFieldDelegate, UnsplashPhotoPickerDelegate,ColorCellDelegate {
    
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
        
        insertImageCell(img: url)
       
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
    
    var data: [ProjectCell] = []
    
    // MARK: View Setup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        user = SessionUser.shared.currentUser
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        guard let project = project else { return }

        let request: NSFetchRequest<ProjectCell> = ProjectCell.fetchRequest()
        request.predicate = NSPredicate(format: "project == %@", project)

        do {
            let results = try context.fetch(request)
            data = results.sorted { $0.order < $1.order }
            collectionView.reloadData()
        } catch {
            print("fetch error: \(error)")
        }
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
                guard let project = self.project else { return }

                let cell = ProjectCell(context: self.context)
                    cell.type = "text"
                    cell.textValue = text
                cell.order = Int16(self.data.count)
                    cell.project = project

                try? self.context.save()

                self.data.append(cell)
                self.collectionView.insertItems(at: [IndexPath(item: self.data.count - 1, section: 0)])
            })
                        
            present(alert, animated: true)
    }
    
    func addImageCell() {
        openPicker()
        
    }
    
    func insertImageCell(img: URL) {
        guard let project = project else { return }

           let cell = ProjectCell(context: context)
        
           cell.type = "image"
        cell.imageURL = img.absoluteString
           cell.order = Int16(data.count)
           cell.project = project

           try? context.save()
           data.append(cell)
        collectionView.insertItems(
               at: [IndexPath(item: data.count - 1, section: 0)]
           )
        collectionView.reloadData()

    }
    
    func colorCell(_ cell: ColorCell, didChange color: UIColor) {
        let indexPath = collectionView.indexPath(for: cell)!
        let model = data[indexPath.item]

        model.colorValue = color.toHex()
        try? context.save()
    }
    
    func addColorCell() {
        guard let project = project else { return }
            let cell = ProjectCell(context: context)
            cell.type = "color"
            cell.colorValue = "#00FF00"
            cell.order = Int16(data.count)
            cell.project = project

            try? context.save()

            data.append(cell)
        collectionView.insertItems(at: [IndexPath(item: data.count - 1, section: 0)])
    }
    
    //MARK: Text Field
    
    @IBAction func editName(_ sender: UIButton) {
        if textField.hasText {
            projectName.adjustsFontSizeToFitWidth = true
            project!.name = textField.text
            projectName.text = textField.text!
            try? context.save()
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

    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return data.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cellObj = data[indexPath.item]

        switch cellObj.type {

        case "text":
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: textCellIdentifier,
                for: indexPath
            ) as! TextCell

            cell.configure(text: cellObj.textValue ?? "")
            return cell

        case "image":
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: imageCellIdentifier,
                for: indexPath
            ) as! ImageCell

            if let urlString = cellObj.imageURL,
               let url = URL(string: urlString) {
                cell.configure(url: url)
            }
            return cell

        case "color":
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: colorCellIdentifier,
                for: indexPath
            ) as! ColorCell
            
            cell.delegate = self

            cell.configure(colorHex: cellObj.colorValue ?? "#FFFFFF")
            return cell

        default:
            fatalError("Unknown cell type")
        }
    }
}


extension UIColor {

    func toHex() -> String {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0

        getRed(&r, green: &g, blue: &b, alpha: &a)

        return String(
            format: "#%02X%02X%02X",
            Int(r * 255),
            Int(g * 255),
            Int(b * 255)
        )
    }
}
