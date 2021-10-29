//
//  MainViewController.swift
//  Lesson 2.2 Repetition
//
//  Created by Marat Shagiakhmetov on 29.10.2021.
//

import UIKit

protocol SettingViewController {
    func setColor(_ color: UIColor)
}

class MainViewController: UIViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let settingVC = segue.destination as? MultiViewController else { return }
        settingVC.currentColor = view.backgroundColor
        settingVC.delegate = self
    }
    
    @IBAction func unwind(segue: UIStoryboardSegue) {
    }

}

extension MainViewController: SettingViewController {
    func setColor(_ color: UIColor) {
        view.backgroundColor = color
    }
}
