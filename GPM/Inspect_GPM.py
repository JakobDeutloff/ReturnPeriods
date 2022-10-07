"""
Quick script to check the GPM data provided by Seshu Kolusu from the MetOffice
"""

import xarray as xr
import cartopy.crs as ccrs
import matplotlib.pyplot as plt

#%% load and show data
GPM_clim = xr.open_dataset('GPM/GPM_Climatology_2001_2019_dayclim_mm_UK.nc')
GPM_clim

# %% plot first timestep
fig, ax = plt.subplots(subplot_kw={'projection': ccrs.PlateCarree()})
GPM_clim.precipitation_flux.isel(time=1).plot(ax=ax, transform=ccrs.PlateCarree())
ax.coastlines()
ax.grid()
plt.show()




