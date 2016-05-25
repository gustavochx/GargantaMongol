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
    
    public var FormularioDeAutorizacao: ORKConsentDocument {
        
        let FormularioDeAutorizacao = ORKConsentDocument()
        FormularioDeAutorizacao.title = "Exemplo de Autorização"
        
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
            sessaoDeAutorizacao.summary = "Resumo..."
            sessaoDeAutorizacao.content = "Conteudo..."
            
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
        
        revisaoDeAutorizacao.text = "Revisão de Autorização!"
        revisaoDeAutorizacao.reasonForConsent = "Motivo..."
        
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
        let taskViewController = ORKTaskViewController(task: TarefasDeAutorizacao, taskRunUUID: nil)
        taskViewController.delegate = self
        presentViewController(taskViewController, animated: true, completion: nil)

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
