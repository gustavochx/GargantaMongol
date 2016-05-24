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
    
    // Arrays de títulos e sumários
    var arraySummary = ["Seja bem-vindo a pesquisa de câncer de garganta.","Este aplicativo capta dados para efetuar nossa pesquisa.","Todos os dados aqui fornecidos serão particulares, não iremos identificar pessoas.","Nós iremos utilizar dos dados aqui fornecidos para obter resultados sobre a pesquisa.","","","Utilizaremos de procedimentos para nossa pesquisa.","Caso queira se retirar da pesquisa, fique à vontade.",""]
    //var arrayReasons = ["Motivo","Motivo1","Motivo2","Motivo3","Motivo4","Motivo5"]
    
    // Microfone
    internal var MicrophoneTask: ORKOrderedTask {
         return ORKOrderedTask.audioTaskWithIdentifier("AudioTask", intendedUseDescription: "A sentence prompt will be given to you to read.", speechInstruction: "These are the last dying words of Joseph of Aramathea", shortSpeechInstruction: "The Holy Grail can be found in the Castle of Aaaaaaaaaaah", duration: 10, recordingSettings: nil, options: ORKPredefinedTaskOption.None)    }
    
    
    // MARK: formulátio já elaborado para autorização
    internal var FormularioDeAutorizacao: ORKConsentDocument {
        
        let FormularioDeAutorizacao = ORKConsentDocument()
        FormularioDeAutorizacao.title = "Autorização para pesquisa do Câncer de "
        
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
    
    
    // MARK: Tarefas de autorização para formulário
    internal var TarefasDeAutorizacao: ORKOrderedTask {
        
        var steps = [ORKStep]()
        
        let formularioDeAutorizacao = FormularioDeAutorizacao
        let autorizacaoVisual = ORKVisualConsentStep(identifier: "AutorizacaoVisual", document: formularioDeAutorizacao)
        
        steps += [autorizacaoVisual]
        
        let assinatura = formularioDeAutorizacao.signatures!.first! as ORKConsentSignature
        let revisaoDeAutorizacao = ORKConsentReviewStep(identifier: "RevisaoDeAutorizacao", signature: assinatura, inDocument: formularioDeAutorizacao)
        
        revisaoDeAutorizacao.text = "Revisão"
        revisaoDeAutorizacao.reasonForConsent = "Após revisar o formulário, você aceita prosseguir com a Pesquisa?"
        
        steps += [revisaoDeAutorizacao]
        
        return ORKOrderedTask(identifier: "TarefasDeAutorizacao", steps: steps)
    }
    
    // MARK: Tarefas de pesquisa para formulário
    
    
    internal var TarefasDePesquisa: ORKOrderedTask{
        var steps = [ORKStep]()
        
        let instrucao = ORKInstructionStep(identifier: "instrucao")
        instrucao.title = "Câncer de Garganta"
        instrucao.text = "Responda as questões para contribuir com nossa pesquisa."
        steps += [instrucao]
        
        let tituloDaQuestao = "Quais destes sintomas você tem sentido?"
        let opcoes = [
            ORKTextChoice(text:"Roquidão", detailText: "Que não se resolve no período de 1 à 2 semanas.", value: 0, exclusive: false),
            ORKTextChoice(text:"Dor de garganta.", detailText:"Que não se resolve no período de 1 à 2 semanas, mesmo com medicamentos.", value:1,exclusive: false),
            ORKTextChoice(text:"Dificuldade de deglutição.",value:2),
            ORKTextChoice(text:"Inchaço no pescoço", value: 3),
            ORKTextChoice(text:"Perda de peso", detailText: "Não intencional.", value:4,exclusive: false),
            ORKTextChoice(text:"Tosse",detailText: "Inexplicável.",value: 5,exclusive: false),
            ORKTextChoice(text:"Tosse",detailText: "Com sangue.", value: 6, exclusive: false),
            ORKTextChoice(text:"Sons respiratórios.", detailText: "Anormais(agudos)", value: 7, exclusive: false)
        ]
        
        let formatoDaResposta:ORKTextChoiceAnswerFormat = ORKTextChoiceAnswerFormat.choiceAnswerFormatWithStyle(.SingleChoice, textChoices: opcoes)
        let perguntaProblemaDoUsuario = ORKQuestionStep(identifier: "perguntaProblemaDoUsuario", title: tituloDaQuestao, answer: formatoDaResposta)
        
        steps += [perguntaProblemaDoUsuario]
        
        let summaryStep = ORKCompletionStep(identifier: "SummaryStep")
        summaryStep.title = "Right. Off you go!"
        summaryStep.text = "That was easy!"
        steps += [summaryStep]
        
        return ORKOrderedTask(identifier: "TarefasDePesquisa", steps: steps)
        
    }
    
    
    // MARK: Começa a pesquisa com o usuário
    @IBAction func startResearch(sender: AnyObject) {
    
        let taskViewController = ORKTaskViewController(task: TarefasDePesquisa, taskRunUUID: nil)
        taskViewController.delegate = self
        presentViewController(taskViewController, animated: true, completion: nil)
    
    
    }
    
    // MARK: Pega autorização do usuário
    @IBAction func getAuthorization(sender: AnyObject) {
    
        
        let taskViewController = ORKTaskViewController(task: TarefasDeAutorizacao, taskRunUUID: nil)
        taskViewController.delegate = self
        presentViewController(taskViewController, animated: true, completion: nil)
        
    
    }
    
    // MARK: Aciona a funcionalidade de microfone para gravação
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

