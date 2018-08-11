
logic_eng_ones = ones(1,length(value_eng_3));

for i_better = 1:length(value_eng_3)
    if value_eng_3(i_better) == 1;
        if mean(value_eng_3(i_better):value_eng_3(i_better-50)) > 100;
            logic_eng_ones(i_better) = 3;
        end
    end
end