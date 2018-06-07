# -*- coding: utf-8 -*-
"""
Created on Tue May 15 17:52:46 2018

@author: MTC
"""

import platform
import numpy, scipy.io
import random
import win32com.client as com
import os

def runn():
    print('gasp!!')

def MatlabToVisum(VDFArr, runtype):

    VDFArr = numpy.array(VDFArr)
    #print (VDFArr)
    
    
    # create the Visum-Object (connect the variable Visum to the software VISUM)
    Visum = com.Dispatch("Visum.Visum.170")
    
    if platform.win32_ver()[1].startswith('5'):
        public = os.environ["ALLUSERSPROFILE"]
    else :
        public = os.environ["PUBLIC"]
    
    if runtype == 0:
        versionPath = 'P:\\70\\36\\10\\Analysis\\Visum\\Parklawn & Lakeshore AM test.ver'
        Visum.LoadVersion(versionPath)
    elif runtype == 1:
        versionPath = 'P:\\70\\36\\10\\Analysis\\Visum\\Parklawn & Lakeshore PM test.ver'
        Visum.LoadVersion(versionPath)
    # load version
    
    # initialize all filters
    Visum.Filters.InitAll
    
    NoLink = Visum.Net.Links.Count
    LinkIter = Visum.Net.Links.Iterator
    link = 0
    
    while LinkIter.Valid == True:
        LinkIter.Item.SetAttValue("TypeNo", VDFArr[link])
        link = link + 1
        LinkIter.Next()
    #vdf = Visum.Procedures.Functions.CrFunctions
    LinkIter = None
    
    #for i in range(0,99):
       # VdfNo = "VdFunctionNo_LinkType(" + str(i) + ")"
      #  vdf.SetAttValue(VdfNo,VDFArr[i])
        
    Proc = Visum.Procedures
    Proc.Execute()
        
    VolVehPrT = numpy.empty(NoLink, dtype=object) 
    TCur = numpy.empty(NoLink, dtype=object)
    LinkIter = Visum.Net.Links.Iterator
    
    link = 0 
    while LinkIter.Valid == True:
        VolVehPrT[link] = LinkIter.Item.AttValue("VolVehPrT(AP)")
        TCur[link] = LinkIter.Item.AttValue("TCur_PrTSys(c)")
        link = link + 1
        LinkIter.Next()
    
    #print (VolVehPrT)
    #print (TCur)
    
    out = numpy.append(VolVehPrT, TCur, axis=0)
    out = out.tolist()
    #print("Hello")
    
    scipy.io.savemat('VolVehPrT.mat', mdict={'arr': VolVehPrT})
    scipy.io.savemat('TCur.mat', mdict={'arr': TCur})
    #with open('VolVehPrT.txt', 'w') as f:
    #    for link in VolVehPrT:
    #        f.write(str(link)+', ')
    #f.flush()
    
    #with open('TCur.txt', 'w') as g:
    #    for link in TCur:
    #        g.write(str(link)+', ')
    #g.flush()
    
    # write version file
    #saveVersionPath = 'P:\\70\\36\\10\\Analysis\\Visum\\Parklawn & Lakeshore AM test_Results.ver'
    #Visum.SaveVersion(saveVersionPath)
    
    #with open('test.txt', 'w') as f:
       # for 
       # numpy.savetxt(f,VolVehPrT, fmt='%d')
    #f.close()
    #close Visum
    #DSeg = None
    Proc = None
    #Visum = None
    return out
   

###MAIN: TEST SECTION 
i = 0
j = 0

V = numpy.empty(276, dtype=object)
    
for i in range(0,276):
    V[i] = random.randint(0,99)
    
MatlabToVisum(V, 0)


        
#print (param_b)

#print (MatlabToVisum(V))
       
        #NodeNo = [0]*(i - 1)
        #while (NodeNoPH[j] != ""):
            #NodeNo[j] = NodeNoPH[j]
            #j = j + 1
    
        #NodeNoPH = None 