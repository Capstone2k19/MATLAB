
function z = calcPheno(x,H,c,A,b)
    
    M = 1999;
    % first, check constraints    
    constraints = A*x < b;
    %if any constraint is violated - set z to big M+
    if min(constraints) == 0
        z = M;
    else
        z = 0.5*x'*H*x + c'*x;
    end
end