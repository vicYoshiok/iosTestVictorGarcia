//
//  MainViewController.swift
//  exameniOsVictorGarcia
//
//  Created by Victor Garcia on 21/11/24.
//
import UIKit
import Foundation

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    private let viewModelC = CameraViewModel() // Instancia del ViewModel
    private var selectedImage: UIImage?
    private var username = ""
    var textField: UITextField?
    
    // Ciclo de vida del controlador
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        viewModelC.selectedImage = { [weak self] image in
            guard let self = self else { return }
            if let image = image {
                print("Imagen seleccionada correctamente.")
                self.selectedImage = image
            } else {
                print("No se seleccionó ninguna imagen.")
            }
        }    }
    
    // Método para obtener el username del textField
    func getUsername() -> String? {
        guard let username = textField?.text?.trimmingCharacters(in: .whitespacesAndNewlines), !username.isEmpty else {
            return nil
        }
        return username
    }
    
    // MARK: - Acción de los botones
    
    @objc func buttonTapped() {
        print("Abrir la cámara!")
        viewModelC.openCameraOrGallery(from: self)
    }
    
    // Acción para navegar a MapsViewController
    @IBAction func toMapsView(_ sender: Any) {
        guard let usernameText = textField?.text, !usernameText.isEmpty else {
                
                print("El campo de nombre de usuario está vacío.")
            let alertC = UIAlertController(title: "Error ",
                                            message: "El campo de nombre de usuario está vacío.",
                                            preferredStyle: .alert)
            let aceptAction = UIAlertAction(title: "Aceptar", style: .default){ [] (action:UIAlertAction) in
                
            }
            alertC.addAction(aceptAction)
            self.present(alertC, animated: true, completion: nil)
                return
            }

            // Verificar que el texto solo contenga caracteres alfabéticos
        let characterSet = CharacterSet.letters // Solo caracteres alfabéticos
        if textField?.text!.rangeOfCharacter(from: characterSet.inverted) != nil {
 
                print("El nombre de usuario contiene caracteres no alfabéticos.")

                let alertC = UIAlertController(title: "Error ",
                                                message: "El nombre de usuario contiene caracteres no alfabéticos.",
                                                preferredStyle: .alert)
                let aceptAction = UIAlertAction(title: "Aceptar", style: .default){ [] (action:UIAlertAction) in
                    
                }
                alertC.addAction(aceptAction)
                self.present(alertC, animated: true, completion: nil)
                return
            }

            
            performSegue(withIdentifier: "toMaps", sender: self.getUsername())
//        performSegue(withIdentifier: "toMaps", sender: self.getUsername())
    }
    
    // Acción para guardar la imagen y el nombre de usuario
    @IBAction func savePhotoAndUsernameAction(_ sender: Any) {
        
        guard let usernameText = textField?.text, !usernameText.isEmpty else {
                
                print("El campo de nombre de usuario está vacío.")
            let alertC = UIAlertController(title: "Error ",
                                            message: "El campo de nombre de usuario está vacío.",
                                            preferredStyle: .alert)
            let aceptAction = UIAlertAction(title: "Aceptar", style: .default){ [] (action:UIAlertAction) in
                
            }
            alertC.addAction(aceptAction)
            self.present(alertC, animated: true, completion: nil)
                return
            }
        username = usernameText

            // Verificar que el texto solo contenga caracteres alfabéticos
        let characterSet = CharacterSet.letters // Solo caracteres alfabéticos
        if textField?.text!.rangeOfCharacter(from: characterSet.inverted) != nil {
 
                print("El nombre de usuario contiene caracteres no alfabéticos.")

                let alertC = UIAlertController(title: "Error ",
                                                message: "El nombre de usuario contiene caracteres no alfabéticos.",
                                                preferredStyle: .alert)
                let aceptAction = UIAlertAction(title: "Aceptar", style: .default){ [] (action:UIAlertAction) in
                    
                }
                alertC.addAction(aceptAction)
                self.present(alertC, animated: true, completion: nil)
                return
            }
        
        guard let image = selectedImage else {
            print("No hay imagen seleccionada.")
            let alertC = UIAlertController(title: "Error ",
                                            message: "No hay imagen seleccionada.",
                                            preferredStyle: .alert)
            let aceptAction = UIAlertAction(title: "Aceptar", style: .default){ [] (action:UIAlertAction) in
                
            }
            alertC.addAction(aceptAction)
            self.present(alertC, animated: true, completion: nil)
            return
        }
        
        viewModelC.uploadImageToFirebase(username: username, image: image) { (success, message) in
            if success {
                print("Imagen subida correctamente a Firebase Storage.")
                let alertC = UIAlertController(title: "Completado ",
                                                message: "la imagen se subio correctamente",
                                                preferredStyle: .alert)
                let aceptAction = UIAlertAction(title: "Aceptar", style: .default){ [] (action:UIAlertAction) in
                    
                }
                alertC.addAction(aceptAction)
                self.present(alertC, animated: true, completion: nil)
            
            } else {
                print("Error al subir la imagen: \(message ?? "Sin mensaje").")
            }
        }
        
        
    }

    
    // Envío del usuario a través del segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toMaps" {
            if let user = sender as? String {
                if let mapsVC = segue.destination as? MapViewController {
                    mapsVC.user = user
                }
            }
        }
    }
    
    // MARK: - Métodos de UITableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "Ver Lista de Peliculas >"
            cell.textLabel?.textAlignment = .left
            cell.textLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
            
        case 1:
            // Crear un textField para el nombre de usuario
            textField = UITextField(frame: CGRect(x: 15, y: 5, width: tableView.frame.width - 30, height: 40))
            textField?.placeholder = "Usuario"
            textField?.borderStyle = .roundedRect
            textField?.keyboardType = .alphabet
            textField?.autocapitalizationType = .none
            textField?.tag = indexPath.row
            cell.contentView.addSubview(textField!)
            
        case 2:
            let button = UIButton(type: .system)
            button.setTitle("Seleccionar foto", for: .normal)
            button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
            button.frame = CGRect(x: 15, y: 5, width: tableView.frame.width - 30, height: 40)
            button.backgroundColor = UIColor.systemBlue
            button.tintColor = .white
            button.layer.cornerRadius = 20
            cell.contentView.addSubview(button)
            
        default:
            break
        }
        
        return cell
    }
    
    // Métodos para manejar la selección de celdas en la tabla
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            print("Ir a Lista de Peliculas")
            performSegue(withIdentifier: "toMovies", sender: nil)
        case 1:
            break
        case 2:
            break
        default:
            break
        }
    }
    
    // Definir la altura de las filas de la tabla
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
