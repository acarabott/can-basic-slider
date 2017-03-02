//
//  ViewController.swift
//  can-basic-slider
//
//  Created by Arthur Carabott on 28/02/2017.
//  Copyright © 2017 Arthur Carabott. All rights reserved.
//

import UIKit
import OSCKit

class ViewController: UIViewController, UITextFieldDelegate {

  // MARK: Properties
  @IBOutlet weak var slider: UISlider!
  @IBOutlet weak var min: UITextField!
  @IBOutlet weak var max: UITextField!
  @IBOutlet weak var number: UILabel!
  @IBOutlet weak var oscAddressField: UITextField!
  @IBOutlet weak var oscPortField: UITextField!
  @IBOutlet weak var sliderWrap: UIView!

  var sideBySide = false;
  var minMaxHidden = false;
  var focusedTextField: UITextField?;

  var sliderWrapFrameSBS: CGRect!;
  var sliderWrapFrameNorm: CGRect!;
  var numberFrameSBS: CGRect!;
  var numberFrameNorm: CGRect!;;

  let oscClient = OSCClient.init();
  var oscPort = 6666;
  var oscAddr = "192.168.0.6";

  override func viewDidLoad() {
    super.viewDidLoad()
    min.delegate = self;
    min.text = String(slider.minimumValue);
    min.isHidden = minMaxHidden;

    max.delegate = self;
    max.text = String(slider.maximumValue);
    max.isHidden = minMaxHidden;

    setValue(value: slider.value, step: getStep());

    numberFrameNorm = number.frame;
    numberFrameSBS = number.frame;
    numberFrameSBS.size.width = view.frame.width / 2.0;
    numberFrameSBS.origin.x = view.frame.width / 2.0;

    sliderWrapFrameNorm = sliderWrap.frame;
    sliderWrapFrameSBS = sliderWrap.frame;
    sliderWrapFrameSBS.size.width = view.frame.width / 2.0;
    // fudging it!
    sliderWrapFrameSBS.origin.y = numberFrameSBS.origin.y +
                                  numberFrameSBS.size.height * 0.3;

    oscAddressField.delegate = self;
    oscPortField.delegate = self;

    let notificationCenter = NotificationCenter.default;
    notificationCenter.addObserver(self,
                                   selector: #selector(keyboardWillShow),
                                   name: .UIKeyboardWillShow,
                                   object: nil);
    notificationCenter.addObserver(self,
                                   selector: #selector(keyboardWillHide),
                                   name: .UIKeyboardWillHide,
                                   object: nil);

    oscAddr = oscAddressField.text!;
    oscPort = Int(oscPortField.text!)!;
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  // MARK: keyboard
  func keyboardWillShow(notification: Notification) {
    if let keyboardRect = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
      self.view.frame.origin.y = -keyboardRect.size.height;
//      // only move the view up if the keyboard would cover the textfield
//      let absFrame = focusedTextField!.convert(focusedTextField!.frame, to: self.view);
//      let absCorner = CGPoint(x: absFrame.origin.x + absFrame.size.width,
//                              y: absFrame.origin.y + absFrame.size.height);
//
//      let absKeyboardRect = focusedTextField!.convert(keyboardRect, from: self.view);
//
//      print("absFrame.origin", absFrame.origin);
//      print("absCorner", absCorner);
//      print("keyboardRect", keyboardRect);
//      print("absKeyboardRect", absKeyboardRect);
//
//      if absKeyboardRect.contains(absFrame.origin) {
//        print("abs origin");
//      }
//      if absKeyboardRect.contains(absCorner) {
//        print("abs corner");
//      }
//      if [absFrame.origin, absCorner].contains(where: { absKeyboardRect.contains($0); }) {
//        self.view.frame.origin.y = -absKeyboardRect.size.height;
//      }
    }
  }

  func keyboardWillHide(notification: Notification) {
    self.view.frame.origin.y = 0;
  }

  // MARK: UITextFieldDelegate

  func textFieldDidBeginEditing(_ textField: UITextField) {
    focusedTextField = textField;
  }

  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    // hide the keyboard
    textField.resignFirstResponder();
    return true;
  }

  func textFieldDidEndEditing(_ textField: UITextField) {
    focusedTextField = nil;
  }

  // MARK: helpers

  func getStepForRounding() -> Float {
    let range = slider.maximumValue - slider.minimumValue;

    if range >= 100.0 {
      return 100.0;
    }

    return pow(10.0, floor(log10(range)));
  }

  func getStep() -> Float {
    return getStepForRounding() / 100.0;
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
    let err = "min > max";
    number.text = value.isNaN ? err : String(format: getFormat(step: step), value);

    if !value.isNaN {
      oscClient.send(OSCMessage.init(address: "/set", arguments: [value]), to: getOscDst())
    }
  }

  func resignFirstResponders() {
    for item in [min, max, oscAddressField, oscPortField] {
      if (item?.isFirstResponder)! {
        item?.resignFirstResponder();
      }
    }
  }

  func getOscDst() -> String {
    return "udp://\(oscAddr):\(oscPort)";
  }


  // MARK: Actions

  @IBAction func sliderAction(_ sender: UISlider, forEvent event: UIEvent) {
    // adjust precision based on size of range
    let value = sender.value * 100.0;
    let step = getStepForRounding();
    let remainder = value.truncatingRemainder(dividingBy: step);
    let rounded = (value - remainder) / 100.0;
    setValue(value: rounded, step: getStep());

    resignFirstResponders();
  }

  @IBAction func minAction(_ sender: UITextField) {
    slider.minimumValue = Float(sender.text!) ?? 0;
  }

  @IBAction func maxAction(_ sender: UITextField) {
    slider.maximumValue = Float(sender.text!) ?? 1.0;
  }

  @IBAction func oscAddrEnd(_ sender: UITextField) {
    oscAddr = sender.text ?? "192.168.0.6";
  }

  @IBAction func oscPortEnd(_ sender: UITextField) {
    oscPort = Int(sender.text!) ?? 6666;
  }

  // MARK: Tap Gesture Recognizers

  @IBAction func doubleTap(_ sender: UITapGestureRecognizer) {
    print("double tap");
    minMaxHidden = !minMaxHidden;
    min.isHidden = minMaxHidden;
    max.isHidden = minMaxHidden;
    if minMaxHidden {
      slider.frame.size.width = sliderWrap.frame.width - view.layoutMargins.left;
      slider.frame.origin.x = sliderWrap.frame.origin.x + sliderWrap.layoutMargins.left;
    }
    else {
      let width = sliderWrap.frame.width -
        sliderWrap.layoutMargins.left -
        sliderWrap.layoutMargins.right -
        min.frame.width -
        max.frame.width;

      slider.frame.size.width = width;
      slider.frame.origin.x = min.frame.origin.x + min.frame.size.width;
    }
  }

  @IBAction func singleTap(_ sender: Any) {
    resignFirstResponders();
  }

  override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
    if motion == .motionShake {
      sideBySide = !sideBySide;

      sliderWrap.frame = sideBySide ? sliderWrapFrameSBS : sliderWrapFrameNorm;
      number.frame = sideBySide ? numberFrameSBS : numberFrameNorm;
    }
  }
}
