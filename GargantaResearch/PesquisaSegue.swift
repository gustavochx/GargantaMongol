//
//  PesquisaSegue.swift
//  GargantaResearch
//
//  Created by Yago Teixeira on 25/05/16.
//  Copyright © 2016 Gustavo Henrique. All rights reserved.
//

import UIKit

class ResearchContainerSegue: UIStoryboardSegue {
    
    override func perform() {
        let controllerToReplace = sourceViewController.childViewControllers.first
        let destinationControllerView = destinationViewController.view
        
        destinationControllerView.translatesAutoresizingMaskIntoConstraints = true
        destinationControllerView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        destinationControllerView.frame = sourceViewController.view.bounds
        
        controllerToReplace?.willMoveToParentViewController(nil)
        sourceViewController.addChildViewController(destinationViewController)
        
        sourceViewController.view.addSubview(destinationControllerView)
        controllerToReplace?.view.removeFromSuperview()
        
        destinationViewController.didMoveToParentViewController(sourceViewController)
        controllerToReplace?.removeFromParentViewController()
    }
}