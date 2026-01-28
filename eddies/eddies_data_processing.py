#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Code to read eddies data
Created on Wed Feb 16 13:28:52 2022

@author: ashwinip
"""

import xarray as xr
import pandas as pd
import numpy as np

#%% Read data

eddies = xr.open_dataset("/Volumes/Lumos/Turtles/Data/Telemetry/Eddies/eddy.nc")

eddies_df = pd.DataFrame(data=np.zeros([27880804,10]),
                         columns=["amplitude", "cyclonic_type", "latitude", "longitude", 
                                  "observation_flag", "observation_number", "speed_average",
                                  "speed_radius", "time", "track"])

#%% Process data

temp = eddies.amplitude.values
eddies_df['amplitude'] = temp

temp = eddies.cyclonic_type.values
eddies_df['cyclonic_type'] = temp

temp = eddies.latitude.values
eddies_df['latitude'] = temp

temp = eddies.longitude.values
eddies_df['longitude'] = temp

temp = eddies.observation_flag.values
eddies_df['observation_flag'] = temp

temp = eddies.observation_number.values
eddies_df['observation_number'] = temp

temp = eddies.speed_average.values
eddies_df['speed_average'] = temp

temp = eddies.speed_radius.values
eddies_df['speed_radius'] = temp

temp = eddies.time.values
eddies_df['time'] = temp

temp = eddies.track.values
eddies_df['track'] = temp

#%% Slice

eddies_sliced = eddies_df[(eddies_df.time >= '2011-01-01T00:00:00.000000000') &
                          (eddies_df.time <= '2015-03-01T00:00:00.000000000') &
                          (eddies_df.latitude >= -30) &
                          (eddies_df.latitude <= 15) &
                          (eddies_df.longitude >= 30) &
                          (eddies_df.longitude <= 140)]

del eddies_df

#%% Write to file

eddies_sliced.to_csv('/Volumes/Lumos/Turtles/Data/Telemetry/Eddies/eddies.csv', index=False)








