%% Generate Random Numbers to predict gas flow (m^3/day)
%   Written by Jessie Diep & Padmanie Maulkhan
%   Feb 7, 2017


%% Setup Data Table
data = readtable('Oakville Hydro.xlsx');
revenue = zeros(500,6);
q = 1;
 
%% Setup Constants
% Minimum requirements (m3/day)
    small_req = 8755;
    med_req = 10946;
    high_req = 14740;
% Daily output (kWe)
    small_output = 847;
    med_output = 1059;
    high_output = 1426;
%% Daily outputs stored in range variable for 365 days
%   note: this section doesn't run all 500 runs in one shot
%   just keep re-running this section to fulfill the 500 trials

for p=1:500
    
    % randomly generate a vector 365 days of expected gas outputs/day
    range = OutputRange(data);
    rng('shuffle')
    
    %Find Revenue for decisions with each vector of expected gas outputs/day 

    revenue(q,1) = RH(small_req, small_output, 1, range); %tank
    revenue(q,2) = RH(small_req, small_output, 0, range); %no tank
    revenue(q,3) = RH(med_req, med_output, 1, range); %tank
    revenue(q,4) = RH(med_req, med_output, 0, range); %no tank
    revenue(q,5) = RH(high_req, high_output, 1, range); %tank     
    revenue(q,6) = RH(high_req, high_output, 0, range); %no tank  

    [q,~] = find(revenue==0,1)
end
