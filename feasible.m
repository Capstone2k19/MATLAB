function [xnew] = feasible(A,b,x,n)
    % feasible generates a feasible neighboring solution to x, by 
    % permuting a random xi to a random value in the feasible region given
    % all other xis
    
    %% set vars/ calculation conditions
    xnew = x; 
    int = randperm(n,1); %pick random index
    Acol = A(:,int);
    xnew(int) = 0; 
    %% find feasible region 
    xIntSet = (b - (A*xnew))./Acol; % xIntSet is a vector of tightened potential xnew vals
    if (any(Acol > 0)) % the properties of A (pos/neg) inform the mins/max of feasible region
        if(any(Acol < 0))
           UB = min(xIntSet(Acol>0));
           LB = max(max(xIntSet(Acol<0)),0); %also enforces non-neg
        else
            UB = max(xIntSet);
            LB = 0; %nonneg
        end
    else
        UB = max(b./Acol);
       LB = max(max(xIntSet),0); %also enforces non-neg
    end  
      xnew(int) = ((UB-LB).*rand(1)+LB); %generates rand number between UB&LB
end