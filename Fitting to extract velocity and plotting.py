# -*- coding: utf-8 -*-
"""
Created on Mon Jul  1 14:08:31 2019

@author: Ryan
"""

import numpy as np
import os
import pickle
import matplotlib.pyplot as plt
import paramiko as pm
from IPython import get_ipython

get_ipython().run_line_magic('matplotlib', 'qt')
#%% Calculate Front velocity for different values of r_pp 
## Used for figs 3a/3b/3c
local_home = 'C:/Users/Ryan/Documents/Research/Keisuke_Code/'
path = local_home
CFL_param = 1 ### 1 for regular fig 5 for cfl test
figure = "3c"
os.chdir(local_home)

cp = []
cm = []
times = []
r_pp = []
CFL = []
vfront_first = []
vfront_second = []
vfront_third = []
front_pos = []
profile_front_pos = []
profile_bulk_pos = []
dx = []
dt = []
profile_time = []

dir_list = [f for f in os.listdir() if "CFL_test_" not in f and figure in f]

for idx, direc in enumerate(dir_list):
    
    os.chdir(path+direc)

    cp_temp = [] 
    cm_temp = []
    times_temp = []
    front_pos_temp = []
    r_pp_temp = []
    CFL_temp = []
    #print(len(vfront_temp))
    #print(os.getcwd())

    ##Select files to be imported
    input_files = [f for f in os.listdir() if "Keisuke_cluster" in f]
    input_files.sort(key = lambda x: int(x.rsplit('_',1)[1]))
    
    for file in input_files:
        
        #print(file)
        ##Import dictionary of simulated data
        infile = open(os.getcwd()+"/"+file, 'rb')
        params = pickle.load(infile)
        infile.close()
        ##Define local variables
        cp_temp.append(params['cp'])
        cm_temp.append(params['cm'])
        r_pp_temp.append(params['r_pp'])
        front_pos_temp.append(params['front'])
        times_temp.append(params['time'])
        CFL_temp.append(params['CFL'])
        profile_front_pos.append(params['profile_pos'])
        profile_bulk_pos.append(params['profile_bulk_pos'])
        dx.append(params['dx'])
        dt.append(params['dt'])
        profile_time.append(params['profile_time'])
        vfront_first_temp = np.zeros(len(r_pp_temp))
        vfront_second_temp = np.zeros(len(r_pp_temp))
        vfront_third_temp = np.zeros(len(r_pp_temp))   
    
    front_pos_temp=np.array([np.array(i) for i in front_pos_temp])
    
    ##Fit first third of front position points
    for i in range(0,len(r_pp_temp)):
        fit = np.polyfit(times_temp[i][0:len(front_pos_temp[i])//3], front_pos_temp[i][0:len(front_pos_temp[i])//3]*dx[i], 1)
        vfront_first_temp[i] = fit[0]
            
     ##Fit middle third of front position points
            
    for i in range(0,len(r_pp_temp)):
         fit = np.polyfit(times_temp[i][(len(front_pos_temp[i]))//3:(2*len(front_pos_temp[i]))//3], front_pos_temp[i][(len(front_pos_temp[i]))//3:(2*len(front_pos_temp[i]))//3]*dx[i], 1)
         vfront_second_temp[i] = fit[0]
                
    ##Fit latter third of front position points
                
    for i in range(0,len(r_pp_temp)):
        fit = np.polyfit(times_temp[i][(2*len(front_pos_temp[i]))//3:int(len(front_pos_temp[i]))], front_pos_temp[i][(2*len(front_pos_temp[i]))//3:int(len(front_pos_temp[i]))]*dx[i], 1)
        vfront_third_temp[i] = fit[0]
        
    cp.append(cp_temp)
    cm.append(cm_temp)
    times.append(times_temp)
    front_pos.append(front_pos_temp)
    r_pp.append(r_pp_temp)
    CFL.append(CFL_temp)
    vfront_first.append(vfront_first_temp)
    vfront_second.append(vfront_second_temp)
    vfront_third.append(vfront_third_temp)
    ##Save front velocity data as .txt files
    np.savetxt("Figure_"+figure+"_y.txt" ,vfront_third, fmt = '%f', delimiter = ',') 
    np.savetxt("Figure_"+figure+"_x.txt" , r_pp_temp, fmt = '%f', delimiter = ',')
    np.savetxt("Figure_"+figure+"_dt.txt" , dt, fmt = '%f', delimiter = ',')
    np.savetxt("Figure_"+figure+"_dx.txt" , dx, fmt = '%f', delimiter = ',')
#%% Calculate Front velocity for different f_p/f_m 
##Same as for growth rate but for different values of f_p/f_m
##Used for figs 6a/6b
local_home = 'C:/Users/Ryan/Documents/Research/Keisuke_Code/'
path = local_home
CFL_param = 1 ### 1 for regular fig 5 for cfl test
figure = "6b"
os.chdir(local_home)

cp = []
cm = []
times = []
front_pos = []
f_p = []
f_m = []
CFL = []
vfront_first = []
vfront_second = []
vfront_third = []
front_pos = []
profile_front_pos = []
profile_bulk_pos = []
dx = []
dt = []
profile_time = []

dir_list = [f for f in os.listdir() if "CFL_test_" not in f and figure in f]

for idx, direc in enumerate(dir_list):
    
    os.chdir(path+direc)

    cp_temp = [] 
    cm_temp = []
    times_temp = []
    front_pos_temp = []
    f_p_temp = []
    f_m_temp = []
    CFL_temp = []
    #print(len(vfront_temp))
    #print(os.getcwd())

    input_files = [f for f in os.listdir() if "Keisuke_cluster" in f]
    input_files.sort(key = lambda x: int(x.rsplit('_',1)[1]))
    
    for file in input_files:
        
        #print(file)
        infile = open(os.getcwd()+"/"+file, 'rb')
        params = pickle.load(infile)
        infile.close()
        cp_temp.append(params['cp'])
        cm_temp.append(params['cm'])
        f_p_temp.append(params['f_p'])
        f_m_temp.append(params['f_m'])
        front_pos_temp.append(params['front'])
        times_temp.append(params['time'])
        CFL_temp.append(params['CFL'])
        profile_front_pos.append(params['profile_pos'])
        profile_bulk_pos.append(params['profile_bulk_pos'])
        dx.append(params['dx'])
        profile_time.append(params['profile_time'])
        dt.append(params['dt'])
        vfront_first_temp = np.zeros(len(f_p_temp))
        vfront_second_temp = np.zeros(len(f_p_temp))
        vfront_third_temp = np.zeros(len(f_p_temp))
    
    front_pos_temp=np.array([np.array(i) for i in front_pos_temp])
    
    for i in range(0,len(f_p_temp)):
        fit = np.polyfit(times_temp[i][0:len(front_pos_temp[i])//3], front_pos_temp[i][0:len(front_pos_temp[i])//3]*dx[i], 1)
        vfront_first_temp[i] = fit[0]
            
     ##Fit middle third of points
            
    for i in range(0,len(f_p_temp)):
         fit = np.polyfit(times_temp[i][(len(front_pos_temp[i]))//3:(2*len(front_pos_temp[i]))//3], front_pos_temp[i][(len(front_pos_temp[i]))//3:(2*len(front_pos_temp[i]))//3]*dx[i], 1)
         vfront_second_temp[i] = fit[0]
                
    ##Fit latter third of points
                
    for i in range(0,len(f_p_temp)):
        fit = np.polyfit(times_temp[i][(2*len(front_pos_temp[i]))//3:int(len(front_pos_temp[i]))], front_pos_temp[i][(2*len(front_pos_temp[i]))//3:int(len(front_pos_temp[i]))]*dx[i], 1)
        vfront_third_temp[i] = fit[0]
        
    cp.append(cp_temp)
    cm.append(cm_temp)
    times.append(times_temp)
    front_pos.append(front_pos_temp)
    f_p.append(f_p_temp)
    f_m.append(f_m_temp)
    CFL.append(CFL_temp)
    vfront_first.append(vfront_first_temp)
    vfront_second.append(vfront_second_temp)
    vfront_third.append(vfront_third_temp)
    sum_switching = np.add(f_p,f_m)
    ratio_switching = np.divide(f_p,np.add(f_p,f_m))

np.savetxt("Figure_"+figure+"_y.txt" ,vfront_third, fmt = '%f', delimiter = ',')
np.savetxt("Figure_"+figure+"_dt.txt" , dt, fmt = '%f', delimiter = ',')
np.savetxt("Figure_"+figure+"_dx.txt" , dx, fmt = '%f', delimiter = ',') 

if figure == '6a':
    np.savetxt("Figure_"+figure+"_x.txt" ,sum_switching, fmt = '%f', delimiter = ',')
    
else:
    np.savetxt("Figure_"+figure+"_x.txt" ,ratio_switching, fmt = '%f', delimiter = ',')
    
#%% Calculate Front velocity for different v_p/v_m 
##Used for figs 5a/5b
local_home = 'C:/Users/Ryan/Documents/Research/Keisuke_Code/'
path = local_home
figure = "5b"
os.chdir(local_home)

cp = []
cm = []
times = []
front_pos = []
v_p = []
v_m = []
CFL = []
vfront_first = []
vfront_second = []
vfront_third = []
front_pos = []
profile_front_pos = []
profile_bulk_pos = []
dx = []
dt = []
profile_time = []

dir_list = [f for f in os.listdir() if figure in f]

for idx, direc in enumerate(dir_list):
    
    os.chdir(path+direc)

    cp_temp = [] 
    cm_temp = []
    times_temp = []
    front_pos_temp = []
    v_p_temp = []
    v_m_temp = []
    CFL_temp = []
    #print(len(vfront_temp))
    #print(os.getcwd())

    input_files = [f for f in os.listdir() if "Keisuke_cluster" in f]
    input_files.sort(key = lambda x: int(x.rsplit('_',1)[1]))
    
    for file in input_files:
        
        #print(file)
        infile = open(os.getcwd()+"/"+file, 'rb')
        params = pickle.load(infile)
        infile.close()
        cp_temp.append(params['cp'])
        cm_temp.append(params['cm'])
        v_p_temp.append(params['v_p'])
        v_m_temp.append(params['v_m'])
        front_pos_temp.append(params['front'])
        times_temp.append(params['time'])
        CFL_temp.append(params['CFL'])
        profile_front_pos.append(params['profile_pos'])
        profile_bulk_pos.append(params['profile_bulk_pos'])
        dx.append(params['dx'])
        dt.append(params['dt'])
        profile_time.append(params['profile_time'])
        vfront_first_temp = np.zeros(len(v_p_temp))
        vfront_second_temp = np.zeros(len(v_p_temp))
        vfront_third_temp = np.zeros(len(v_p_temp))

    front_pos_temp=np.array([np.array(i) for i in front_pos_temp])
    
    for i in range(0,len(v_p_temp)):
        fit = np.polyfit(times_temp[i][0:len(front_pos_temp[i])//3], front_pos_temp[i][0:len(front_pos_temp[i])//3]*dx[i], 1)
        vfront_first_temp[i] = fit[0]
            
     ##Fit middle third of points
            
    for i in range(0,len(v_p_temp)):
         fit = np.polyfit(times_temp[i][(len(front_pos_temp[i]))//3:(2*len(front_pos_temp[i]))//3], front_pos_temp[i][(len(front_pos_temp[i]))//3:(2*len(front_pos_temp[i]))//3]*dx[i], 1)
         vfront_second_temp[i] = fit[0]
                
    ##Fit latter third of points
                
    for i in range(0,len(v_p_temp)):
        fit = np.polyfit(times_temp[i][(2*len(front_pos_temp[i]))//3:int(len(front_pos_temp[i]))], front_pos_temp[i][(2*len(front_pos_temp[i]))//3:int(len(front_pos_temp[i]))]*dx[i], 1)
        vfront_third_temp[i] = fit[0]
                    
    cp.append(cp_temp)
    cm.append(cm_temp)
    times.append(times_temp)
    front_pos.append(front_pos_temp)
    v_p.append(v_p_temp)
    v_m.append(v_m_temp)
    CFL.append(CFL_temp)
    vfront_first.append(vfront_first_temp)
    vfront_second.append(vfront_second_temp)
    vfront_third.append(vfront_third_temp)
    sum_velocity = np.add(v_p,v_m)
    ratio_velocity = np.divide(v_p,np.add(v_p,v_m))

np.savetxt("Figure_"+figure+"_y.txt" ,vfront_third, fmt = '%f', delimiter = ',') 
np.savetxt("Figure_"+figure+"_dt.txt" , dt, fmt = '%f', delimiter = ',')
np.savetxt("Figure_"+figure+"_dx.txt" , dx, fmt = '%f', delimiter = ',')

if figure == '5a':
    np.savetxt("Figure_"+figure+"_x.txt" ,sum_velocity , fmt = '%f', delimiter = ',')
    
else:
    np.savetxt("Figure_"+figure+"_x.txt" ,ratio_velocity , fmt = '%f', delimiter = ',')

#%% Front velocity vs r_pp (Figure 3a/3b/3c)
    
Jdrift = (params['v_p']*params['f_m'] - params['v_m']*params['f_p'])/(params['f_p']+params['f_m'])

def Vappx(r_pp):
    D = (params['v_p'] + params['v_m'])**2/(4*(params['f_p'] + params['f_m']))
    Vappx = Jdrift + 2*np.sqrt(D*r_pp)
    return Vappx

def Vexact(r_pp):
    if r_pp > params['f_p']:
        return params['v_p']
    elif r_pp < 0:
        return 0
    else:
        Vexact = (2*params['v_m']*np.sqrt(params['f_p']*r_pp) - (params['f_p']+r_pp)*params['v_m'] + params['f_m']*params['v_p'])/(params['f_m'] + params['f_p'] + r_pp - 2*np.sqrt(params['f_p']*r_pp))
        return Vexact

growthrange = np.arange(0,8,0.01)
Vexact_plot = []

for i in range(len(growthrange)):
    Vexact_plot.append(Vexact(growthrange[i]))

figX2 = plt.figure(figsize = (25,12))
plt.plot(growthrange,Vappx(growthrange),linestyle = '--', label = 'Diffusion Approximation')
plt.plot(growthrange,Vexact_plot, label = 'Exact Solution')
plt.plot(params['v_p']*np.ones_like(growthrange), linestyle = ':', color = 'k')
plt.axvline(x=params['f_p'], ymax = 0.82, color = 'k', linestyle = ':')
plt.plot(r_pp[0],vfront_third[0], marker = 'o', linestyle = '',markersize = 12, label = 'Simulated Velocities')


plt.xlim([0,1.2*params['f_p']])
plt.ylim([-8,1.4*params['v_p']])
plt.xlabel(r'Growth Rate $r_{++}$', fontsize=30)
plt.ylabel(r'Front Velocity', fontsize=30)
plt.xticks(([0,1,2,3,4]), (0,1,2,3,4),fontsize=30)
plt.yticks(([-8,-4,0,4,8,12]), (-8,-4,0,4,8,12), fontsize=30)
plt.legend(loc = 'best',prop={'size': 20}) 

# %% Front Velocity vs v_p+v_m (Figure 5a)
    
### Define Diffusion Appxmtn and Keisuke Prediction

def Vappx(v_p, v_m):
    Vappx = (v_p*params['f_m'] - v_m*params['f_p'])/(params['f_p']+params['f_m']) + ((v_p + v_m)/(params['f_p'] + params['f_m']))*np.sqrt(params['f_m']*params['r_pp'])
    return Vappx

def Vexact(v_p, v_m):
    if v_p+v_m < 0: 
        return params['v_p']
    else: 
        Vexact = (2*v_m*np.sqrt(params['f_p']*params['r_pp']) - (params['f_p'] + params['r_pp'])*v_m + params['f_m']*v_p)/(params['f_m'] + params['f_p'] + params['r_pp'] - 2*np.sqrt(params['f_p']*params['r_pp']))
        return Vexact

v_m_range = np.arange(0,7.5,0.1)
v_p_range = (3/7)*v_m_range
sum_velocity_range = v_p_range + v_m_range
sum_velocity = np.add(v_p,v_m)
Vexact_plot = []

for i in range(len(v_p_range)):
    Vexact_plot.append(Vexact(v_p_range[i],v_m_range[i]))

### Plot Diffusion Approximation, Keisuke Prediction and Simulated results

figX2 = plt.figure(figsize = (25,12))
plt.plot(sum_velocity_range,Vappx(v_p_range,v_m_range), linestyle = '--', label = 'Diffusion Approximation')
plt.plot(sum_velocity_range,Vexact_plot, label = 'Exact Solution')
plt.plot(sum_velocity[0],vfront_third[0], marker = 'o', linestyle = '',markersize = 12, label = 'Simulated Velocities')

plt.xlim([0,10])
plt.ylim([0,2])
plt.xlabel(r'$v_{+} + v_{-}$', fontsize=30)
plt.ylabel(r'Front Velocity', fontsize=30)
plt.xticks(([0,5,10]), (0,5,10),fontsize=30)
plt.yticks(([0, 1, 2]), (0, 1, 2),fontsize=30)

plt.legend(loc = 'best',prop={'size': 20})

# %% Front Velocity vs v_p+v_m (Figure 5b)
    
def Vappx(v_p, v_m):
    Vappx = (v_p*params['f_m'] - v_m*params['f_p'])/(params['f_p']+params['f_m']) + ((v_p + v_m)/(params['f_p'] + params['f_m']))*np.sqrt(params['f_m']*params['r_pp'])
    return Vappx

def Vexact(v_p, v_m):
    Vexact = (2*v_m*np.sqrt(params['f_p']*params['r_pp']) - (params['f_p'] + params['r_pp'])*v_m + params['f_m']*v_p)/(params['f_m'] + params['f_p'] + params['r_pp'] - 2*np.sqrt(params['f_p']*params['r_pp']))
    return Vexact

v_p_range = np.arange(0,10,0.1)
v_m_range = 10-v_p_range
ratio_velocity_range = v_p_range/(v_p_range + v_m_range)
ratio_velocity = np.divide(v_p,np.add(v_p,v_m))

figX2 = plt.figure(figsize = (25,12))
plt.plot(ratio_velocity_range,Vappx(v_p_range,v_m_range), linestyle = '--', label = 'Diffusion Approximation')
plt.plot(ratio_velocity_range,Vexact(v_p_range, v_m_range), label = 'Exact Solution')
plt.plot(ratio_velocity[0],vfront_third[0], marker = 'o', linestyle = '',markersize = 12, label = 'Simulated Velocities')

plt.xlim([0,1])
plt.ylim([0,10])
plt.xlabel(r'$\frac{v_{+}}{v_{+} + v_{-}}$', fontsize=30)
plt.ylabel(r'Front Velocity', fontsize=30)
plt.xticks(([0,0.5,1]), (0,0.5,1),fontsize=30)
plt.yticks(([0, 5, 10]), (0, 5, 10),fontsize=30)

plt.legend(loc = 'best',prop={'size': 20})


# %% Front Velocity vs f_p+f_m (Figure 6a)
    
def Vappx(f_p, f_m):
    Vappx = (params['v_p']*f_m - params['v_m']*f_p)/(f_p+f_m) + ((params['v_p'] + params['v_m'])/(f_p + f_m))*np.sqrt(f_m*params['r_pp'])
    return Vappx

def Vexact(f_p, f_m):
    if f_p+f_m < 1.3: 
        return params['v_p']
    else: 
        Vexact = (2*params['v_m']*np.sqrt(f_p*params['r_pp']) - (f_p + params['r_pp'])*params['v_m'] + f_m*params['v_p'])/(f_m + f_p + params['r_pp'] - 2*np.sqrt(f_p*params['r_pp']))
        return Vexact

f_p_range = np.arange(0,8,0.01)
f_m_range = (1/4)*f_p_range
sum_switching_range = f_p_range + f_m_range
sum_switching = np.add(f_p,f_m)
Vexact_plot = []

for i in range(len(f_p_range)):
    Vexact_plot.append(Vexact(f_p_range[i],f_m_range[i]))

figX2 = plt.figure(figsize = (25,12))
plt.plot(sum_switching_range,Vappx(f_p_range,f_m_range), linestyle = '--', label = 'Diffusion Approximation')
plt.plot(sum_switching_range,Vexact_plot, label = 'Exact Solution')
plt.plot(params['v_p']*np.ones_like(sum_switching_range), linestyle = ':', color = 'k', label = r'$v_+$')
plt.plot(sum_switching[0],vfront_third[0], marker = 'o', linestyle = '',markersize = 12, label = 'Simulated Velocities')


plt.xlim([0,10])
plt.ylim([0,1.75*params['v_p']])
plt.xlabel(r'$f_{+} + f_{-}$', fontsize=30)
plt.ylabel(r'Front Velocity', fontsize=30)
plt.xticks(([0,5,10]), (0,5,10),fontsize=30)
plt.yticks(([0, 5, 10, 15]), (0, 5, 10, 15),fontsize=30)

plt.legend(loc = 'best',prop={'size': 20})

# %% Front Velocity vs f_p/f_p+f_m (Figure 6b)
    
def Vappx(f_p, f_m):
    Vappx = (params['v_p']*f_m - params['v_m']*f_p)/(f_p+f_m) + ((params['v_p'] + params['v_m'])/(f_p + f_m))*np.sqrt(f_m*params['r_pp'])
    return Vappx

def Vexact(f_p, f_m):
    if f_p/(f_p+f_m) < .1: 
        return params['v_p']
    else: 
        Vexact = (2*params['v_m']*np.sqrt(f_p*params['r_pp']) - (f_p + params['r_pp'])*params['v_m'] + f_m*params['v_p'])/(f_m + f_p + params['r_pp'] - 2*np.sqrt(f_p*params['r_pp']))
        return Vexact

f_p_range = np.arange(0,9.25,0.1)
f_m_range = 8-f_p_range
ratio_switching_range = f_p_range/(f_p_range + f_m_range)
ratio_switching = np.divide(f_p,np.add(f_p,f_m))
Vexact_plot = []

for i in range(len(f_p_range)):
    Vexact_plot.append(Vexact(f_p_range[i],f_m_range[i]))

figX2 = plt.figure(figsize = (25,12))
plt.plot(ratio_switching_range,Vappx(f_p_range,f_m_range), linestyle = '--', label = 'Diffusion Approximation')
plt.plot(params['v_p']*np.ones_like(ratio_switching_range), linestyle = ':', color = 'k', label = r'$v_{+}$')
plt.plot(ratio_switching_range,Vexact_plot, label = 'Exact Solution')
plt.plot(ratio_switching[0],vfront_third[0], marker = 'o', linestyle = '',markersize = 12, label = 'Simulated Velocities')

plt.xlim([0,1])
plt.ylim([-0.75*params['v_p'],1.5*params['v_p']])
plt.xlabel(r'$\frac{f_{+}}{f_{+} + f_{-}}$', fontsize=30)
plt.ylabel(r'Front Velocity', fontsize=30)
plt.xticks(([0,0.5,1]), (0,0.5,1),fontsize=30)
plt.yticks(([-8,-4,0,4,8,12]), (-8,-4,0,4,8,12),fontsize=30)

plt.legend(loc = 'best',prop={'size': 20})


