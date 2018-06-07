% make up some dummy parameters
%a = [1,2,7,5];
%b = [6,2,1,6];
%c = [0,0,0,0];
nlinks = 276;
nvars = 31;  %trying to assign one of 99 link types to each link

%% Fitness function
%fitness = CalculateFitness([x])
fitfun = @CalculateSelectLinks;


Aa = zeros(nvars,nvars);
b = zeros(1,nvars);
Aeq = zeros(nvars,nvars);
beq = zeros(nvars,1);
lb = zeros(nvars,1);
ub = 29 * (ones(nvars,1));      %99 possible link types
IntCon = [1:nvars];
options = optimoptions('ga', 'Display', 'iter', 'PopulationSize',70, 'PlotFcn', 'gaplotrange', 'InitialPopulationRange',[1;100], 'FitnessLimit', 5, 'MaxStallGenerations', 20);

tic;
[x,fval,exitflag,output,population,scores] = ga(fitfun,nvars, Aa, b, [], [], lb, ub,[],IntCon,  options)
toc
