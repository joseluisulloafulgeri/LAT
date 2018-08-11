
%% 1. smooth > normalize
B = fileStruct.data(1:find(fileStruct.common_seconds(:, 1) == 62230),2,1);
% plot
figure, plot(B), set(gca,'ylim',[300 550])
% smooth
smooth_data = fastsmooth(B,length(B)/100,3,1);
figure, plot(smooth_data, 'r')
% plot
figure, plot(B), set(gca,'ylim',[300 550]),
hold on
plot(smooth_data, '--r')
% normalize
normalized_data_1 = smooth_data - mean(smooth_data(:));
normalized_data_2 = normalized_data_1/std(smooth_data(:));
figure, plot(normalized_data_2),

%% 2. normalize > smooth !! equivalent to 1.
normalized_data_3 = B - mean(B(:));
normalized_data_4 = normalized_data_3/std(B(:));
% plot
figure, plot(normalized_data_4),
% smooth
smooth_data_2 = fastsmooth(normalized_data_4,length(normalized_data_4)/100,3,1);
figure, plot(smooth_data_2, 'r')
% plot
figure, plot(B), set(gca,'ylim',[300 550]),
hold on
plot(smooth_data_2, '--r')



% END