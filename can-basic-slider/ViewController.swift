//
//  ViewController.swift
//  can-basic-slider
//
//  Created by Arthur Carabott on 28/02/2017.
//  Copyright © 2017 Arthur Carabott. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

  // MARK: Properties
  @IBOutlet weak var slider: UISlider!
  @IBOutlet weak var min: UITextField!
  @IBOutlet weak var max: UITextField!

  override func viewDidLoad() {
    super.viewDidLoad()
    min.delegate = self;
    max.delegate = self;
    min.text = "0.0";
    max.text = "1.0";
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  // MARK: UITextFieldDelegate

  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    // hide the keyboard
    textField.resignFirstResponder();
    return true;
  }

  func textFieldDidEndEditing(_ textField: UITextField) {
    print("did end editing!");
  }

  // MARK: Actions

  @IBAction func sliderAction(_ sender: UISlider, forEvent event: UIEvent) {
    print(sender.value);
    min.resignFirstResponder();
    max.resignFirstResponder();
  }

  @IBAction func minAction(_ sender: UITextField) {
    slider.minimumValue = Float(sender.text!) ?? 0;
  }

  @IBAction func maxAction(_ sender: UITextField) {
    slider.maximumValue = Float(sender.text!) ?? 1.0;
  }

  @IBAction func minChanged(_ sender: UITextField) {
    print("min changed");
  }


}

