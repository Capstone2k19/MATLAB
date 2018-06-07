function [z,x,n] = run_HQP(H,c,A,b)
    % Hildreth for QPs
    % OBJ :     min 1/2 x'Hx + c'x -- Aleman syntax
    % CONST:    s.t  Ax <= b, x >= 0
    % A is PSD
    % x is row vector
    % c is col vector
    % b is row vector
    %% 1. SELECT INITIAL SOLUTION: lambda = 0
    % as many lambdas as there as constraints
    % lambda = 0
    A = [A; -eye(numel(c))];
    b = [b; zeros(numel(c),1)];    
    m = size(A, 1);
    lambda = zeros(m,1); % row vector

    % intermediate lambda
    % dummy lambda that we can update since we
    % want to preserve lambda so that we can compare
    optLam = lambda;

    %% 2. DETERMINE DUAL
    % max e' * lambda + 1/2 * lambda' * D * lambda

    % Dual of c
    % e = b + A*H^(-1) *c
    e = b + A*(H\c) ; % row vector

    % Dual of A
    % D = A*H^(-1)*A'
    D = A*(H\A'); % PSD

    %% 3. APPLY KKT: to solve for each lambda and update lambda
    % L : lagrangian, C : complimentary slackness, P : positivity, F : feasibility
    % gradient of L_hat(lambda) = D*lambda + e <= 0

    % repeat cycle until solution converges
    % this means lambda_i = lambda_i-1
    % OR set a limit for number of times cycle repeats

    n = 0;
    halt = 100;
    reiter = true;
    while reiter 

        for i = 1:m  
          %v = -1/Dii * (Di(i!=i) * lami(i!=i) + ... + Dim * lamim + ei)
          Di = D(i, :); % row of interest
          Di(i) = 0; % lambda of interest
    %         belowi = D(i, 1:i-1);
    %         abovei =  D(i, i+1:m);   
    %       sum of all coef_lambda < i * newLambda + sum of all coef_lambda > i *
    %      oldLambda + ei
          v = -(Di*optLam + e(i))/D(i,i);
    %         v = (belowi * optLam(1:i-1) + abovei * lambda(i+1:m) - e(i))/D(i,i);
          optLam(i) = max(0, v);  

        end

        % check if new lambda same as old lambda
        % have to consider doubles
        %   or if we reached limit on iterations
        n = n+1;
        if ( norm(lambda - optLam) )== 0 || isequal(n, halt)
            reiter = false;

        % if not, reiterate with new lambda
        else
            lambda = optLam;

        end

        
    end


    %% 5. CONVERT TO PRIMAL: determine solution
    % VARS
    x = -H\(A' * lambda + c);



    % OBJ :     min 1/2 x'Hx + c'x -- Aleman syntax
    z = (0.5* x') * (H * x) + c'*x;
    
    %QUADPROG SOL
    %options = optimoptions('quadprog','Display','off');
    %[qpx,qpz] = quadprog(H, c, A, b, [], [], zeros(m,1), [], [], options);
    
    %% CORRECT -0.00's
    % find where -ve numbers exist in x
    % check if |xi| < epsilon
    % < e^-5 is negigable
    % replace with 0
    x(abs(x) <= 0.00001 ) = 0;
    
end