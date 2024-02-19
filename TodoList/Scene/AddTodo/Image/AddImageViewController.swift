//
//  AddImageViewController.swift
//  TodoList
//
//  Created by SUCHAN CHANG on 2/19/24.
//

import UIKit
import SnapKit

protocol AddImageDelegate: AnyObject {
    func transferSelectedImage(_ image: UIImage?)
}

final class AddImageViewController: UIViewController {
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo")
        imageView.tintColor = .white
        imageView.contentMode = .scaleToFill
        imageView.backgroundColor = .clear
        return imageView
    }()
    
    let addImageFromGalleryButton: UIButton = {
        let button = UIButton()
        button.setTitle("갤러리에서 사진 추가하기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 18.0)
        button.backgroundColor = .darkGray
        button.clipsToBounds = true
        button.layer.cornerRadius = 20
        return button
    }()
    
    var navigationItemTitle: String = ""
    
    var delegate: AddImageDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavigationBar()
        configureConstraints()
        configureUI()
        configureUserEvents()
    }
}

extension AddImageViewController {
    @objc func addImageFromGalleryButtonTapped() {
        let imagePickerVC = UIImagePickerController()
        imagePickerVC.delegate = self
        imagePickerVC.allowsEditing = true
        present(imagePickerVC, animated: true)
    }
}

extension AddImageViewController: UIViewControllerConfigurationProtocol {
    func configureNavigationBar() {
        navigationItem.title = navigationItemTitle
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
    }
    
    func configureConstraints() {
        [
            imageView,
            addImageFromGalleryButton
        ].forEach { view.addSubview($0) }
        
        imageView.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(UIScreen.main.bounds.width)
        }
        
        addImageFromGalleryButton.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(16.0)
            $0.horizontalEdges.equalToSuperview().inset(16.0)
            $0.height.equalTo(50.0)
        }
    }
    
    func configureUI() {
        view.backgroundColor = .black
    }
    
    func configureOtherSettings() {
        
    }
    
    func configureUserEvents() {
        addImageFromGalleryButton.addTarget(self, action: #selector(addImageFromGalleryButtonTapped), for: .touchUpInside)
    }

}

extension AddImageViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print(#function)
        
        dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print(#function)
        
        let image = info[.editedImage] as? UIImage
        imageView.image = image
        delegate?.transferSelectedImage(image)
        
        dismiss(animated: true)
    }
}
