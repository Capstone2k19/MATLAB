function [ revenue ] = RH( enginereq, engineoutput, tankinstall, range )
%RevenueHydro calculates potential revenue for Hydro Case
%   Engine_req = Engine Intake Requirement (m^3/day)
%   Tankinstall = binary {0,1}, 1 = install the tank

revenue =0;
amtStored = 0; %Assume none at the beginning of year 1
numTanks = 5;

%Loop through daily values of gas output (range vector)
for j=1:365
 
    %If enough intake, we make revenue! 
    if((range(j) + amtStored) >= enginereq)
        %Revenue increase
        revenue = revenue + 0.1490*(engineoutput)*24; 
        %Tank top-up
        if(tankinstall ==1)
            amtStored =  range(j) + amtStored - enginereq ; %Amt leftover from combustion
            if(amtStored >(1855*numTanks))
                %Cannot store more in tank than capacity
                amtStored = (1855*numTanks);
            end
        end
    %If not enough intake, we can still fill up the tank!    
    else
        if(tankinstall ==1)
            amtStored =  amtStored + range(j) ;
            if(amtStored >(1855*numTanks))
                %Cannot store more in tank than capacity
                amtStored = (1855*numTanks);
            end
        end
        
    end

end

end

