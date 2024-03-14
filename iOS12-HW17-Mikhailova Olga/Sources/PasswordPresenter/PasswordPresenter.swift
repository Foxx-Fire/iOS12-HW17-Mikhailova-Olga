//
//  PasswordPresenter.swift
//  iOS12-HW17-Mikhailova Olga
//
//  Created by FoxxFire on 10.03.2024.
//

import Foundation

// Показали(вернули) инфу
protocol ViewProcotol: AnyObject {
    func result(label: String)
    func setBrut(label: String)
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
            view?.setBrut(label: password)
        }
        view?.result(label: password)
    }
}
