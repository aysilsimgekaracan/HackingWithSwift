//
//  ViewController.swift
//  Project13
//
//  Created by Ayşıl Simge Karacan on 26.08.2020.
//  Copyright © 2020 Ayşıl Simge Karacan. All rights reserved.
//

import UIKit
import CoreImage

class ViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var intensity: UISlider!
    @IBOutlet var centerSlider: UISlider!
    @IBOutlet var scaleSlider: UISlider!
    @IBOutlet var radiusSlider: UISlider!
    
    @IBOutlet var intensityLabel: UILabel!
    @IBOutlet var radiusLabel: UILabel!
    @IBOutlet var scaleLabel: UILabel!
    @IBOutlet var centerLabel: UILabel!
    
    @IBOutlet var changeFilterButton: UIButton!
    var currentImage: UIImage!
    
    var context: CIContext! // An evaluation context for rendering image processing results and performing image analysis.
    var currentFilter: CIFilter! // An image processor that produces an image by manipulating one or more input images or by generating new image data.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "InstaFilter - YACIFP"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(importPicture))
        
        context = CIContext()
        currentFilter = CIFilter(name: "CISepiaTone")
        
        intensityLabel.text = "Intensity"
        radiusLabel.text = "Radius"
        scaleLabel.text = "Scale"
        centerLabel.text = "Center"
        
        imageView.alpha = 0
    }
    
    @objc func importPicture() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        dismiss(animated: true, completion: nil)
        
        UIView.animate(withDuration: 1) {
            self.imageView.alpha = 1
        }
        
        currentImage = image
        
        // You use CIImage objects in conjunction with other Core Image classes—such as CIFilter, CIContext, CIVector, and CIColor—to take advantage of the built-in Core Image filters when processing images.
        let beginImage = CIImage(image: currentImage)
        
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey) // kCIInputImageKey -> A key for the CIImage object to use as an input image.
        applyProcessing()
    }

    @IBAction func changeFilter(_ sender: UIButton) {
        let ac = UIAlertController(title: "Choose filter", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "CIBumpDistortion", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIGaussianBlur", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIPixellate", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CISepiaTone", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CITwirlDistortion", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIUnsharpMask", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIVignette", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        if let popoverController = ac.popoverPresentationController {
            popoverController.sourceView = sender
            popoverController.sourceRect = sender.bounds
        }
        
        present(ac, animated: true)
    }
    
    func setFilter(action: UIAlertAction) {
        guard currentImage != nil else { return }
        guard let actionTitle = action.title else { return }
        changeFilterButton.setTitle("\(actionTitle)", for: .normal)
        
        currentFilter = CIFilter(name: actionTitle)
        
        let beginImage = CIImage(image: currentImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        
        applyProcessing()
    }
    
    @IBAction func save(_ sender: Any) {
        guard let image = imageView.image else {
            let ac = UIAlertController(title: "Error", message: "No image uploaded", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            present(ac, animated: true)
            return
        }
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
//    @IBAction func intensityChanged(_ sender: Any) {
//        applyProcessing()
//    }
    
    @IBAction func sliderChanged(_ sender: Any) {
        applyProcessing()
    }
    
    
    func applyProcessing() {
        let inputKeys = currentFilter.inputKeys // inputKeys -> The names of all input parameters to the filter.
        
        if inputKeys.contains(kCIInputIntensityKey) {
            intensity.isEnabled = true
            intensityLabel.isEnabled = true
            currentFilter.setValue(intensity.value, forKey: kCIInputIntensityKey)
            intensityLabel.text = "Intensity"
        } else {
            intensity.isEnabled = false
            intensityLabel.isEnabled = false
        }
        
        if inputKeys.contains(kCIInputRadiusKey) {
            radiusSlider.isEnabled = true
            radiusLabel.isEnabled = true
            currentFilter.setValue(radiusSlider.value * 200, forKey: kCIInputRadiusKey)
        } else {
            radiusLabel.isEnabled = false
            radiusSlider.isEnabled = false
        }
        
        if inputKeys.contains(kCIInputScaleKey) {
            scaleLabel.isEnabled = true
            scaleSlider.isEnabled = true
            currentFilter.setValue(scaleSlider.value * 10, forKey: kCIInputScaleKey)
        } else {
            scaleLabel.isEnabled = false
            scaleSlider.isEnabled = false
        }
        
        if inputKeys.contains(kCIInputCenterKey) {
            centerSlider.isEnabled = true
            centerLabel.isEnabled = true
            currentFilter.setValue(CIVector(x: currentImage.size.width / 2, y: currentImage.size.height / 2), forKey: kCIInputCenterKey)
        } else {
            centerLabel.isEnabled = false
            centerSlider.isEnabled = false
        }
        
        guard let outputImage = currentFilter.outputImage else { return }
        //currentFilter.setValue(intensity.value, forKey: kCIInputIntensityKey)
        
        // CIImage -> CGImage -> UIImage
        if let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
            let processedImage = UIImage(cgImage: cgImage)
            imageView.image = processedImage
        }
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "You altered image has been saved to your library", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
    
}

