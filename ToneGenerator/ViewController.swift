//
//  ViewController.swift
//  ToneGenerator
//
//  Created by OOPer in cooperation with shlab.jp, on 2015/3/22.
//  See LICENSE.txt .
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var label: UILabel!
    var engine: AVAudioEngine!
    var tone: AVTonePlayerUnit!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tone = AVTonePlayerUnit()
        label.text = String(format: "%.1f", tone.frequency)
        slider.minimumValue = -5.0
        slider.maximumValue = 5.0
        slider.value = 0.0
        let format = AVAudioFormat(standardFormatWithSampleRate: tone.sampleRate, channels: 1)
        print(format?.sampleRate ?? "format nil")
        engine = AVAudioEngine()
        engine.attach(tone)
        let mixer = engine.mainMixerNode
        engine.connect(tone, to: mixer, format: format)
        do {
            try engine.start()
        } catch let error as NSError {
            print(error)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sliderChanged(_ sender: UISlider) {
        let freq = 440.0 * pow(2.0, Double(slider.value))
        tone.frequency = freq
        label.text = String(format: "%.1f", freq)
    }
    
    @IBAction func togglePlay(_ sender: UIButton) {
        if tone.isPlaying {
            engine.mainMixerNode.volume = 0.0
            tone.stop()
            engine.reset()
            sender.setTitle("Start", for: UIControlState())
        } else {
            tone.preparePlaying()
            tone.play()
            engine.mainMixerNode.volume = 1.0
            sender.setTitle("Stop", for: UIControlState())
        }
    }
}

