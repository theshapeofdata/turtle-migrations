#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Code to extract current velocities at track locations
Created on Wed Feb 23 11:51:18 2022

@author: ashwinip
"""

import numpy as np
import pandas as pd
import xarray as xr

#%% Read data

currents = xr.open_dataset("/Volumes/Lumos/Turtles/Data/Telemetry/Currents/2015/hycom_2015.nc4")

turtles = pd.read_csv("/Users/ashwinip/Documents/Academic/Turtles/Telemetry/Currents/tracks/tracks_2015.csv",
                      parse_dates=['date'])
turtles = turtles.set_index('date', drop=False)

turtles['u'] = np.nan
col_no_u = turtles.columns.get_loc('u')
turtles['v'] = np.nan
col_no_v = turtles.columns.get_loc('v')


#%% Extract

for i in range(0,len(turtles)):
    turtles.iloc[i,col_no_u] = currents.sel(time = turtles.iloc[i,0], lat = turtles.iloc[i,4], 
                                            lon = turtles.iloc[i,3],
                                            method = 'nearest').water_u.values
    turtles.iloc[i,col_no_v] = currents.sel(time = turtles.iloc[i,0], lat = turtles.iloc[i,4], 
                                            lon = turtles.iloc[i,3],
                                            method = 'nearest').water_v.values

#%% Save to csv

title = '/Users/ashwinip/Documents/Academic/Turtles/Telemetry/Currents/values/currents_' + str(2015) + '.csv'
turtles.to_csv(title)  


#%% Monthly

year = 2014
filename = '/Users/ashwinip/Documents/Academic/Turtles/Telemetry/Currents/tracks/tracks_' + str(year) + '.csv'

turtles = pd.read_csv(filename,
                      parse_dates=['date'])
turtles = turtles.set_index('date', drop=False)

turtles['u'] = np.nan
col_no_u = turtles.columns.get_loc('u')
turtles['v'] = np.nan
col_no_v = turtles.columns.get_loc('v')

#%% Extract

for i in range(0,len(turtles)):
    month = turtles.index.month[i]
    
    filename = '/Volumes/Lumos/Turtles/Data/Telemetry/Currents/' + str(year) + '/hycom_' + str(year) + '_m' + str(month) + '.nc4'
    
    currents = xr.open_dataset(filename)
    
    turtles.iloc[i,col_no_u] = currents.sel(time = turtles.iloc[i,0], lat = turtles.iloc[i,4], 
                                            lon = turtles.iloc[i,3],
                                            method = 'nearest').water_u.values
    turtles.iloc[i,col_no_v] = currents.sel(time = turtles.iloc[i,0], lat = turtles.iloc[i,4], 
                                            lon = turtles.iloc[i,3],
                                            method = 'nearest').water_v.values
    
    #del currents
    print(i)

#%% Write to csv

title = '/Users/ashwinip/Documents/Academic/Turtles/Telemetry/Currents/values/currents_' + str(year) + '.csv'
turtles.to_csv(title)  


#GLBv0.08_expt_53.X_20110701.nc4
#hycom_2011_m1


  

