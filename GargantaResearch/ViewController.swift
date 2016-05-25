//
//  ViewController.swift
//  GargantaResearch
//
//  Created by Gustavo Henrique on 24/05/16.
//  Copyright © 2016 Gustavo Henrique. All rights reserved.
//

import UIKit
import ResearchKit
import LocalAuthentication

class ViewController: UITableViewController {
     let titulos = ["Pesquisa","Audio"]
    
    
    
    var contentHidden = false {
        didSet {
            guard contentHidden != oldValue && isViewLoaded() else { return }
            childViewControllers.first?.view.hidden = contentHidden
        }
    }
    
    public var MicrophoneTask: ORKOrderedTask {
         return MongolInstruction.gargantaTeste()
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
    
    func startResearch() {
    
        let taskViewController = ORKTaskViewController(task: TarefasDePesquisa, taskRunUUID: nil)
        taskViewController.delegate = self
        presentViewController(taskViewController, animated: true, completion: nil)
    
    
    }

    
    
    func microphoneTapped() {
    
        let taskViewController = ORKTaskViewController(task: MicrophoneTask, taskRunUUID: nil)
        taskViewController.delegate = self
        taskViewController.outputDirectory = NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] , isDirectory: true)
        presentViewController(taskViewController, animated: true, completion: nil)
    
    
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.contentInset = UIEdgeInsetsMake(20.0, 0.0, 0.0, 0.0)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

    }
 
}

extension ViewController: ORKTaskViewControllerDelegate {
    
    func taskViewController(taskViewController: ORKTaskViewController, didFinishWithReason reason: ORKTaskViewControllerFinishReason, error: NSError?) {
        
        print()
        
        taskViewController.dismissViewControllerAnimated(true, completion: nil)
        
        
    }
    
}

extension ViewController{
    
   
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! MyTableViewCell
        
        cell.title.text = titulos[indexPath.row]
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.row {
        case 0:
            startResearch()
            break
        case 1:
            microphoneTapped()
            break
        default:
            
            break
        }
    }
}

