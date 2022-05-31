#= 
network.py
~~~~~~~~~~
IT WORKS

A module to implement the stochastic gradient descent learning
algorithm for a feedforward neural network.  Gradients are calculated
using backpropagation.  Note that I have focused on making the code
simple, easily readable, and easily modifiable.  It is not optimized,
and omits many desirable features.
 =#
using LinearAlgebra
using Random

abstract type AbstractNetwork end
mutable struct Network <: AbstractNetwork
    num_layers::Int64
    sizes
    biases
    weights
    Network(
        sizes,
        num_layers = length(sizes),
        biases = [randn(y, 1) for y in sizes[2:end]],
        weights = [randn(y, x) for (x, y) in zip(sizes[begin:end-1], sizes[2:end])],
    ) = new(sizes, num_layers, biases, weights)
end
function feedforward(self::AbstractNetwork, a)
    #= Return the output of the network if ``a`` is input. =#
    for (b, w) in zip(self.biases, self.weights)
        a = sigmoid(LinearAlgebra.dot(w, a) + b)
    end
    return a
end

function SGD(
    self::AbstractNetwork,
    training_data,
    epochs,
    mini_batch_size,
    eta,
    test_data = nothing,
)
    #= Train the neural network using mini-batch stochastic
            gradient descent.  The ``training_data`` is a list of tuples
            ``(x, y)`` representing the training inputs and the desired
            outputs.  The other non-optional parameters are
            self-explanatory.  If ``test_data`` is provided then the
            network will be evaluated against the test data after each
            epoch, and partial progress printed out.  This is useful for
            tracking progress, but slows things down substantially. =#
    training_data = collect(training_data)
    n = length(training_data)
    if test_data
        test_data = collect(test_data)
        n_test = length(test_data)
    end
    for j = 0:epochs-1
        shuffle(training_data)
        mini_batches = [training_data[k+1:k+mini_batch_size] for k = 0:mini_batch_size:n-1]
        for mini_batch in mini_batches
            update_mini_batch(self, mini_batch, eta)
        end
        if test_data
            println("Epoch $(j) : $(evaluate(self, test_data)) / $(n_test)")
        else
            println("Epoch $(j) complete")
        end
    end
end

function update_mini_batch(self::AbstractNetwork, mini_batch, eta)
    #= Update the network's weights and biases by applying
            gradient descent using backpropagation to a single mini batch.
            The ``mini_batch`` is a list of tuples ``(x, y)``, and ``eta``
            is the learning rate. =#
    nabla_b = [zeros(Float64, b.shape) for b in self.biases]
    nabla_w = [zeros(Float64, w.shape) for w in self.weights]
    for (x, y) in mini_batch
        delta_nabla_b, delta_nabla_w = backprop(self, x, y)
        nabla_b = [nb + dnb for (nb, dnb) in zip(nabla_b, delta_nabla_b)]
        nabla_w = [nw + dnw for (nw, dnw) in zip(nabla_w, delta_nabla_w)]
    end
    self.weights =
        [w - (eta / length(mini_batch)) * nw for (w, nw) in zip(self.weights, nabla_w)]
    self.biases =
        [b - (eta / length(mini_batch)) * nb for (b, nb) in zip(self.biases, nabla_b)]
end

function backprop(self::AbstractNetwork, x, y)::Tuple
    #= Return a tuple ``(nabla_b, nabla_w)`` representing the
            gradient for the cost function C_x.  ``nabla_b`` and
            ``nabla_w`` are layer-by-layer lists of numpy arrays, similar
            to ``self.biases`` and ``self.weights``. =#
    nabla_b = [zeros(Float64, b.shape) for b in self.biases]
    nabla_w = [zeros(Float64, w.shape) for w in self.weights]
    activation = x
    activations = [x]
    zs = []
    for (b, w) in zip(self.biases, self.weights)
        z = LinearAlgebra.dot(w, activation) + b
        push!(zs, z)
        activation = sigmoid(z)
        push!(activations, activation)
    end
    delta = cost_derivative(self, activations[end], y) * sigmoid_prime(zs[end])
    nabla_b[end] = delta
    nabla_w[end] = LinearAlgebra.dot(delta, transpose(activations[end]))
    for l = 2:self.num_layers-1
        z = zs[-(l)+1]
        sp = sigmoid_prime(z)
        delta = LinearAlgebra.dot(transpose(self.weights[-(l)+2]), delta) * sp
        nabla_b[-(l)+1] = delta
        nabla_w[-(l)+1] = LinearAlgebra.dot(delta, transpose(activations[-(l)]))
    end
    return (nabla_b, nabla_w)
end

function evaluate(self::AbstractNetwork, test_data)
    #= Return the number of test inputs for which the neural
            network outputs the correct result. Note that the neural
            network's output is assumed to be the index of whichever
            neuron in the final layer has the highest activation. =#
    test_results = [(argmax(feedforward(self, x)), y) for (x, y) in test_data]
    return sum((Int(x == y) for (x, y) in test_results))
end

function cost_derivative(self::AbstractNetwork, output_activations, y)::Any
    #= Return the vector of partial derivatives \partial C_x /
            \partial a for the output activations. =#
    return output_activations - y
end

function sigmoid(z)::Float64
    #= The sigmoid function. =#
    return 1.0 / (1.0 + [ℯ^i for i in -(z)])
end

function sigmoid_prime(z)::Float64
    #= Derivative of the sigmoid function. =#
    return sigmoid(z) * (1 - sigmoid(z))
end
