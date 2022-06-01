#= 
mnist_loader
~~~~~~~~~~~~
A library to load the MNIST image data.  For details of the data
structures that are returned, see the doc strings for ``load_data``
and ``load_data_wrapper``.  In practice, ``load_data_wrapper`` is the
function usually called by our neural network code.
=#
using GZip
using Pickle
 
function load_data()::Tuple
    #= Return the MNIST data as a tuple containing the training data,
        the validation data, and the test data.
        The ``training_data`` is returned as a tuple with two entries.
        The first entry contains the actual training images.  This is a
        numpy ndarray with 50,000 entries.  Each entry is, in turn, a
        numpy ndarray with 784 values, representing the 28 * 28 = 784
        pixels in a single MNIST image.
        The second entry in the ``training_data`` tuple is a numpy ndarray
        containing 50,000 entries.  Those entries are just the digit
        values (0...9) for the corresponding images contained in the first
        entry of the tuple.
        The ``validation_data`` and ``test_data`` are similar, except
        each contains only 10,000 images.
        This is a nice data format, but for use in neural networks it's
        helpful to modify the format of the ``training_data`` a little.
        That's done in the wrapper function ``load_data_wrapper()``, see
        below.
        =#
    f = GZip.open(
        "/home/miguel/Desktop/Tese/Repositories/pyjl_tests/network/mnist.pkl.gz",
        "rb",
    )
    (training_data, validation_data, test_data) = Pickle.npyload(f)
    close(f)
    return (training_data, validation_data, test_data)
end
 
function load_data_wrapper()::Tuple
     #= Return a tuple containing ``(training_data, validation_data,
         test_data)``. Based on ``load_data``, but the format is more
         convenient for use in our implementation of neural networks.
         In particular, ``training_data`` is a list containing 50,000
         2-tuples ``(x, y)``.  ``x`` is a 784-dimensional numpy.ndarray
         containing the input image.  ``y`` is a 10-dimensional
         numpy.ndarray representing the unit vector corresponding to the
         correct digit for ``x``.
         ``validation_data`` and ``test_data`` are lists containing 10,000
         2-tuples ``(x, y)``.  In each case, ``x`` is a 784-dimensional
         numpy.ndarry containing the input image, and ``y`` is the
         corresponding classification, i.e., the digit values (integers)
         corresponding to ``x``.
         Obviously, this means we're using slightly different formats for
         the training data and the validation / test data.  These formats
         turn out to be the most convenient for use in our neural network
         code. =#
    (tr_d, va_d, te_d) = load_data()
    tr_d_arr = array_or_arrays(tr_d[1])
    va_d_arr = array_or_arrays(va_d[1])
    te_d_arr = array_or_arrays(te_d[1])
 
    training_inputs = [reshape(x, (784, 1)) for x in tr_d_arr]
    training_results = [vectorized_result(y) for y in tr_d[2]]
    training_data = zip(training_inputs, training_results)
    validation_inputs = [reshape(x, (784, 1)) for x in va_d_arr]
    validation_data = zip(validation_inputs, va_d[2])
    test_inputs = [reshape(x, (784, 1)) for x in te_d_arr]
    test_data = zip(test_inputs, te_d[2])
    return (training_data, validation_data, test_data)
end

# Temp function:
function array_or_arrays(matrix::Matrix)
    arr::Vector{Vector}= []
    row, col = size(matrix)
    for i in 0:row-1
        curr_pos = i*col
        push!(arr, matrix'[curr_pos+1:curr_pos+col])
    end
    return arr
end
 
function vectorized_result(j)
    #= Return a 10-dimensional unit vector with a 1.0 in the jth
        position and zeroes elsewhere.  This is used to convert a digit
        (0...9) into a corresponding desired output from the neural
        network. =#
    e = zeros(Float64, (10, 1))
    e[j+1] = 1.0
    return e
end
 