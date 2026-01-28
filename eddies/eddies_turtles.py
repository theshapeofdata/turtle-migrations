#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Code to find eddies in individual turtle tracks
Created on Tue Feb 22 18:29:52 2022

@author: ashwinip
"""

import pandas as pd
import numpy as np
#import datetime as dt
from geopy import distance

#%% Read data

eddies_df = pd.read_csv("/Users/ashwinip/Documents/Academic/Turtles/Telemetry/Data/Eddies/eddies_filtered.csv",
                     parse_dates=['time'])

turtles = pd.read_csv("/Users/ashwinip/Documents/Academic/Turtles/Telemetry/Environment/tracks.csv",
                      parse_dates=['date'])

eddies_turtles = []

#%% Filter

tid = 113337

turtle = turtles[turtles.id == tid]

eddies_turtle = []

for e_index, e_row in eddies_df.iterrows():
    for t_index, t_row in turtle.iterrows():
        if e_row['time'].date() != t_row['date'].date():
            continue
        else:
            e_coords = (e_row['latitude'], e_row['longitude'])
            t_coords = (t_row['lat'], t_row['lon'])
            dist = distance.distance(e_coords, t_coords).meters
            
            if dist<= e_row['speed_radius']:
                #eddies_df.loc[e_index,'match']=1
                eddies_turtle.append(e_row['no.'])
                print(t_row)
                break
    print(e_index)

eddies_turtles.append(eddies_turtle)


#%% Save to csv

#import csv

np.savetxt("/Users/ashwinip/Documents/Academic/Turtles/Telemetry/Data/Eddies/eddies_turtles.csv",
           eddies_turtles,
           delimiter = ", ",
           fmt = '% s')

