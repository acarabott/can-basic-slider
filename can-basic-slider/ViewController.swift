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
    min.text = String(slider.minimumValue);

    max.delegate = self;
    max.text = String(slider.maximumValue);

    setValue(value: slider.value, step: getStep());
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

  func textFieldDidEndEditing(_ textField: UITextField) {}

  // MARK: helpers

  func getStep() -> Float {
    let range = slider.maximumValue - slider.minimumValue;
    return pow(10.0, floor(log10(range))) / 100.0;
  }

  func getFormat(step: Float) -> String {
    // if step is 0.0 log10(step) will be NaN
    if step >= 1.0 || step == 0.0 {
      return "%.0f";
    }
    let places = Int(abs(log10(step)));
    return "%.\(places)f";
  }

  func setValue(value: Float, step: Float = 0.1) {
    number.text = String(format: getFormat(step: step), value);
  }

  // MARK: Actions

  @IBAction func sliderAction(_ sender: UISlider, forEvent event: UIEvent) {
    // adjust precision based on size of range
    let step = getStep();
    let remainder = sender.value.truncatingRemainder(dividingBy: step);
    let rounded = sender.value - remainder;
    setValue(value: rounded, step: step);

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
