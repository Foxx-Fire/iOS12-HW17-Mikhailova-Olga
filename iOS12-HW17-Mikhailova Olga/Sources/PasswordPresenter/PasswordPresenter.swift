//
//  PasswordPresenter.swift
//  iOS12-HW17-Mikhailova Olga
//
//  Created by FoxxFire on 10.03.2024.
//

import Foundation

// Показали(вернули) инфу
protocol ViewProcotol: AnyObject {
    func setBrut(textField: String, label: String, bruting: String)
}

// Получили инфу(со стороны)
protocol PresenterProtocol: AnyObject {
    init(view: ViewProcotol, model: Brute)
    func bruteForce(passwordToUnlock: String)
}

final class ModulePresenter: PresenterProtocol {
    
    weak var view: ViewProcotol?
    private var model: Brute?
    
    init(view: ViewProcotol, model: Brute) {
        self.view = view
        self.model = model
    }
    
    func bruteForce(passwordToUnlock: String) {
        let allowedCharacters: [String] = String().printable.map { String($0) }
        var password: String = ""
        
        while password != passwordToUnlock {
            password = self.model?.generateBruteForce(password, fromArray: allowedCharacters) ?? ""
            let printing = { () -> String in password }
            view?.setBrut(textField: password, label: "", bruting: printing())
        }
        view?.setBrut(textField: password, label: password, bruting: "")
    }
}
