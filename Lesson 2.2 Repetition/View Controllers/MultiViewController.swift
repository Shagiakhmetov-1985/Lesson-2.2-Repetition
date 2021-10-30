//
//  ViewController.swift
//  Lesson 2.2 Repetition
//
//  Created by Marat Shagiakhmetov on 24.10.2021.
//

import UIKit

class MultiViewController: UIViewController {

    @IBOutlet weak var colorView: UIView!

    @IBOutlet weak var redLabel: UILabel!
    @IBOutlet weak var greenLabel: UILabel!
    @IBOutlet weak var blueLabel: UILabel!
    
    @IBOutlet weak var redSlider: UISlider!
    @IBOutlet weak var greenSlider: UISlider!
    @IBOutlet weak var blueSlider: UISlider!
    
    @IBOutlet weak var redTextField: UITextField!
    @IBOutlet weak var greenTextField: UITextField!
    @IBOutlet weak var blueTextField: UITextField!
    
    var delegate: SettingViewController!
    var currentColor: UIColor!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        colorView.layer.cornerRadius = 20
        colorView.backgroundColor = currentColor
        setSliders()
        
        setLabelValue(for: redLabel, greenLabel, blueLabel)
        setTextFieldValue(for: redTextField, greenTextField, blueTextField)
        
        redSlider.minimumTrackTintColor = .red
        greenSlider.minimumTrackTintColor = .green
        blueSlider.minimumTrackTintColor = .blue
        
        redTextField.delegate = self
        greenTextField.delegate = self
        blueTextField.delegate = self
    }
    // MARK: - При смещении слайдера меняется цвет вьюшки, данные лейбл и текстфилд
    @IBAction func sliderAction(_ sender: UISlider) {
        setupColor()
        switch sender {
        case redSlider:
            setLabelValue(for: redLabel)
            setTextFieldValue(for: redTextField)
        case greenSlider:
            setLabelValue(for: greenLabel)
            setTextFieldValue(for: greenTextField)
        default:
            setLabelValue(for: blueLabel)
            setTextFieldValue(for: blueTextField)
        }
    }
    @IBAction func doneButton() {
        delegate.setColor(colorView.backgroundColor ?? .white)
        dismiss(animated: true)
    }
    // MARK: - Установка цвета
    private func setupColor() {
        colorView.backgroundColor = UIColor(
            red: CGFloat(redSlider.value),
            green: CGFloat(greenSlider.value),
            blue: CGFloat(blueSlider.value),
            alpha: 1
        )
    }
    // MARK: Смена данных лейбл
    private func setLabelValue(for labels: UILabel...) {
        labels.forEach { label in
            switch label {
            case redLabel: label.text = string(from: redSlider)
            case greenLabel: label.text = string(from: greenSlider)
            default: label.text = string(from: blueSlider)
            }
        }
    }
    // MARK: Смена данных текстфилд
    private func setTextFieldValue(for textFields: UITextField...) {
        textFields.forEach { textField in
            switch textField {
            case redTextField: textField.text = string(from: redSlider)
            case greenTextField: textField.text = string(from: greenSlider)
            default: textField.text = string(from: blueSlider)
            }
        }
    }
    // MARK: От передачи цвета фона с первого экрана на второй, меняется положение слайдеров
    private func setSliders() {
        let ciColor = CIColor(color: currentColor)
        
        redSlider.value = Float(ciColor.red)
        greenSlider.value = Float(ciColor.green)
        blueSlider.value = Float(ciColor.blue)
    }
    // MARK: Установка формата 0.00 десятичных дробей для лейбл и текстфилд
    private func string(from slider: UISlider) -> String {
        String(format: "%.2f", slider.value)
    }
    // MARK: Alert сообщение
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    // MARK: Реакция при нажатии на кнопку Done в барбаттон на клавиатуре
    @objc private func didTapDone() {
        view.endEditing(true)
    }
}
// MARK: - Работа с текстфилд и с касанием на экран при печатании текста в текстфилд
extension MultiViewController: UITextFieldDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let newValue = textField.text else { return }
        
        if let numberValue = Float(newValue) {
            switch textField {
            case redTextField:
                redSlider.setValue(numberValue, animated: true)
                sliderAction(redSlider)
            case greenTextField:
                greenSlider.setValue(numberValue, animated: true)
                sliderAction(greenSlider)
            default:
                blueSlider.setValue(numberValue, animated: true)
                sliderAction(blueSlider)
            }
            return
        }
        showAlert(title: "Wrong forman!", message: "Please type correct format: '0.00'")
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let keyboardToolbar = UIToolbar()
        textField.inputAccessoryView = keyboardToolbar
        keyboardToolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(
            title: "Done",
            style: .done,
            target: self,
            action: #selector(didTapDone)
        )
        
        let flexBarButton = UIBarButtonItem(
            barButtonSystemItem: .flexibleSpace,
            target: nil,
            action: nil
        )
        
        keyboardToolbar.items = [flexBarButton, doneButton]
    }
}

