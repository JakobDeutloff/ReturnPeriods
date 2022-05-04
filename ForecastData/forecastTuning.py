import xarray as xr
import numpy as np
import cartopy.crs as ccrs
import matplotlib.pyplot as plt

#%% open datafiles

t1 = {}
t2 = {}
t3 = {}
t4 = {}
for i in range(10):
    t1[str(i)] = xr.open_dataset(
        r'Forecast Data/202002060300/202002060300_u1096_ng_ek0' + str(i) + '_precipaccum_2km.nc')
    # one member missing from second timeframe
    if i != 2:
        t2[str(i)] = xr.open_dataset(
            r'Forecast Data/202002080300/202002080300_u1096_ng_ek0' + str(i) + '_precipaccum_2km.nc')
    t3[str(i)] = xr.open_dataset(
        r'Forecast Data/202002100300/202002100300_u1096_ng_ek0' + str(i) + '_precipaccum_2km.nc')
    t4[str(i)] = xr.open_dataset(
        r'Forecast Data/202002110300/202002110300_u1096_ng_ek0' + str(i) + '_precipaccum_2km.nc')

for i in range(2):
    t1[str(i+10)] = xr.open_dataset(
        r'Forecast Data/202002060300/202002060300_u1096_ng_ek1' + str(i) + '_precipaccum_2km.nc')
    t2[str(10+i)] = xr.open_dataset(
        r'Forecast Data/202002080300/202002080300_u1096_ng_ek1' + str(i) + '_precipaccum_2km.nc')
    t3[str(10+i)] = xr.open_dataset(
        r'Forecast Data/202002100300/202002100300_u1096_ng_ek1' + str(i) + '_precipaccum_2km.nc')
    t4[str(10+i)] = xr.open_dataset(
        r'Forecast Data/202002110300/202002110300_u1096_ng_ek1' + str(i) + '_precipaccum_2km.nc')


# %% first plot - doesn't work yet because x and y in m
fig = plt.figure()
ax = plt.subplot(projection=ccrs.PlateCarree())
x = t1['1'].isel(time=10)['amount_of_precipitation'].projection_x_coordinate
y = t1['1'].isel(time=10)['amount_of_precipitation'].projection_y_coordinate

ax.contourf(t1['1'].isel(time=10)['amount_of_precipitation'], transform=ccrs.TransverseMercator())
ax.gridlines()
ax.coastlines()
plt.show()
