B = load(A(5).name);
str = ['D=B.', char(fieldnames(B))];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%

value_eng_4 = medfilt1(value_eng_2,90,30);  
