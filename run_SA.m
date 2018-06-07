function [z,x] = run_SA(H,c,A,b)
    %% set vars & constants
    %set n
    [~,n] = size(A);
    % best check variables
    bestX = zeros(n,1);
    % set parameters
    alpha = .9875; %anything between .99-.8
    Tmin = 0.01;
    limit = n*20;
    % find a feasible starting solution
    options = optimset('Display', 'off');
    x = linprog(zeros(size(A,2),1),A,b,[],[],zeros(size(A,2),1),[],[],options);
    %calculate starting costs
    oldCst = (x'*H*x)/2 + c'*x; 
    % set T & bestcost to starting cost
    T = oldCst;
    bestCst = oldCst;

    %% run algorithm
    while (T > Tmin)
        i = 0;
        while (i < limit)
            %find random feasible neighboring solution
            xnew = feasible(A,b,x,n);
            %calculate cost of new solution
            newCst = (xnew'*H*xnew)/2 + c'*xnew;
           %grab best solution ever found, just in case
            if (newCst < bestCst)
                bestCst = newCst;
                bestX = xnew;
            end
            % calculate acceptance prob
            a = exp((oldCst - newCst)/T);
            %keep new solution when if is met
            if (a > rand(1))
                x = xnew;
                oldCst = newCst;
            end           
            i = i +1;
        end % i loop
        T = T*alpha;   
    end %T loop
    %% return algorith results
    %if somehow we found better that we never came back to, return that
    if(oldCst > bestCst)
        z = bestCst;
        x = bestX;   
    else %return 'converged' solution (x is already x)
        z = oldCst;
    end
end %end function