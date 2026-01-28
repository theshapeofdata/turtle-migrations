#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Code to combine currents data month-wise
Created on Wed Feb 23 12:11:54 2022

@author: ashwinip
"""

import xarray as xr
import os

#%% Loop

year = 2015
month = 2
month_str = "{:02d}".format(month)

#filename = '/Volumes/Lumos/Turtles/Data/Telemetry/Currents/' + str(year) + '/GLBv0.08_expt_53.X_20130201.nc4'
filename = '/Volumes/Lumos/Turtles/Data/Telemetry/Currents/' + str(year) + '/GLBv0.08_expt_53.X_' + str(year) + month_str + '01.nc4'
f_combo = xr.open_dataset(filename)

# giving directory name
dirname = '/Volumes/Lumos/Turtles/Data/Telemetry/Currents/' + str(year) + '/m' + str(month) + '/'
 
# giving file extension
ext = ('.nc4')
 
# iterating over all files
for files in os.listdir(dirname):
    if files.endswith(ext):
        f2_name = dirname + files
        print(f2_name)  # printing file name
        f2 = xr.open_dataset(f2_name) 
        f_combo = xr.combine_by_coords([f_combo, f2], combine_attrs='override')
    else:
        continue
    
del f2

#%% Save to nc4

filename = '/Volumes/Lumos/Turtles/Data/Telemetry/Currents/' + str(year) + '/hycom_' + str(year) + '_m' + str(month) + '.nc4'
f_combo.to_netcdf(filename)

del f_combo
