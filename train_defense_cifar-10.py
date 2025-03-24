#from setup_cifar10 import CIFAR10
from defensive_models import DenoisingAutoEncoder as DAE
import os


# Load command line args (input path and outout path)
shape = [32, 32, 3]

combination_I = [3, "average", 3, 3]

combination_II = [3, 3, 3]

activation = "sigmoid"
reg_strength = 1e-9  
epochs = 400  
noise_level = 0.025  

if not os.path.exists('models'):
    os.makedirs('models')

print("Loading CIFAR-10 dataset...")
#data = CIFAR10()
# grab the CIFAR 10 dataset from the main data folder (path in command line args)

print("Dataset loaded!")

print("Training the first autoencoder (with pooling)...")
AE_I = DAE(shape, combination_I, v_noise=noise_level, activation=activation,
           reg_strength=reg_strength)
AE_I.train(data, "CIFAR10_I", num_epochs=epochs)

print("Training the second autoencoder (without pooling)...")
AE_II = DAE(shape, combination_II, v_noise=noise_level, activation=activation,
            reg_strength=reg_strength)
AE_II.train(data, "CIFAR10_II", num_epochs=epochs)

print("Training complete!")