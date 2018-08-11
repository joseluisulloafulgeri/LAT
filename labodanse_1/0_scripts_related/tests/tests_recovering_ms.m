% tests
extract_timeseries = {};
for j_count = 1:15321
    extract_timeseries{j_count} = sprintf('%.0f', A01804PM1ENG(j_count));
end
extract_timeseries = extract_timeseries';

new_ms = recovering_ms(:, 11:13);
new_ms_2 = str2num(new_ms)/100;
new_ms_3 = round(new_ms_2);

% something else
time_rounded = [];
for x_count = 1:length(recovering_ms_4)
    time_rounded(x_count) = str2num(sprintf('%.1f', recovering_ms_4(x_count)));
end
time_rounded = time_rounded';

% second chose
list = 0.1:0.1:10;
list = list';
first_sec = str2num(sprintf('%.1f', recovering_ms_4(1)));

for i_find = 1:length(list)
    if list(i_find) == first_sec;
        index_in_list = i_find;
    else
        % nothing
    end
end

new_time_rounded = [];
index_add = index_in_list;
for i_new_ms = 1:length(recovering_ms_4)
    if index_add == 101;
        index_add = 1;
    else
        new_time_rounded(i_new_ms) = list(index_add);
        index_add = index_add + 1;
    end
end

new_time_rounded = new_time_rounded';
