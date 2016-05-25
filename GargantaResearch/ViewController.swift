//
//  ViewController.swift
//  GargantaResearch
//
//  Created by Gustavo Henrique on 24/05/16.
//  Copyright © 2016 Gustavo Henrique. All rights reserved.
//

import UIKit
import ResearchKit
import CloudKit

class ViewController: UIViewController {
    
    // Arrays de títulos e sumários
    var arraySummary = ["Welcome to the throat cancer research.","This app collect data to perform our research.","All data collected by this app is private, no one will be identified.","The collected data will be used to obtain the results of this research.","","","We will be using secure procedures in this research.","In the case you want to give up this research, feel free.",""]
    //var arrayReasons = ["Motivo","Motivo1","Motivo2","Motivo3","Motivo4","Motivo5"]
    
    // Microfone
    internal var MicrophoneTask: ORKOrderedTask {
        return ORKOrderedTask.audioTaskWithIdentifier("AudioTask", intendedUseDescription: "A sentence prompt will be given to you to read.", speechInstruction: "These are the last dying words of Joseph of Aramathea", shortSpeechInstruction: "The Holy Grail can be found in the Castle of Aaaaaaaaaaah", duration: 10, recordingSettings: nil, options: ORKPredefinedTaskOption.None)    }
    
    
    // MARK: formulátio já elaborado para autorização
    internal var FormularioDeAutorizacao: ORKConsentDocument {
        
        let FormularioDeAutorizacao = ORKConsentDocument()
        FormularioDeAutorizacao.title = "Permission to perform this research about Throat Cancer"
        
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
        
        revisaoDeAutorizacao.text = "Review"
        revisaoDeAutorizacao.reasonForConsent = "After reviewing this form, do you agree to go on with this research?"
        
        steps += [revisaoDeAutorizacao]
        
        return ORKOrderedTask(identifier: "TarefasDeAutorizacao", steps: steps)
    }
    
    // MARK: Tarefas de pesquisa para formulário
    
    
    internal var TarefasDePesquisa: ORKOrderedTask{
        var steps = [ORKStep]()
        
        let instrucao = ORKInstructionStep(identifier: "instrucao")
        instrucao.title = "Throat Cancer"
        instrucao.text = "Answer the following questions to contribute with this research."
        steps += [instrucao]
        
        let tituloDaQuestao = "Wich of the following symptoms are you felling?"
        let opcoes = [
            ORKTextChoice(text:"Hoarseness", detailText: "Wich does not ends in a period of 1 to 2 weeks.", value: 0, exclusive: false),
            ORKTextChoice(text:"Sore Throat", detailText:"Wich does not ends in a period of 1 to 2 weeks, even though I am still using the medicine.", value:1,exclusive: false),
            ORKTextChoice(text:"Swallow Difficulties.",value:2),
            ORKTextChoice(text:"Swelling in the Neck", value: 3),
            ORKTextChoice(text:"Lost of Wheight", detailText: "Not intentional.", value:4,exclusive: false),
            ORKTextChoice(text:"Coughing",detailText: "Enexplicable.",value: 5,exclusive: false),
            ORKTextChoice(text:"Coughing",detailText: "With blood.", value: 6, exclusive: false),
            ORKTextChoice(text:"Breath sounds.", detailText: "Uncommon(acute)", value: 7, exclusive: false)
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
    
    
    
    func gravaDados(resultado: NSData){
        
        let container = CKContainer.defaultContainer()
        let publicDb = container.publicCloudDatabase
        
        
        let ckResearch = CKRecord(recordType: "Research")
        ckResearch.setObject(resultado, forKey: "resultado")
        
        publicDb.saveRecord(ckResearch, completionHandler: { (record,error) in
            
            if error != nil {
                print(error?.localizedDescription)
            }else{
                print("Salvo!")
            }
        })
    }
    
    
    
}

extension ViewController: ORKTaskViewControllerDelegate {
    
    func taskViewController(taskViewController: ORKTaskViewController, didFinishWithReason reason: ORKTaskViewControllerFinishReason, error: NSError?) {
        
        taskViewController.dismissViewControllerAnimated(true, completion: nil)
        
        if let result = taskViewController.result.resultForIdentifier("perguntaProblemaDoUsuario") {
            let data = NSKeyedArchiver.archivedDataWithRootObject(result)
            gravaDados(data)
        }
    }
    
    func taskViewController(taskViewController: ORKTaskViewController, recorder: ORKRecorder, didFailWithError error: NSError) {
        
        print(error.description)
        
    }
    
    
    
}

