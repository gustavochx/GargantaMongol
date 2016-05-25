//
//  ComecoViewController.swift
//  GargantaResearch
//
//  Created by Yago Teixeira on 25/05/16.
//  Copyright © 2016 Gustavo Henrique. All rights reserved.
//

import UIKit
import ResearchKit

class ComecoViewController: UIViewController {
    
    var contentHidden = false {
        didSet {
            guard contentHidden != oldValue && isViewLoaded() else { return }
            childViewControllers.first?.view.hidden = contentHidden
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if ORKPasscodeViewController.isPasscodeStoredInKeychain() {
            toStudy()
        }
        else {
            toOnboarding()
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func toOnboarding() {
        performSegueWithIdentifier("Autenticar", sender: self)
    }
    
    func toStudy() {
        performSegueWithIdentifier("Principal", sender: self)
    }

}


