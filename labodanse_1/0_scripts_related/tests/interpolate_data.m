
A = fileStruct.data;
B = fileStruct.data;

t = linspace(0.1, 10, numel(A));
% indices to NaN values in x (assumes there are no NaNs in t)
nans = isnan(A);
% replace all NaNs in x with linearly interpolated values
B(nans) = interp1(t(~nans), A(~nans), t(nans));
% A_2(nans) = interp1(t(~nans), A(~nans), t(nans), 'nearest'); % 'spline'

fileStruct.data = B;
clear A
clear B
clear t
clear nans

fileStruct.comments{4} = 'data has been globally interpolated';

% figure, plot(squeeze(fileStruct.data(:,2,:)))