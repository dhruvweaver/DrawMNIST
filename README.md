# DrawMNIST
A machine learning experiment using PyTorch and Core ML.

The goal is to design a model using PyTorch that accurately classifies symbols from the [MNIST dataset](https://en.wikipedia.org/wiki/MNIST_database),
and then convert it into a Core ML model that can be used in an iOS app.
The app will allow users to draw a symbol and then have the app predict what symbol they have drawn.

### PyTorch model
Currently the model is a fairly simple neural net with 2 hidden layers with 800 nodes each.
It is also trained only on digits, no letters.
Soon this model will use convolution as well as other methods to improve model performance.

The Jupyter Notebook contained in the `training` directory configures and trains this model, as well as converting it to Core ML.

### iOS app
The app is also very simple at the moment. It allows a user to draw a symbol by hand, and then the app will infer what the user has drawn.
