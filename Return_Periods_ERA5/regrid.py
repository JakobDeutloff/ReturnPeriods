'''
Regrid the ERA5 data to the MetOffice forecast grid
'''
import matplotlib.pyplot as plt
import iris
import iris.coord_systems
import iris.quickplot as qplt

#%%
forecast = iris.load_cube(r'Forecast Data/202002060300/202002060300_u1096_ng_ek00_precipaccum_2km.nc')
periods = [5, 10, 25, 50, 100]
for period in periods:

    ERA = iris.load_cube(r'ERA5_RP/precipitation-at-fixed-return-period_europe_ecad_30-year_' + str(period) +'-yrs_1989-2018_v1.nc')

    pp_coord_system = iris.coord_systems.GeogCS(iris.fileformats.pp.EARTH_RADIUS)

    UK_lat = iris.Constraint(latitude=lambda v: v > 50 and v <= 60)
    UK_lon = iris.Constraint(longitude=lambda v: v > -10 and v <= 2)
    era_revised = ERA.extract(UK_lat & UK_lon)

    lat = era_revised.coord('latitude')
    lon = era_revised.coord('longitude')
    lat.coord_system = pp_coord_system
    lat.guess_bounds()
    lon.coord_system = pp_coord_system
    lon.guess_bounds()

    regridded_cube = era_revised.regrid(forecast, iris.analysis.Linear())
    iris.save(regridded_cube, 'ERA5_RP_regridded/ERA_RP_' + str(period) + '.nc')

# %% simple plots
qplt.pcolormesh(regridded_cube, vmin=40, vmax=100)
plt.gca().coastlines()
plt.show()