function [normCorArray] = movingcorrelationspearman(dataMatrix, lengthWindow, lengthOverlap)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%movingcorrelationspearman.m

% USE : compute the moving correlation over a given signal. Each vector
% of the matrix is tested with any other matrix's vectors.

% INPUT : one matrix in which samples are given in column. The differents
% columns are the different data to correlate (time line should not be part
% of the input)

% OUTPUT : a matrix which contains the Froebenius Norm of each correlation matrix (1st column)and the mean
% index of each window (2nd column)

% ROOT : anywhere

% created : by YF 09/14
% last update : 10/01/15
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if lengthWindow > lengthOverlap
    
lengthDataMatrix = length(dataMatrix); 

nFullWindows= (lengthDataMatrix - lengthWindow)/(lengthWindow-lengthOverlap);

normCorArray = zeros(nFullWindows,2);

index = 1 : lengthWindow; % initial list of the vecor's index which is processed. See further steps in the next loop.

for i_Window=1:nFullWindows       

      matCor=corr(dataMatrix(index,:),'rows','pairwise','type','Spearman'); 
      % compute the correlation with : 
      % 'rows' = 'pairwise' to compute RHO(i_Window,i_Window) using rows with no missing values in column i or j //
      % 'type' = 'Spearman' to compute Spearman's rho
                   
      normCorArray(i_Window,1) = norm(matCor,'fro'); 
      % compute the 'Froebenius" norm of the covariance matrix : matrix norm of an m?n matrix, defined as the square root of the sum of the absolute squares of its elements (= vector norm)
      
      normCorArray(i_Window,2)=floor((min(index)+max(index))/2); % mean index of the result, for a given window.
      
      index=index+(lengthWindow-lengthOverlap);
end

else
    
disp('the overlap is too large')

normCorArray = zeros(1,2);
    
end