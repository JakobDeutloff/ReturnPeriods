from __future__ import annotations

import warnings

import numpy as np
import xarray as xr

warnings.simplefilter("ignore")
from scipy.stats import bernoulli, gamma

from xclim.core.missing import missing_pct
from xclim.indices.generic import select_resample_op
from xclim.indices.stats import fa, fit, frequency_analysis, parametric_quantile

#%% Create synthetic daily precipitation time series (mm/d)
n = 50 * 366
start = np.datetime64("1950-01-01")
time = start + np.timedelta64(1, "D") * range(n)
# time = xr.cftime_range(start="1950-01-01", periods=n)

# Generate wet (1) /dry (0) days, then multiply by rain magnitude.
wet = bernoulli.rvs(0.1, size=n)
intensity = gamma(a=4, loc=1, scale=6).rvs(n)
pr = xr.DataArray(
    wet * intensity,
    dims=("time",),
    coords={"time": time},
    attrs={"units": "mm/d", "standard_name": "precipitation_flux"},
)
pr

#%% Compute the design value
frequency_analysis(
    pr, t=20, dist="genextreme", mode="max", freq="Y", month=[5, 6, 7, 8, 9, 10]
)
