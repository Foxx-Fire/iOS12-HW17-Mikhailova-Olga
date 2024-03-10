//
//  Builder.swift
//  iOS12-HW17-Mikhailova Olga
//
//  Created by FoxxFire on 10.03.2024.
//

import UIKit

class Bulder {
    static func module() -> UIViewController {
        let view = ViewController()
        let model = BruteClass()
        let presenter = ModulePresenter(view: view, model: model)
        view.presenter = presenter

        return view
    }
}
