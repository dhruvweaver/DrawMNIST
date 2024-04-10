//
//  ViewController.swift
//  DrawMNIST
//
//  Created by Dhruv Weaver on 4/6/24.
//

import UIKit
import CoreML
import UIKit
import PencilKit

class HomeVC: UIViewController {
    var model: MNIST? = nil
    
    let predictionText = UILabel()
    var canvas: PKCanvasView = PKCanvasView()
    let clearDrawingButton = UIButton()
    let testButton = UIButton()
    
    override func viewDidLoad() {
        // load model
        do {
            model = try MNIST()
            print("Loaded ML model")
        } catch {
            print("Failed to load ML Model")
        }
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.backgroundColor = .systemBackground
        title = "MNIST Draw"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // build UI
        configureUI()
    }
    
    func performInference(on image: UIImage) -> (Int64, [Int64 : Double])? {
        guard let resized = resize(image: image, to: CGSize(width: 28, height: 28)) else {
            print("Could not resize image")
            return nil
        }
        guard let buffer = toPixelBuffer(image: resized) else {
            print("Could not convert to image buffer")
            return nil
        }
        
        do {
            if let result = try model?.prediction(Input: buffer) {
                return (result.Prediction, result.Prediction_probs)
            } else {
                print("Prediciton results not as expected")
                return nil
            }
            
        } catch {
            print("Coult not make prediction")
            return nil
        }
    }
    
    @objc func clearButtonHandler() {
        canvas.drawing = PKDrawing()
        predictionText.text = "Prediction: None yet"
    }
    
    @objc func testButtonHandler() {
        if canvas.drawing.bounds.isEmpty {
            print("No drawing detected")
            return
        }
        
        //*** Saving Image ***
        let renderer = UIGraphicsImageRenderer(bounds: canvas.bounds)
        let finalImage = renderer.image { context in
            let image = canvas.drawing.image(from: canvas.drawing.bounds.inset(by: .init(top: -50, left: -50, bottom: -50, right: -50)), scale: 1.0)
            
            // set the background color to black
            context.cgContext.setFillColor(UIColor.black.cgColor)
            // fill context
            context.cgContext.fill(canvas.bounds)
            
            // draw the image on top of the black background
            image.draw(in: canvas.bounds)
        }
        
        // display result
        if let result = performInference(on: finalImage) {
            print(result)
            predictionText.text = "Prediction: \(result.0)"
        }
    }
    
    func configureUI() {
        configureCanvas()
        configureLabel()
        configureClearButton()
        configureTestButton()
    }
    
    func configureCanvas() {
        view.addSubview(canvas)
        canvas.translatesAutoresizingMaskIntoConstraints = false
        
        canvas.layer.cornerRadius = 30
        canvas.backgroundColor = .black
        canvas.drawingPolicy = .anyInput
        canvas.tool = PKInkingTool(.monoline, color: .white, width: 10)
        
        NSLayoutConstraint.activate([
            canvas.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            canvas.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 60),
            canvas.heightAnchor.constraint(equalTo: view.widthAnchor, constant: -30),
            canvas.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -30)
        ])
    }
    
    func configureLabel() {
        view.addSubview(predictionText)
        predictionText.translatesAutoresizingMaskIntoConstraints = false
        
        predictionText.text = "Prediction: None yet"
        predictionText.font = .boldSystemFont(ofSize: 24)
        
        NSLayoutConstraint.activate([
            predictionText.bottomAnchor.constraint(equalTo: canvas.topAnchor, constant: -20),
            predictionText.leadingAnchor.constraint(equalTo: canvas.leadingAnchor)
        ])
    }
    
    func configureClearButton() {
        view.addSubview(clearDrawingButton)
        clearDrawingButton.translatesAutoresizingMaskIntoConstraints = false
        
        clearDrawingButton.setTitle("Clear", for: .normal)
        clearDrawingButton.setTitleColor(.systemBlue, for: .normal)
        
        clearDrawingButton.addTarget(self, action: #selector(clearButtonHandler), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            clearDrawingButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -60),
            clearDrawingButton.topAnchor.constraint(equalTo: canvas.bottomAnchor, constant: 10)
        ])
    }
    
    func configureTestButton() {
        view.addSubview(testButton)
        testButton.translatesAutoresizingMaskIntoConstraints = false
        
        testButton.setTitle("Test", for: .normal)
        testButton.setTitleColor(.systemBlue, for: .normal)
        
        testButton.addTarget(self, action: #selector(testButtonHandler), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            testButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 60),
            testButton.topAnchor.constraint(equalTo: canvas.bottomAnchor, constant: 10)
        ])
    }
}
