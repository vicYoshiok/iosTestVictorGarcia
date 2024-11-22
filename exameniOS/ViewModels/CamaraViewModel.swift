
//  CamaraViewModel.swift
//  exameniOsVictorGarcia
//
//  Created by Victor Garcia on 21/11/24.
//
import UIKit
import Firebase
import FirebaseStorage

class CameraViewModel: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // Esta propiedad es un closure que manejará la imagen seleccionada
    var selectedImage: ((UIImage?) -> Void)?
    
    // Función para abrir la cámara o la galería
    func openCameraOrGallery(from viewController: UIViewController) {
        let alert = UIAlertController(title: "Seleccionar imagen", message: "Elige una opción", preferredStyle: .actionSheet)

        alert.addAction(UIAlertAction(title: "Cámara", style: .default, handler: { [weak self] _ in
            self?.openCamera(from: viewController)
        }))
        
        alert.addAction(UIAlertAction(title: "Galería", style: .default, handler: { [weak self] _ in
            self?.openGallery(from: viewController)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = viewController.view
            popoverController.sourceRect = CGRect(x: viewController.view.bounds.midX, y: viewController.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        viewController.present(alert, animated: true, completion: nil)
    }
    
    // Abrir la cámara
    private func openCamera(from viewController: UIViewController) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            viewController.present(imagePicker, animated: true, completion: nil)
        } else {
            print("Cámara no disponible")
        }
    }
    
    // Abrir la galería
    private func openGallery(from viewController: UIViewController) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            viewController.present(imagePicker, animated: true, completion: nil)
        } else {
            print("Galería no disponible")
        }
    }
    
    // Manejar la imagen seleccionada
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            // Usar el closure para enviar la imagen seleccionada al ViewController
            selectedImage?(image)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    func resizeImage(_ image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        let scaleFactor = min(widthRatio, heightRatio)
        
        let newSize = CGSize(width: size.width * scaleFactor, height: size.height * scaleFactor)
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        image.draw(in: CGRect(origin: .zero, size: newSize))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return resizedImage ?? image
    }
    
    // Método para subir la imagen seleccionada a Firebase Storage
    func uploadImageToFirebase(username: String, image: UIImage, completion: @escaping (Bool, String?) -> Void) {

        let resizedImage = resizeImage(image, targetSize: CGSize(width: 1000, height: 1000))
        
        // Convertir la imagen a Data
        guard let imageData = resizedImage.jpegData(compressionQuality: 0.75) else {
            completion(false, "Error al convertir la imagen a Data.")
            return
        }

        let storageRef = Storage.storage().reference().child("images/\(UUID().uuidString).jpg")
        print("Subiendo imagen a: \(storageRef.fullPath)")

        storageRef.putData(imageData) { metadata, error in
            if let error = error {
                print("Error al subir la imagen a Firebase Storage: \(error.localizedDescription)")
                completion(false, "Error al subir la imagen: \(error.localizedDescription)")
                return
            }
            
            
            print("Imagen subida correctamente")
        
            // Obtener la URL de la imagen subida
            storageRef.downloadURL { url, error in
                if let error = error {
                    print("Error al obtener la URL de la imagen: \(error.localizedDescription)")
                    completion(false, "Error al obtener la URL: \(error.localizedDescription)")
                    return
                }

                guard let imageUrl = url?.absoluteString else {
                    print("URL no disponible")
                    completion(false, "URL no disponible")
                    return
                }

                // Guardar la URL en Firestore junto con el nombre de usuario
                let db = Firestore.firestore()
                let coordinatesRef = db.collection("coordinates").document(username)
                coordinatesRef.setData([
                    "username": username,
                    "imageUrl": imageUrl,
                    "timestamp": FieldValue.serverTimestamp()
                ]) { error in
                    if let error = error {
                        print("Error al guardar en Firestore: \(error.localizedDescription)")
                        completion(false, "Error al guardar en Firestore: \(error.localizedDescription)")
                    } else {
                        print("Imagen subida y URL guardada en Firestore.")
                        completion(true, imageUrl)
                    }
                }
            }
        }
    }

}
