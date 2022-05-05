'''
Calculate the mean and mean +- 2std of the forecast ensemble
'''
import xarray as xr
import numpy as np
import pandas as pd
#%%
forecast = []
for i in range(12):
    forecast.append(xr.open_dataset(r'processed_forecast/member' + str(i) + '.nc'))

#%%
forc_ens= xr.concat(forecast, pd.Index(np.arange(12), name='number'))
mean_forc = forc_ens.mean('number')
std_forc = forc_ens.std('number')
#%%
std_minus = mean_forc - (2*std_forc)
std_plus = mean_forc + (2*std_forc)

#%%
mean_forc.to_netcdf('mean.nc')
std_minus.to_netcdf('mean_minus_2std.nc')
std_plus.to_netcdf('mean__plus_2std.nc')