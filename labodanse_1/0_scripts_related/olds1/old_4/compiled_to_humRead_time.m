time_epoch = 69435;
epoch_hours_A = time_epoch/(60*60); % get the hours,
epoch_hours_B = floor(epoch_hours_A); % get the hours,
epoch_minutes_A = (epoch_hours_A - epoch_hours_B)*60; % get the minutes,
epoch_minutes_B = floor(epoch_minutes_A); % get the minutes,
epoch_seconds_A = (epoch_minutes_A - epoch_minutes_B)*60; % get the seconds,

compiled_time = [num2str(epoch_hours_B),':',num2str(epoch_minutes_B),':',num2str(epoch_seconds_A)]