
A = fileStruct.data(1:find(fileStruct.common_seconds(:, 1) == 62230),1);
B = fileStruct.data(1:find(fileStruct.common_seconds(:, 1) == 62230),2,1);

% %% normalization
% t = linspace(0.1, 10, numel(A));
% % indices to NaN values in x (assumes there are no NaNs in t)
% nans = isnan(A);
% % replace all NaNs in x with linearly interpolated values
% B(nans) = interp1(t(~nans), A(~nans), t(nans));
% % A_2(nans) = interp1(t(~nans), A(~nans), t(nans), 'nearest'); % 'spline'

%--- plot
% figure, plot(fileStruct.common_seconds(1:find(fileStruct.common_seconds(:, 1) == 62230)), A), set(gca,'ylim',[200 800])
% figure, plot(fileStruct.common_seconds(1:find(fileStruct.common_seconds(:, 1) == 62230)), A), set(gca,'ylim',[200 800])
% hold on
% plot ((fileStruct.common_seconds(1:find(fileStruct.common_seconds(:, 1) == 62230))), B, ':r')
% figure, plot((fileStruct.common_seconds(1:find(fileStruct.common_seconds(:, 1) == 62230))), B, 'r'), set(gca,'ylim',[200 800])

%% median filtr
% C = medfilt1(B, 30, 30);
C = medfilt1(B, 90, 200);

%--- plot
%figure, plot((fileStruct.common_seconds(1:find(fileStruct.common_seconds(:, 1) == 62230))), C, 'r'), set(gca,'ylim',[300 550])
figure, plot(B), set(gca,'ylim',[300 550])
figure, plot(C), set(gca,'ylim',[300 550])

% %% smoothing with gaussian 
% w = gausswin(floor(length(B)/100));
% D = filter(w,1,B);
% D = D/20;
% %--- plot
% figure, plot(D), set(gca,'ylim',[300 550])
% 
% %% smoothing with gaussian  2
% w_1 = gausswin(20);
% w_1 = w_1/sum(w_1);
% D_1 = conv(B, w_1, 'same');
% %--- plot
% figure, plot(D_1), set(gca,'ylim',[300 550])
% 
% %% smooth function
% E = smoothts(B,'g', floor(length(B)/100), 10);
% figure, plot(E)

F = fastsmooth(B,length(B)/100,3,1);
figure, plot(F, 'r')

figure, plot(B), set(gca,'ylim',[300 550]),
hold on
plot(F, '--r')

% tranf_data_1 = bsxfun(@minus, B, min(B));
% tranf_data_2 = bsxfun(@rdivide, tranf_data_1, max(B) - min(B));

normalized_data_1 = B - mean(B(:));
normalized_data_2 = normalized_data_1/std(B(:));

% END