//
//  ViewController.swift
//  can-basic-slider
//
//  Created by Arthur Carabott on 28/02/2017.
//  Copyright © 2017 Arthur Carabott. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  // MARK: Properties
  @IBOutlet weak var slider: UISlider!
  @IBOutlet weak var min: UITextField!
  @IBOutlet weak var max: UITextField!

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  // MARK: Actions

  @IBAction func sliderAction(_ sender: UISlider, forEvent event: UIEvent) {
    print(sender.value);
  }

  @IBAction func minAction(_ sender: UITextField) {
    slider.minimumValue = Float(sender.text!) ?? 0;
  }

  @IBAction func maxAction(_ sender: UITextField) {
    slider.maximumValue = Float(sender.text!) ?? 1.0;
  }

}

