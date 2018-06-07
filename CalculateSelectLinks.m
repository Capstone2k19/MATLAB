function fitness = CalculateSelectLinks(x_inputs)
    %initialize x and y
    nvars = length (x_inputs);
    nlinks = 276;
    vols = ones(1,(2*nlinks));         
    %times = ones(1,nlinks);            %times will be evaluated later

    x_inputs'
    %set targets
    AMvol_tar = load('Select Volume Targets AM.mat');
    PMvol_tar = load('Select Volume Targets PM.mat');
    %times_tar = load('Time Targets AM.mat');
    AMvol_tar = AMvol_tar.vol_tar;
    PMvol_tar = PMvol_tar.vol_tar;
    vol_tar = [AMvol_tar, PMvol_tar];
    %times_tar = times_tar.times_tar;
    
    %set up x
    x = ones(1,nlinks);
    j = 1;
    
    relevant = (AMvol_tar == 4) + (AMvol_tar == 6);
    
    
    for i = 1:nlinks
        if relevant(i)
            x(i) = vol_tar(i);
        else
            x(i) = x_inputs(j);
            j = j+1;
        end
    end
    relevant = 1 - relevant;
    
    %run simulations and calculate fitness
    AMresults = py.VisumToMatLab.MatlabToVisum(x,0);
    PMresults = py.VisumToMatLab.MatlabToVisum(x,1);
    
    for i = 1:nlinks
        vols(i) = AMresults{i};
        vols(i+nlinks) = PMresults{i};
        %times(i) = results{(i + nlinks)};
    end
    %x = results(1:nlinks)
    %y = results((1+nlinks):(2*nlinks))
    %fitness = sum(abs(vol_tar - vols).*relevant)
    GEH = (2.*(vol_tar - vols).^2./(vol_tar+vols)).^0.5;
    relevant = [relevant, relevant];
    threshold = GEH > 3;
    penalty = GEH > 8;
    penalty = GEH.*relevant.*penalty*5;
    fitness = sum(GEH.*relevant.*threshold)+sum(penalty)
    
end