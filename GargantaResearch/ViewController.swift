//
//  ViewController.swift
//  GargantaResearch
//
//  Created by Gustavo Henrique on 24/05/16.
//  Copyright © 2016 Gustavo Henrique. All rights reserved.
//

import UIKit
import ResearchKit

class ViewController: UIViewController {
    
    
    public var MicrophoneTask: ORKOrderedTask {
         return ORKOrderedTask.audioTaskWithIdentifier("AudioTask", intendedUseDescription: "A sentence prompt will be given to you to read.", speechInstruction: "These are the last dying words of Joseph of Aramathea", shortSpeechInstruction: "The Holy Grail can be found in the Castle of Aaaaaaaaaaah", duration: 10, recordingSettings: nil, options: ORKPredefinedTaskOption.None)    }
    
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
        
        return ORKOrderedTask(identifier: "TarefasDeAutorizacao", steps: steps)
    }
    
    
    public var TarefasDePesquisa: ORKOrderedTask{
        
        
        var steps = [ORKStep]()
        
        let instrucao = ORKInstructionStep(identifier: "instrucao")
        instrucao.title = "Titulo da pesquisa"
        instrucao.text = "Instruções da pesquisa."
        
        steps += [instrucao]
        
        let tituloDaQuestao = "O que voce esta sentindo?"
        let opcoes = [ORKTextChoice(text:"BABABA", value:0),ORKTextChoice(text:"DUDUDU", value:1), ORKTextChoice(text:"DEDEDE",value:2)]
        
        let formatoDaResposta:ORKTextChoiceAnswerFormat = ORKTextChoiceAnswerFormat.choiceAnswerFormatWithStyle(.SingleChoice, textChoices: opcoes)
        let perguntaProblemaDoUsuario = ORKQuestionStep(identifier: "perguntaProblemaDoUsuario", title: tituloDaQuestao, answer: formatoDaResposta)
        
        steps += [perguntaProblemaDoUsuario]
        
        let summaryStep = ORKCompletionStep(identifier: "SummaryStep")
        summaryStep.title = "Right. Off you go!"
        summaryStep.text = "That was easy!"
        steps += [summaryStep]
        
        return ORKOrderedTask(identifier: "TarefasDePesquisa", steps: steps)
        
    }
    
    @IBAction func startResearch(sender: AnyObject) {
    
        let taskViewController = ORKTaskViewController(task: TarefasDePesquisa, taskRunUUID: nil)
        taskViewController.delegate = self
        presentViewController(taskViewController, animated: true, completion: nil)
    
    
    }
    
    @IBAction func getAuthorization(sender: AnyObject) {
    
        
        let taskViewController = ORKTaskViewController(task: TarefasDeAutorizacao, taskRunUUID: nil)
        taskViewController.delegate = self
        presentViewController(taskViewController, animated: true, completion: nil)
        
    
    }
    
    
    @IBAction func microphoneTapped(sender: AnyObject) {
    
        let taskViewController = ORKTaskViewController(task: MicrophoneTask, taskRunUUID: nil)
        taskViewController.delegate = self
        taskViewController.outputDirectory = NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] , isDirectory: true)
        presentViewController(taskViewController, animated: true, completion: nil)
    
    
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ViewController: ORKTaskViewControllerDelegate {
    
    func taskViewController(taskViewController: ORKTaskViewController, didFinishWithReason reason: ORKTaskViewControllerFinishReason, error: NSError?) {
        
        print()
        
        taskViewController.dismissViewControllerAnimated(true, completion: nil)
        
        
    }
    
}

