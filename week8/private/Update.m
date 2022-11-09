function [newrow, newcol, c] = Update(row, col, currentcase)
    if currentcase == 1
        newrow = row - 1; newcol = col - 1; c = 1;
    elseif currentcase == 2
        newrow = row; newcol = col - 1; c = 8;
    elseif currentcase == 3
        newrow = row + 1; newcol = col - 1; c = 7;
    elseif currentcase == 4
        newrow = row - 1; newcol = col; c = 2;
    elseif currentcase == 6
        newrow = row + 1; newcol = col; c = 6;
    elseif currentcase == 7
        newrow = row - 1; newcol = col + 1; c = 3;
    elseif currentcase == 8
        newrow = row; newcol = col + 1; c = 4;
    else
        newrow = row + 1; newcol = col + 1; c = 5;
    end
end