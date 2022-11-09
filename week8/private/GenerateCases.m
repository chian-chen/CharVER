function cases = GenerateCases()
    cases = cell(1, 7);
    cases{1} = [6 3 2 1 4 7 8 9];
    for i = 2 : 8
        a = cases{i - 1};
        cases{i} = [a(2:end) a(1)];
    end
end