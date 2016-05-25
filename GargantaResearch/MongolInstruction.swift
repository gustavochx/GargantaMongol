//
//  MongolInstruction.swift
//  GargantaResearch
//
//  Created by Yago Teixeira on 24/05/16.
//  Copyright © 2016 Gustavo Henrique. All rights reserved.
//

import ResearchKit
import AVFoundation

class MongolInstruction: NSObject {
    static func gargantaTeste() -> ORKOrderedTask {
        
        let defaultRecordingSettings:[String:AnyObject] = [ AVFormatIDKey : NSNumber(unsignedInt: kAudioFormatAppleLossless),
                                                            AVNumberOfChannelsKey : NSNumber(int:2),
                                                            AVSampleRateKey: NSNumber(double:44100.0) ]
        let recordingSettings = defaultRecordingSettings
        
        
        
        var steps = [ORKStep]()
        
        
        let audioPresenterStep = AudioInstrucao(identifier: ORKInstruction0StepIdentifier)
        audioPresenterStep.title = "Ouça esse audio!"
        audioPresenterStep.text = "Ouça esse audio e tente reproduzir a nas proximas instruções."
        do{
            let path = NSBundle.mainBundle().URLForResource("ezenggileer", withExtension: "mp3")
            let audio = try AVAudioPlayer(contentsOfURL: path!)
            
            audioPresenterStep.audio = audio
        }catch{
            print(error)
        }
        audioPresenterStep.image = UIImage(named: "Ayan_sings.gif", inBundle: NSBundle.mainBundle(), compatibleWithTraitCollection: nil)
        
        steps.append(audioPresenterStep)
        
        
        let countDownStep = ORKCountdownStep(identifier: ORKCountdownStepIdentifier)
        countDownStep.stepDuration = 5.0;
        countDownStep.recorderConfigurations = [ORKAudioRecorderConfiguration(identifier: ORKAudioRecorderIdentifier,recorderSettings: recordingSettings)]
        
        steps.append(countDownStep)
        
        
        
        let listenerStep = ORKAudioStep(identifier: ORKAudioStepIdentifier)
        listenerStep.title =  "aaaaaaaaaaaa"
        listenerStep.recorderConfigurations = [ORKAudioRecorderConfiguration(identifier: ORKAudioRecorderIdentifier,recorderSettings: recordingSettings)]
        listenerStep.stepDuration = 10;
        listenerStep.shouldContinueOnFinish = true;
        
        steps.append(listenerStep)
        
        
        let task = ORKOrderedTask(identifier: "mongolTest",steps: steps)
        
        return task
    }
}

class AudioInstrucaoViewController: ORKInstructionStepViewController {
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if let instrucao = step as? AudioInstrucao{
            instrucao.audio?.stop()
            instrucao.audio?.prepareToPlay()
            instrucao.audio?.play()
        }
    }
}

class AudioInstrucao: ORKInstructionStep {
    var audio:AVAudioPlayer?
    
    static func stepViewControllerClass() -> AnyClass{
        return AudioInstrucaoViewController.self
    }
}
