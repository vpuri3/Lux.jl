module LuxDeviceUtilsLuxCUDAExt

using LuxCUDA, LuxDeviceUtils, Random
import Adapt: adapt_storage, adapt

__init__() = reset_gpu_device!()

LuxDeviceUtils.__is_loaded(::LuxCUDADevice) = true
LuxDeviceUtils.__is_functional(::LuxCUDADevice) = LuxCUDA.functional()

# Default RNG
LuxDeviceUtils.default_device_rng(::LuxCUDADevice) = CUDA.default_rng()

# Query Device from Array
LuxDeviceUtils.get_device(::CUDA.AnyCuArray) = LuxCUDADevice()

# Device Transfer
## To GPU
adapt_storage(::LuxCUDAAdaptor, x) = cu(x)
adapt_storage(::LuxCUDAAdaptor, rng::AbstractRNG) = rng
adapt_storage(::LuxCUDAAdaptor, rng::Random.TaskLocalRNG) = CUDA.default_rng()

adapt_storage(::LuxCPUAdaptor, rng::CUDA.RNG) = Random.default_rng()

## To CPU
adapt_storage(::LuxCPUAdaptor, x::CUSPARSE.AbstractCuSparseMatrix) = adapt(Array, x)

end
