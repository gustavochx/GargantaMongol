//
//  AutenticacaoViewController.swift
//  GargantaResearch
//
//  Created by Yago Teixeira on 25/05/16.
//  Copyright © 2016 Gustavo Henrique. All rights reserved.
//

import UIKit
import ResearchKit

class AutenticacaoViewController: UIViewController {
    var taskViewController:ORKTaskViewController?
    
    
     var arraySummary = ["Welcome to the throat cancer research.","This app collect data to perform our research.","All data collected by this app is private, no one will be identified.","The collected data will be used to obtain the results of this research.","","","We will be using secure procedures in this research.","In the case you want to give up this research, feel free.",""]
    
    internal var FormularioDeAutorizacao: ORKConsentDocument {
        
        let FormularioDeAutorizacao = ORKConsentDocument()
        FormularioDeAutorizacao.title = "Cancer Permission Research"
        
        let tiposDeSessoesDeAutorizacao: [ORKConsentSectionType] = [
            .Overview,
            .DataGathering,
            .Privacy,
            .DataUse,
            .StudyTasks,
            .Withdrawing
        ]
        
        let sessoesDeAutorizacoes: [ORKConsentSection] = tiposDeSessoesDeAutorizacao.map {
            
            tipoDeSessao in
            
            let sessaoDeAutorizacao = ORKConsentSection(type: tipoDeSessao)
            sessaoDeAutorizacao.summary = arraySummary[tipoDeSessao.rawValue]
            sessaoDeAutorizacao.content = arraySummary[tipoDeSessao.rawValue]
            return sessaoDeAutorizacao
        }
        
        FormularioDeAutorizacao.sections = sessoesDeAutorizacoes
        
        FormularioDeAutorizacao.addSignature(ORKConsentSignature(forPersonWithTitle: nil, dateFormatString: nil, identifier: "AssinaturaDoFormularioDeAutorizacao"))
        
        return FormularioDeAutorizacao
    }
    
    public var TarefasDeAutorizacao: ORKOrderedTask {
        
        var steps = [ORKStep]()
        
        let formularioDeAutorizacao = FormularioDeAutorizacao
        let autorizacaoVisual = ORKVisualConsentStep(identifier: "AutorizacaoVisual", document: formularioDeAutorizacao)
        
        steps += [autorizacaoVisual]
        
        let assinatura = formularioDeAutorizacao.signatures!.first! as ORKConsentSignature
        let revisaoDeAutorizacao = ORKConsentReviewStep(identifier: "RevisaoDeAutorizacao", signature: assinatura, inDocument: formularioDeAutorizacao)
        
        revisaoDeAutorizacao.text = "Review"
        revisaoDeAutorizacao.reasonForConsent = "Do you agree with this permission?"
        
        steps += [revisaoDeAutorizacao]
        
        let passcodeStep = ORKPasscodeStep(identifier: "Passcode")
        passcodeStep.text = "Now you will create a passcode to identify yourself to the app and protect access to information you've entered."
        steps += [passcodeStep]
        
        let completionStep = ORKCompletionStep(identifier: "CompletionStep")
        completionStep.title = "Welcome aboard."
        completionStep.text = "Thank you for joining this study."
        steps += [completionStep]
        
        return ORKOrderedTask(identifier: "TarefasDeAutorizacao", steps: steps)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        taskViewController = ORKTaskViewController(task: TarefasDeAutorizacao, taskRunUUID: nil)
        taskViewController!.delegate = self
        presentViewController(taskViewController!, animated: true, completion: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        if ORKPasscodeViewController.isPasscodeStoredInKeychain() {
            dismissViewControllerAnimated(false, completion: nil)
        }else{
            super.viewDidAppear(animated)
            let taskViewController = ORKTaskViewController(task: TarefasDeAutorizacao, taskRunUUID: nil)
            taskViewController.delegate = self
            presentViewController(taskViewController, animated: true, completion: nil)
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
    
}

extension AutenticacaoViewController: ORKTaskViewControllerDelegate {
    
    func taskViewController(taskViewController: ORKTaskViewController, didFinishWithReason reason: ORKTaskViewControllerFinishReason, error: NSError?) {
        
        print()
        
        taskViewController.dismissViewControllerAnimated(true, completion: nil)
        
        
    }
    
}
