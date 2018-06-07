function [z, x] = run_GA(H,c,A,b)
%% Constants
[chromes,~]= size(c);       %number of chromosomes corresponding to the number of variables
scorecol = chromes + 1;
popsize = min([1500 150*chromes]);      %size of population
maxval = 2;                 %maximum value range, also x cannot be less than 0
M = 999;                    %Big M for infeasible score
k = 5;                      %Number of all-time fittest genotpes to score todo: maybe don't need?
threshold = 1;              %todo: give this an implementation
probfactor = 1/3;           % 1/PF: PF is the factor for preference of fittest individuals
problimit = popsize^(1/probfactor); %range for stochastic generation of mate indices

if chromes < 5              %percent of chromosomes (variables) to randomly receive mutation
    mutRate = 0.12;         %smaller populations require higher mutations
elseif chromes < 10;        %larger populations perform better with smaller mutation rates
    mutRate = 0.07;
else
    mutRate = 0.02;              
end
%Initializing stopping points to prevent infinite loops
maxiteration = 15000;        %limiting number of iterations
maxstuck = 10+7*chromes;    %limiting number of iterations for which the best optimal does not improve
maxtries = min([100 14*chromes]); %limiting number of feasible offspring attempts
iteration = 1;
stuck = 0;
tolerance = 0.02;
b = b + tolerance*abs(b);
%initializing dimension variables

topscores = ones(k, scorecol)*M;  


%% Initialize first generation
%generate random genotypes (sets of values for x)

population = rand(popsize, chromes).*maxval;    %generate random population 
scores = zeros(popsize,1);

 %% Check this generation
    %put each x (genotype) into formula
   
   for ii = 1:popsize
        scores(ii) = calcPheno(population(ii,:)',H,c,A,b);          %start with a population that fits relaxed constraints
        
    end
    %record objective value (z = phenotype)for each set
    population = [population scores];



%% Repeat until optimal solution doesn't improve....k times in a row?
    %check this generation
        %if the best solution stops changing, return
        %else, procreate new generation
while ((iteration<maxiteration)&&(stuck<maxstuck))    
    %sort population
    population = sortrows(population, scorecol);
    %record the best Z of this iteration
    if population(1,scorecol)<= max(topscores(:,scorecol))
        [~,worst] = max(topscores(:,scorecol));
        topscores(worst(1),:) = population(1,:);
        stuck = 0;
    else
        stuck = stuck+1;
    end
    z = min(topscores(:,scorecol));
    [~,xx] = min(topscores(:,scorecol));
    x = topscores(xx,:);
    %compare to k previous Z, if they exist
    if max(topscores(:,scorecol))-min(topscores(:,scorecol)) < threshold
        optimal = true;
    %    return;
    end

    %% Create the next generation
    %generate random set of coin flips to determine crossover combination
    crossover = rand(1,chromes);
    crossbool = crossover>0.5;
    newPopulation = zeros(popsize,scorecol);
    stuck2 = 0;
    ii = 1;
    while ii < popsize+1
        %assign a probability to each successful x (genotype)
            %Based on rank for now
        mate1 = ceil(popsize-(problimit*rand)^(probfactor));
        mate2 = ceil(popsize-(problimit*rand)^(probfactor));

        %make sure they don't match
        if mate1 == mate2
            mate2 = mate2+1;
            if mate2 == (popsize-1)
                mate2 = (popsize-1);
            end
        end
        
        mates(ii,1) = mate1;
        mates(ii,2) = mate2;
        % mate selection
        mate1 = population(mate1,1:chromes);
        mate2 = population(mate2,1:chromes);

        %mate x's to produce the next generation (meiosis...ish)

        offspring = mate1.*crossbool + mate2.*(1-crossbool);
        %include genetic mutations
        offspring(crossover<mutRate)= (maxval*rand);
        fitness = calcPheno(offspring',H,c,A,b);
        
        if (fitness ~= M)||(stuck2>maxtries)
            newPopulation(ii,:) = [offspring fitness];
            ii = ii+1;
            stuck2 =0;
        else
            stuck2= stuck2+1;
        end
    end
    population = newPopulation;
    iteration = iteration+1;

    
end

    z = min(topscores(:,scorecol));
    [~,xx] = min(topscores(:,scorecol));
    x = topscores(xx,1:chromes);
    
end