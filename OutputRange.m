function [ range ] = OutputRange(data)
%OutputRange generates a predicted output values for gas created / day
%   Range returns 365 numbers, one for each gas output/day
%% Generate indexes and allocate vector space

ii=1;
range = zeros(365,1);

total = data.Total;     %cumulative probability
[n,~] = size(total);

%% Use Random number to determine flow output

%Set range of deviation output / day
devAllowed = 0.25;

while(ii<366)
    %generate a random number, and match it to the histogram bin that it
    %falls within based on cumulative probability column (data.Total)
    randomnumber = rand(1,1);
    vectorrand = ones(n,1)*randomnumber;
    diff = abs(total-vectorrand);
    index = find(diff==min(diff));
    
    %the range of the gas output is [tempgasoutput-500,tempgasoutput]
    tempgasoutput = data.UB(index);
    a = tempgasoutput-500;
    
    %generate the final output for day ii by picking a
    %uniformly-distributed number within the range of the corresponding
    %histogram bin (U(LB, LB+500))
    finalnum = a + (tempgasoutput-a)*rand(1,1);
    
    
    %Store first value
    if ii==1 
        range(ii)= finalnum;
        ii = ii+1;
        
    %If finalnum is within devAllowed, store it and go to next number. O/W try again
    elseif ( (finalnum >= (1-devAllowed)*range(ii-1)) || (finalnum <(1+devAllowed)*range(ii-1)))
        range(ii) = finalnum;
        ii = ii+1;
    end
   
end


end

