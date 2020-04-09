#!/share/pkg.7/python3/3.6.5/install/bin/python3.6
#$ -j y
import numpy as np
import pickle
import argparse
import math
import time

# =============================================================================
# ############# the following block defines the varaibles that can be passed
# parser = argparse.ArgumentParser()
# parser.add_argument("-T", type=float, help="simulation time",default=10.)
# parser.add_argument("-x", type=float, help="max spatial length",default=10.)
# parser.add_argument("--v_p", type=float, help="polymerisation rate",default=1.)
# parser.add_argument("--v_m", type=float, help="depolymerisation rate",default=1.)
# parser.add_argument("--f_p", type=float, help="catastrophe rate",default=1.)
# parser.add_argument("--f_m", type=float, help="rescue rate",default=1.)
# parser.add_argument("--r_pp", type=float, help="nucleation rate",default=1.)
# parser.add_argument("--r_pm", type=float, help="nucleation rate",default=1.)
# parser.add_argument("--r_mp", type=float, help="nucleation rate",default=1.)
# parser.add_argument("--r_mm", type=float, help="nucleation rate",default=1.)
# parser.add_argument("--d_m", type=float, help="nucleation rate",default=1.)
# parser.add_argument("--d_p", type=float, help="nucleation rate",default=1.)
# parser.add_argument("-k", type=float, help="nucleation carrying capacity",default=10.)
# parser.add_argument("--file_suffix", help="file_suffix",default='')
# parser.add_argument("--path", help="filepath",default="/usr4/ugrad/ryancorn/keisuke_model_output/")
# args = parser.parse_args()

# ########## the variables are assigned values, if variable is not passed, default value is given
# 
# T=args.T
# x=args.x
# v_p=args.v_p
# v_m=args.v_m 
# f_p=args.f_p
# f_m=args.f_m
# r_pp=args.r_pp
# r_pm=args.r_pm
# r_mp=args.r_mp
# r_mm=args.r_mm
# d_m=args.d_m
# d_p=args.d_p
# k=args.k
# file_suffix=args.file_suffix
# path = args.path
# path=args.path
# =============================================================================

parser = argparse.ArgumentParser()
parser.add_argument("IPT", help = "Input dictionary containing params")
args = parser.parse_args()

##Read in pickle dictionary of parameters
ipt = args.IPT
infile = open(ipt, 'rb')
params_dict = pickle.load(infile)
infile.close()

##Define local variables from dictionary
v_p = params_dict['v_p']
v_m = params_dict['v_m']
f_p = params_dict['f_p']
f_m = params_dict['f_m']
r_pp = params_dict['r_pp']
r_pm = params_dict['r_pm']
r_mp = params_dict['r_mp']
r_mm = params_dict['r_mm']
d_m = params_dict['d_m']
d_p = params_dict['d_p']
k = params_dict['k']
T = params_dict['T']
x = params_dict['x']
figure = params_dict['figure']
idx = params_dict['idx']
CFL = params_dict['CFL']
p = params_dict['p']
q = params_dict['q']

##Define simulation loop
def simulate(v_p,v_m,f_p,f_m,r_pp,r_pm,r_mp,r_mm,d_p,d_m,k,figure,idx,CFL,p,q,T,x):
    
    ##Choose temporal spacing sufficiently smaller than rates
    dt = 0.1/max(f_p,f_m,r_pp,r_pm,r_mp,r_mm,d_p,d_m)
    
# =============================================================================
#     while T/dt < 20e4:
#     
#         dt = dt - 0.001
# =============================================================================
    
    ##Determine advection numbers if not specified
    if None in (p,q):
        
        v_p = int(v_p)
        v_m = int(v_m)
    
        rescale = math.gcd(v_p,v_m)
        
        p = v_p//rescale
        q = v_m//rescale
        
        dx = v_p*q*dt
        dt = CFL*dt
        
    else:
        
        dx = v_p*q*dt
           
    ##Create arrays
    x_array = np.arange(0,x,dx)
    front_times = []
    profile_front_pos = []
    profile_bulk_pos = []
    profile_times = []
    Front_pos = []
    Tempcp = []
    Tempcm = []
    cp_array = np.zeros(len(x_array))
    cm_array = np.zeros(len(x_array))
    cp_shifted = np.zeros(len(x_array))
    cm_shifted = np.zeros(len(x_array))
    cpTemp = np.zeros(len(x_array))
    cmTemp= np.zeros(len(x_array))
    cpNew = np.zeros(len(x_array))
    cmNew = np.zeros(len(x_array))
    front_counter = 0
    profile_counter = 0
    p_counter = 0
    q_counter = 0
    
    ##Localized initial condition at midpoint of lattice
    for i in range(0,10):    
        cp_array[len(x_array)//2+i] = 1 #initial condition

    start_time = time.time()
    
    for t in np.arange(0,T,dt): 
        
        front_counter = front_counter + 1
        profile_counter = profile_counter + 1
        p_counter = p_counter + 1
        q_counter = q_counter + 1
        
        ##Shifting to the right for positive walkers
        if q_counter == q:
            
            cp_shifted[1:-1] = (cp_array[1:-1] - cp_array[:-2])
            cpTemp[1:-1] = cp_array[1:-1] - cp_shifted[1:-1]
            
            ### Fixed Boundary Conditions
            cpTemp[0] = cp_array[0] 
            cpTemp[-1] = cp_array[-1]
            
            ### Reflecting Boundary Conditions
            
            #cpTemp[0] = cp_array[0] - np.abs(v_p)*dt/dx*cp_array[0]
            #cpTemp[-1] = cp_array[-1] + np.abs(v_p)*dt/dx*cp_array[-2]
            
            q_counter = 0
            
        else:
            
            cpTemp = cp_array
        
        ##Shifting to the left for negative walkers
        if p_counter == p:
            
            cm_shifted[1:-1] = (cm_array[2:] - cm_array[1:-1])   
            cmTemp[1:-1] = cm_array[1:-1] + cm_shifted[1:-1]   
            
            ### Fixed Boundary Conditions
            
            cmTemp[0] = cm_array[0] 
            cmTemp[-1] = cm_array[-1]
            
            ### Reflecting Boundary Conditions
            
            #cmTemp[0] = cm_array[0] + np.abs(v_m)*dt/dx*cm_array[1]
            #cmTemp[-1] = cm_array[-1] - np.abs(v_m)*dt/dx*cm_array[-1]
            
            p_counter = 0
        
        else:
            
            cmTemp = cm_array
        
        ##Switching and growth on positive 
        cpNew = cpTemp - f_p*dt*cpTemp + f_m*dt*cmTemp - d_p*dt*cpTemp
        cpNew = cpNew + r_pp*dt*cpTemp*(1-((cpTemp + cmTemp)/k)) + r_pm*dt*cmTemp*(1-((cpTemp+cmTemp)/k))
        
        ##Switching and growth on negative
        cmNew = cmTemp + f_p*dt*cpTemp - f_m*dt*cmTemp - d_m*dt*cmTemp
        cmNew = cmNew + r_mp*dt*cpTemp*(1-((cpTemp + cmTemp)/k)) + r_mm*dt*cmTemp*(1-((cmTemp+cpTemp)/k))
        
        cp_array = cpNew
        cm_array = cmNew
        
        ##Stop simulation if wave reaches boundary to avoid boundary effects
        if cp_array[-12] > 10e-3 or cp_array[12] > 10e-3:
            print("Wave "+str(idx)+" off lattice!")
            break              

        ##Save front position
        if front_counter == len(np.arange(0,T,dt))//100:
            
            c_sum = cp_array + cm_array
            c_max = np.argmax(c_sum)
            c_sum_fitting = c_sum[c_max:]
            front_pos_temp = np.argmin(np.abs(c_sum_fitting-10e-4))
            Front_pos.append((front_pos_temp + c_max))
            front_times.append(t)
            front_counter = 0
        
        ##Save some profiles
        if profile_counter == len(np.arange(0,T,dt))//5:
            
            profile_times.append(t)
            c_sum = cp_array + cm_array
            c_max = np.argmax(c_sum)
            profile_bulk_pos.append(c_max)
            c_sum_fitting = c_sum[c_max:]
            profile_front_pos_temp = np.argmin(np.abs(c_sum_fitting-10e-4))
            profile_front_pos.append((profile_front_pos_temp + c_max))
            
            Tempcp.append(cp_array)
            Tempcm.append(cm_array)
            
            profile_counter = 0
        
        cp_shifted = np.zeros(len(x_array))
        cm_shifted = np.zeros(len(x_array))
        cpTemp = np.zeros(len(x_array))
        cmTemp= np.zeros(len(x_array))
        cpNew = np.zeros(len(x_array))
        cmNew = np.zeros(len(x_array))
        
    end_time = time.time()
    np.savetxt("Time_loop_"+str(idx), [(np.abs(end_time - start_time))/3600], fmt = '%f') 
    params_sim = {'profile_time' : profile_times , 'profile_bulk_pos' : profile_bulk_pos , 'profile_pos' : profile_front_pos, 'time' : front_times , 'front' : Front_pos , 'cp' : Tempcp , 'cm' : Tempcm, 'CFL' : CFL, 'dt' : dt, 'dx' : dx, 'T' : T, 'x' : x}
    params_sim.update(params_dict)
    
    ##Export data as pickled dictionary
    outfile = open("Keisuke_cluster_"+figure+"_"+str(idx),'wb')
    pickle.dump(params_sim, outfile)
    outfile.close()

##Call simulation function
simulate(v_p,v_m,f_p,f_m,r_pp,r_pm,r_mp,r_mm,d_p,d_m,k,figure,idx,CFL,p,q,T,x)
    
#print(v_p,v_m,f_p,f_m,r_pp,T,x)
    