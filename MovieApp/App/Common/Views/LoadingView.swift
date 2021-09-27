//
//  LoadingView.swift
//  MovieApp
//
//  Created by Ishipo on 07/07/2021.
//

import SVProgressHUD

open class LoadingView: NSObject {
    
    public static let shared = LoadingView()
    
    public override init() {
        super.init()
        customProgressHUD()
    }
    
    private func customProgressHUD() {
        SVProgressHUD.setDefaultMaskType(.custom)
        SVProgressHUD.setDefaultAnimationType(.flat)
        SVProgressHUD.setDefaultStyle(.light)
        SVProgressHUD.setRingThickness(1.0)
        SVProgressHUD.setMaximumDismissTimeInterval(2.0)
        SVProgressHUD.setMaxSupportedWindowLevel(UIWindow.Level.alert + 1)
    }
    
    public func showProgressHubOnMainThread() {
        DispatchQueue.main.async {
            SVProgressHUD.show()
        }
    }
    
    public func dismissProgressHubOnMainThread() {
        DispatchQueue.main.async {
            SVProgressHUD.dismiss()
        }
    }
}
