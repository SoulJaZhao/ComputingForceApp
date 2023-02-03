//
//  ActivityIndicatorManager.swift
//  ComputingForceApp
//
//  Created by 赵龙 on 2023/1/31.
//

import UIKit
import NVActivityIndicatorView

class ActivityIndicatorManager {
    static let manager = ActivityIndicatorManager()
    
    private let containerView: UIView
    private let activityIndicatorView: NVActivityIndicatorView
    private var keyWindow: UIWindow {
        AppContext.context.router.keyWindow
    }
    
    private init() {
        containerView = UIView(frame: UIScreen.main.bounds)
        containerView.backgroundColor = AppContext.context.theme.blackColor.withAlphaComponent(0.8)
        let xPoint = (UIScreen.main.bounds.size.width - NVActivityIndicatorView.DEFAULT_BLOCKER_SIZE.width) * 0.5
        let yPoint = (UIScreen.main.bounds.size.height - NVActivityIndicatorView.DEFAULT_BLOCKER_SIZE.height) * 0.5
        activityIndicatorView = NVActivityIndicatorView(frame: CGRect(origin: CGPoint(x: xPoint, y: yPoint), size: NVActivityIndicatorView.DEFAULT_BLOCKER_SIZE), type: .audioEqualizer)
        activityIndicatorView.isHidden = true
        containerView.addSubview(activityIndicatorView)
        keyWindow.addSubview(containerView)
    }
    
    func startAnimation() {
        containerView.isHidden = false
        keyWindow.bringSubviewToFront(containerView)
        activityIndicatorView.startAnimating()
    }
    
    func stopAnimation() {
        activityIndicatorView.stopAnimating()
        containerView.isHidden = true
    }
}
