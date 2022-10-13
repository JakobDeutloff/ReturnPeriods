"""
Quick script to check the data downloaded from Nasa, repair it and export the repaired file
"""
import pandas as pd
import xarray as xr
import cartopy.crs as ccrs
import cartopy.feature as ft
import matplotlib.pyplot as plt
import numpy as np

from datetime import datetime


#%% load data
GPM_new = xr.open_dataset('GPM/downloads/GPM_rainfall.nc4')

# %% plot first timestep
fig, ax = plt.subplots(subplot_kw={'projection': ccrs.PlateCarree()})
GPM_new.HQprecipitation.isel(time=1).plot(ax=ax, x='lon', y='lat', transform=ccrs.PlateCarree())
ax.coastlines()
ax.add_feature(ft.BORDERS)
ax.grid()
plt.show()

# %% Inspect index of new data
fig, ax = plt.subplots()
ax.plot(np.arange(len(GPM_new.time)), GPM_new.time)
plt.show()

#%% extract right time slice
# 16125
GPM_new_corr = GPM_new.isel(time=slice(16125, 23902))
GPM_new_corr.attrs['EndDate'] = '2021-09-30'

# %% Plot corrected data to check if everything is alright
fig, ax = plt.subplots(subplot_kw={'projection': ccrs.PlateCarree()})
GPM_new_corr.HQprecipitation.isel(time=1).plot(ax=ax, x='lon', y='lat', transform=ccrs.PlateCarree())
ax.coastlines()
ax.add_feature(ft.BORDERS)
ax.gridlines(crs=ccrs.PlateCarree(), draw_labels=True, linewidth=2, color='gray', alpha=0.5, linestyle='--')
plt.show()

# %% export the corrected data
GPM_new_corr.to_netcdf(format='NETCDF4', path='GPM/GPM_climatology_2000_2021.nc4')





