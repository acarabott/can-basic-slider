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
  @IBOutlet weak var number: UILabel!

  override func viewDidLoad() {
    super.viewDidLoad()
    min.delegate = self;
    max.delegate = self;
    min.text = String(slider.minimumValue);
    max.text = String(slider.maximumValue);
    number.text = String(slider.value);
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
  }

  // MARK: Actions

  @IBAction func sliderAction(_ sender: UISlider, forEvent event: UIEvent) {
    // adjust precision based on size of range
    let range = slider.maximumValue - slider.minimumValue;
    let step = pow(10.0, floor(log10(range))) / 100.0;
    let remainder = sender.value.truncatingRemainder(dividingBy: step);
    let rounded = sender.value - remainder;

    number.text = String(rounded);

    if min.isFirstResponder {
      min.resignFirstResponder();
    }
    if max.isFirstResponder {
      max.resignFirstResponder();
    }
  }

  @IBAction func minAction(_ sender: UITextField) {
    slider.minimumValue = Float(sender.text!) ?? 0;
  }

  @IBAction func maxAction(_ sender: UITextField) {
    slider.maximumValue = Float(sender.text!) ?? 1.0;
  }

}
