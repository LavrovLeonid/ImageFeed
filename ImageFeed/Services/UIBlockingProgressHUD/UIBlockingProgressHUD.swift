//
//  UIBlockingProgressHUD.swift
//  ImageFeed
//
//  Created by Леонид Лавров on 6/17/24.
//

import UIKit
import ProgressHUD

final class UIBlockingProgressHUD {
    // MARK: Static properties
    private static var window: UIWindow? {
        UIApplication.shared.windows.first
    }
    
    // MARK: Static methods
    static func show() {
        window?.isUserInteractionEnabled = false
        ProgressHUD.animate()
    }
    
    static func dismiss() {
        window?.isUserInteractionEnabled = true
        ProgressHUD.dismiss()
    }
}
